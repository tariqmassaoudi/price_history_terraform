# -*- coding: utf-8 -*-
from bs4 import BeautifulSoup
import requests
from tqdm import tqdm
from datetime import datetime
import pandas as pd
from tqdm.contrib.concurrent import thread_map
import sys
if len(sys.argv) < 2:
    n_subcategories=None
else:
    n_subcategories = int(sys.argv[1])

outfile='/home/ec2-user/scrape_scripts/data/jumia_data'+str(datetime.today().strftime('%Y-%m-%d'))+'d.csv'
subCategories=pd.read_csv('/home/ec2-user/scrape_scripts/subCategoriesHrefs.csv')
subCategories.href=subCategories.href.apply(lambda s: str(s).split("?shipped_from=country_local")[0])


def processArticle(article):
    dataid=article.find('a').get('data-id')
    href=article.find('a').get('href')
    category=article.find('a').get('data-category')
    name=article.find('a').get('data-name')
    price=article.find(class_='prc').text
    stars=article.find(class_='stars _s').text if article.find(class_='stars _s') else None
    reviewcount=article.find(class_='rev').text if article.find(class_='stars _s') else None
    brand=article.find('a').get('data-brand')
    discount=article.find(class_='bdg _dsct _sm').text if article.find(class_='bdg _dsct _sm') else False
    boutiqueOfficielle=True if article.find(class_='bdg _mall _xs') else False
    etranger=True if article.find(class_='bdg _glb _xs') else False
    fastDelivery=True if article.find(class_='shipp') else False
    image=article.find(class_='img').get('data-src')
    return {'reviewcount':reviewcount,'img_url':image,'id':dataid,'href':href,'name':name,'category':category,'brand':brand,'price':price,'stars':stars,'discount':discount,'boutiqueOfficielle':boutiqueOfficielle,'etranger':etranger,'fastDelivery':fastDelivery,'timestamp':datetime.today().strftime('%Y-%m-%d %H:%M:%S')}

def processPage(url):
    page = requests.get(url)
    soup = BeautifulSoup(page.text, 'html.parser')
    PageData=[processArticle(article) for article in soup.find_all(name='article',attrs={'class':'prd _fb col c-prd'})]
    PagaDataTable=pd.DataFrame(PageData)
    PagaDataTable.to_csv(outfile, mode='a', index=False,header=False, encoding="utf-8")

def processSubCategory(url):
    page = requests.get(url)
    soup = BeautifulSoup(page.text, 'html.parser')
    try:
        numPagesToScrape=soup.find(name='a',attrs={'class':'pg','aria-label':'Dernière page'}).get('href').split("page=")[1].split("#")[0]
    except:
        numPagesToScrape='1'
    urls=[url+'?page='+str(i) for i in range(int(numPagesToScrape)+1)]
    thread_map(processPage,urls,max_workers=32)

pd.DataFrame({'reviewcount':[],'img_url':[],'id':[],'href':[],'name':[],'category':[],'brand':[],'price':[],'stars':[],'discount':[],'boutiqueOfficielle':[],'etranger':[],'fastDelivery':[],'timestamp':[]}).to_csv(outfile,index=False)


for subCategory in tqdm(subCategories.href[:n_subcategories]):
    try:
        processSubCategory(subCategory)
    except:
        processSubCategory(subCategory)
print("Scraping completed successfully ✅")