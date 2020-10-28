clear all

* cd project folder path
cd "/Users/clockorange/Downloads/Thresholds code review/Zhuocheng_Deliverables/"



/*******************************************************************************
	start to manage data before 1990
********************************************************************************/

import excel "./Census data/c2_updated.xls", sheet("c2") clear

foreach v of varlist _all{ 
		local varlabel : variable label `v'
	    di "`v'" ,","  ,  "`varlabel'"
	}
	di "----------------","`i'","---------------------"

/*
A , county
C , 1989 in current dollars 
E , 1979 in current dollars 
G , 1969 in current dolllars
I , 1959 in current dollars
*/


// keep useful data
keep A C E G I
keep in 13/3282

// rename variables
rename A county
rename C median1989
rename E median1979
rename G median1969
rename I median1959

// generate state name and couny name
split county, p(,) 

drop county
rename county1 county
rename county2 st

replace county = upper(county)

// remove blank lines
drop if st == ""

// remove leading space
replace st = strtrim(st)
tostring st, replace


* Destring the median family income variables

foreach var of varlist median1989 median1979 median1969 median1959 {

	gen `var'_rvsd = regexs(0) if regexm(`var', "[0-9]+") // keep only numbers
	
	destring `var'_rvsd, replace
	
	drop `var'
	rename `var'_rvsd `var'
	
	}
	
	
* Add State Numeric Code
gen     fipst = 1  if st == "AL"
replace fipst = 2  if st == "AK"
replace fipst = 4  if st == "AZ"
replace fipst = 5  if st == "AR"
replace fipst = 6  if st == "CA"
replace fipst = 8  if st == "CO"
replace fipst = 9  if st == "CT"
replace fipst = 10 if st == "DE"
replace fipst = 11 if st == "DC"
replace fipst = 12 if st == "FL"
replace fipst = 13 if st == "GA"
replace fipst = 15 if st == "HI"
replace fipst = 16 if st == "ID"
replace fipst = 17 if st == "IL"
replace fipst = 18 if st == "IN"
replace fipst = 19 if st == "IA"
replace fipst = 20 if st == "KS"
replace fipst = 21 if st == "KY"
replace fipst = 22 if st == "LA"
replace fipst = 23 if st == "ME"
replace fipst = 24 if st == "MD"
replace fipst = 25 if st == "MA"
replace fipst = 26 if st == "MI"
replace fipst = 27 if st == "MN"
replace fipst = 28 if st == "MS"
replace fipst = 29 if st == "MO"
replace fipst = 30 if st == "MT"
replace fipst = 31 if st == "NE"
replace fipst = 32 if st == "NV"
replace fipst = 33 if st == "NH"
replace fipst = 34 if st == "NJ"
replace fipst = 35 if st == "NM"
replace fipst = 36 if st == "NY"
replace fipst = 37 if st == "NC"
replace fipst = 38 if st == "ND"
replace fipst = 39 if st == "OH"
replace fipst = 40 if st == "OK"
replace fipst = 41 if st == "OR"
replace fipst = 42 if st == "PA"
replace fipst = 44 if st == "RI"
replace fipst = 45 if st == "SC"
replace fipst = 46 if st == "SD"
replace fipst = 47 if st == "TN"
replace fipst = 48 if st == "TX"
replace fipst = 49 if st == "UT"
replace fipst = 50 if st == "VT"
replace fipst = 51 if st == "VA"
replace fipst = 53 if st == "WA"
replace fipst = 54 if st == "WV"
replace fipst = 55 if st == "WI"
replace fipst = 56 if st == "WY"
replace fipst = 66 if st == "GU"
replace fipst = 72 if st == "PR"
replace fipst = 78 if st == "VI"



replace county = "NORTHWEST ARCTIC BOROUGH"     if county == "NORTHWEST ARTIC BOROUGH"      & fipst == 2
replace county = "ANCHORAGE MUNICIPALITY"       if county == "ANCHORAGE BOROUGH"            & fipst == 2
replace county = "FAIRBANKS NORTH STAR BOROUGH" if county == "FAIRBANKS-NORTH STAR BOROUGH" & fipst == 2
replace county = "JUNEAU CITY AND BOROUGH"      if county == "JUNEAU BOROUGH"               & fipst == 2 

