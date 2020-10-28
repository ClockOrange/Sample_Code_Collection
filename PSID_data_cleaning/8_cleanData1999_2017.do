/* ------------------------------------------------
	Part I: Rename variable names from 2000 - 2017
   ------------------------------------------------
*/

clear all

* cd project folder path
cd "/Users/clockorange/Downloads/Thresholds code review/Zhuocheng_Deliverables/"

//log close
// local c_date = c(current_date)
// local c_time = c(current_time)
// local c_time_date = "`c_date'"+"_" +"`c_time'"
// local time_string = subinstr("`c_time_date'", ":", "_", .)
// local time_string = subinstr("`time_string'", " ", "_", .)

// log using "log/incomeEligibilityThresholds-`time_string'.log", replace




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
	
	foreach v of varlist _all{ 
		local varlabel : variable label `v'
	    di "`v'" ,"`varlabel'"
	}
	di "----------------","`i'","---------------------"
}


forvalues i = 2014/2017 {
    * read in variable as lowercase *
	import excel "./rawFiles/hudincome`i'.xls", firstrow case(lower) clear
	
	* rename by year [median + year] to [median]
	gen year = `i'
	
	rename median`i'   		median
	rename state_alpha 		st
	rename state 			fipst
	rename county          	fipcty
	rename metro_area_name 	msaname 
	rename county_name     	county
	rename state_name      	state
	
	* to string type
	cap tostring fips2010, replace
	cap tostring fips2000, replace
	
	* rename eli_ to l30
	forvalues num = 1/8 {
	
		rename eli_`num'	l30_`num'
	}
	
	* l30,50,80 to numeric type
	foreach var of varlist l* {
	
		destring `var', replace
		
	}
	
	* save data file locally
	export delimited using "./output/csv/income`i'.csv", replace
	//save income`i', replace
	
	
}


/* Rename variable names for years in 2013
* 2013: State_Alpha	fips2010 fips2000	State	County	County_Name	CBSASub	Metro_Area_Name             median2013 MSA	county_town_name state_name	metro
*/

* list variable
* just to check if variable matches comparing with original do.file
forvalues i = 2013/2013{
    * read in variable as lowercase *
	import excel "./rawFiles/hudincome`i'.xls", firstrow case(lower) clear
	
	foreach v of varlist _all{ 
		local varlabel : variable label `v'
	    di "`v'" ,"`varlabel'"
	}
	di "----------------","`i'","---------------------"
}


forvalues i = 2013/2013 {
    * read in variable as lowercase *
	import excel "./rawFiles/hudincome`i'.xls", firstrow case(lower) clear
	
	* rename by year [median + year] to [median]
	gen year = `i'
	
	rename median`i'   		median
	rename state_alpha 		st
	rename state 			fipst
	rename county          	fipcty
	rename metro_area_name 	msaname 
	rename county_name     	county
	rename state_name      	state
	
	* to string type
	cap tostring fips2010, replace
	cap tostring fips2000, replace

	
	* eli_ already stored as l30
	* l30,50,80 to numeric type
	foreach var of varlist l* {
	
		destring `var', replace
		
	}
	
	* save data file locally
	export delimited using "./output/csv/income`i'.csv", replace
	//save income`i', replace
	
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
* list variable
* just to check if variable matches comparing with original do.file

forvalues i = 2000/2012{
    * read in variable as lowercase *
	import excel "./rawFiles/hudincome`i'.xls", firstrow case(lower) clear
	
	foreach v of varlist _all{ 
		local varlabel : variable label `v'
	    di "`v'" ,","  ,  "`varlabel'"
	}
	di "----------------","`i'","---------------------"
}

forvalues i = 2006/2012 {
    * read in variable as lowercase *
	import excel "./rawFiles/hudincome`i'.xls", firstrow case(lower) clear
	
	* rename by year [median + year] to [median]
	gen year = `i'
	
	rename median`i'   		median
	rename state_alpha 		st
	rename state 			fipst
	rename county          	fipcty
	rename metro_area_name 	msaname 
	rename county_name     	county
	rename state_name      	state
	rename fips				fips2000
	
	* to string type
	cap tostring fips2000, replace

	
	* eli_ already stored as l30
	* l30,50,80 to numeric type
	foreach var of varlist l* {
	
		destring `var', replace
		
	}
	
	* save data file locally
	export delimited using "./output/csv/income`i'.csv", replace
	//save income`i', replace
	
}

* 2005: state_alpha	                    state	county  CountyName          msaname(not found)          median2005 msa  name(could be MSAname)
forvalues i = 2005/2005 {
    * read in variable as lowercase *
	import excel "./rawFiles/hudincome`i'.xls", firstrow case(lower) clear
	
	* rename by year [median + year] to [median]
	gen year = `i'
	
	rename median`i'   		median
	rename state_alpha 		st
	rename state 			fipst
	rename county          	fipcty
	rename countyname     	county
	rename name             msaname
	
	* eli_ already stored as l30
	* l30,50,80 to numeric type
	foreach var of varlist l* {
	
		destring `var', replace
		
	}
	
	* save data file locally
	export delimited using "./output/csv/income`i'.csv", replace
	//save income`i', replace
	
}

* 2004: state_alpha	                    state   county	CountyName          msaname(found)              median2004 msa 
* 													    (list but not show in local excel)       
forvalues i = 2004/2004 {
    * read in variable as lowercase *
	import excel "./rawFiles/hudincome`i'.xls", firstrow case(lower) clear
	
	* rename by year [median + year] to [median]
	gen year = `i'
	
	rename median`i'   		median
	rename state_alpha 		st
	rename state 			fipst
	rename county          	fipcty
	rename countyname     	county
	
	* eli_ already stored as l30
	* l30,50,80 to numeric type
	foreach var of varlist l* {
	
		destring `var', replace
		
	}
	
	* save data file locally
	export delimited using "./output/csv/income`i'.csv", replace
	//save income`i', replace
	
}

* 2003: state_alpha                     state   county  countyname	        msaname 	                median2003 msa	
* 2002: StateAlpha                      State	county  CountyName		    MSAName                     Median     MSA
forvalues i = 2003/2003 {
    * read in variable as lowercase *
	import excel "./rawFiles/hudincome`i'.xls", firstrow case(lower) clear
	
	* rename by year [median + year] to [median]
	gen year = `i'
	
	rename median`i'   		median
	rename state_alpha 		st
	rename state 			fipst
	rename county          	fipcty
	rename countyname     	county
	rename msaname          msaname
	
	* eli_ already stored as l30
	* l30,50,80 to numeric type
	foreach var of varlist l* {
	
		destring `var', replace
		
	}
	
	* save data file locally
	export delimited using "./output/csv/income`i'.csv", replace
	//save income`i', replace
	
}

forvalues i = 2002/2002 {
    * read in variable as lowercase *
	import excel "./rawFiles/hudincome`i'.xls", firstrow case(lower) clear
	
	gen year = `i'
	
	rename statealpha 		st
	rename state 			fipst
	rename county          	fipcty
	rename countyname     	county
	rename msaname          msaname
	rename median			median
	
	* eli_ already stored as l30
	* l30,50,80 to numeric type
	foreach var of varlist l* {
	
		destring `var', replace
		
	}
	
	* save data file locally
	export delimited using "./output/csv/income`i'.csv", replace
	//save income`i', replace
	
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

forvalues i = 2000/2001 {
    * read in variable as lowercase *
	import excel "./rawFiles/hudincome`i'.xls", firstrow case(lower) clear
	
	gen year = `i'
	rename fipsstatecode 		fipst
	rename state 				st
	rename fipscountycode       fipcty
	rename countyname     		county
	rename hudmsacode			msa
	rename msaname          	msaname
	rename fy`i'medianfamilyincome			median
	
	
	rename incomelimit1person				l30_1
	
	forvalues num = 2/8{
	
		rename incomelimit`num'persons		l30_`num'
	}
	
	rename verylow50incomelimit1 			l50_1
	local vlist q r s t u v w
	local index = 2
	foreach var of local vlist{
		rename `var' 						l50_`index' 
		local index = `index' + 1
	}
	
	rename low80incomelimit1perso 			l80_1
	
	forvalues num = 2/8{
	
		rename lowincomelimit`num'persons	l80_`num'
	}
	
	destring fipst, replace
	destring fipcty, replace
	destring msa, replace
	destring median, replace
	* l30,50,80 to numeric type
	foreach var of varlist l* {
	
		destring `var', replace
		
	}
	
	* save data file locally
	export delimited using "./output/csv/income`i'.csv", replace
	//save income`i', replace
	
}


forvalues i = 1999/1999{
    * read in variable as lowercase *
	import excel "./rawFiles/hudincome`i'.xls", firstrow case(lower) clear
	
	foreach v of varlist _all{ 
		local varlabel : variable label `v'
	    di "`v'" ,","  ,  "`varlabel'"
	}
	di "----------------","`i'","---------------------"
}


/*
* 1999
*
 fipsstatecode , stateabrev, fipscountycode, countyname , hudmsacode , msaname , fy1999medianfamilyincome , 
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

*/

forvalues i = 1999/1999 {
    * read in variable as lowercase *
	import excel "./rawFiles/hudincome`i'.xls", firstrow case(lower) clear
	
	gen year = `i'
	rename fipsstatecode 		fipst
	rename state 				st
	rename fipscountycode       fipcty
	rename countyname     		county
	rename hudmsacode			msa
	rename msaname          	msaname
	rename fy`i'medianfamilyincome			median
	
	
	rename incomelimit1person				l30_1
	
	forvalues num = 2/8{
	
		rename incomelimit`num'persons		l30_`num'
	}
	
	rename verylow50incomelimit1 			l50_1
	local vlist q r s t u v w
	local index = 2
	foreach var of local vlist{
		rename `var' 						l50_`index' 
		local index = `index' + 1
	}
	
	rename low80incomelimit1perso 			l80_1
	
	forvalues num = 2/8{
	
		rename lowincomelimit`num'persons	l80_`num'
	}
	
	destring fipst, replace
	destring fipcty, replace
	destring msa, replace
	destring median, replace
	* l30,50,80 to numeric type
	foreach var of varlist l* {
	
		destring `var', replace
		
	}
	
	* save data file locally
	export delimited using "./output/csv/income`i'.csv", replace
	//save income`i', replace
	
}

