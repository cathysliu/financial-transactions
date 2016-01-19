library(XML)

## 50 most recent transactions
# get recent transactions from opensecrets.org
recent = read.csv('data/recent_transactions.csv', header=T)
# to get most recent transactions, use:
# recent = data.frame(readHTMLTable('http://opensecrets.org/pfds/recent_trans.php'))
recent = get_transactions(recent)
recent_returns = get_res_returns(recent)
recent_returns = get_res_returns2(recent_returns)


## getting recent transactions by congress member
# get list of congress members
reps = as.character(read.delim('reps.txt',header = F)[,1])
reps_df = data.frame('Last' = rep(NA, length(reps)), 'First' = rep(NA, length(reps)))
for(i in 1:length(reps)){
  name_split = strsplit(reps[i], ', ')[[1]]
  reps_df[i,] = name_split
}

# loop over list of all congress members to get all transactions by reps
all_reps = list()
for(i in 1:length(reps)){
  url = paste('http://www.opensecrets.org/pfds/recent_trans.php?name=', reps_df[i,1], ',+', 
            reps_df[i,2], '&asset=&amount=',sep='')
  df = data.frame(readHTMLTable(url))
  all_reps[[i]] = df
}

# get reps that have data from recent transactions (2012-now)
usable = all_reps[which(sapply(all_reps,function(x) any(dim(x)[1] != 50)))]
usable = lapply(usable, get_transactions)
usable2 = lapply(usable, get_transactions2)
usable2 = usable2[-which(sapply(usable2, function(x) dim(x)[1]) == 0)]
usable2 = usable2[-which(sapply(usable2, function(x) length(names(x)) <= 6))]

# save as txt files
#for(i in 1:length(usable2)){
#  write.table(usable2[[i]], file = paste('usable_data/', usable2[[i]]$Member[1], '.txt',
#                                         sep = ''), quote = FALSE, sep = '\t')
#}

# get residual returns
all_returns = lapply(usable2, get_res_returns)
all_returns2 = lapply(all_returns, get_res_returns2)

# save residual returns to text files
#for(i in 1:length(all_returns2)){
#  write.table(all_returns2[[i]], file = paste('returns_data/', all_returns2[[i]]$Member[1],
#                                              '.txt', sep = ''), quote = FALSE, sep = '\t')
#}

# save average residual returns to Excel file
save_averages(all_returns2, 'Average_Residuals')
