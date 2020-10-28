
import io
import re
import urllib.request
import sys
import pandas as pd 

# msa
# fipst, 9,10 index
# fipcity, 11,12,13 index
# county
# l50,80
# median 


# function to remove blank lines
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


# function to remove all whitespace
# and split each term with " ", one space
def removeCRLF(year,path,savePath):
    filePath = path+"hudincome"+str(year)+".txt"
    a_file = open(filePath, "r")
    lines = a_file.readlines()
    a_file.close()

    filePath = savePath +"hudincome"+str(year)+".txt"
    new_file = open(filePath, "w")

    for index in range(5,len(lines)-1):
        if len(lines[index].split()) < 10 and len(lines[index].split()) > 3:
            #if line != '\n' or line != '\r\n':
            temp = ' '.join(lines[index].split())
            new_file.write(temp+'\n')
    new_file.close()



# gen line breaks
def genLine(year,savePath):
    filePath = savePath+"hudincome"+str(year)+".txt"
    a_file = open(filePath, "r")
    lines = a_file.readlines()
    a_file.close()

    new_file = open(filePath, "w")
    for line in lines:
        # msa
        # fipst, 9,10 index
        # fipcity, 11,12,13 index
        # county
        # l50,80
        # median 
        linesplit = line.split()

        lens = len(linesplit)
        temp = ' '.join(linesplit[2 : lens-3])
        new_file.write(temp+'\n')  # county

        new_file.write(linesplit[0]+'\n') # msa
        number = str(linesplit[1])

        new_file.write(number[0: len(number)-3]+'\n')# fipst
        new_file.write(number[ len(number)-3:]+'\n') # fipcty

        new_file.write(number +'\n')
        
        new_file.write(linesplit[lens-1]+'\n')    # median 

        new_file.write(linesplit[lens-3]+'\n')
        new_file.write(linesplit[lens-2]+'\n')

        
# add up as line and turn to csv
def genCsv(year,savePath):
    filePath = savePath+"hudincome"+str(year)+".txt"
    a_file = open(filePath, "r")
    lines = a_file.readlines()
    a_file.close()

    new_file = open(filePath, "w")
    count = 1
    for line in lines:
        
        if count == 8:
            line = line.rstrip('\n')
            new_file.write(line + ';'+str(year)+'\n')
            count = 1
        else:
            line = line.rstrip('\n')
            new_file.write(line + ';')
            count += 1


def saveCSVfile(year,savePath,csvPath):
    filePath = savePath+"hudincome"+str(year)+".txt"
    Cov = pd.read_csv(filePath, 
                  sep=';', 
                  header = None,
                  names=["county","msa","fipst","fipcty","statecty","median","l50_4","l80_4","year"])


    csvPath = csvPath+"income"+str(year)+".csv"
    Cov.to_csv (csvPath, index = False, header=True)
    print(' ------',str(year),'------')
    #print(Cov)


################################
# function calls

path = input("Enter path:- ")
savePath = input("Enter savepath:- ")
csvPath = input("Enter csvpath:- ")

removeBreakLine(1990,path,savePath)
removeCRLF(1990,savePath,savePath)
removeBreakLine(1990,savePath,savePath)
genLine(1990,savePath)
genCsv(1990,savePath)
saveCSVfile(1990,savePath,csvPath)