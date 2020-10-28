import io
import re
import urllib.request
import sys
import pandas as pd 


import io
import re
import urllib.request
import sys
import pandas as pd 

# function to remove blank lines
def removeBreakLine(year,path,savePath):
    # remove break lines for files 1990-1998 except 1994 & 1995 
    filePath = path+"hudincome"+str(year)+"origin.txt"
    a_file = open(filePath, "r")
    lines = a_file.readlines()
    a_file.close()

    new_file = open(savePath+"hudincome"+str(year)+"origin.txt", "w")
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
    filePath = savePath+"hudincome"+str(year)+"origin.txt"
    a_file = open(filePath, "r")
    lines = a_file.readlines()
    a_file.close()

    filePath = savePath+"hudincome"+str(year)+"origin.txt"
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
            temp = ' '.join(splitline[len(splitline)-8:len(splitline)])
            count  += 1
            new_file.write(temp+'\n')
        elif count == 4:
            temp = ' '.join(splitline[ len(splitline)-8 : len(splitline)])
            count  += 1
            new_file.write(temp+'\n')
        elif count == 5 :
            temp = ' '.join(splitline[len(splitline)-5 : len(splitline)])
            count = 1
            new_file.write(temp+'\n')

        #new_file.write(temp+'\n')

    new_file.close()


path = input("Enter path:- ")
savePath = path
csvPath = path

#removeBreakLine(1998,path,savePath)
#removeCRLF(1998,savePath)
#removeBreakLine(1998,savePath,savePath)
#saveDF(1998,savePath)

removeBreakLine(1990,path,path)
removeBreakLine(1991,path,path)
removeBreakLine(1992,path,path)