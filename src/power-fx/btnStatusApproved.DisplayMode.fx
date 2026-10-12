If(!varShowHistory && varAnalyzed && CountRows(colAuthorizationResults) > 0 && CountIf(colAuthorizationResults, Result = "Missing") = 0, DisplayMode.Edit, DisplayMode.Disabled)
