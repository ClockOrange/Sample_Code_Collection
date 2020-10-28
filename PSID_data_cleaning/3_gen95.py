
import textract
import io
import re
import urllib.request
import sys
import pandas as pd



# function to extrct text from doc file
def extractDoc(year,path, savePath):
    filePath = path+"hudincome"+str(year)+".doc"
    text = textract.process(filePath)

    filePathnew = savePath +"hudincome"+str(year)+".txt"

    with open(filePathnew,'wb') as f:
        f.write(text)
    f.close()


# function to remove blank lines
def removeBlank(year,savePath):
    filePath = savePath+"hudincome"+str(year)+".txt"
    a_file = open(filePath, "r")
    lines = a_file.readlines()
    a_file.close()

    new_file = open(filePath, "w")
    for line in lines:
        if line != '\n':
            new_file.write(line)

    new_file.close()


# function to remove all whitespace
# and split each term with " ", one space
def removeCRLF(year,savePath):
    filePath = savePath +"hudincome"+str(year)+".txt"
    a_file = open(filePath, "r")
    lines = a_file.readlines()
    a_file.close()
   
    new_file = open(filePath, "w")
    for line in lines:
        temp = ' '.join(line.split())
        # remove some headers 
        if temp != "FY 1995 HUD INCOME LIMITS" and temp != "----I N C O M E L I M I T S--------------------------" and temp != "PREPARED: 12-10-94 PROGRAM 1 PERSON 2 PERSON" and temp != "3 PERSON 4 PERSON 5 PERSON 6 PERSON 7 PERSON 8 PERSON":
            if temp != "PREPARED: 12-10-94 PROGRAM 1 PERSON PERSON 3" and temp != "PERSON 4 PERSON 5 PERSON 6 PERSON 7 PERSON 8 PERSON":
                new_file.write(temp+'\n')
    new_file.close()


# function to read in each line in the txt file
# extract each line with following info:
# FIPS, State,fipcty, County, MSA code, MSA name
# median
# l50_*
# l80_*
def genLine(year,savePath):
    filePath = savePath+"hudincome"+str(year)+".txt"
    a_file = open(filePath, "r")
    lines = a_file.readlines()
    a_file.close()
    new_file = open(filePath, "w")

    tempstate = ""
    saveincome = ""
    count = 1
    for line in lines:
        line = line.lstrip(' ')
        linesplit = line.split(' ')
        #print(linesplit)
        lens = len(linesplit)
        if linesplit[0] == 'STATE:' :
            tempstate = ' '.join(linesplit[1: lens-1])
            tempstate = tempstate.lstrip(' ')
            count = 1
        #elif linesplit[0] == 'COUNTY':
        #    tempstate = ' '.join(linesplit[2: lens-1])
        #    tempstate = tempstate.lstrip(' ')
        #    count = 1
        else:
            if count == 1:
                # if is MSA
                # if is County or Driecti
                new_file.write(tempstate+'\n')
                # msa
                if linesplit[0] == 'MSA':
                    new_file.write('1' + '\n') # none county, use MSA
                    msa = ' '.join(linesplit[2:])
                    msa = msa.rstrip('\n')
                    new_file.write(msa + '\n')
                else:
                    new_file.write('0' + '\n') # none msa, use county
                    msa = ' '.join(linesplit[2:])
                    msa = msa.rstrip('\n')
                    new_file.write(msa + '\n')
                count += 1
                
            elif count == 2:
                saveincome = linesplit[lens-2] +' ' + linesplit[lens -1]
                saveincome = saveincome.rstrip('\n')
                #new_file.write(lowincome)
                
                count += 1
            elif count == 3:

                lowincome = ' '.join(saveincome.split()+linesplit) 
                #lowincome = ' '.join(linesplit)
                lowincome = lowincome.lstrip()
                lowincome = lowincome.rstrip('\n')
                new_file.write(lowincome +'\n')
                saveincome = ""
                count += 1

            elif count == 4:
                income = linesplit[1]
                income = income.rstrip('\n')
                new_file.write(income+'\n')

                saveincome = linesplit[lens-2] +' ' + linesplit[lens -1]
                saveincome = saveincome.rstrip('\n')
                #new_file.write(lowincome)

                count += 1
            elif count == 5:
                lowincome = ' '.join(saveincome.split()+linesplit) 
                lowincome = lowincome.lstrip()
                lowincome = lowincome.rstrip('\n')
                new_file.write(lowincome +'\n')
                saveincome = ""
                count = 1
            

# function to read in lines 
# and seperate each term with semicolon 
def saveDF(year,savePath):
    filePath = savePath+"hudincome"+str(year)+".txt"
    a_file = open(filePath, "r")
    lines = a_file.readlines()
    a_file.close()
  
    new_file = open(filePath, "w")
    count = 1
    saveline = ""
    for line in lines:
        if count == 1 or count == 2 or count == 3 or count == 5:
            line = line.rstrip('\n')
            if count == 3:
                line = re.sub('[^a-zA-Z-,.\' ]+', '', line)
                line = line.lstrip()
            saveline = saveline + line + ';'
       
            count += 1
        elif count == 4:
            temp = ';'.join(line.split())
            temp = temp.rstrip()
            saveline = saveline + temp +';'
            count += 1
      
        elif count == 6:
            temp = ';'.join(line.split())
            temp = temp.rstrip()
            saveline = saveline.lstrip()
            new_file.write(saveline +temp+';'+str(year)+'\n')
            saveline = ""
            count = 1



# function to dave txt files as csv files
def saveCSVfile(year,savePath,csvPath):
    filePath = savePath+"hudincome"+str(year)+".txt"
    Cov = pd.read_csv(filePath, 
                  sep=';', 
                  header = None,
                  names=["state", "msaindicator","county","l50_1",
                  "l50_2","l50_3","l50_4","l50_5","l50_6","l50_7","l50_8","median","l80_1","l80_2",
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

extractDoc(1995,path,savePath)
removeBlank(1995,savePath)
removeCRLF(1995,savePath)
removeBlank(1995,savePath)
genLine(1995,savePath)
saveDF(1995,savePath)
saveCSVfile(1995,savePath,csvPath)