replace county = "LA PLATA COUNTY"   if county == "LAPLATA COUNTY"  & fipst == 8 
replace county = "MIAMI-DADE COUNTY" if county == "DADE COUNTY"     & fipst == 12
replace county = "DEKALB COUNTY"     if county == "DE KALB COUNTY"  & fipst == 18 
replace county = "LAPORTE COUNTY"    if county == "LA PORTE COUNTY" & fipst == 18 
replace county = "DE BACA COUNTY"    if county == "DEBACA COUNTY"   & fipst == 35 
replace county = "MCKEAN COUNTY"     if county == "MC KEAN COUNTY"  & fipst == 42 



drop if median1959 >= . | median1969 >= . | median1979 >= . | median1989 >= .


save output/cleanFile/medfaminc_1959_1989, replace




********************************************************************************
* Import State and County FIPS Codes from 1999 Census File 
********************************************************************************

import excel "./Census data/County_1999.xlsx", clear
foreach v of varlist _all{ 
		local varlabel : variable label `v'
	    di "`v'" ,","  ,  "`varlabel'"
	}
	di "----------------","`i'","---------------------"
	
	
// remove headers
drop in 1/2

rename C county
split county, p(,)

drop county

rename county1 county
rename county2 state

replace county = upper(county)

destring B, gen(fips)

gen fipst = floor(fips/1000)
gen fipcty = fips - fipst * 1000

keep fipst fipcty state county

save output/cleanFile/fips1999, replace

********************************************************************************
* Merge the Median Incomes for 1950-1990 with the FIPS Codes
********************************************************************************

* In the 1959-1989 Median Income File we have 2 non-matches for AK and VA. These
* aren't in the 1999 file, so I'm not going to worry about them. 

use output/cleanFile/medfaminc_1959_1989, clear

merge m:1 county fipst using output/cleanFile/fips1999

bysort _merge county: gen n = _n

sort st county  
*br if _merge == 1 & n == 1
drop n

* Keep only matches

keep if _merge == 3
drop _merge

save output/cleanFile/medfaminc_1959_1989, replace

********************************************************************************
* Add Missing Median Family Incomes for Washington DC
********************************************************************************

* DC is not included in the county file, but I do have median incomes from 
* the State file that is available on the census website under Historical state
* Income. I'm going to mannual import the DC values. See the spreadsheet named 
* state2.xlsx for these values
clear all
import delimited "./Census data/state2.csv", delimiter(comma) clear 

keep v1 v3 v5 v7 v9

rename v1 st
rename v3 median1989
rename v5 median1979
rename v7 median1969
rename v9 median1959

keep if st == "D.C"

replace st = "DC" if st == "D.C"

gen fipst  = 11
gen fipcty = 1
gen county = "District of Columbia"
gen state  = "District of Columbia"

replace median1959 = subinstr(median1959, ",", "", .)
replace median1969 = subinstr(median1969, ",", "", .)
replace median1979 = subinstr(median1979, ",", "", .)
replace median1989 = subinstr(median1989, ",", "", .)

destring median*, replace

append using output/cleanFile/medfaminc_1959_1989

* Reshape to Long

reshape long median, i(fipst fipcty) j(year)

save output/cleanFile/medfaminc_1959_1989, replace

********************************************************************************
* Expand Data Set to Include Years in-Between Censuses
********************************************************************************

egen id = group(fipst fipcty)

xtset id year
tsfill

* Fill in missing fips codes that are missing because of the expansion

foreach var of varlist fipst fipcty {
	
	bysort id (year): replace `var' = `var'[_n-1] if `var' >= . 
	
	}
	
foreach var of varlist state st county {
	
	bysort id (year): replace `var' = `var'[_n-1] if `var' == ""
	
	}
		
	
* Interpolate years in between censuses
bysort id (year): ipolate median year, gen(median_imp)

replace median = median_imp if median >= .

drop median_imp

* Round Median Family income to Nearest 100
replace median = round(median, 100)

* Calulcate Low-Income (80%) threshold and very-low income (%50) and extremely low (30%) income thresholds
* Round to nearest 50

gen l80_4 = round(0.80 * median, 50)
gen l50_4 = round(0.50 * median, 50) 
gen l30_4 = round(0.30 * median, 50) 

