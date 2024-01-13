from bs4 import BeautifulSoup
import requests

url = 'https://en.wikipedia.org/wiki/The_World%27s_Billionaires'
page = requests.get(url)
soup = BeautifulSoup(page.text, 'html')

soup.find_all('table')[2]

table = soup.find_all('table')[2]

main_titles = table.find_all('th')

main_table_titles = [title.text.strip() for title in main_titles]
print(main_table_titles)

import pandas as pd

df = pd.DataFrame(columns = main_table_titles)

column_data = table.find_all('tr')

for row in column_data[1:]:
    row_data = row.find_all('td')
    individual_row_data = [data.text.strip() for data in row_data]
    
    length = len(df)
    df.loc[length] = individual_row_data