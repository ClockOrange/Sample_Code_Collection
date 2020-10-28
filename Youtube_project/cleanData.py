import pandas as pd 
import csv 

# clean data 

import re


comment_train= []
df = pd.read_csv("comment_result.csv")

commetDF = df[['comment']]
print(commetDF)
for lines in commetDF.itertuples(name='Pandas'):
    #comment_train.append(line['comment'])
    comment = str(lines.comment)
    #print(comment)
    comment_train.append(comment)
#print(comment_train)

#print(comment_train)

REPLACE_NO_SPACE = re.compile("&#39[.;:!\'?,\"()\[\]]|-|&#39|[?]|<br />|/><br|/>|\|<br|\<br")
REPLACE_WITH_SPACE = re.compile("(|\|<br\s*/><br\s*/>)|(\-)|(\/)")

def preprocess_reviews(reviews):
    for line in reviews:
        com = line.split()
        newstr=''
        for spl in com:
            #spl = re.sub("-|&#39|[?]|<br />|/><br|/>|\|<br|\<br",'',spl)
            spl = REPLACE_NO_SPACE.sub("",spl.lower())
            spl = REPLACE_WITH_SPACE.sub("",spl)
            spl = spl.replace("<b>",'')
            spl = spl.replace("&#39",'')
            spl = spl.replace("[]",'')
            spl = spl.replace("< b>",'')
            spl = spl.replace("<i>",'')

            newstr+=' '
            newstr +=spl
        print(newstr)
    #print(reviews)
    return reviews

reviews_train_clean = preprocess_reviews(comment_train)
# reviews_test_clean = preprocess_reviews(reviews_test)