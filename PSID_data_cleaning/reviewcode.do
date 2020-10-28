clear all

* cd project folder path
cd "/Users/clockorange/Downloads/Thresholds code review/Zhuocheng_Deliverables/"

/* ------------------------------------------------
	Part I: Rename variable names from 2000 - 2017
   ------------------------------------------------
*/



/*
* Rename variable names for years from 2014 to 2017
* 2017: State_Alpha	fips2010	        State	County	County_Name cbsasub	Metro_Area_Name             median2017 MSA	county_town_name state_name	metro
* 2016: State_Alpha	fips2010 fips2000	State	County	County_Name cbsasub	Metro_Area_Name             median2016 MSA	county_town_name state_name	metro
* 2015: State_Alpha	fips2010 fips2000	State	County	County_Name	CBSASub	Metro_Area_Name             median2015 MSA	county_town_name state_name	metro
* 2014: State_Alpha	fips2010 fips2000	State	County	County_Name	CBSASub	Metro_Area_Name             median2014 MSA	county_town_name state_name	metro
*/


* list variable
* just to check if variable matches comparing with original do.file


forvalues i = 2014/2017 {
    * read in variable as lowercase *
	import excel "./rawFiles/hudincome`i'.xls", firstrow case(lower) clear
	
	* rename by year [median + year] to [median]
	gen year = `i'
	
	* rename variable names for years that are not consistent with the overall pattern	
	rename state           fipst
	rename county          fipcty
	rename state_alpha     st
	rename state_name      state
	rename county_name     county
	rename metro_area_name msaname 
	rename median`i'       median
	
	*cap tostring fips2010, replace
	*cap tostring fips2000, replace

	
	forvalues j = 1/8 {
		
		rename eli_`j' l30_`j'
		
		}
	
	foreach var of varlist l* {
	
		destring `var', replace
		
		}
	
	tempfile income`i'
	save `income`i'', replace
	
	}


/* Rename variable names for years in 2013
* 2013: State_Alpha	fips2010 fips2000	State	County	County_Name	CBSASub	Metro_Area_Name             median2013 MSA	county_town_name state_name	metro
*/



forvalues i = 2013/2013 {
    * read in variable as lowercase *
	import excel "./rawFiles/hudincome`i'.xls", firstrow case(lower) clear
	
	* rename by year [median + year] to [median]
	gen year = `i'
	
	* rename variable names for years that are not consistent with the overall pattern	
	rename state           fipst
	rename county          fipcty
	rename state_alpha     st
	rename state_name      state
	rename county_name     county
	rename metro_area_name msaname 
	rename median`i'       median
	
    tostring fips2000, replace
	
	foreach var of varlist l* {
	
		destring `var', replace
		
		}
	
	tempfile income`i'
	save `income`i'', replace
	
	}
	

/* 
* 2012: State_Alpha	fips	            State	County	County_Name	CBSASub	Metro_Area_Name             median2012 MSA	county_town_name state_name	metro
* 2011: State_Alpha	fips	            State	County	County_Name	CBSASub	Metro_Area_Name             median2011 MSA	county_town_name state_name	metro
*
* 2010: State_Alpha	fips	            State	County	County_Name	CBSASub	Metro_Area_Name	median1999	median2010 MSA	county_town_name State_Name metro
* 2009: State_Alpha	fips	            State	County	County_Name	CBSASub	Metro_Area_Name	median1999	median2009 MSA	county_town_name State_Name metro
* 2008: State_Alpha	fips	            State	County	County_Name	CBSASub	Metro_Area_Name	median1999	median2008 MSA	county_town_name State_Name metro
* 2007: State_Alpha	fips	            State   County  County_Name CBSASub Metro_Area_Name	median1999	median2007 msa  County_Town_Name State_Name metro
* 2006: State_Alpha	fips	            State	County	County_Name CBSASub Metro_Area_Name	median1999	median2006 msa  County_Town_Name State_Name metro
*
* 2005: state_alpha	                    state	county  CountyName          msaname(not found)          median2005 msa  name(could be MSAname)
* 2004: state_alpha	                    state   county	CountyName          msaname(found)              median2004 msa 
* 													    (list but not show in local excel)              
*     
* 2003: state_alpha                     state   county  countyname	        msaname 	                median2003 msa	
* 2002: StateAlpha                      State	county  CountyName		    MSAName                     Median     MSA
*
* All have l30,50,80 format
*/

forvalues i = 2006/2012 {
    * read in variable as lowercase *
	import excel "./rawFiles/hudincome`i'.xls", firstrow case(lower) clear
	
	gen year = `i'
	
	* rename variable names for years that are not consistent with the overall pattern
	rename state           fipst
	rename county          fipcty
	rename fips            fips2000
	rename state_name      state
	rename state_alpha     st
	rename median`i'       median
	rename metro_area_name msaname 
	rename county_name      county

	tostring fips2000, replace
	
	foreach var of varlist l* {
	
		destring `var', replace
		
		}
	
	tempfile income`i'
	save `income`i'', replace
	
	}

* 2005: state_alpha	                    state	county  CountyName          msaname(not found)          median2005 msa  name(could be MSAname)
forvalues i = 2005/2005 {
    * read in variable as lowercase *
	import excel "./rawFiles/hudincome`i'.xls", firstrow case(lower) clear
	
	* rename by year [median + year] to [median]
	gen year = `i'
	
	drop name
	
	* rename variable names for years that are not consistent with the overall pattern
	rename state           fipst
	rename county          fipcty	
	rename state_alpha     st
	rename median`i'       median
	rename countyname      county
		
	foreach var of varlist l* {
	
		destring `var', replace
		
		}
	
	tempfile income`i'
	save `income`i'', replace
	
	}	

* 2004: state_alpha	                    state   county	CountyName          msaname(found)              median2004 msa 
* 													    (list but not show in local excel)       
forvalues i = 2004/2004 {
    * read in variable as lowercase *
	import excel "./rawFiles/hudincome`i'.xls", firstrow case(lower) clear
	
	* rename by year [median + year] to [median]
	gen year = `i'
	
	* rename variable names for years that are not consistent with the overall pattern
	rename state           fipst
	rename county          fipcty	
	rename state_alpha     st
	rename median`i'       median
	rename countyname      county
		
	foreach var of varlist l* {
	
		destring `var', replace
		
		}
	
	tempfile income`i'
	save `income`i'', replace
	
	}	

* 2003: state_alpha                     state   county  countyname	        msaname 	                median2003 msa	
* 2002: StateAlpha                      State	county  CountyName		    MSAName                     Median     MSA
forvalues i = 2003/2003 {
    * read in variable as lowercase *
	import excel "./rawFiles/hudincome`i'.xls", firstrow case(lower) clear
	
	* rename by year [median + year] to [median]
	gen year = `i'
	
	* rename variable names for years that are not consistent with the overall pattern
	rename state           fipst
	rename county          fipcty	
	rename state_alpha     st
	rename median`i'       median
	rename countyname      county
		
	foreach var of varlist l* {
	
		destring `var', replace
		
		}
	
	tempfile income`i'
	save `income`i'', replace
	
	}

forvalues i = 2002/2002 {
    * read in variable as lowercase *
	import excel "./rawFiles/hudincome`i'.xls", firstrow case(lower) clear
	
	gen year = `i'
	
	* rename variable names for years that are not consistent with the overall pattern
	rename state      fipst
	rename county     fipcty
	rename statealpha st
	rename countyname county
	
	foreach var of varlist l* {
	
		destring `var', replace
		
		}
	
	tempfile income`i'
	save `income`i'', replace
	
	}

/*
* 2001
*
 fipsstatecode , stateabrev, fipscountycode, countyname , hudmsacode , msaname , fy2001medianfamilyincome , 
 incomelimit1person , 30% INCOME LIMIT - 1 PERSON
 incomelimit2persons , 30% INCOME LIMIT - 2 PERSONS
 incomelimit3persons , 30% INCOME LIMIT - 3 PERSONS
 incomelimit4persons , 30% INCOME LIMIT - 4 PERSONS
 incomelimit5persons , 30% INCOME LIMIT - 5 PERSONS
 incomelimit6persons , 30% INCOME LIMIT - 6 PERSONS
 incomelimit7persons , 30% INCOME LIMIT - 7 PERSONS
 incomelimit8persons , 30% INCOME LIMIT -  8 PERSONS
 
 verylow50incomelimit1 , VERY LOW (50%) INCOME LIMIT - 1 PERSON
 q , 50% INCOME LIMIT - 2 PERSONS
 r , 50% INCOME LIMIT - 3 PERSONS
 s , 50% INCOME LIMIT - 4 PERSONS
 t , 50% INCOME LIMIT - 5 PERSONS
 u , 50% INCOME LIMIT - 6 PERSONS
 v , 50% INCOME LIMIT - 7 PERSONS
 w , 50% INCOME LIMIT -  8 PERSONS
 
 low80incomelimit1perso , LOW (80%) INCOME LIMIT - 1 PERSON
 lowincomelimit2persons , LOW  INCOME LIMIT - 2 PERSONS
 lowincomelimit3persons , LOW INCOME LIMIT - 3 PERSONS
 lowincomelimit4persons , LOW INCOME LIMIT - 4 PERSONS
 lowincomelimit5persons , LOW INCOME LIMIT - 5 PERSONS
 lowincomelimit6persons , LOW INCOME LIMIT - 6 PERSONS
 lowincomelimit7persons , LOW INCOME LIMIT - 7 PERSONS
 lowincomelimit8persons , LOW INCOME LIMIT -  8 PERSONS

* 2000
fy2000medianfamilyincome

*
*/

forvalues i = 1999/2001 {
    * read in variable as lowercase *
	import excel "./rawFiles/hudincome`i'.xls",  clear
	
	
	drop if _n == 1
	
	keep A-AE
	
	rename A  fipst
	rename B  st
	rename C  fipcty
	rename D  county
	rename E  msa
	rename F  msaname
	rename G  median
	rename H  l30_1
	rename I  l30_2
	rename J  l30_3
	rename K  l30_4
	rename L  l30_5 
	rename M  l30_6
	rename N  l30_7
 	rename O  l30_8
	rename P  l50_1 
	rename Q  l50_2
	rename R  l50_3
	rename S  l50_4
	rename T  l50_5
	rename U  l50_6
	rename V  l50_7
	rename W  l50_8 
	rename X  l80_1
	rename Y  l80_2
	rename Z  l80_3
 	rename AA l80_4
	rename AB l80_5
	rename AC l80_6
	rename AD l80_7
	rename AE l80_8
	
	gen year = `i'
	
	destring fipst, replace
	destring fipcty, replace
	destring msa, replace
	destring median, replace
	
	foreach var of varlist l* {
	
	destring `var', replace
	
	}
	
	tempfile income`i'
	save `income`i'', replace
	
 		
	}


/*
 Copy original DO file 
 and check output with csv file generated by python code
*/
********************************************************************************
* Import 1998 HUD Income Eligibility Guidelines
********************************************************************************

/*
TXT FILE
fipst, st, county, msa, msaname, 
median
l_50, l_80, fair market rent
*/
clear all
//import delimited "./hud/hudincome1998.txt"


#delimit ;

clear ;
quietly infix             
10 lines                  
1:      fipst        1-2  
2:	str st           1-2  
3:	    fipcty       1-4 
4:	str county       1-28  
5:	    msa     	 1-5  
6:	str msaname 	 1-28  
7:      median 		 1-5       
8:	str	l50			 1-48
9:	str l80      	 1-48
10: str	fmr			 1-25  
		

using "./rawFiles/hudincome1998origin.txt";

#delimit cr
generate str clean_county = ustrregexra(county,`"[^a-zA-Z-,.\' ]"',"")
drop county
rename clean_county county

generate str clean_msa = ustrregexra(msaname,`"[^a-zA-Z-,.\' ]"',"")
drop msaname
rename clean_msa msaname

split l50, parse(" ") generate(temp)
forvalues i = 1/8{
destring temp`i', replace
rename temp`i' l50_`i'
}
drop l50

split l80, parse(" ") generate(temp)
forvalues i = 1/8{
destring temp`i', replace
rename temp`i' l80_`i'
}
drop l80

split fmr, parse(" ") generate(temp)
rename temp1 fmre 
rename temp2 fmr1 
rename temp3 fmr2
rename temp4 fmr3 
rename temp5 fmr4 

destring  fmre,replace
destring fmr1,replace
destring fmr2,replace
destring fmr3,replace
destring fmr4,replace

drop fmr


gen year = 1998
order fipst st fipcty county msa msaname
//tempfile income1998 
tempfile income1998
save `income1998', replace


//10:     fmre 		1-4   
//	    fmr1 		5-8 
//	    fmr2 		9-12  
//	    fmr3 		13-16 
//	    fmr4 		17-21 


********************************************************************************
* Import 1997 HUD Income Eligibility Guidelines
********************************************************************************


#delimit ;

clear ;
quietly infix             
10 lines                  
1:      fipst        1-2  
2:	str st           1-2  
3:	    fipcty       1-4 
4:	str county       1-28  
5:	    msa     	 1-5  
6:	str msaname 	 1-28  
7:      median 		 1-5    
8:	str	l50			 1-48
9:	str l80      	 1-48
10: str	fmr			 1-25 
 
using "./rawFiles/hudincome1997origin.txt";

#delimit cr

generate str clean_county = ustrregexra(county,`"[^a-zA-Z-,.\' ]"',"")
drop county
rename clean_county county

generate str clean_msa = ustrregexra(msaname,`"[^a-zA-Z-,.\' ]"',"")
drop msaname
rename clean_msa msaname

split l50, parse(" ") generate(temp)
forvalues i = 1/8{
	destring temp`i', replace
	rename temp`i' l50_`i'
}
drop l50

split l80, parse(" ") generate(temp)
forvalues i = 1/8{
	destring temp`i', replace
	rename temp`i' l80_`i'
}
drop l80


split fmr, parse(" ") generate(temp)
rename temp1 fmre 
rename temp2 fmr1 
rename temp3 fmr2
rename temp4 fmr3 
rename temp5 fmr4 

destring fmre,replace
destring fmr1,replace
destring fmr2,replace
destring fmr3,replace
destring fmr4,replace

drop fmr
gen year = 1997
order fipst st fipcty county msa msaname
tempfile income1997
save `income1997', replace




********************************************************************************
* Import 1996 HUD Income Eligibility Guidelines
********************************************************************************

#delimit ;

clear ;
quietly infix             
10 lines                  
1:      fipst        1-2  
2:	str st           1-2  
3:	    fipcty       1-4 
4:	str county       1-28  
5:	    msa     	 1-5  
6:	str msaname 	 1-28  
7:      median 		 1-5    
8:	str	l50			 1-48
9:	str l80      	 1-48
10: str	fmr			 1-25      
using  "./rawFiles/hudincome1996origin.txt";

#delimit cr

generate str clean_county = ustrregexra(county,`"[^a-zA-Z-,.\' ]"',"")
drop county
rename clean_county county

generate str clean_msa = ustrregexra(msaname,`"[^a-zA-Z-,.\' ]"',"")
drop msaname
rename clean_msa msaname

split l50, parse(" ") generate(temp)
forvalues i = 1/8{
	destring temp`i', replace
	rename temp`i' l50_`i'
}
drop l50

split l80, parse(" ") generate(temp)
forvalues i = 1/8{
	destring temp`i', replace
	rename temp`i' l80_`i'
}
drop l80


split fmr, parse(" ") generate(temp)
rename temp1 fmre 
rename temp2 fmr1 
rename temp3 fmr2
rename temp4 fmr3 
rename temp5 fmr4 

destring fmre,replace
destring fmr1,replace
destring fmr2,replace
destring fmr3,replace
destring fmr4,replace

drop fmr
gen year = 1996
order fipst st fipcty county msa msaname


tempfile income1996
save `income1996', replace


********************************************************************************
* Import 1995 & 1994 HUD Income Eligibility Guidelines
********************************************************************************

forvalues j = 1994/1995 {

	import delimited "./rawFiles/hudincome`j'_RVSD.txt", delimiter("STATE:", asstring) clear
		
	* Fill down the state name to all observations below	
	replace v2 = v2[_n-1] if v2 == ""	

	* Extract the state name from other text and characters in the second column
	gen      state_name = substr(v2, 1, 20)
	replace  state_name = strtrim(state_name)
	compress state_name

	* Drop original state name column
	drop v2

	* Drop observations that relate to the second heading row that identifies the 
	* number of people per household and a blank row. This will leave us with a data
	* set that has 3 observations per geographic area
	drop if v1 == ""
	drop if substr(v1,1,8) == "PREPARED"

	* Generate a blank county name that will be filled in
	gen county = ""

	* Take county name from rows 1, 4, 7, ...

	gen n = _n

	forvalues i = 1(3)`=_N' {

		replace county = v1[`i'] if `i' == n
		
		}

	* Fill down county name
	replace county = county[_n-1] if county == ""
	
	* Split county name into and indicator for MSA/County and the name
	split county, p(:)
	
	drop county
	
	rename county1 msa_indicator
	rename county2 county

	* Some counties include the state abbrevation (e.g., Washtentaw County, MI). 
	* Since we already have the state name I drop the comma and state abbrevations.
	replace county = substr(county, 1, strpos(county, ",") - 1) if strpos(county, ",") != 0

	* The previous code brought the county name down to the income thresholds lines
	* This gets rid of the now uncessary line that includes the county name.

	forvalues i = 1(3)`=_N' {

		drop if n == `i'
		
		}

	* Generate income variable that includes the 8 low-income and 8 very-low-income values
	* in a single variable
	gen income1 = substr(v1, 58, .)

	* Take low-income and move it onto the same line as very low income
	gen income2 = income1[_n-1]

	* Keep only low-income lines
	drop if regexm(v1, "VERY LOW-INCOME"?)

	* Divide low-income columns into 8 categories of family size
	split income1, gen(l80_) destring
	
	* Divide very low-income columns into 8 categories of family size
	split income2, gen(l50_) destring

	* Geneate year varaible
	gen year = `j'

	* Trim trailing and leading white space
	replace county = strtrim(county)
	
	* Generate Median Income
	gen median = substr(v1,16, 5)
	destring median, replace
	
	* Add State Numeric Code
	gen     fipst = 1  if state_name == "ALABAMA"
	replace fipst = 2  if state_name == "ALASKA"
	replace fipst = 4  if state_name == "ARIZONA"
	replace fipst = 5  if state_name == "ARKANSAS"
	replace fipst = 6  if state_name == "CALIFORNIA"
	replace fipst = 8  if state_name == "COLORADO"
	replace fipst = 9  if state_name == "CONNECTICUT"
	replace fipst = 10 if state_name == "DELAWARE"
	replace fipst = 11 if state_name == "DIST. OF COLUMBIA"
	replace fipst = 12 if state_name == "FLORIDA"
	replace fipst = 13 if state_name == "GEORGIA"
	replace fipst = 15 if state_name == "HAWAII"
	replace fipst = 16 if state_name == "IDAHO"
	replace fipst = 17 if state_name == "ILLINOIS"
	replace fipst = 18 if state_name == "INDIANA"
	replace fipst = 19 if state_name == "IOWA"
	replace fipst = 20 if state_name == "KANSAS"
	replace fipst = 21 if state_name == "KENTUCKY"
	replace fipst = 22 if state_name == "LOUISIANA"
	replace fipst = 23 if state_name == "MAINE"
	replace fipst = 24 if state_name == "MARYLAND"
	replace fipst = 25 if state_name == "MASSACHUSETTS"
	replace fipst = 26 if state_name == "MICHIGAN"
	replace fipst = 27 if state_name == "MINNESOTA"
	replace fipst = 28 if state_name == "MISSISSIPPI"
	replace fipst = 29 if state_name == "MISSOURI"
	replace fipst = 30 if state_name == "MONTANA"
	replace fipst = 31 if state_name == "NEBRASKA"
	replace fipst = 32 if state_name == "NEVADA"
	replace fipst = 33 if state_name == "NEW HAMPSHIRE"
	replace fipst = 34 if state_name == "NEW JERSEY"
	replace fipst = 35 if state_name == "NEW MEXICO"
	replace fipst = 36 if state_name == "NEW YORK"
	replace fipst = 37 if state_name == "NORTH CAROLINA"
	replace fipst = 38 if state_name == "NORTH DAKOTA"
	replace fipst = 39 if state_name == "OHIO"
	replace fipst = 40 if state_name == "OKLAHOMA"
	replace fipst = 41 if state_name == "OREGON"
	replace fipst = 42 if state_name == "PENNSYLVANIA"
	replace fipst = 44 if state_name == "RHODE ISLAND"
	replace fipst = 45 if state_name == "SOUTH CAROLINA"
	replace fipst = 46 if state_name == "SOUTH DAKOTA"
	replace fipst = 47 if state_name == "TENNESSEE"
	replace fipst = 48 if state_name == "TEXAS"
	replace fipst = 49 if state_name == "UTAH"
	replace fipst = 50 if state_name == "VERMONT"
	replace fipst = 51 if state_name == "VIRGINIA"
	replace fipst = 53 if state_name == "WASHINGTON"
	replace fipst = 54 if state_name == "WEST VIRGINIA"
	replace fipst = 55 if state_name == "WISCONSIN"
	replace fipst = 56 if state_name == "WYOMING"
	replace fipst = 66 if state_name == "W.PACIFIC AREAS"
	replace fipst = 72 if state_name == "PUERTO RICO"
	replace fipst = 78 if state_name == "VIRGIN ISLANDS"

	* Because the 1994 and 1995 text files do not have numeric county number or MSA
	* identifiers, we will need to merge them from this file. This code is going to create
	* a unique county/msa name to match on. 

	gen county_id = upper(substr(county, 1, 21)) // take the first 21 characters because
												 // the file we're matching with allows
												 // for only 21 characters of text for the
                                                 // county name

	keep year fipst county_id county msa_indicator median l80_* l50*

	tempfile income`j'
	save `income`j'', replace

	}

********************************************************************************
* Use 1996 Numeric County and MSA Codes for 1995 Data
********************************************************************************

* Because the 1994 and 1995 text files do not have numeric county number or MSA
* identifiers, we will need to merge them from this file. This code is going to create
* a unique county/msa name to match on using the 1996 files that have both fips
* codes and county/msa names. 

use `income1996', clear

replace msaname = substr(msaname, 1, strpos(msaname, ",") - 1) if strpos(msaname, ",") != 0 

* Use the MSA name for metro areas and county name for non-metro areas.
* There will be multiple county_ids (when msa span multiple counties) but the
* duplicates will have the same median family incomes with the exception of two 
* MSAs (Kalamazoo-Battle Creek, MI and Odessa-Midland, TX).
gen     county_id = msaname 
replace county_id = county if msa == 0
replace county_id = upper(substr(county_id, 1, 21)) // I'm limiting the number of characters to match on to 21
										            // since there is a different character limit in the 1994, 
											        // 1995, and 1996 files.

* Make adhoc adjustments to improve matches. There isn't a match for these four 
* counties from the 1995 data in the 1996 data. However, the counties are present
* in the 1996 data it's just that they have a different MSA name. 

replace county_id = "COCONINO COUNTY" if fipst == 4  & msa == 2620 & county_id == "FLAGSTAFF"
replace county_id = "MESA COUNTY"     if fipst == 8  & msa == 2995 & county_id == "GRAND JUNCTION"
replace county_id = "KANE COUNTY"     if fipst == 49 & msa == 3739 & county_id == "3739 CODE UNKNOWN"

replace county_id = "SPALDING COUNTY" if fipst == 13 & msa == 520  & county_id == "ATLANTA" & county == "Spalding County"

keep fipst fipcty county_id msa county msaname

* Merge 1996 ids with 1995 data
* Virgin Islands is the only non-match so not a problem

merge m:1 fipst county_id using `income1995'
drop if _merge == 2
drop _merge

keep year fipst fipcty median l80* l50* county_id

tempfile income1995
save `income1995', replace


********************************************************************************
* Use 1996 Numeric County Codes for 1994 Data
********************************************************************************

* Because the 1994 and 1995 text files do not have numeric county number or MSA
* identifiers, we will need to merge them from this file. This code is going to create
* a unique county/msa name to match on using the 1996 files that have both fips
* codes and county/msa names. 

use `income1996', clear

* Format County and MSA Names for Matching By Upper Casing and Deleting Everything
* that Comes After the Comma (usually state abbreviations)
replace county  = upper(county) 
replace msaname = upper(msaname) 

replace msaname = substr(msaname, 1, strpos(msaname, ",") - 1) if strpos(msaname, ",") != 0 

* Use the MSA name for metro areas and county name for non-metro areas.
* There will be multiple county_ids (when msa span multiple counties) but the
* duplicates will have the same median family incomes with the exception of two 
* MSAs (Kalamazoo-Battle Creek, MI and Odessa-Midland, TX), which appear to be an error. 
gen     county_id = msaname 
replace county_id = county if msa == 0
replace county_id = substr(county_id, 1, 21) // I'm limiting the number of characters to match on to 21
										     // since there is a different character limit in the 1994, 
											 // 1995, and 1996 files.

* Make adhoc adjustments to improve matches. There isn't a match for these four 
* counties from the 1995 data in the 1996 data. However, the counties are present
* in the 1996 data it's just that they have a different MSA name. 

replace county_id = "COCONINO COUNTY" if fipst == 4  & msa == 2620 & county == "COCONINO COUNTY"
replace county_id = "MESA COUNTY"     if fipst == 8  & msa == 2995 & county == "MESA COUNTY"
replace county_id = "SPALDING COUNTY" if fipst == 13 & msa == 520  & county == "SPALDING COUNTY"
replace county_id = "KANE COUNTY"     if fipst == 49 & msa == 3739 & county == "KANE COUNTY"
replace county_id = "FORREST COUNTY"  if fipst == 28 & msa == 3285 & county == "FORREST COUNTY"
replace county_id = "LAMAR COUNTY"    if fipst == 28 & msa == 3285 & county == "LAMAR COUNTY"

keep fipst fipcty county_id msa county msaname

* Merge 1996 ids with 1994 data
* Virgin Islands is the only non-match so not a problem

merge m:1 fipst county_id using `income1994'
drop if _merge == 2
drop _merge

keep year fipst fipcty median l80* l50* county_id

tempfile income1994
save `income1994', replace



********************************************************************************
* Import 1993 HUD Income Eligibility Guidelines
********************************************************************************


#delimit ;

clear ;
quietly infix          
3 lines                
1:  str st           3-4     
    str county       6-31    
	    msa         32-35   
		fipst       37-38    
	    fipcty      39-41   
		median      42-47   
2:      l50_1        6-10       
	    l50_2   	16-20      
	    l50_3   	26-30      
	    l50_4   	36-40      
	    l50_5   	46-50      
	    l50_6   	56-60     
	    l50_7   	66-70      
	    l50_8   	76-80      
3:      l80_1    	 6-10       
	    l80_2    	16-20      
	    l80_3    	26-30      
	    l80_4    	36-40      
	    l80_5    	46-50      
	    l80_6    	56-60     
	    l80_7    	66-70      
	    l80_8    	76-80      
using "./rawFiles/hudincome1993.txt" ;

#delimit cr

gen year = 1993

tempfile income1993
save `income1993', replace



********************************************************************************
* Import 1992 HUD Income Eligibility Guidelines
********************************************************************************


#delimit ;

clear ;
quietly infix          
3 lines                
1:  str st           4-5     
    str county       7-29    
	    msa         30-33   
		fipst       39-40    
	    fipcty      41-43   
		median 		48-53   
2:      l50_1   	 6-10       
	    l50_2   	16-20      
	    l50_3   	26-30      
	    l50_4   	36-40      
	    l50_5   	46-50      
	    l50_6   	56-60     
	    l50_7   	66-70      
	    l50_8   	76-80      
3:      l80_1    	 6-10       
	    l80_2    	16-20      
	    l80_3    	26-30      
	    l80_4    	36-40      
	    l80_5    	46-50      
	    l80_6    	56-60     
	    l80_7    	66-70      
	    l80_8    	76-80      
using "./rawFiles/hudincome1992origin.txt" ;

#delimit cr

gen year = 1992

tempfile income1992
save `income1992', replace



#delimit ;

clear ;
quietly infix          
3 lines                
1:  str st           4-5     
    str county       7-24    
	    msa    		25-28   
		fipst       34-35    
	    fipcty      36-38   
		median 		44-48   
2:      l50_1   	 6-10       
	    l50_2   	16-20      
	    l50_3   	26-30      
	    l50_4   	36-40      
	    l50_5   	46-50      
	    l50_6   	56-60     
	    l50_7   	66-70      
	    l50_8   	76-80      
3:      l80_1    	 6-10       
	    l80_2    	16-20      
	    l80_3    	26-30      
	    l80_4    	36-40      
	    l80_5    	46-50      
	    l80_6    	56-60     
	    l80_7    	66-70      
	    l80_8    	76-80      
using "./rawFiles/hudincome1991origin.txt" ;

#delimit cr

gen year = 1991

tempfile income1991
save `income1991', replace





********************************************************************************
* Import 1990 HUD Income Eligibility Guidelines
********************************************************************************


#delimit ;

clear ;
quietly infix          
1 firstlineoffile
1 lines                
1:  str county      35-55   
	    msa    		 1-6     
		fipst 		 9-10     
	    fipcty      11-13   
		median 		76-80   
	    l50_4   	56-60      
	    l80_4    	66-70      
using "./rawFiles/hudincome1990origin.txt" ;

#delimit cr

gen year = 1990

* Generate County Id for Mergin with 1991 FIPS codes

gen     county_id = fipcty if msa == 0
replace county_id = msa if msa > 0 & msa < .

* There are Duplicate Observations for Some Reason for WY. Just going to drop these.

duplicates drop

* This file doesn't have the full array for the number of families. HUD uses 
* these formulas that base the thresholds on fractions of the 4-person family
* income limits. 

gen l80_1 = round(l80_4 * 0.7,  50) 
gen l80_2 = round(l80_4 * 0.8,  50) 
gen l80_3 = round(l80_4 * 0.9,  50)

gen l50_1 = round(l50_4 * 0.7,  50) 
gen l50_2 = round(l50_4 * 0.8,  50) 
gen l50_3 = round(l50_4 * 0.9,  50)

* From 5 on HUD just adds 0.08 

forvalues i = 5/8 {

	gen l80_`i' = round(l80_4 * (1 + (`i' - 4) * 0.08), 50) 
	gen l50_`i' = round(l50_4 * (1 + (`i' - 4) * 0.08), 50) 	
	
	}
	
