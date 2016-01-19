from bs4 import BeautifulSoup
from urllib2 import urlopen

reps = urlopen('https://www.opensecrets.org/politicians/summary_all.php').read()
reps = BeautifulSoup(reps,'lxml')
reps = reps.find('table', attrs={'id':'data'})
headings = [str(th.get_text()) for th in reps.find_all('th')]
reps = [str(tr.get_text()).split('\n')[0] for tr in reps.find('tbody').find_all('tr')]
#reps = [rep.replace(', ', '\t') for rep in reps]

with open("reps.txt", "wb") as f:
    for rep in reps:
        f.write(rep + '\n')
    f.close() 
