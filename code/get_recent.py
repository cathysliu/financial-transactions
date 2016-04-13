#getting most recent transactions from opensecrets.org
from bs4 import BeautifulSoup
from urllib2 import urlopen

recent = urlopen('http://www.opensecrets.org/pfds/recent_trans.php').read()
recent = BeautifulSoup(recent,'lxml')
recent = recent.find('table',attrs={'id':'transactions'})
headings = [str(th.get_text()) for th in recent.find('thead').find_all('th')]
recent = [str(tr.get_text()).split('\n')[1:-1] for tr in recent.find('tbody').find_all('tr')]
recent = [headings] + recent

import csv

with open("data/recent_transactions.csv", "wb") as f:
    writer = csv.writer(f)
    writer.writerows(recent)
