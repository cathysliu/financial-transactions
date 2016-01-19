
#investments in 2014, sorted from most popular to least
inv_2014 = as.data.frame(table(rle(unlist(sapply(all_returns2, function(x) unique(x[x$Year == '2014',]$Ticker))))$values))
inv_2014 = inv_2014[order(inv_2014[,2], decreasing = T),]
rownames(inv_2014) = NULL
head(inv_2014)
#1 MSFT   13
#2 AAPL   11
#3 INTC   10
#4    T    8
#5  COP    7
#6  JNJ    7

#2013
inv_2013 = as.data.frame(table(rle(unlist(sapply(all_returns2, function(x) unique(x[x$Year == '2013',]$Ticker))))$values))
inv_2013 = inv_2013[order(inv_2013[,2], decreasing = T),]
rownames(inv_2013) = NULL
head(inv_2013)
#1 MSFT   10
#2    T    8
#3 CSCO    7
#4   VZ    7
#5  XOM    7
#6 AAPL    6

#2012
inv_2012 = as.data.frame(table(rle(unlist(sapply(all_returns2, function(x) unique(x[x$Year == '2012',]$Ticker))))$values))
inv_2012 = inv_2012[order(inv_2012[,2], decreasing = T),]
rownames(inv_2012) = NULL
head(inv_2012)
#1 AAPL    4
#2 CSCO    4
#3  XOM    3
#4  ABT    2
#5  BAC    2
#6  BHI    2

#average returns by state
#unique states
states = unique(sapply(all_returns2, function(x) x$State[1]))
by_state = function(state, lst){
  df = data.frame(matrix(0, 0, 8))
  for(i in 1:length(lst)){
    if(lst[[i]]$State[1] == state){
      df = rbind(df, lst[[i]][,1:8])
    }
  }
  df = df[order(df$Ticker),]
  rownames(df) = NULL
  return(df)
}
mem_by_state = lapply(states, function(x) by_state(x, all_returns2))
#get unique member/ticker
mem_by_state = lapply(mem_by_state, function(x) unique(x))
#num transactions by state
sapply(mem_by_state, function(x) dim(x)[1])
#most transactions from Texas congress members (1035) (ind = 7)
#states with only 1 transaction
#"Ariz" "Ark"  "Nev"  "RI"   "Ind"  "Neb" 
#num members per state
sapply(mem_by_state, function(x) length(unique(x$Member)))
#Texas doesn't have most members; California does

#notes:
#single transactions of interest:
which(sapply(mem_by_state, function(x) dim(x)[1] == 1))
#18 20 21 22 29 31 33
#Tim Griffin (AR) - Murphy Oil Corp (MUR) - AR company
#is Tim Griffin in any committee?? C/O of Ways and Means
#Joe Heck (NV) - Retail Properties of America (RPAI) - IL company
#Company owns a lot of shopping centers - shopping mall recently opened in NV
#Jim Langevin (RI) - CSX - FL company ???
#Lee Terry of Nebraska - Pinnacle West Capital Corporation - PNW company (energy co)
#C/O on Energy and Commerce! Sub-C/O on Energy and Power

#transactions states with single member of interest:
which(sapply(mem_by_state, function(x) length(unique(x$Member)) == 1))
#5 6 12 14 16 18 19 20 21 23 24 26 28 30 31 32 33 34 35
