# Looking at Financial Transactions of Congress Members

## 1 Data
We get the data from the website opensecrets.org, specifically the “Recent Financial Transactions” page  (https://www.opensecrets.org/pfds/recent_trans.php).   This will get us the 50 most recent transactions. Data is of the format:
```
Member  | Company | Action  (Purchased, Sold, or Exchanged) | Date of Transaction | Value
```

Getting recent transactions by member takes a little more effort, but will give us transactions as far back as 2012. However, congress members do not have any transaction history, and when we try to retrieve the nonexistent data for that member, we instead get the 50 most recent transactions. So, we will check which members do not have transactions, and remove them from our data.  We end up with usable data from 78 congress members, saved into one list in R (usable2 in congress.RData).

Code for this is lines 1-32 of transactions.R.

## 2 Merging Data with Tickers
First, we need to merge the Historical Prices file with a list of tickers (merge_hist.R).  Then, because the company names in the data we obtained   from opensecrets.org are slightly different from the ones stated in the Historical Prices file (i.e., “Ebay” vs. “Ebay Inc.”), so we need to do some character matching to make sure the companies are the same despite differences in names (get_transactions in transactions_functions.R). Finally, we run a loop through each data frame of our list to merge each transaction instance with the ticker for that stock (get_transactions2 in transactions_functions.R).

## 3 Adding Time Periods for Residual Return Calculations
Next, we generate   six new columns to our data   frames  (get_transactions2 in transactions_functions.R):
- Estimated Date of Report  - assumed to be one week after the date of transaction
- One Day After Report
- One Week After Report
- One Month After Report
- Two Months After Report
- Six Months After Report

Our output is now in the format:
```
Ticker  | Company Name  | Member  | Action  | Value  | Estimated Date of Report | Various Time Periods
```

We will calculate residual returns for each of the time periods after the estimated date of report.

## 4 Residual Returns
In order to calculate residual returns, we first find the date in the historical prices and the market prices that match the estimated date of report. We then get the market price on that day, as well as the price of the stock on that day using the index of the date of the respective files. Then, we get the date for each of the time periods following the date of report. If these dates do not exist in the historical prices file, we do not calculate the residual returns (return NA). (get_res_returns in residual _return_functions.R)

We end up with a list of 78 data frames, each data frame with residual returns for each of the congress members' individual transactions. (all_returns in congress.RData, see figure1.png)

## 5 Cleaning Residual Returns Data Frames
Before we can continue on to calculate average residual returns, we need to add Political Party, State, and Year columns to each of our data frames.   We also need to remove any columns for which we could not calculate any residual returns (get_res_returns2 in residual_return_functions.R). We get output (all_returns2 in congress.RData) of the format:
```
Year  | Party | State | Member  | Ticker  | Action  | Value  | Estimated Date of Report | Various Time Periods
```

## 6 Average Residual Returns
The function get_average (average _returns_functions.R) calculates average residual returns over all_returns2 by year and transaction. We do this for each year and all types of transactions, and then repeat the process by subsetting our returns list into Republicans and Democrats. The function save_average then combines all of the average residual returns into three data frames, separating by Both Parties, Democrats, and Republicans, and saves the results into an Excel file with three sheets.  ('Average Residuals.xlsx')

## 7 Improving Signal for Average Residual Returns
We get really low average residual returns (close to 0) when we calculate the average over all returns, so we will try to improve the signal through a few methods (improvements.R). 

### 7.1 Method 1
Some of the congress members have a high volume of trades, so it is possible that rather than making their own investments, they have hired someone to make the investments for them.  In order to differentiate between who made their own investments and who didn't, I created a set of rules to remove instances where congress members didn't make their own investments:
1.  Look at congress members with more than 100 transactions.
2.  If the transaction stock is one of the tops six stocks invested in by the congress member, remove all transactions with value less than  $50,000.
3.  If the transaction stock isn't one of the top six stocks, remove all transactions with value less than  $15,000.

We don't remove all the transactions because if there is a transaction with a higher value, it is probable that the congress made that investment by him or her ('Average_Residuals2.xlsx').

### 7.2 Method 2
We look at the top fifteen invested stocks, all of which have at least ten transactions, and remove the investments with value under $100,000. ('Average_Residuals3.xlsx')

### 7.3 Method 3
We do a combination of the previous two methods ('Average_Residuals4.xlsx').

### 7.4 Results
There doesn’t seem to be any overall improvement in signal from each of these improvement methods  - if anything, some of the methods cause us to get even worse signals.  For example, we go from a 0.60% one day after report for stocks purchased in 2012 to 0.25% after using method 4.

On the other hand, we also get some improvements - we go from a 2.48% two months after report for stocks sold in 2014 to 4.88% after using method 2, and to 5.30% after using method 4.

## 8 Other Analysis
See analysis.R

### 8.1 Top Investments
See inv_2012.png, inv_2013.png, and inv_2014.png.

### 8.2 Looking at Volume of Transactions by State
In order to look at transactions by states instead of members, we need to reorganize our data so that each data frame in our list is a data frame of all the transactions of one state. We get a list of 35 data frames (mem_by_state)

Texas had the highest volume of transactions total, but California had the most investors. For some states, there was only one transaction, so I looked to see if any of these transactions gave any information:
* Tim Griffin (Republican, Arkansas)
  - Invested in Murphy Oil Company in 2012 (company in Arkansas)
  - Committee of Ways and Means
* Joe Heck (Republican, Nevada)
  - Invested in Retail Properties of America in 2013 (company in Illinois)
 * Jim Langevin (Democrat, Rhode Island)
  - Invested in CSX Corporation (transportation company in Florida)
  - Committee of Ways and Means
* Allyson Schwartz  (Democrat, Pennsylvania)
  - Invested in Teva Pharmaceutical Industries (company in Israel)
  - Committee of Ways and Means
* Lee Terry  (Republican, Nebraska)
  - Invested in Pinnacle West Capital Corporation
  - Committee of Energy and Commerce
  - Subcommittee on Energy and Power

### 8.3 Possible Next Steps
We can look at members that only made one investment in states with more than one transaction. We can also look at average returns by state.
