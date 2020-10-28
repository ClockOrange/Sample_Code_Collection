
// cd project folders
cap version 16.1
clear all
set more off
capture log close


clear all
cd "/Users/clockorange/Downloads/Thresholds code review/Zhuocheng_Deliverables/"

log using "./log/incomeEligibilityThresholds-`time_string'.log", replace

cd code
 
 
// path to save all raw data files
global path "/Users/clockorange/Downloads/Thresholds code review/Zhuocheng_Deliverables/rawFiles/"

// path to save cleaned data files with Python code (files from 1990 to 1998)
global savePath "/Users/clockorange/Downloads/Thresholds code review/Zhuocheng_Deliverables/output/cleanFile/"

// path to save csv files
global csvPath "/Users/clockorange/Downloads/Thresholds code review/Zhuocheng_Deliverables/output/csv/"

// run python script
// enviroment: python3

// download files 
// could be comment out
//python script 1_downloadfile.py
//$path

python script 2_gen98_96.py 
$path
$savePath
$csvPath

// python code contains third-party package "antiword"
// used to extract .doc files
// which can not call directly by Stata
// more install information cound see 
// https://docs.bitnami.com/installer/apps/resourcespace/configuration/install-antiword/

/*python script 3_gen95.py
$path
$savePath
$csvPath
python script 4_gen94.py
$path
$savePath
$csvPath
 */
  
python script 5_gen93.py
$path
$savePath
$csvPath

python script 6_gen92_91.py
$path
$savePath
$csvPath

python script 7_gen90.py
$path
$savePath
$csvPath
 
cd "/Users/clockorange/Downloads/Thresholds code review/Zhuocheng_Deliverables/"
// run Do files
// clean date from 1999 to 2017
do code/8_cleanData1999_2017.do
di "------- finish clean 1999_2017 --------"

// update 1995,1994 files with l50_* and l80_*
// update 1990 files with FIPS Code
do code/9_updateFip95_94_90.do
di "------- finish update 1995_1994_1990 --------"


// append all data together
// sort, save
do code/10_appendData
di "------- finish append all data ---------"

log close

