
****This Stata code is to deal with crime data from California Policy Lab****

clear all
cap log c
set more off
macro drop _all
estimates clear

cd "/Users/ClockOrange/Documents/Cali_crime"
import delimited /Users/ClockOrange/Documents/Cali_crime/case.csv

gen arrest_date2=date(arrest_date,"YMD")
gen dispos_date2=date(dispos_date,"YMD")

sort person_id  arrest_date


*Create a variable called ‘re_arrest’ that equals
*one if the defendant was arrested prior to trial and zero otherwise. 

gen re_arrest=0
local i=1
while `i'<=20000{
replace re_arrest=1 if arrest_date2[_n+1]<dispos_date2[_n]& ///
person_id[_n]==`i'&person_id[_n+1]==`i'

local i=`i'+1
}


save case_finished.dta, replace
clear

* Create a variable called prior_arrests that equals the number of arrests prior to the current arrest.
* For example, if person z has five arrests in prior.csv and two in case.csv, her first
* arrest in case.csv should have prior_arrests = 5 and the second should have prior_arrests =
* 6. If someone is not included in prior_arrests.csv, assume they had zero arrests at the start
* of the study period.
import delimited /Users/ClockOrange/Documents/Cali_crime/rior_arrests.csv
bysort person_id: gen prior_arrest=[_N]
collapse prior_arrest,by(person_id)
save prior_arrests.dta,replace
clear all

use case_finished,clear
merge m:1 person_id using prior_arrests
replace prior_arrest=0 if prior_arrest==.

bysort person_id (arrest_date):replace prior_arrest=prior_arrest+_n-1
drop merge
save case_finished.dta, replace

**generate age that equals the defendant’s age at the time of each arrest
clear
import delimited /Users/ClockOrange/Documents/Cali_crime/demo.csv

encode gender, gen(sex)
encode race, gen(color)

gen bdate2=date(bdate,"YMD")


merge 1:m person_id using case_finished
gen age = (arrest_date2 - bdate2)/365.25
replace age=floor(age)
save case_finished.dta, replace