tempfile income1990
save `income1990', replace

* Import 1991 Data for Merging

use `income1991', clear

gen     county_id = fipcty if msa == 0
replace county_id = msa if msa > 0 & msa < .

keep fipst fipcty county_id 

* Only non-merges are for PR, VI, and Guam
merge m:1 fipst county_id using `income1990'
drop if _merge != 3
drop _merge

drop county_id 

tempfile income1990
save `income1990', replace



********************************************************************************
* Import County Median Family Incomes for 1960, 1970, 1980, and 1990 Censuses
********************************************************************************

* Received median family incomes by county and MSA for the the decenial censuses 
* (1960, 1970, 1980, and 1990) from the U.S. census bureau in an email dated
* February 14, 2018. This code will import the county median family incomes. 

* Unfortunately, the file does not include numeric county ids. Therefore, I am 
* importing numeric codes from each decenial census using the IPUMS-NGIS for 
* both counties and MSAs.

* The purpose of this first section of code is simply to import the median 
* family income data.

import excel "./Census data/c2_updated.xls", sheet("c2") clear


* Drop heading and extraneous text

keep A C E G I
keep in 13/3282

* Rename variables

rename A county
rename C median1989
rename E median1979
rename G median1969
rename I median1959

* Parse county_name variable to remove state abbreviation and create new state variable
* and drop observations that correspond to State median incomes

