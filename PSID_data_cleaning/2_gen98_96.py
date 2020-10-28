
import io
import re
import urllib.request
import sys
import pandas as pd 

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
def removeCRLF(year,savePath):
    filePath = savePath+"hudincome"+str(year)+".txt"
    a_file = open(filePath, "r")
    lines = a_file.readlines()
    a_file.close()
    new_file = open(filePath, "w")
    for line in lines:
        #if line != '\n' or line != '\r\n':
        temp = ' '.join(line.split())
        new_file.write(temp+'\n')
    new_file.close()


# function to read in each line in the txt file
# extract each line with following info:
# FIPS, State,fipcty, County, MSA code, MSA name
# median
# l50_*
# l80_*
def saveDF(year,savePath):
    filePath = savePath+"hudincome"+str(year)+".txt"
    a_file = open(filePath, "r")
    lines = a_file.readlines()
    a_file.close()

    filePath = savePath+"hudincome"+str(year)+".txt"
    new_file = open(filePath, "w")
    count = 1
    for line in lines:
        #if line != '\n' or line != '\r\n':
        splitline = line.split()
        temp = ""
        if count == 1: 
            save = ""
            indexs = splitline.index('MSA:')
            for item in range(0, indexs+1):
                if item == 0:
                    new_file.write(splitline[item]+'\n') 
                elif splitline[item] == 'MSA:':
                    temp = ' '.join(splitline[item+1:])
                    new_file.write(temp+'\n')
                elif splitline[item].isnumeric() and item > 0:
                    if len(save) > 0 :
                        save = save.lstrip()
                        new_file.write(save+'\n')
                        new_file.write(splitline[item]+'\n')
                        save = ""
                    else :
                        new_file.write(splitline[item]+'\n')
                else:
                        save = save + ' '+splitline[item]
                        #print(save)
            #temp = join(splitline)
            count  += 1
        elif count == 2:
            temp = splitline[len(splitline)-1]
            count  += 1
            new_file.write(temp+'\n')
        elif count == 3:
            temp = ';'.join(splitline[len(splitline)-8:len(splitline)])
            count  += 1
            new_file.write(temp+'\n')
        elif count == 4:
            temp = ';'.join(splitline[ len(splitline)-8 : len(splitline)])
            count  += 1
            new_file.write(temp+'\n')
        elif count == 5 :
            temp = ';'.join(splitline[len(splitline)-5 : len(splitline)])
            count = 1
            new_file.write(temp+'\n')

        #new_file.write(temp+'\n')
    new_file.close()

## read as dataframe

    
# function to read in lines 
# and seperate each term with semicolon 
def changeSep(year,saveDF):
    # read changed file
    # add ; as seperator
    filePath = saveDF + "hudincome"+str(year)+".txt"
    a_file = open(filePath, "r")
    lines = a_file.readlines()
    a_file.close()

    filePath = saveDF + "hudincome"+str(year)+".txt"
    new_file = open(filePath, "w")
    count = 1
    temp = ""
    for line in lines:
        line = line.rstrip("\n")
        if count < 10:
            if count == 4 or count == 6:
                line = re.sub('[^a-zA-Z-,.\' ]+', '', line)
                line = line.lstrip()
            temp  = temp + line +';'
            count += 1
        elif count == 10:
            temp  = temp + line
            temp = temp.lstrip()
            temp = temp.rstrip("\n")
            temp = temp + ';'+str(year)
            new_file.write(temp+'\n')
            count = 1
            temp = ""


    
# function to dave txt files as csv files
def saveCSVfile(year,savePath,csvPath):
    savePath = savePath+"hudincome"+str(year)+".txt"
    Cov = pd.read_csv(savePath, 
                  sep=';', 
                  header = None,
                  names=["fipst", "st", "fipcty", "county","msa","msaname","median","l50_1",
                  "l50_2","l50_3","l50_4","l50_5","l50_6","l50_7","l50_8","l80_1","l80_2",
                  "l80_3","l80_4","l80_5","l80_6","l80_7","l80_8","fmre","fmr1","fmr2","fmr3","fmr4","year"])


    csvPath = csvPath+"income"+str(year)+".csv"
    Cov.to_csv (csvPath, index = False, header=True)
    print(' ------',str(year),'------')
    #print(Cov)



################################
# function calls

path = input("Enter path:- ")
savePath = input("Enter savepath:- ")
csvPath = input("Enter csvpath:- ")

removeBreakLine(1998,path,savePath)
removeCRLF(1998,savePath)
removeBreakLine(1998,savePath,savePath)
saveDF(1998,savePath)
changeSep(1998,savePath)
saveCSVfile(1998,savePath,csvPath)

removeBreakLine(1997,path,savePath)
removeCRLF(1997,savePath)
removeBreakLine(1997,savePath,savePath)
saveDF(1997,savePath)
changeSep(1997,savePath)
saveCSVfile(1997,savePath,csvPath)


removeBreakLine(1996,path,savePath)
removeCRLF(1996,savePath)
removeBreakLine(1996,savePath,savePath)
saveDF(1996,savePath)
changeSep(1996,savePath)
saveCSVfile(1996,savePath,csvPath)