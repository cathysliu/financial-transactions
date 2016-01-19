from bs4 import BeautifulSoup
from urllib2 import urlopen
import csv

#get list of reps from opensecrets.org
reps = urlopen('https://www.opensecrets.org/politicians/summary_all.php').read()
reps = BeautifulSoup(reps,'lxml')
reps = reps.find('table', attrs={'id':'data'})
headings = [str(th.get_text()) for th in reps.find_all('th')]
reps = [str(tr.get_text()).split('\n')[0] for tr in reps.find('tbody').find_all('tr')]

#getting recent transactions by member from opensecrets.org
reps = [line.strip() for line in open('reps.txt')]
for mem in reps:
    mem_name = mem.split(', ')
    member = urlopen('http://www.opensecrets.org/pfds/recent_trans.php?name='+ \
mem_name[0] + ', ' + mem_name[1] + '&asset=&amount=').read()
    member = BeautifulSoup(member,'lxml')
    member = member.find('table',attrs={'id':'transactions'})
    headings = [str(th.get_text()) for th in member.find('thead').find_all('th')]
    member = [str(tr.get_text()).split('\n')[1:-1] for tr in member.find('tbody').find_all('tr')]
    member = [headings] + member
    with open('congress/' + mem + '.csv', "wb") as f:
        writer = csv.writer(f)
        writer.writerows(member)
