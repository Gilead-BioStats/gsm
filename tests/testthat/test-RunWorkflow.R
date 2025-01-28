wf_mapping <- MakeWorkflowList(strPath = test_path('testdata/mappings'))
workflows <- MakeWorkflowList(strPath = test_path('testdata/metrics'))

# Don't run things we don't use.
used_params <- map(workflows, ~ map(.x$steps, "params")) %>%
  unlist() %>%
  unique()
wf_mapping$steps <- purrr::keep(
  wf_mapping$steps,
  ~ .x$output %in% used_params
)
# Source Data
lSource <- list(
  Source_SUBJ = clindata::rawplus_dm,
  Source_AE = clindata::rawplus_ae
)

# Step 0 - Data Ingestion - standardize tables/columns names
lRaw <- list(
  Raw_SUBJ = lSource$Source_SUBJ,
  Raw_AE = lSource$Source_AE
)

# Create Mapped Data
lMapped <- quiet_RunWorkflows(lWorkflows = wf_mapping, lData = lRaw)

# Run Metrics
results <- map(
  workflows,
  ~ quiet_RunWorkflow(lWorkflow = .x, lData = lMapped, bReturnResult = FALSE, bKeepInputData = FALSE)
)

yaml_outputs <- map(
  map(workflows, ~ map_vec(.x$steps, ~ .x$output)),
  ~ .x[!grepl("lCharts", .x)]
)

test_that("RunWorkflow preserves all steps when bReturnResult = FALSE", {
  expect_no_error({
    purrr::iwalk(
      workflows,
      function(this_workflow, this_name) {
        expect_identical(
          this_workflow, results[[this_name]][names(this_workflow)]
        )
      }
    )
  })
})

test_that("RunWorkflow contains all outputs from yaml steps", {
  expect_no_error({
    purrr::iwalk(
      results,
      function(this_result, this_name) {
        expect_setequal(yaml_outputs[[this_name]], names(this_result$lData))
      }
    )
  })
})

test_that("RunWorkflow contains all outputs from yaml steps with populated fields (contains rows of data)", {
  expect_no_error({
    purrr::iwalk(
      yaml_outputs,
      function(this_output_set, this_name) {
        expect_true(
          all(map_int(results[[this_name]]$lData[this_output_set], NROW) > 0)
        )
      }
    )
  })
})

# ----
# Test [ lConfig ] parameter of [ RunWorkflow ].

lConfig <- list(
  LoadData = function(lWorkflow, lConfig, lData) {
    lData <- lData
    purrr::imap(
      lWorkflow$spec,
      ~ {
        input <- lConfig$Domains[[.y]]

        if (is.data.frame(input)) {
          data <- input
        } else if (is.function(input)) {
          data <- input()
        } else if (is.character(input)) {
          data <- read.csv(input)
        } else {
          cli::cli_abort("Invalid data source: {input}.")
        }

        lData[[.y]] <<- data
      }
    )
    return(lData)
  },
  SaveData = function(lWorkflow, lConfig) {
    domain <- paste0(lWorkflow$meta$Type, "_", lWorkflow$meta$ID)
    if (domain %in% names(lConfig$Domains)) {
      assign(
        domain,
        lWorkflow$lResult,
        envir = .GlobalEnv
      )
    }
  },
  Domains = c(
    Raw_AE = function() {
      clindata::rawplus_ae
    },
    Mapped_AE = function() {
      Mapped_AE
    }
  )
)

test_that("RunWorkflow loads/saves data with configuration object.", {
  expect_no_error({
    RunWorkflow(
      lWorkflow = wf_mapping$AE,
      lConfig = lConfig
    )
  })

  expect_true(exists("Mapped_AE"))
})

test_that("RunWorkflow passes existing lData objects through with configuration object.", {
  lData <- list(lWorkflows = wf_mapping)

  expect_no_error({
    output <- RunWorkflow(
      lWorkflow = wf_mapping$AE,
      lConfig = lConfig,
      lData = lData,
      bReturnResult = F
    )
  })

  expect_true(!is.null(output$lData$lWorkflows))
})

test_that("RunWorkflow errors out if [ lConfig ] does not have a method to load data.", {
  lBadConfig <- lConfig
  lBadConfig$LoadData <- NULL

  expect_error(
    {
      RunWorkflow(
        lWorkflow = wf_mapping$AE,
        lConfig = lBadConfig
      )
    },
    "must include a function named .LoadData."
  )
})

test_that("RunWorkflow errors out if the data load method does not have expected parameters.", {
  lBadConfig <- lConfig
  lBadConfig$LoadData <- function(lWorkflow) {}

  expect_error(
    {
      RunWorkflow(
        lWorkflow = wf_mapping$AE,
        lConfig = lBadConfig
      )
    },
    "must include a function named .LoadData."
  )

  lBadConfig <- lConfig
  lBadConfig$LoadData <- function(lConfig) {}

  expect_error(
    {
      RunWorkflow(
        lWorkflow = wf_mapping$AE,
        lConfig = lBadConfig
      )
    },
    "must include a function named .LoadData."
  )
})

test_that("RunWorkflow errors out if [ lConfig ] does not have a method to save data.", {
  lBadConfig <- lConfig
  lBadConfig$SaveData <- NULL

  expect_error(
    {
      RunWorkflow(
        lWorkflow = wf_mapping$AE,
        lConfig = lBadConfig
      )
    },
    "must include a function named .SaveData."
  )
})

test_that("RunWorkflow errors out if the data save method does not have expected parameters.", {
  lBadConfig <- lConfig
  lBadConfig$SaveData <- function(lWorkflow) {}

  expect_error(
    {
      RunWorkflow(
        lWorkflow = wf_mapping$AE,
        lConfig = lBadConfig
      )
    },
    "must include a function named .SaveData."
  )

  lBadConfig <- lConfig
  lBadConfig$SaveData <- function(lConfig) {}

  expect_error(
    {
      RunWorkflow(
        lWorkflow = wf_mapping$AE,
        lConfig = lBadConfig
      )
    },
    "must include a function named .SaveData."
  )
})