split county, p(,) 

drop county
rename county1 county
rename county2 st

* Remove Extra Spaces

replace st = strtrim(st)

* Drop blank rows and rows with state median incomes

drop if st == ""

* Put County in Upper-case to Make Matching Easier

replace county = upper(county)

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

* Make Adhoc Adjustments for Matching

* We're never going to get the Alaska areas straight, but after looking at the 
* PSID geocodes, I think we have the place we need.

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

tempfile medfaminc_1959_1989
save `medfaminc_1959_1989', replace

********************************************************************************
* Import State and County FIPS Codes from 1999 Census File 
********************************************************************************

* I received this file with the median income files. We're going to use the 
* county names here to attach fips codes for counties to the county names above.

import excel "./Census data/County_1999.xlsx", clear

drop in 1/2

split C, p(,) gen(county)

rename county1 county
rename county2 state

replace county = upper(county)

destring B, gen(fips)

gen fipst = floor(fips/1000)
gen fipcty = fips - fipst * 1000

keep fipst fipcty state county 

tempfile fips1999
save `fips1999', replace

********************************************************************************
* Merge the Median Incomes for 1950-1990 with the FIPS Codes
********************************************************************************

* In the 1959-1989 Median Income File we have 2 non-matches for AK and VA. These
* aren't in the 1999 file, so I'm not going to worry about them. 

