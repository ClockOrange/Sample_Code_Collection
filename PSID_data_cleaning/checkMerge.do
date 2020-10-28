
clear all
cd "/Users/clockorange/Downloads/Thresholds code review/Zhuocheng_Deliverables/"

import delimited "./output/csv/final_append.csv", delimiter(comma) clear 
duplicates drop


keep st year fips county finalid
tempfile review
save `review'
describe using `review', varlist short

import delimited "./finalOutput/old_final_append.csv", delimiter(comma) clear 
duplicates drop

keep st year fips county finalid
tempfile origin
save `origin'
describe using `origin', varlist short

merge 1:1 finalid using `review'

tempfile result
save `result'

use `result', clear
keep if _merge==1
export delimited using "./finalOutput/dataInOrigin.csv", replace

use `result', clear
keep if _merge==2 
export delimited using "./finalOutput/dataInReview.csv", replace

*******************************************************************
*******************************************************************


clear all

import delimited "./output/csv/final_append.csv", delimiter(comma) clear 
duplicates drop

keep st year fips county median finalid
tempfile review
save `review'
describe using `review', varlist short

import delimited "./finalOutput/old_final_append.csv", delimiter(comma) clear 
duplicates drop

keep st year fips county median finalid
tempfile origin
save `origin'
describe using `origin', varlist short

merge 1:1 median-finalid using `review'


tempfile result
save `result'

use `result', clear
keep if _merge==1
export delimited using "./finalOutput/dataInOriginMedian.csv", replace

use `result', clear
keep if _merge==2 
export delimited using "./finalOutput/dataInReviewMedian.csv", replace
