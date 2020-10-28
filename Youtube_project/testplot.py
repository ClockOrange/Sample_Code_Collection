import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import math
import datetime
from dateutil.parser import parse
from pandas import Grouper
import matplotlib as mpl
from sklearn.decomposition import PCA

df = pd.read_csv("ChannelVideo.csv")

like = []
for data in df["like"]:
    data = math.log(data + 1)
    like.append(data)

dislike = []
for data in df["dislike"]:
    data = math.log(data + 1)
    dislike.append(data)
viewcount = []
for data in df["viewcount"]:
    data = math.log(data + 1)
    viewcount.append(data)
#data = np.column_stack((viewcount, like))
like = np.array(like)
dialike = np.array(dislike)
viewcount = np.array(viewcount)


X = pd.read_csv('Text_vector_all.csv')
X = X.drop(columns = ["Unnamed: 0"])
pca = PCA(n_components=2)
principalComponents = pca.fit_transform(X)
meanS = principalComponents.mean(axis=1)


Y = pd.read_csv('ChannelVideo.csv')
Y_train = Y["like"] / (Y["dislike"] + Y["like"])
index = Y_train>=0.9
principalComponents = principalComponents[index]
Y_train = Y_train[index]
print(Y_train.describe())


gridsize = (1, 1)
fig = plt.figure(figsize=(12, 8))
ax1 = plt.subplot2grid(gridsize, (0, 0), colspan=1, rowspan=1)
# >>> ax2 = plt.subplot2grid(gridsize, (2, 0))
# >>> ax3 = plt.subplot2grid(gridsize, (2, 1))
ax1.set_title('Y_label as a function of 2 component word vector score ',
              fontsize=14)
sctr = ax1.scatter(x=principalComponents[:,0], y=principalComponents[:,1], c=Y_train, cmap='RdYlGn')
plt.colorbar(sctr, ax=ax1, format='%d')
# ax1.set_yscale('log')
# >>> ax2.hist(age, bins='auto')
# >>> ax3.hist(pop, bins='auto', log=True)

# >>> add_titlebox(ax2, 'Histogram: home age')
# >>> add_titlebox(ax3, 'Histogram: area population (log scl.)')
# fig, (ax1) = plt.subplots(nrows=1, ncols=1,
#                                figsize=(8, 4))

#ax2.hist(age, bins='auto')
# ax3.hist(pop, bins='auto', log=True)
# ax1.scatter(x=viewcount, y=dislike, marker='o', c='yellow', edgecolor='b')
# ax1.set_title('Log Figure of $viewcount$ versus $dislike$')
# ax1.set_xlabel('$viewcount$')
# ax1.set_ylabel('$dislike$')
# ax2.hist(data, bins=np.arange(data.min(), data.max()),
#         label=('like', 'dislike'))
# ax2.legend(loc=(0.65, 0.8))
# ax2.set_title('Count of $like$ and $dislike$')
# ax2.yaxis.tick_right()

plt.show()



