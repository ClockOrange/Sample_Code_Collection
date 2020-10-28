import numpy as np
import pandas as pd 
import string
import nltk
from bs4 import BeautifulSoup
from nltk.tokenize import RegexpTokenizer
import os
nltk.download('stopwords')
nltk.download('wordnet')
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer
from nltk.stem.porter import PorterStemmer
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.feature_extraction.text import CountVectorizer

from sklearn.feature_extraction.text import TfidfTransformer
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt
import re


comment_train= []
df = pd.read_csv("comment_result.csv")
print(df.shape)
commetDF = df[['comment']]
print(commetDF)

def isLineEmpty(line):
    return len(line.strip()) < 1 
def oneChar(line):
    return len(line) <=1

def clearup(s, chars):
    return re.sub('[%s]' % chars, '', s).lower()
# remove html & punctuation
for lines in commetDF.itertuples(name='Pandas'):
    #comment_train.append(line['comment'])
    comment = str(lines.comment)
    #print(comment)
    soup = BeautifulSoup(comment,'lxml')
    html_free = soup.get_text()
    no_punct = "".join([c for c in html_free if c not in string.punctuation])
    comment_train.append(no_punct)
   

comment_clean=[]
# tokenizer & remove stop words & digits
tokenizer = RegexpTokenizer(r'\w+')
lemmatizer = WordNetLemmatizer()
stemmer = PorterStemmer()
for comment in comment_train:
    comment = clearup(comment, string.punctuation+string.digits)
    comment = tokenizer.tokenize(comment.lower())
    comment = [w for w in comment if w not in stopwords.words('english')]
    comment = [p for p in comment if not p.isdigit()]
    comment = " ".join([lemmatizer.lemmatize(i) for i in comment])
    # comment = " ".join([stemmer.stem(i) for i in comment])

        # Remove single characters from the start 
    if not isLineEmpty(comment):
        #if not oneChar(comment):
        comment_clean.append(comment)

#save as new file 
cleanData = pd.DataFrame(comment_clean)
cleanData.to_csv("text.csv",index=False)

#convert words to vector
#bag of words TF-IDF
df = pd.read_csv("text.csv")
df.replace(np.nan,'',regex=True)
# print(df)


docs = df.to_numpy().ravel()
newDoc = []
for doc in docs:
    if doc is not np.nan:
        newDoc.append(doc)
newDoc = np.array(newDoc)
print(newDoc)
#print(newDoc)

#vectorizer = TfidfVectorizer(ngram_range=(2,2),min_df=0.01,max_df=0.9,use_idf=True)
vectorizer = TfidfVectorizer(min_df=0.01,max_df=0.9,use_idf=True)
#count = CountVectorizer(ngram_range=(2,2))

#bag = count.fit_transform(newDoc[[0]])
# bag = count.fit_transform(newDoc)
# print(count.vocabulary_)
# print(bag.toarray())
# tfidf = TfidfTransformer(smooth_idf=True,use_idf=True)

# np.set_printoptions(2)
# xd = tfidf.fit_transform(bag).toarray()
# print(xd.shape)

# Data = pd.DataFrame(xd)
# Data.to_csv("fdcount.csv",index=False)

# for lin in range(df.shape[0]):
#     X = (str(vect[lin]))
#     print(X)

X = vectorizer.fit_transform(newDoc)
print("names : ",vectorizer.get_feature_names(),X.T.todense())
print("count :",len(vectorizer.get_feature_names()))
# for term in X:
    #Data = pd.DataFrame(term.T.todense(), index=vectorizer.get_feature_names(), columns=["tfidf"])
    # print(vectorizer.get_feature_names(), " ",term.T.todense())
#Data = Data.sort_values(by=["tfidf"],ascending=False)
# print(df)
    
X = X.toarray()
#print(X)
#Data = pd.DataFrame(X)
#Data.to_csv("fdcount.csv")
#     # sum by row 
#     print(lin)

pca = PCA(n_components=2)
pca.fit(X)  
pca = PCA().fit(X)
#Plotting the Cumulative Summation of the Explained Variance
plt.figure()
plt.plot(np.cumsum(pca.explained_variance_ratio_))
plt.xlabel('Number of Components')
plt.ylabel('Variance (%)') #for each component
plt.title('Pulsar Dataset Explained Variance')
plt.show()
print(pca.transform(X))  