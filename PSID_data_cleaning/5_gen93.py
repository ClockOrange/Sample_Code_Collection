
import io
import re
import urllib.request
import sys
import pandas as pd 

## remove white space
# st, county, msa, fipst, fipcty, median
# l50_1,2,3,4,5,6,7,8
# l80_1,2,3,4,5,6,7,8

def removeBreakLine(year,path,savePath):
    # remove break lines for files 1990-1998 except 1994 & 1995 
    filePath = path+"hudincome"+str(year)+".txt"
    a_file = open(filePath, "r")
    lines = a_file.readlines()
    a_file.close()

    new_file = open(savePath+"hudincome"+str(year)+".txt", "w")
    for line in lines:
        if line != '\n':
            new_file.write(line)

    new_file.close()



def removeCRLF(year,path,savePath):
    filePath = path+"hudincome"+str(year)+".txt"
    a_file = open(filePath, "r")
    lines = a_file.readlines()
    a_file.close()

    filePath = savePath +"hudincome"+str(year)+".txt"
    new_file = open(filePath, "w")
    for line in lines:
        temp = ' '.join(line.split())
        new_file.write(temp+'\n')
    new_file.close()

# generate 3 line as one component
# use , to seperate each variable
def genMissCode(year,savePath):
    filePath = savePath+"hudincome"+str(year)+".txt"
    a_file = open(filePath, "r")
    lines = a_file.readlines()
    a_file.close()
    
    new_file = open(filePath, "w")
    count = 1
    for line in lines:
        splitline = line.split()
        if count == 1:
            if splitline[len(splitline)-6].isnumeric():

                lens = len(splitline)
                #splitline.append(str('-1'))
                # county name
                chartemp = ' '.join(splitline[0: len(splitline)-6])
                new_file.write(chartemp+"\n")

                new_file.write(splitline[lens-6] + ' ')
                new_file.write(splitline[lens-5] + ' ')
                new_file.write(splitline[lens-4]+' ')
                new_file.write(splitline[lens-3]+'\n')
               
            else:

                lens = len(splitline)
                fipts = splitline[lens - 4]

       
                chartemp = ' '.join(splitline[0: lens-5])
                new_file.write(chartemp+"\n")

                new_file.write(splitline[lens-5] + ' ')

                fip = fipts[:len(fipts)-3]
                fipt = fipts[len(fipts)-3:]
                new_file.write(fip+' '+fipt+' ')

                chartemp = splitline[lens-3]
                chartemp = chartemp.rstrip()
                new_file.write(chartemp+"\n")
            count += 1
        elif count == 3:
            new_file.write(' '.join(splitline)+'\n')
            count = 1
        else:
            new_file.write(' '.join(splitline)+"\n")
            count += 1



def genLine(year,savePath):
    filePath = savePath+"hudincome"+str(year)+".txt"
    a_file = open(filePath, "r")
    lines = a_file.readlines()
    a_file.close()
    
    new_file = open(filePath, "w")
    count = 1
    for line in lines:
        splitline = line.split()
        save = ""
        if count == 1:
            stcode = splitline[0]
            new_file.write(stcode+';')
            other = splitline[1:]

            others = ' '.join(other)
            others = others.rstrip("\n")
            others = others+';'
            new_file.write(others)
            count += 1
        elif count == 4:
           
            temp = ';'.join(splitline)
            temp = temp.rstrip("\n")
          

            temp = temp +';'+str(year)
            temp = temp.rstrip("\n")
            new_file.write(temp+'\n')
            temp = ""
            count = 1
        elif count == 2:
            temp = ';'.join(splitline[0:4])
            temp = temp.rstrip("\n")
            temp = temp + ';'
            new_file.write(temp)
            count += 1

        else:
            temp = ';'.join(splitline)
     
            temp = temp.rstrip("\n")
            temp = temp+';'
            new_file.write(temp)
            count += 1

    new_file.close()

# st, county, msa, fipst, fipcty, median
# l50_1,2,3,4,5,6,7,8
# l80_1,2,3,4,5,6,7,8
def saveCSVfile(year,savePath,csvPath):
    filePath = savePath+"hudincome"+str(year)+".txt"
    Cov = pd.read_csv(filePath, 
                  sep=';', 
                  header = None,
                  names=["st", "county","msa","fipst","fipcty","median","l50_1",
                  "l50_2","l50_3","l50_4","l50_5","l50_6","l50_7","l50_8","l80_1","l80_2",
                  "l80_3","l80_4","l80_5","l80_6","l80_7","l80_8","year"])


    csvPath = csvPath+"income"+str(year)+".csv"
    Cov.to_csv (csvPath, index = False, header=True)
    print(' ------',str(year),'------')
    #print(Cov)



################################
# function calls

path = input("Enter path:- ")
savePath = input("Enter savepath:- ")
csvPath = input("Enter csvpath:- ")

removeBreakLine(1993,path,savePath)
removeCRLF(1993,savePath,savePath)
removeBreakLine(1993,savePath,savePath)
genMissCode(1993,savePath)
genLine(1993,savePath)
saveCSVfile(1993,savePath,csvPath)
