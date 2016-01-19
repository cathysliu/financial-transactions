get_average = function(lst, year, action){
#returns a dataframe with the average residual returns for a certain year and type of transaction
#lst: list of residual returns
#year: year for transactions for which we want to calculate average residual returns
#action: type of transaction, "Purchased", "Sold", or "Exchanged"
  df = data.frame(matrix(0, 0, 5))
  #initialize empty dataframe
  for(i in 1:length(lst)){
    last_ind = dim(lst[[i]])[2]
    new_df = data.frame(lst[[i]][lst[[i]]$Year == year & lst[[i]]$Action == action, 9:last_ind], 
                        matrix(NA, sum(lst[[i]]$Year == year & lst[[i]]$Action == action), (13-last_ind)))
    if(dim(new_df)[1] > 0){
      names(new_df) = names(df)
      df = rbind(df, new_df)
    }
  }
  num_trans = dim(df)[1] #get number of transactions
  df = sapply(sapply(df, mean, na.rm = T), function(x) round(x, 6))
  df = data.frame("Year" = year, "Action" = action, "Number of Transactions" = num_trans, 
                  'One Day After Report' = df[1], 'One Week After Report' = df[2], 
                  'One Month After Report' = df[3], 'Two Months After Report' = df[4], 
                  'Six Months After Report' = df[5])
  rownames(df) = NULL
  df[sapply(df,is.nan)] = NA
  #remove NaN values
  return(df)
}

save_averages = function(df, name){
  #generates dataframes of average residual returns for all parties, Democrats, and Republicans
  #saves dataframes in Excel files
  #df: dataframe of residual returns
  #name: Excel file name
  avg = get_average(df, "2012", "Purchased")
  avg = rbind(avg, get_average(df, "2012", "Sold"),
              get_average(df, "2012", "Exchanged"),
              get_average(df, "2013", "Purchased"),
              get_average(df, "2013", "Sold"),
              get_average(df, "2013", "Exchanged"),
              get_average(df, "2014", "Purchased"),
              get_average(df, "2014", "Sold"),
              get_average(df, "2014", "Exchanged"))
  avg = avg[-which(apply(avg[,4:8], 1, function(x) sum(is.na(x))) != 0),]
  #remove rows where no averages calculated
  
  #get average residual returns based on party
  dem = df[which(sapply(df, function(x) x$Party[1] == 'D'))]
  dem = dem[which(sapply(dem, function(x) dim(x)[1] != 0))]
  avg_dem = get_average(dem, "2012", "Purchased")
  avg_dem = rbind(avg_dem, get_average(dem, "2012", "Sold"),
                  get_average(dem, "2012", "Exchanged"),
                  get_average(dem, "2013", "Purchased"),
                  get_average(dem, "2013", "Sold"),
                  get_average(dem, "2013", "Exchanged"),
                  get_average(dem, "2014", "Purchased"),
                  get_average(dem, "2014", "Sold"),
                  get_average(dem, "2014", "Exchanged"))
  avg_dem = avg_dem[-which(apply(avg_dem[,4:8], 1, function(x) sum(is.na(x))) != 0),]
  
  gop = df[which(sapply(df, function(x) x$Party[1] == 'R'))]
  gop = gop[which(sapply(gop, function(x) dim(x)[1] != 0))]
  avg_gop = get_average(gop, "2012", "Purchased")
  avg_gop = rbind(avg_gop, get_average(gop, "2012", "Sold"),
                  get_average(gop, "2012", "Exchanged"),
                  get_average(gop, "2013", "Purchased"),
                  get_average(gop, "2013", "Sold"),
                  get_average(gop, "2013", "Exchanged"),
                  get_average(gop, "2014", "Purchased"),
                  get_average(gop, "2014", "Sold"),
                  get_average(gop, "2014", "Exchanged"))
  avg_gop = avg_gop[-which(apply(avg_gop[,4:8], 1, function(x) sum(is.na(x))) != 0),]
  
  #save results to Excel file
  library(xlsx)
  wb = createWorkbook()
  cs = CellStyle(wb) + Font(wb, isBold=TRUE)
  addDataFrame(avg, sheet =createSheet(wb, sheetName = "Both Parties"), row.names=F, colnamesStyle=cs)
  addDataFrame(avg_dem, sheet = createSheet(wb, sheetName = "Democrats"), row.names=F, colnamesStyle=cs)
  addDataFrame(avg_gop, sheet = createSheet(wb, sheetName = "Republicans"), row.names=F, colnamesStyle=cs)
  saveWorkbook(wb, paste(name, '.xlsx', sep=''))
  rm(wb, cs)
}