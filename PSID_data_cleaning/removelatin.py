import io
import re
import urllib.request
import sys
import pandas as pd


def isEnglish(s):
    try:
        s.encode(encoding='utf-8').decode('ascii')
    except UnicodeDecodeError:
        return False
    else:
        return True



filePath = "/Users/clockorange/Downloads/Thresholds code review/Zhuocheng_Deliverables/rawFiles/hudincome1995copy.txt"
a_file = open(filePath, "r",encoding = "latin-1")
lines = a_file.readlines()
a_file.close()

new_file = open(filePath, "w")
for line in lines[1:]:
    if line != '\n' :
        if isEnglish(line):
            if len(line.split()) > 2 and len(line)>5:
                new_file.write(line)


filePath = "/Users/clockorange/Downloads/Thresholds code review/Zhuocheng_Deliverables/rawFiles/hudincome1994copy.txt"
a_file = open(filePath, "r",encoding = "latin-1")
lines = a_file.readlines()
a_file.close()

new_file = open(filePath, "w")
for line in lines[1:]:
    if line != '\n' :
        if isEnglish(line):
            if len(line.split()) > 2 and len(line)>5:
                new_file.write(line)
