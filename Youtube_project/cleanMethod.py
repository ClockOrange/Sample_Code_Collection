import numpy as np
import pandas as pd 
import string
import sys
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

def isLineEmpty(line):
    return len(line.strip()) < 1 
def oneChar(line):
    return len(line) <=1

def clearup(s, chars):
    return re.sub('[%s]' % chars, '', s).lower()


# dataframe input 
def clean(commentDF):
    comment_train = []
    names = commentDF.columns
    # tokenizer & remove stop words & digits
    tokenizer = RegexpTokenizer(r'\w+')
    lemmatizer = WordNetLemmatizer()
    stemmer = PorterStemmer()
    # remove html & punctuation
    comment_clean=[]
    for n in names:
        for lines in commentDF[n]:#.itertuples(name='Pandas'):
            #comment_train.append(line['comment'])
            
            comment = str(lines)
            #print(comment)
            soup = BeautifulSoup(comment,'lxml')
            html_free = soup.get_text()
            no_punct = "".join([c for c in html_free if c not in string.punctuation])
            comment = no_punct

        # for comment in comment_train:
            comment = clearup(comment, string.punctuation+string.digits)
            comment = tokenizer.tokenize(comment.lower())
            comment = [w for w in comment if w not in stopwords.words('english')]
            comment = [p for p in comment if not p.isdigit()]
            comment = " ".join([lemmatizer.lemmatize(i) for i in comment])
            comment = re.sub(r'^https?:\/\/.*[\r\n]*|www|http', '', comment)
            # comment = " ".join([stemmer.stem(i) for i in comment])

                # Remove single characters from the start 
            # if not isLineEmpty(comment):
                #if not oneChar(comment):
            comment_clean.append(comment)
        #save as new file 
        cleanData = pd.DataFrame(comment_clean)
        cleanData.to_csv("des.csv",index=False)

        #convert words to vector
        #bag of words TF-IDF
        df = pd.read_csv("des.csv")
        df.replace(np.nan,'',regex=True)

        docs = df.to_numpy().ravel()
        newDoc = []
        for doc in docs:
            if doc is np.nan:
                doc = ""
            newDoc.append(doc)
        newDoc = np.array(newDoc)
        print(newDoc)

        vectorizer = TfidfVectorizer(min_df=0.01,max_df=0.9,use_idf=True)

        X = vectorizer.fit_transform(newDoc)
        # print("names : ",vectorizer.get_feature_names())
        # print("count :",len(vectorizer.get_feature_names()))

        return X.toarray()
   
def main():
    # read in file
    path = sys.argv[1]
    # get datafram
    #df = pd.read_csv(path)[:1000]
    df = pd.read_csv(path)
   
    # col_name = 'title'
    results = []

    col_name = 'title'
    commentDF = df[[col_name]]
    res = clean(commentDF)
    results.append(res)
    print(res.shape)

    col_name = 'description'
    desDF = df[[col_name]]
    #desDF.drop_duplicates(subset='description',keep="last") 
    res = clean(desDF)
    results.append(res)
    print(res.shape)

    results = np.hstack(results)
    # pca = PCA().fit(results)
    #Plotting the Cumulative Summation of the Explained Variance
    # plt.figure()
    # plt.plot(np.cumsum(pca.explained_variance_ratio_))
    # plt.xlabel('Number of Components')
    # plt.ylabel('Variance (%)') #for each component
    # plt.title('Title & Description Dataset Explained Variance')
    # plt.show()

    pca = PCA(n_components=200)
    principalComponents = pca.fit_transform(results)
    # plt.figure()
    # plt.plot(np.cumsum(principalComponents.explained_variance_ratio_))
    # plt.xlabel('Number of Components')
    # plt.ylabel('Variance (%)') #for each component
    # plt.title('Title & Description Dataset Explained Variance with component 200')
    # plt.show()
    print(principalComponents.shape)
    #save final 
    Data = pd.DataFrame(principalComponents)
    Data.to_csv("Text_vector_all.csv")



if __name__== "__main__":
  main()