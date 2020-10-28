import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import math
import datetime
from dateutil.parser import parse
from pandas import Grouper
import matplotlib as mpl

#read in files
df = pd.read_csv("ChannelVideo.csv")

dateDF = df['publish_date']
dateCsv = []
yearCsv = []
monthCsv=[]
for date in dateDF:
    if date is np.nan:
        date = '30-Nov-19'
#     print('Parsing: ' + date)
    dt = parse(date)
#     print(dt.date())
    dateCsv.append(dt.date())
    datee = datetime.datetime.strptime(str(dt.date()), "%Y-%m-%d")
    yearCsv.append(datee.year)
    monthCsv.append(datee.month)
#     print(dt.time())
#     print(dt.tzinfo)

dateDF = pd.DataFrame(dateCsv)
yearDF = pd.DataFrame(yearCsv)
monthDF = pd.DataFrame(monthCsv)
df['date']=dateDF
df['date'] = pd.to_datetime(df['date'])
df['year']=yearDF
df['month'] = monthDF

print(df.shape)
file = df
file.to_csv("addDate.csv", sep=',',index=False)
print(file.dtypes)


groups = file.groupby(['year','month'],as_index=False)["viewcount"].mean()
viewMonth = pd.DataFrame()
viewMonth = groups
print(viewMonth)
# yearSum = []
# viewCount = []
# year = []
# disCount = []
# print(groups)

# month = {1,2,3,4,5,6,7,8,9,10,11,12}
# monthCount = []
# for line,group in groups:
#     print(group.countview)
#     for data in line:
    #     #get count view
    #     print(data)


   
        

years = viewMonth['year'].unique()
print(years)
np.random.seed(100)
mycolors = np.random.choice(list(mpl.colors.XKCD_COLORS.keys()), len(years), replace=False)

plt.figure(figsize=(16,12), dpi= 80)
for i, y in enumerate(years):
    if i == 0:        
        plt.plot('month', 'viewcount', data=viewMonth.loc[viewMonth.year==y, :], color=mycolors[i], label=y)
        plt.text(viewMonth.loc[viewMonth.year==y, :].shape[0]-.9, viewMonth.loc[viewMonth.year==y, 'viewcount'][-1:].values[0], y, fontsize=12, color=mycolors[i])

# # Decoration
plt.gca().set(xlim=(1, 12), ylim=(100000, 10000000), ylabel='$view count$', xlabel='$Month$')
plt.yticks(fontsize=12, alpha=.7)
plt.title("Seasonal Plot of Video View Time Series", fontsize=20)
plt.show()