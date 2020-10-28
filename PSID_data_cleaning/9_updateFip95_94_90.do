
clear all

* cd project folder path
cd "/Users/clockorange/Downloads/Thresholds code review/Zhuocheng_Deliverables/"


/*******************************************************************************
	Generate 1995.csv files, in order to update fipcty code, msaname
	match with 1996.csv county name 
********************************************************************************/

import delimited "./output/csv/income1995.csv",clear

	gen     fipst = 1  if state == "ALABAMA"
	replace fipst = 2  if state == "ALASKA"
	replace fipst = 4  if state == "ARIZONA"
	replace fipst = 5  if state == "ARKANSAS"
	replace fipst = 6  if state == "CALIFORNIA"
	replace fipst = 8  if state == "COLORADO"
	replace fipst = 9  if state == "CONNECTICUT"
	replace fipst = 10 if state == "DELAWARE"
	replace fipst = 11 if state == "DIST. OF COLUMBIA"
	replace fipst = 12 if state == "FLORIDA"
	replace fipst = 13 if state == "GEORGIA"
	replace fipst = 15 if state == "HAWAII"
	replace fipst = 16 if state == "IDAHO"
	replace fipst = 17 if state == "ILLINOIS"
	replace fipst = 18 if state == "INDIANA"
	replace fipst = 19 if state == "IOWA"
	replace fipst = 20 if state == "KANSAS"
	replace fipst = 21 if state == "KENTUCKY"
	replace fipst = 22 if state == "LOUISIANA"
	replace fipst = 23 if state == "MAINE"
	replace fipst = 24 if state == "MARYLAND"
	replace fipst = 25 if state == "MASSACHUSETTS"
	replace fipst = 26 if state == "MICHIGAN"
	replace fipst = 27 if state == "MINNESOTA"
	replace fipst = 28 if state == "MISSISSIPPI"
	replace fipst = 29 if state == "MISSOURI"
	replace fipst = 30 if state == "MONTANA"
	replace fipst = 31 if state == "NEBRASKA"
	replace fipst = 32 if state == "NEVADA"
	replace fipst = 33 if state == "NEW HAMPSHIRE"
	replace fipst = 34 if state == "NEW JERSEY"
	replace fipst = 35 if state == "NEW MEXICO"
	replace fipst = 36 if state == "NEW YORK"
	replace fipst = 37 if state == "NORTH CAROLINA"
	replace fipst = 38 if state == "NORTH DAKOTA"
	replace fipst = 39 if state == "OHIO"
	replace fipst = 40 if state == "OKLAHOMA"
	replace fipst = 41 if state == "OREGON"
	replace fipst = 42 if state == "PENNSYLVANIA"
	replace fipst = 44 if state == "RHODE ISLAND"
	replace fipst = 45 if state == "SOUTH CAROLINA"
	replace fipst = 46 if state == "SOUTH DAKOTA"
	replace fipst = 47 if state == "TENNESSEE"
	replace fipst = 48 if state == "TEXAS"
	replace fipst = 49 if state == "UTAH"
	replace fipst = 50 if state == "VERMONT"
	replace fipst = 51 if state == "VIRGINIA"
	replace fipst = 53 if state == "WASHINGTON"
	replace fipst = 54 if state == "WEST VIRGINIA"
	replace fipst = 55 if state == "WISCONSIN"
	replace fipst = 56 if state == "WYOMING"
	replace fipst = 66 if state == "W.PACIFIC AREAS"
	replace fipst = 72 if state == "PUERTO RICO"
	replace fipst = 78 if state == "VIRGIN ISLANDS"
	
	
// drop state from original county variable
gen county_temp = strpos(county,",") 
replace county = substr(county, 1, county_temp - 1) if county_temp != 0
replace county = strtrim(county)
drop county_temp

