test_that("MakeStudyInfo output has expected shape", {
  test_result <- MakeStudyInfo(
    list(
      StudyID = "Unique Study ID",
      SiteCount = 10,
      ParticipantCount = 100,
      Status = "Ongoing"
    )
  )
  expect_s3_class(test_result, "data.frame")
  expect_identical(
    names(test_result),
    c("Param", "Value", "Description")
  )
  expect_equal(nrow(test_result), 4)
})

test_that("MakeStudyInfo labels things as expected", {
  test_result <- MakeStudyInfo(
    list(
      StudyID = "Unique Study ID",
      SiteCount = 10,
      ParticipantCount = 100,
      Status = "Ongoing"
    )
  )
  expect_identical(
    test_result$Description,
    c("Study ID", "Sites Enrolled", "Participants Enrolled", "Study Status")
  )
})

test_that("MakeStudyInfo uses lLabels over default", {
  test_result <- MakeStudyInfo(
    list(
      StudyID = "Unique Study ID",
      SiteCount = 10,
      ParticipantCount = 100,
      Status = "Ongoing"
    ),
    list(
      StudyID = "study#",
      SiteCount = "nsites",
      ParticipantCount = "nsubj",
      Status = "stat"
    )
  )
  expect_identical(
    test_result$Description,
    c("study#", "nsites", "nsubj", "stat")
  )
})