use `medfaminc_1959_1989', clear

merge m:1 county fipst using `fips1999'

bysort _merge county: gen n = _n

sort st county  
*br if _merge == 1 & n == 1
drop n

* Keep only matches

keep if _merge == 3
drop _merge

save `medfaminc_1959_1989', replace

********************************************************************************
* Add Missing Median Family Incomes for Washington DC
********************************************************************************

* DC is not included in the county file, but I do have median incomes from 
* the State file that is available on the census website under Historical state
* Income. I'm going to mannual import the DC values. See the spreadsheet named 
* state2.xlsx for these values

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

append using `medfaminc_1959_1989'

* Reshape to Long

reshape long median, i(fipst fipcty) j(year)

save `medfaminc_1959_1989', replace

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
	
keep year median fipst fipcty l80_* l50_* l30_*

tempfile medfaminc_1959_1989
save `medfaminc_1959_1989', replace


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

use `medfaminc_1959_1989', clear			
	
forvalues i = 1990/2017 {

	append using `income`i''
	
		}

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

*gen msasave = _n if msa == .
*gen count = _n
*tostring(count),replace

gen stryear = year
tostring(stryear),replace

gen strmedian = median
tostring(strmedian),replace

gen msasave = 1000001 if msa == .
destring(msasave),replace
replace msasave = msa if msa <. & msa>=0
replace msasave = 1000001 if year == 1995 | year == 1996

tostring(msasave),replace

destring(fips2000),replace
destring(fips2010),replace
gen fipssave = fips2000 if fips2000 >= 0 & fips2000 <.
replace fipssave = fips2010 if fips2010 >= 0 & fips2010<.
replace fipssave = fips if fips2000 == . & fips2010 == .
tostring(fipssave),replace


gen numID = stryear + fipssave+msasave +strmedian
gen otherID = st + countyID

gen finalid = otherID + numID 

replace finalid = upper(finalid)

drop countyID fipssave stryear strmedian numID otherID

save ./finalOutput/income_eligiblity_thresholds, replace
export delimited using "./finalOutput/old_final_append.csv", replace
