
import io
import re
import urllib.request
import sys
import pandas as pd 

## remove white space
# st, county, msa, fipst, fipcty, median
# l50_1,2,3,4,5,6,7,8
# l80_1,2,3,4,5,6,7,8

# remove blank lines
def removeBreakLine(year,path,savePath):  
    # open file
    filePath = path+"hudincome"+str(year)+".txt"
    a_file = open(filePath, "r")
    # read in all lines 
    lines = a_file.readlines()
    a_file.close()
    # open new file pth
    new_file = open(savePath+"hudincome"+str(year)+".txt", "w")
    # write only if current line is not empty
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
        # split each line based on white space
        # then combine each term into one line, which seperate each by " "
        temp = ' '.join(line.split())
        new_file.write(temp+'\n')
    new_file.close()

# generate 3 line as one component
# use , to seperate each variable
# for eaxmple :
#    AL CALHOUN 450 1015 28500 26000
#    10000 11400 12800 14250 15400 16550 17650 18800
#    15950 18250 20500 22800 24600 26450 28250 30100

def genMissCode(year,savePath):
    filePath = savePath+"hudincome"+str(year)+".txt"
    a_file = open(filePath, "r")
    lines = a_file.readlines()
    a_file.close()

    new_file = open(filePath, "w")
    count = 1 # total 3 lines for each corhot
    for line in lines:
        splitline = line.split() # split line
        if count == 1: # first line
            if splitline[len(splitline)-4].isnumeric(): #450
                # write in all non-numeric terms
                # AL CALHOUN
                chartemp = ' '.join(splitline[0: len(splitline)-4])
                new_file.write(chartemp+"\n")

                # generate msa code lengthh
                lens = len(splitline)

                # number 1015 
                fipts = splitline[lens-3]
                # fip = [0:1] 10
                fip = fipts[:len(fipts)-3]
                # fipcty = [2: last] 15
                fipt = fipts[len(fipts)-3:]

                # save 450 as msa
                chartemp = splitline[len(splitline)-4]
                chartemp = chartemp.rstrip()
                new_file.write(chartemp+' ')

                # write in fips
                chartemp = fip
                chartemp = chartemp.rstrip()
                new_file.write(chartemp+' ')

                # write in fipcty
                chartemp = fipt
                chartemp = chartemp.rstrip()
                new_file.write(chartemp+' ')

                # write in 1015 as whole
                chartemp = fipts
                chartemp = chartemp.rstrip()
                new_file.write(chartemp+' ')

                # write in median 28500
                chartemp = splitline[len(splitline)-2]
                chartemp = chartemp.rstrip()
                new_file.write(chartemp+"\n")

            count += 1
        elif count == 3: # last line
            # write in all l80_*, split by " "
            new_file.write(' '.join(splitline)+'\n')
            count = 1
        else:
            for item in splitline:
                # write in all l50_*, split by " " 
                # regular expression 
                # beacuse some num followed by 'f'
                item =  re.sub("[^0-9]", "", item)          
                new_file.write(item+' ')            
            new_file.write('\n')
            count += 1


#    AL CALHOUN 
#    450 1015 28500 26000
#    10000 11400 12800 14250 15400 16550 17650 18800
#    15950 18250 20500 22800 24600 26450 28250 30100

def genLine(year,savePath):
    filePath = savePath+"hudincome"+str(year)+".txt"
    a_file = open(filePath, "r")
    lines = a_file.readlines()
    a_file.close()

    new_file = open(filePath, "w")
    count = 1
    for line in lines:
        splitline = line.split()
        if count == 1:
            # get state code AL
            stcode = splitline[0]
            if stcode == 'PACIFIC':
                new_file.write('PAC'+';')
                # write county, followed by ;
                other = splitline[0:]
                others = ' '.join(other)
                others = others.rstrip("\n")
                others = others+';'
                new_file.write(others)
            else:  
                # write in code
                new_file.write(stcode+';')

                # get in all rest items
                # write in county, followed by ;
                other = splitline[1:]
                others = ' '.join(other)
                others = others.rstrip("\n")
                others = others+';'
                new_file.write(others)
            count += 1

        elif count == 4: # last line
            # write in all num in one line but seperate by ;
            temp = ';'.join(splitline)
            temp = temp.rstrip("\n")

            # write year = i
            temp = temp +';'+str(year)
            temp = temp.rstrip("\n")
            new_file.write(temp+'\n')
            temp = ""
            count = 1

        elif count == 2:
            # write in all num in one line but seperate by ;
            temp = ';'.join(splitline[0:5])
            temp = temp.rstrip("\n")
            temp = temp + ';'
            new_file.write(temp)
            count += 1

        else:
            # write in all num in one line but seperate by ;
            temp = ';'.join(splitline)
            temp = temp.rstrip("\n")
            temp = temp+';'
            new_file.write(temp)
            count += 1

    new_file.close()

#  Each item seperated by ; can be read in as pandas dataframe, and export as csv
# AL;CALHOUN;450;1;015;1015;28500;10000;11400;12800;14250;15400;16550;17650;18800;15950;18250;20500;22800;24600;26450;28250;30100;1992

# st, county, msa, fipst, fipcty, median
# l50_1,2,3,4,5,6,7,8
# l80_1,2,3,4,5,6,7,8
def saveCSVfile(year,savePath,csvPath):
    filePath = savePath+"hudincome"+str(year)+".txt"
    Cov = pd.read_csv(filePath, 
                  sep=';', 
                  header = None,
                  names=["st", "county","msa","fipst","fipcty","statecty","median","l50_1",
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

removeBreakLine(1992,path,savePath)
removeCRLF(1992,savePath,savePath)
removeBreakLine(1992,savePath,savePath)
genMissCode(1992,savePath)
genLine(1992,savePath)
saveCSVfile(1992,savePath,csvPath)

removeBreakLine(1991,path,savePath)
removeCRLF(1991,savePath,savePath)
removeBreakLine(1991,savePath,savePath)
genMissCode(1991,savePath)
genLine(1991,savePath)
saveCSVfile(1991,savePath,csvPath)