// keep 1-21 characters as county_id		
gen county_id = upper(substr(county, 1, 21)) 
tempfile income1995
save `income1995'

// import 1996.csv 
import delimited "./output/csv/income1996.csv", clear

* Format County and MSA Names for Matching By Upper Casing and Deleting Everything
* that Comes After the Comma (usually state abbreviations)
gen county_temp = strpos(county,",") 
replace county = substr(county, 1, county_temp - 1) if county_temp != 0
replace county = strtrim(county)
drop county_temp

replace county  = upper(county) 

gen msa_temp = strpos(msaname,",") 
replace msaname = substr(msaname, 1, msa_temp - 1) if msa_temp != 0
replace msaname = strtrim(msaname)
drop msa_temp

replace msaname = upper(msaname) 

* Use the MSA name for metro areas and county name for non-metro areas.
* There will be multiple county_ids (when msa span multiple counties) but the
* duplicates will have the same median family incomes with the exception of two 
* MSAs (Kalamazoo-Battle Creek, MI and Odessa-Midland, TX), which appear to be an error. 
gen     county_id = msaname 
replace county_id = county if msa == 0
replace county_id = substr(county_id, 1, 21) 


* Make adhoc adjustments to improve matches. There isn't a match for these four 
* counties from the 1995 data in the 1996 data. However, the counties are present
* in the 1996 data it's just that they have a different MSA name. 

replace county_id = "COCONINO COUNTY" if fipst == 4  & msa == 2620 & county_id == "FLAGSTAFF"
replace county_id = "MESA COUNTY"     if fipst == 8  & msa == 2995 & county_id == "GRAND JUNCTION"
replace county_id = "KANE COUNTY"     if fipst == 49 & msa == 3739 & county_id == "CODE UNKNOWN"

replace county_id = "SPALDING COUNTY" if fipst == 13 & msa == 520  & county_id == "ATLANTA" & county == "Spalding County"

keep fipst fipcty st county_id msa county msaname

* Merge 1996 ids with 1995 data
* Virgin Islands is the only non-match so not a problem

merge m:1 fipst county_id using `income1995'
drop if _merge == 2
drop _merge

//keep year fipst fipcty median l80* l50*
duplicates drop
export delimited using "./output/csv/income1995update.csv", replace



/*******************************************************************************
	Generate 1994.csv files, in order to update fipcty code, msaname, msa code
	match with 1996.csv county name & fipst code
********************************************************************************/

clear all
import delimited "./output/csv/income1994.csv",clear

// generate fipst based on state name
	gen     fipst = 1  if state == "ALABAMA"
	replace fipst = 2  if state == "ALASKA"
	replace fipst = 4  if state == "ARIZONA"
	replace fipst = 5  if state == "ARKANSAS"
	replace fipst = 6  if state == "CALIFORNIA"
	replace fipst = 8  if state == "COLORADO"
	replace fipst = 9  if state == "CONNECTICUT"
	replace fipst = 10 if state == "DELAWARE"
	replace fipst = 11 if state == "DIST. OF COLUMBIA"
	replace fipst = 12 if state == "FLORIDA"
	replace fipst = 13 if state == "GEORGIA"
	replace fipst = 15 if state == "HAWAII"
	replace fipst = 16 if state == "IDAHO"
	replace fipst = 17 if state == "ILLINOIS"
	replace fipst = 18 if state == "INDIANA"
	replace fipst = 19 if state == "IOWA"
	replace fipst = 20 if state == "KANSAS"
	replace fipst = 21 if state == "KENTUCKY"
	replace fipst = 22 if state == "LOUISIANA"
	replace fipst = 23 if state == "MAINE"
	replace fipst = 24 if state == "MARYLAND"
	replace fipst = 25 if state == "MASSACHUSETTS"
	replace fipst = 26 if state == "MICHIGAN"
	replace fipst = 27 if state == "MINNESOTA"
	replace fipst = 28 if state == "MISSISSIPPI"
	replace fipst = 29 if state == "MISSOURI"
	replace fipst = 30 if state == "MONTANA"
	replace fipst = 31 if state == "NEBRASKA"
	replace fipst = 32 if state == "NEVADA"
	replace fipst = 33 if state == "NEW HAMPSHIRE"
	replace fipst = 34 if state == "NEW JERSEY"
	replace fipst = 35 if state == "NEW MEXICO"
	replace fipst = 36 if state == "NEW YORK"
	replace fipst = 37 if state == "NORTH CAROLINA"
	replace fipst = 38 if state == "NORTH DAKOTA"
	replace fipst = 39 if state == "OHIO"
	replace fipst = 40 if state == "OKLAHOMA"
	replace fipst = 41 if state == "OREGON"
	replace fipst = 42 if state == "PENNSYLVANIA"
	replace fipst = 44 if state == "RHODE ISLAND"
	replace fipst = 45 if state == "SOUTH CAROLINA"
	replace fipst = 46 if state == "SOUTH DAKOTA"
	replace fipst = 47 if state == "TENNESSEE"
	replace fipst = 48 if state == "TEXAS"
	replace fipst = 49 if state == "UTAH"
	replace fipst = 50 if state == "VERMONT"
	replace fipst = 51 if state == "VIRGINIA"
	replace fipst = 53 if state == "WASHINGTON"
	replace fipst = 54 if state == "WEST VIRGINIA"
	replace fipst = 55 if state == "WISCONSIN"
	replace fipst = 56 if state == "WYOMING"
	replace fipst = 66 if state == "W.PACIFIC AREAS"
	replace fipst = 72 if state == "PUERTO RICO"
	replace fipst = 78 if state == "VIRGIN ISLANDS"