* Family sizes 1-3

foreach j in 80 50 30 {

	gen l`j'_1 = round(l`j'_4 * 0.7,  50) 
	gen l`j'_2 = round(l`j'_4 * 0.8,  50) 
	gen l`j'_3 = round(l`j'_4 * 0.9,  50) 
	
	}

* From 5 on HUD just adds 0.08 

foreach j in 80 50 30 {

	forvalues i = 5/8 {

		gen l`j'_`i' = round(l`j'_4 * (1 + (`i' - 4) * 0.08), 50) 
		
		}
	}
	

foreach var of varlist l* {
	
		destring `var', replace
		
		}
	
keep year county median fipst fipcty l80_* l50_* l30_*

save output/cleanFile/medfaminc_1959_1989, replace
export delimited using "./output/csv/old_income1959.csv", replace





********************************************************************************
* Append all of the data sets together
********************************************************************************

* We collapse the data by state, county, and year. For the vast majority of states
* collapsing at the county level makes no difference. However, there are about
* 8 states where income eligibility guidelines vary within counties. This is true
* for every single county in Connecticut for example. I've decided to take the 
* maximum income eligibility of the subareas within a county. Alternatively, we
* could have created a weighted average based on population. However, the maximum
* makes more sense to me because depending on local laws, people may be able to
* apply for assistance from a PSA where they do not live. 

* Applying the maximum local area eligibility threshold to an entire county does
* create an odd sitation in Connecticut where in at least some years, the state
* only ends up having a single eligiblity guideline. This is because the area
* with the highest eligibility threshold overlaps with the state's 8 counties.
forvalues i = 1990/2017 {
	if `i' == 1990{

	import delimited "./output/csv/income1990update.csv",clear
		foreach var of varlist l* {
	
		destring `var', replace
		tempfile income`i'
		save `income`i'', replace
		}
	}
	else if `i' == 1994{
		import delimited "./output/csv/income1994update.csv",clear
		foreach var of varlist l* {
	
		destring `var', replace
		tempfile income`i'
		save `income`i'', replace
		}
	}
	else if `i' == 1995{
		import delimited "./output/csv/income1995update.csv",clear
		foreach var of varlist l* {
	
		destring `var', replace
		tempfile income`i'
		save `income`i'', replace
		}
	}
	else{
	
		import delimited "./output/csv/income`i'.csv",clear
		di "----------------","`i'","---------------------"
			
		foreach var of varlist l* {
		
		destring `var', replace
		
		}
		tempfile income`i'
		save `income`i'', replace
	}

}

use output/cleanFile/medfaminc_1959_1989, clear			
	
forvalues i = 1990/2017 {
	di "----------------","`i'","---------------------"
	append using `income`i''
	

	}
	
//drop county_id
drop statecty
//drop msaindicator
save output/cleanFile/medfaminc_all, replace

* We're actually not going to collapse. I'm going to try to match the sub-county CBSAS 
* with the geocodes in the PSID.		
* collapse (max) l80_* l50_* l30_*, by(fipst fipcty year)

********************************************************************************
* Shift by One Year
********************************************************************************

* Shift by One Year because the Data (1959, 1969, 1979, 1989) correspond to 
* Census Years. And the FY for 1990-2017 start in October, so really these thresholds
* are for the second part of the FY. For exaple, FY 2017 runs from Oct 2017-Sept 2018,
* meaning that most of the year is actually in CY 2018. 
clear all
use output/cleanFile/medfaminc_all, clear 
replace year = year + 1	

********************************************************************************
* Fill in Extremely Low-Income Variable for Years prior to 1999 and after 1989
********************************************************************************

forvalues i = 1/8 {

	replace l30_`i' = round(l50_`i' * 0.6, 50) if l30_`i' >= .
	
	}
	
********************************************************************************
* Expand Family Size to 20
********************************************************************************

foreach j in 80 50 30 {

	* From 5 on HUD just adds 0.08 

	forvalues i = 9/20 {

		gen l`j'_`i' = round(l`j'_4 * (1 + (`i' - 4) * 0.08), 50) 
		
		}
	}

********************************************************************************
* Generate State-County FIPS Code
********************************************************************************

gen fips = fipst * 1000 + fipcty

********************************************************************************
* Label Variables
********************************************************************************

label variable year   			"Year"
label variable fips    			"State-County FIPS"
label variable fipst   			"State FIPS"
label variable fipcty  			"County FIPS"
label variable msa     			"MSA"
label variable fips2000 		"2000 Tract"
label variable fips2010 		"2010 Tract"
label variable cbsasub  		"CBSA"
label variable metro    		"Metro Area"
label variable state    		"State"
label variable st       		"State Abbr."
label variable county    		"County"
label variable county_town_name "County/Town"
label variable msaname   		"MSA Name"
label variable fmre      		"FMR Efficiency"
label variable fmr1      		"FMR 1-bedroom"
label variable fmr2      		"FMR 2-bedroom"
label variable fmr3      		"FMR 3-bedroom"
label variable fmr4      		"FMR 4-bedroom"
label variable median    		"Median Family Income"

********************************************************************************
* Sort, Order, and Save
********************************************************************************

* Distribute State, County, and MSA Names Where Missing

gen negyear = -year

sort fipst negyear

order year fipst fipcty msa st state county msa msaname

foreach var of varlist st state {
	
	bysort fipst (negyear): replace `var' = `var'[_n-1] if _n > 1
	
	}
	
	
foreach var of varlist county {
	
	bysort fipst fipcty (negyear): replace `var' = `var'[_n-1] if _n > 1
	
	}
	
foreach var of varlist msaname {
	
	bysort fipst fipcty msa (negyear): replace `var' = `var'[_n-1] if _n > 1
	
	}
	
drop negyear	

* Drop Virgin Islands, Puerto Rico, Guam and other territories

drop if inlist(fipst, 60, 66, 69, 72, 78)

* Relable Income Eligibility Thresholds

foreach j in 80 50 30 {

	forvalues i = 1/20 {

		label variable l`j'_`i' "`j'% threshold for family size = `i'"
		
		}
	}
		

#delimit ;

order

year

fips
fipst
fipcty
msa
fips2000
fips2010 
cbsasub 
metro 

state
st 
fipst 

county 
county_town_name
msaname 

fmre 
fmr1 
fmr2 
fmr3 
fmr4 

median 

l30_1 l30_2 l30_3 l30_4 l30_5 l30_6 l30_7 l30_8 l30_9 l30_10 l30_11 l30_12 l30_13 l30_14 l30_15 l30_16 l30_17 l30_18 l30_19 l30_20
l50_1 l50_2 l50_3 l50_4 l50_5 l50_6 l50_7 l50_8 l50_9 l50_10 l50_11 l50_12 l50_13 l50_14 l50_15 l50_16 l50_17 l50_18 l50_19 l50_20 
l80_1 l80_2 l80_3 l80_4 l80_5 l80_6 l80_7 l80_8 l80_9 l80_10 l80_11 l80_12 l80_13 l80_14 l80_15 l80_16 l80_17 l80_18 l80_19 l80_20 ;

#delimit cr

sort fips year	  

compress
 
********************************************************************************
* Genarate ID
********************************************************************************
gen countyID = county if county_town_name == ""
replace countyID = county if msaname == ""
replace countyID = county_town_name if county_town_name > "" 
replace countyID = county_id if county_id >""

gen stryear = year
tostring(stryear),replace

gen strmedian = median
tostring(strmedian),replace

gen msasave = 1000001 if msa == .
destring(msasave),replace
replace msasave = msa if msa <. & msa>=0
replace msasave = 1000001 if year == 1995 | year == 1996

tostring(msasave),replace


gen fipssave = fips2000 if fips2000 >= 0 & fips2000 <.
replace fipssave = fips2010 if fips2010 >= 0 & fips2010<.
replace fipssave = fips if fips2000 == . & fips2010 == .
tostring(fipssave),replace


gen numID = stryear + fipssave +msasave+strmedian
gen otherID = st + countyID

gen finalid = otherID + numID 

replace finalid = upper(finalid)


drop countyID fipssave stryear strmedian numID otherID
*bys finalid: gen count = _N
*sum count
*gsort -count finalid

save finalOutput/review_income_eligiblity_thresholds, replace
export delimited using "./output/csv/final_append.csv", replace



