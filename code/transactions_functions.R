## two functions, get_transactions and get_transactions2
## df: dataframe of transactions
## two functions to prevent anything from crashing/freezing while running


get_transactions = function(df){
  ## Creates new column with company name as in historical prices dataset
  ## We need to do this because the company name is off sometimes by a punctuation mark, or a word
  ## Ex: company is 'Ebay' in transactions dataset, but 'Ebay, Inc.' in the historical prices dataset

  names(df) = c('Member', 'Name', 'Action', 'Date.of.Transaction', 'Value')
  df$Name = as.character(df$Name)
  df$New = NA
  for(k in 1:length(ticker$Name)){
    for(j in 1:length(df$Name)){
      if(!is.na(pmatch(df$Name[j], ticker$Name[k]))){
        df$New[j] = as.character(ticker$Name[k])
      }
    }
  }

  return(df)
}



get_transactions2 = function(df){
  ## Replaces original company column with new one
  ## Get historical prices by stock
  ## Generate dates to calculate residual returns

  if(sum(is.na(df$New)) < length(df$New)){
    df = df[!is.na(df$New),c(1,3:6)]
    names(df)[5] = "Name"
    df = merge(ticker, df, "Name")
    df = df[grep('^[A-Z]+$', df$Ticker),] # keep one ticker for company
    df = df[!duplicated(df[,-2]),] # remove duplicates

    df[,5] = as.character(df[,5])
    df = df[which(df[,5] != ''),]
    df[,5] = as.Date(sapply(df[,5], function(x) gsub("\\s+", " ", x)), 
                               format = "%B %d %Y")

    # Get dates (i.e., estimated date of report, one day after report)
    df = data.frame("Ticker" = df[,2], df[,c(1,3,4,6)], 
                              "Date of Transaction" = as.Date(df[,5]), 
                              "Est Date of Report" = df[,5] + 7, 
                              "After One Day" = df[,5] + 8, 
                              "One Week" = df[,5] + 14,
                              "One Month" = df[,5] + 37,
                              "Two Months" = df[,5] + 67,
                              "Six Months" = df[,5] + 187)
    # Account for weekends
    for(k in 1:length(df[,1])){
      for(j in 7:12){
        if(weekdays(df[k,j]) == 'Saturday'){
          df[k,j] = df[k,j] + 2
        } else if(weekdays(df[k,j]) == 'Sunday'){
          df[k,j] = df[k,j] + 1
        }
      }
    }

    # organize df
    df = df[order(df$Ticker),]
    df[,1:4] = sapply(df[,1:4], as.character)
    # Remove duplicate lines
    df = df[df$Ticker %in% unique(merged$Ticker),]
    df$Value = as.character(df$Value)
    rownames(df) = NULL
  }

  return(df)
}

