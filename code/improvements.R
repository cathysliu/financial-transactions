### Improving the Signal ###

## removing transactions that may have been done by someone the congress member hired
## getting number of transactions per congress member, ordered from most to least transactions

num_trans = order(sapply(usable2, function(x) dim(x)[1]), decreasing = T)
# ind most transactions ( > 100) first 11
most_trans = list()
for(i in 1:11){
  x = all_returns2[[num_trans[i]]]
  df = data.frame(table(x$Ticker))
  df = df[order(df[,2], decreasing = T),]
  most_trans[[i]] = x[(x$Ticker %in% as.character(head(df)[,1])) & x$Value != "$1,000 to $15,000" 
                      & x$Value != "$15,001 to $50,000" & x$Value != "$0 to $0",]
  if(dim(most_trans[[i]])[1] == 0){
    most_trans[[i]] = x[(x$Ticker %in% as.character(head(df)[,1])) & x$Value != "$1,000 to $15,000" 
                        & x$Value != "$0 to $0",]
    if(dim(most_trans[[i]])[1] == 0){
      most_trans[[i]] = x[(x$Ticker %in% as.character(head(df)[,1])) & x$Value != "$0 to $0",]
    }
  }
  rownames(most_trans[[i]]) = NULL
}
ar3 = all_returns2
ar3[num_trans[1:11]] = most_trans

save_averages(ar3, 'Average_Residuals2')

## removing top stocks that people invested in
values = c("$100,001 to $250,000","250,001 to $500,000", "$500,000 to $1,000,000",
"$1,000,001 to $5,000,000", "$5,000,001 to $25,000,000",
"$25,000,001 to $50,000,000", "$50,000,001 to $50,000,001")
ar4 = all_returns2
df = data.frame(table(rle(unlist(sapply(ar4,function(x) x$Ticker)))$values))
df = df[order(df[,2], decreasing = T),]
rownames(df) = NULL
top_stocks = as.character(head(df, 15)[,1])
#top 15 invested stocks (at least 10 transactions)

for(i in 1:length(ar4)){
  for(j in 1:15){
    if(dim(ar4[[i]])[1] > 0){
      if(top_stocks[j] %in% ar4[[i]]$Ticker){
        ar4[[i]] = ar4[[i]][-which(ar4[[i]]$Ticker == top_stocks[j] & ar4[[i]]$Value != values[1]
                                   & ar4[[i]]$Value != values[2] & ar4[[i]]$Value != values[3]
                                   & ar4[[i]]$Value != values[4] & ar4[[i]]$Value != values[5]
                                   & ar4[[i]]$Value != values[6] & ar4[[i]]$Value != values[7]),] 
      }
    }
  }
}
ar4 = ar4[-which(sapply(ar4, function(x) dim(x)[1]) == 0)]

save_averages(ar4, 'Average_Residuals3')

# combination of first two methods
ar5 = ar3
for(i in 1:length(ar5)){
  for(j in 1:15){
    if(dim(ar5[[i]])[1] > 0){
      if(top_stocks[j] %in% ar5[[i]]$Ticker){
        ar5[[i]] = ar5[[i]][-which(ar5[[i]]$Ticker == top_stocks[j] & ar5[[i]]$Value != values[1]
                                   & ar5[[i]]$Value != values[2] & ar5[[i]]$Value != values[3]
                                   & ar5[[i]]$Value != values[4] & ar5[[i]]$Value != values[5]
                                   & ar5[[i]]$Value != values[6] & ar5[[i]]$Value != values[7]),] 
      }
    }
  }
}
ar5 = ar5[-which(sapply(ar5, function(x) dim(x)[1]) == 0)]

save_averages(ar5, 'Average_Residuals4')