// drop state from original county variable
gen county_temp = strpos(county,",") 
replace county = substr(county, 1, county_temp - 1) if county_temp != 0
replace county = strtrim(county)
drop county_temp

// keep 1-21 characters as county_id		
gen county_id = upper(substr(county, 1, 21)) 
tempfile income1994
save `income1994'


// import 1996.csv 
import delimited "./output/csv/income1996.csv", clear

* Format County and MSA Names for Matching By Upper Casing and Deleting Everything
* that Comes After the Comma (usually state abbreviations)
gen county_temp = strpos(county,",") 
replace county = substr(county, 1, county_temp - 1) if county_temp != 0
replace county = strtrim(county)
drop county_temp

replace county  = upper(county) 

gen msa_temp = strpos(msaname,",") 
replace msaname = substr(msaname, 1, msa_temp - 1) if msa_temp != 0
replace msaname = strtrim(msaname)
drop msa_temp

replace msaname = upper(msaname) 

* Use the MSA name for metro areas and county name for non-metro areas.
* There will be multiple county_ids (when msa span multiple counties) but the
* duplicates will have the same median family incomes with the exception of two 
* MSAs (Kalamazoo-Battle Creek, MI and Odessa-Midland, TX), which appear to be an error. 
gen     county_id = msaname 
replace county_id = county if msa == 0
replace county_id = substr(county_id, 1, 21) 

* Make adhoc adjustments to improve matches. There isn't a match for these four 
* counties from the 1995 data in the 1996 data. However, the counties are present
* in the 1996 data it's just that they have a different MSA name. 

replace county_id = "COCONINO COUNTY" if fipst == 4  & msa == 2620 & county == "COCONINO COUNTY"
replace county_id = "MESA COUNTY"     if fipst == 8  & msa == 2995 & county == "MESA COUNTY"
replace county_id = "SPALDING COUNTY" if fipst == 13 & msa == 520  & county == "SPALDING COUNTY"
replace county_id = "KANE COUNTY"     if fipst == 49 & msa == 3739 & county == "KANE COUNTY"
replace county_id = "FORREST COUNTY"  if fipst == 28 & msa == 3285 & county == "FORREST COUNTY"
replace county_id = "LAMAR COUNTY"    if fipst == 28 & msa == 3285 & county == "LAMAR COUNTY"

keep fipst fipcty st county_id msa county msaname

* Merge 1996 ids with 1994 data
* Virgin Islands is the only non-match so not a problem

merge m:1 fipst county_id using `income1994'
drop if _merge == 2
drop _merge
duplicates drop
//keep year fipst fipcty median l80* l50*
export delimited using "./output/csv/income1994update.csv", replace



/*******************************************************************************
	Generate 1990.csv files, in order to update county name
	match with 1991.csv county name 
********************************************************************************/

clear all
import delimited "./output/csv/income1990.csv",clear


// add county id
// statecty : combination of fipst and fipcty from raw files
gen     county_id = statecty if msa == 0
replace county_id = msa if msa > 0 & msa < .

// around 30 duplicates records
// most are in WY state
duplicates drop

// add missing l50_* and l80_*
gen l80_1 = round(l80_4 * 0.7,  50) 
gen l80_2 = round(l80_4 * 0.8,  50) 
gen l80_3 = round(l80_4 * 0.9,  50)

gen l50_1 = round(l50_4 * 0.7,  50) 
gen l50_2 = round(l50_4 * 0.8,  50) 
gen l50_3 = round(l50_4 * 0.9,  50)

forvalues i = 5/8 {

	gen l80_`i' = round(l80_4 * (1 + (`i' - 4) * 0.08), 50) 
	gen l50_`i' = round(l50_4 * (1 + (`i' - 4) * 0.08), 50) 	
	
	}
	
tempfile income1990
save `income1990', replace

import delimited "./output/csv/income1991.csv",clear

gen     county_id = statecty if msa == 0
replace county_id = msa if msa > 0 & msa < .

keep fipst fipcty county st county_id

merge m:1 fipst county_id using `income1990'
// only keep fipcty show in both files

drop if _merge != 3
drop _merge

drop county_id 

drop statecty

export delimited using "./output/csv/income1990update.csv", replace

