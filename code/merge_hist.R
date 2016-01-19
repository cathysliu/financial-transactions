#merging ASF_companies and historical prices
asf = read.table('data/ASF_COMPANIES.TXT', header = T, sep = '\t')
asf = asf[order(asf$Ticker),]
historical = read.csv('data/Historical Prices.csv', header = F)
names(historical) = c(names(asf)[7], 'Date', 'Price')
merged = merge(asf, historical, names(historical)[1])
merged = na.omit(merged)
merged$Ticker = as.character(merged$Ticker)

#merge tickers from different stock exchanges
ticker_nasdaq = read.csv('data/companylist_nasdaq.csv')[1:2]
names(ticker_nasdaq)[1] = "Ticker"
ticker_nyse = read.csv('data/companylist_nyse.csv')[1:2]
names(ticker_nyse)[1] = "Ticker"
ticker_amex = read.csv('data/companylist_amex.csv')[1:2]
names(ticker_amex)[1] = 'Ticker'
ticker = rbind(ticker_nasdaq, ticker_nyse)[1:2]
ticker = rbind(ticker, ticker_amex)[1:2]
ticker = ticker[order(ticker$Ticker),]
ticker$Name = sapply(ticker$Name, function(x) gsub('&#39;', "'", x))
ticker = ticker[!duplicated(ticker$Name),]

#get market data
market = read.csv('data/w5000.csv')
market$Date = as.Date(market$Date)
res_returns = get_res_returns(recent_names)
