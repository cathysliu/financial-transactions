## two functions:
## get_res_returns calculates the residual returns
## get_res_returns2 cleans up the returned dataframe (adds new columns, remove NA's)


get_res_returns = function(df){
## df: dataframe for which we want to calculate residual returns
## print(df$Member[1]) #prints member for which we are calculating residual returns
  res_returns = data.frame(matridf(NA,nrow = 1,ncol = 10)) # initialize dataframe
  names(res_returns) = c('Member', 'Ticker', 'Action', 'Value', 'Date.of.Report', 'After.One.Day', 
                         'One.Week', 'One.Month', 'Two.Months', 'Six.Months')
  if(dim(df)[1] > 0){
    for(i in 1:length(df$Ticker)){
      df = merged[merged$Ticker == df$Ticker[i], c(2,4,5,9,10)]
      df$Date = as.Date(df$Date)

        for(j in 1:5){
          if(weekdays(df[i,6]) == "Sunday"){
            # if the date falls on a Sunday, we want to add one day so the date will
            # match the date in the historical prices and market prices dataframes
            date1_ind = which(df$Date == (df[i,6] + 1)) # get date indices
            m1_ind = which(market$Date == (df[i,6] + 1))
          } else{
            date1_ind = which(df$Date == df[i,6])
            m1_ind = which(market$Date == df[i,6])
          }
          date_ind = which(df$Date == df[i,(j+7)])
          market_ind = which(market$Date == df[i,(j+7)])
          if(length(date_ind) > 0 & length(market_ind) > 0 & length(date1_ind) > 0){
            p1 = df[date1_ind,5] # stock price on date
            m1 = market[m1_ind,5] # market price
            # calculate residual returns
            res_returns[i,(j+5)] = (df[date_ind,5]/p1 - 1) - (market[market_ind,5]/m1 - 1)
          }
        }

      res_returns[i,1:4] = df[i,c(3,1,4,5)]
    }
  }
  # clean up df
  res_returns[,5] = as.Date(df$Date[i], format = "%Y-%m-%d")
  res_returns[,6:10] = sapply(res_returns[,6:10], function(df) round(df, 5))

  return(res_returns)
}



get_res_returns2 = function(df){
  # add Year, Party, State columns
  df$Year = sapply(df$Date.of.Report, function(x) format(x,'%Y'))
  df$Member = as.character(df$Member)

  for(i in 1:length(df$Member)){
    string = strsplit(df$Member[i],"-")[[1]]
    df$Party[i] = string[1]
    df$State[i] = string[2]
  }
  if(df$Member[i] == "Buchanan, Vernon(R-Fla)"){
    df$Member = sapply(df$Member, function(x) strsplit(x, "\\(")[[1]][1])
    df$Party = sapply(df$Party, function(x) strsplit(x, "\\(")[[1]][2])
  } else{
    df$Member = sapply(df$Member, function(x) strsplit(x, " \\(")[[1]][1])
    df$Party = sapply(df$Party, function(x) strsplit(x, " \\(")[[1]][2])
  }
  df$State = sapply(df$State, function(x) gsub("\\)", "", x))
  df = df[,c(which((names(df) %in% c('Year', 'Party','State'))),
                                     which(!(names(df) %in% c('Year', 'Party','State'))))]
  # remove transactions of $0 value
  if(any(df$Value == "$0 to $0")){
    df = df[df$Value != "$0 to $0",]
  }
  # remove columns with all NA's (i.e., columns where there were 0 residual returns calculated)
  df = df[,sapply(df, function(x) ifelse(sum(is.na(x)) == length(x),FALSE,TRUE))]
  return(df)
}
