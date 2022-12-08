# incorrect file path returns message

    Code
      SaveQTL(df, strPath = "wxyz")
    Message
      csv file not found. Check value provided to `strPath`.

# qtl with bStatus == FALSE returns message

    Code
      SaveQTL(df_error)
    Message
      csv file not found. Check value provided to `strPath`.

