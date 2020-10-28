
********************************************************
//Stata Code by Zhuocheng Shang, SID:862188698\\
********************************************************


********************************************************
//Part One: data cleaning for Current Population Survey and cohort income description\\
********************************************************

set more off
use cpsdata,clear
keep if month == 3
sum year
label list EMPSTAT
drop if empstat==1
keep if age>=21&age<=70
drop if gq==2
keep if citizen==1|citizen==.|citizen==9
label list CLASSWKR
drop if classwkr==10|classwkr==13|classwkr==14

***(1)Generate harmonized educational attainment variable
#delimit ;
	gen highgrade = 0 if educ == 2 ;
	
	replace highgrade = 4 if educ >= 10 & educ <=14 ;
	replace highgrade = 6 if educ >= 20 & educ <= 22;
	replace highgrade = 8 if educ >=30 & educ <= 32 ;
	replace highgrade = 9 if educ == 40 ; 
	replace highgrade = 10 if educ == 50 ; 
	replace highgrade = 11 if educ == 60 | educ == 71 | educ == 72 ; 
	replace highgrade = 12 if educ == 70 | educ == 73 ;
	replace highgrade = 13 if educ == 80 | educ == 81 ; 
	replace highgrade = 14 if educ >= 90 & educ <= 92 ; 
	replace highgrade = 15 if educ == 100 ; 
	replace highgrade = 16 if educ >= 110 & educ <= 111 ; 
	replace highgrade = 19 if educ >= 120 & educ <= 125 ; 
	
	gen any_college = highgrade > 12 ; 
	gen associate_degree = highgrade > 12 & highgrade < 16 ;
	gen bachelor_degree = highgrade >= 16 ; 
	
	gen low_ed = highgrade < 16 ;  

***(2) /*Data Imputation Flags*/
#delimit cr
gen imputed_flag = 0
foreach var of varlist qage qsex qrace {
replace imputed_flag = 1 if `var' != 0
}
replace imputed_flag = . if year <1988 | (year >=2003 & year <= 2009) | (year>= 2014 & year <= 2019)
egen trq = group(age sex highgrade race)
egen num = sum(imputed_flag*asecwt), by(trq)
egen den = sum(asecwt), by(trq)
gen phat = num/den
drop if imputed_flag == 1
gen weight = asecwt/(1-phat)
replace weight = asecwt if year <1988 | (year >=2003 & year <= 2009) | (year>= 2014 & year <= 2019)
drop if weight < 0

*(3) deal with wage
replace incwage=. if incwage==99999999
replace incwage= 1 if incwage == 0 
gen lincwage=log(incwage) 

*(4)  generate 3 year pooled years 
#delimit ;
	gen year3 = . ;
	replace year3 = 1969 if year >= 1968 & year <= 1970 ;
	replace year3 = 1972 if year >= 1971 & year <= 1973 ;
	replace year3 = 1975 if year >= 1974  & year <= 1976 ;
	replace year3 = 1978 if year >= 1977 & year <= 1979 ;	
	replace year3 = 1981 if year >= 1980 & year <= 1982 ;
	replace year3 = 1984 if year >= 1983 & year <= 1985 ;
	replace year3 = 1987 if year >= 1986 & year <= 1988 ;
	replace year3 = 1990 if year >= 1989 & year <= 1991 ;	
	replace year3 = 1993 if year >= 1992 & year <= 1994 ;
	replace year3 = 1996 if year >= 1995 & year <= 1997 ;
	replace year3 = 1999 if year >= 1998 & year <= 2000 ;
	replace year3 = 2002 if year >= 2001 & year <= 2003 ;
	replace year3 = 2005 if year >= 2004  & year <= 2006 ;
	replace year3 = 2008 if year >= 2007 & year <= 2009 ;	
	replace year3 = 2011 if year >= 2010 & year <= 2012 ;
	replace year3 = 2014 if year >= 2013 & year <= 2015 ;
	replace year3 = 2017 if year >= 2016 & year <= 2018 ;


*(5) generate 5 birth cohorts
#delimit ;
gen byear = year - age ;
	
	gen cohort5 = . ;
	replace cohort5 = 1949 if byear >= 1947 & byear <= 1951 ;
	replace cohort5 = 1959 if byear >= 1957 & byear <= 1961 ;
	replace cohort5 = 1969 if byear >= 1967 & byear <= 1971 ;
	replace cohort5 = 1979 if byear >= 1977 & byear <= 1981 ;
	replace cohort5 = 1989 if byear >= 1987 & byear <= 1991 ;

*(6) graph cohort income
drop if cohort5==.

label list EMPSTAT
gen employ=1 if empstat==10|empstat==12
replace employ=0 if employ==.


/*Income*/
/*male*/
sort age
sum incwage,detail
by age: asgen incwage_m49=incwage if sex == 1 & cohort5 == 1949 & year3 >= 1972& incwage > 0&incwage<r(p99), w(weight)
by age: asgen incwage_m59=incwage if sex == 1 & cohort5 == 1959 & year3 >= 1981& incwage > 0&incwage<r(p99), w(weight)
by age: asgen incwage_m69=incwage if sex == 1 & cohort5 == 1969 & year3 >= 1993& incwage > 0&incwage<r(p99), w(weight)
by age: asgen incwage_m79=incwage if sex == 1 & cohort5 == 1979 & year3 >= 2002& incwage > 0&incwage<r(p99), w(weight)
by age: asgen incwage_m89=incwage if sex == 1 & cohort5 == 1989 & year3 >= 2011& incwage > 0&incwage<r(p99), w(weight)

preserve
forvalue i= 49(10)89{
gen lincwage_m`i'=log(incwage_m`i')
}
collapse lincwage_m*, by (age)
sort age
egen OK = anymatch(age), values(21(3)66)
keep if OK
twoway line lincwage_m* age, ytitle(Male income by cohort) xtitle(age) xlabel(21(3)66) 
restore

/*Income*/
/*female*/
sort age
sum incwage,detail
by age: asgen incwage_f49=incwage if sex == 2 & cohort5 == 1949 & year3 >= 1972& incwage > 0&incwage<r(p99), w(weight)
by age: asgen incwage_f59=incwage if sex == 2 & cohort5 == 1959 & year3 >= 1981& incwage > 0&incwage<r(p99), w(weight)
by age: asgen incwage_f69=incwage if sex == 2 & cohort5 == 1969 & year3 >= 1993& incwage > 0&incwage<r(p99), w(weight)
by age: asgen incwage_f79=incwage if sex == 2 & cohort5 == 1979 & year3 >= 2002& incwage > 0&incwage<r(p99), w(weight)
by age: asgen incwage_f89=incwage if sex == 2 & cohort5 == 1989 & year3 >= 2011& incwage > 0&incwage<r(p99), w(weight)

preserve
forvalue i= 49(10)89{
gen lincwage_f`i'=log(incwage_f`i')
}
collapse lincwage_f*, by (age)
sort age
egen OK = anymatch(age), values(21(3)66)
keep if OK
twoway line lincwage_f* age, ytitle(Feale income by cohort) xtitle(age) xlabel(21(3)66) 
restore




//Part Two: Replication of Duflo,Dupas and Kremer(2011) \\
//https://www.aeaweb.org/articles?id=10.1257/aer.101.5.1739\\

clear all
set more off
cd "C:\Users\Administrator\Desktop\dofile"
use "student_test_data.dta"

*(0) CREATE VARIOUS VARIABLES;
gen etpteacher_tracking_lowstream=etpteacher*lowstream
gen sbm_tracking_lowstream=sbm*tracking*lowstream
foreach name in bottomhalf tophalf etpteacher  {
	gen `name'_tracking=`name'*tracking
}

gen percentilesq=percentile*percentile
gen percentilecub=percentile^3

replace agetest=r2_age-1 if agetest==.

* STANDARDIZE TEST SCORES;
foreach x of varlist  litscore mathscoreraw totalscore letterscore wordscore sentscore spellscore  additions_score substractions_score ///
multiplications_score{
sum `x' if tracking==0  
gen meancomp=r(mean) 
gen sdcomp=r(sd) 
gen stdR_`x'=(`x'-meancomp)/sdcomp 
drop meancomp sdcomp
}



*(1)////Treatment effect estimation and generate table/////////////////

**a 
reg stdR_totalscore tracking girl std_mark agetest, cluster(schoolid)
eststo
**b 
reg stdR_totalscore tracking girl std_mark agetest if bottomhalf==0, cluster(schoolid)
eststo
**c
reg stdR_totalscore tracking girl std_mark  agetest if bottomhalf==1, cluster(schoolid)
eststo

**d
reg stdR_totalscore tracking girl std_mark agetest if etpteacher==0, cluster(schoolid)
eststo

**e
reg stdR_totalscore tracking girl std_mark agetest if etpteacher==1, cluster(schoolid)
eststo

*f
reg stdR_totalscore tracking girl std_mark agetest  if etpteacher==0 & bottomhalf==0, cluster(schoolid)
eststo

*g
reg stdR_totalscore tracking girl std_mark agetest  if etpteacher==1 & bottomhalf==0, cluster(schoolid)
eststo

*h
reg stdR_totalscore tracking girl std_mark agetest  if etpteacher==0 & bottomhalf==1, cluster(schoolid)
eststo

*i
reg stdR_totalscore tracking girl std_mark agetest  if etpteacher==1 & bottomhalf==1, cluster(schoolid)
eststo
esttab using Q2k.tex, replace stats(pval) drop(_cons agetest girl) mlabel( "a" "b" "c" "d" "e" "f" "g" "h" "i") ///
addnotes("a b c d e f g h i")
eststo clear

*j
*High vs Low
reg stdR_totalscore tracking girl std_mark agetest if bottomhalf==0
estimates store m1

reg stdR_totalscore tracking girl std_mark  agetest if bottomhalf==1
estimates store m2

eststo: suest m1 m2, cluster (schoolid)
test [m1_mean]tracking-[m2_mean]tracking=0
estadd scalar pval r(p)

*Civil vs Contract
reg stdR_totalscore tracking girl std_mark agetest if etpteacher==0
estimates store m1

estimates store m2

eststo: suest m1 m2, cluster (schoolid)
test [m1_mean]tracking-[m2_mean]tracking=0
estadd scalar pval r(p)

*LowCivil vs LowContract
reg stdR_totalscore tracking girl std_mark agetest  if etpteacher==0 & bottomhalf==1
estimates store m1

reg stdR_totalscore tracking girl std_mark agetest if etpteacher==1 & bottomhalf==1
estimates store m2

eststo: suest m1 m2, cluster (schoolid)
test [m1_mean]tracking-[m2_mean]tracking=0
estadd scalar pval=r(p)

*HighCivil vs HighContract
reg stdR_totalscore tracking girl std_mark  agetest if etpteacher==0 & bottomhalf==0
estimates store m1

reg stdR_totalscore tracking girl std_mark  agetest etpteacher if etpteacher==1 & bottomhalf==0
estimates store m2

eststo: suest m1 m2, cluster (schoolid)
test [m1_mean]tracking-[m2_mean]tracking=0
estadd scalar pval=r(p)

*LowCivil vs HighCivil
reg stdR_totalscore tracking girl std_mark  agetest if etpteacher==0 & bottomhalf==1
estimates store m1

reg stdR_totalscore tracking girl std_mark agetest etpteacher if etpteacher==0 & bottomhalf==0
estimates store m2

eststo: suest m1 m2, cluster (schoolid)
test [m1_mean]tracking-[m2_mean]tracking=0
estadd scalar pval=r(p)

*LowContract vs HighContract
reg stdR_totalscore tracking girl std_mark  agetest if etpteacher==1 & bottomhalf==1
estimates store m1

reg stdR_totalscore tracking girl std_mark  agetest if etpteacher==1 & bottomhalf==0
estimates store m2


eststo: suest m1 m2, cluster (schoolid)
test [m1_mean]tracking-[m2_mean]tracking=0
estadd scalar pval=r(p)

esttab using Q2k2.tex, replace stats(pval) drop(_cons agetest girl) mlabel("High vs Low" "Civil vs Contract" "L.Civil vs L.Contract" "H.Civil vs H.Contract" "L.Civil vs H.Civil" "L.Contract vs H.Contract") ///
addnotes("seemingly unrelated regressions comparision")


*(2)///Visualizing Dynamic Treatment Effects\\
**a

rename stdR_totalscore total

preserve 
keep if tophalf==1  & etpteacher==0 
**High&Civil
* track
locpoly total percentile if tracking==1 , gen(hcivil_track) at(percentile) adoonly degree(1) nog
*non-track
locpoly total percentile if tracking==0 , gen(hcivil_nontrack) at(percentile) adoonly degree(1) nog
collapse total hcivil_track hcivil_nontrack, by(realpercentile tracking)
twoway (scatter total realpercentile if tracking==1) (scatter total realpercentile if tracking==0,msymbol(diamond_hollow)) ///
(line hcivil_track realpercentile)(line hcivil_nontrack realpercentile,lp(dash)), title("High Ability with Civil Teacher") ///
xline(75) 

graph export P2a1.png , replace
restore

**Low&Civil
* track
preserve 
keep if tophalf==0  & etpteacher==0 
locpoly total percentile if tracking==1 , gen(lcivil_track) at(percentile) adoonly degree(1) nog
*non-track
locpoly total percentile if tracking==0 , gen(lcivil_nontrack) at(percentile) adoonly degree(1) nog
collapse total lcivil_track lcivil_nontrack, by(realpercentile tracking)
twoway (scatter total realpercentile if tracking==1) (scatter total realpercentile if tracking==0,msymbol(diamond_hollow)) ///
(line lcivil_track realpercentile)(line lcivil_nontrack realpercentile,lp(dash)), title("Low Ability with Civil Teacher") ///
xline(25) 

graph export P2a2.png , replace
restore

**High&Contract
* track
preserve 
keep if tophalf==1  & etpteacher==1
locpoly total percentile if tracking==1 , gen(hcontract_track) at(percentile) adoonly degree(1) nog
*non-track
locpoly total percentile if tracking==0 , gen(hcontract_nontrack) at(percentile) adoonly degree(1) nog
collapse total hcontract_track hcontract_nontrack, by(realpercentile tracking)
twoway (scatter total realpercentile if tracking==1) (scatter total realpercentile if tracking==0,msymbol(diamond_hollow)) ///
(line hcontract_track realpercentile)(line hcontract_nontrack realpercentile,lp(dash)), title("High Ability with Contract Teacher") ///
xline(75) 

graph export P2a3.png , replace
restore

**Low&Contract
* track
preserve 
keep if tophalf==0  & etpteacher==1
locpoly total percentile if tracking==1 , gen(lcontract_track) at(percentile) adoonly degree(1) nog
*non-track
locpoly total percentile if tracking==0 , gen(lcontract_nontrack) at(percentile) adoonly degree(1) nog
collapse total lcontract_track lcontract_nontrack, by(realpercentile tracking)
twoway (scatter total realpercentile if tracking==1) (scatter total realpercentile if tracking==0,msymbol(diamond_hollow)) ///
(line lcontract_track realpercentile)(line lcontract_nontrack realpercentile,lp(dash)), title("Low Ability with Contract Teacher") ///
xline(25)

graph export P2a4.png , replace
restore

**b
***High&Civil
preserve 
keep if tophalf==1  & etpteacher==0 
* track
locpoly total percentile if tracking==1 , gen(hcivil_track) at(percentile) adoonly degree(1) nog
*non-track
locpoly total percentile if tracking==0 , gen(hcivil_nontrack) at(percentile) adoonly degree(1) nog
collapse total hcivil_track hcivil_nontrack, by(realpercentile tracking)
gen t=hcivil_track-hcivil_nontrack
twoway (line t realpercentile), title("Treatment Effect High Ability with Civil Teacher") ///
xline(75) 
graph export P2b1.png , replace
restore

***Low&Civil
preserve 
keep if tophalf==0  & etpteacher==0 
* track
locpoly total percentile if tracking==1 , gen(lcivil_track) at(percentile) adoonly degree(1) nog
*non-track
locpoly total percentile if tracking==0 , gen(lcivil_nontrack) at(percentile) adoonly degree(1) nog
collapse total lcivil_track lcivil_nontrack, by(realpercentile tracking)
gen t=lcivil_track-lcivil_nontrack
twoway (line t realpercentile), title("Treatment Effect Low Ability with Civil Teacher") ///
xline(25) 
graph export P2b2.png , replace
restore

***High&Ccontract
preserve 
keep if tophalf==1  & etpteacher==1
* track
locpoly total percentile if tracking==1 , gen(hcontract_track) at(percentile) adoonly degree(1) nog
*non-track
locpoly total percentile if tracking==0 , gen(hcontract_nontrack) at(percentile) adoonly degree(1) nog
collapse total hcontract_track hcontract_nontrack, by(realpercentile tracking)
gen t=hcontract_track-hcontract_nontrack
twoway (line t realpercentile), title("Treatment Effect High Ability with Contract Teacher") ///
xline(75) 
graph export P2b3.png , replace
restore

***Low&Ccontract
preserve 
keep if tophalf==0  & etpteacher==1
* track
locpoly total percentile if tracking==1 , gen(lcontract_track) at(percentile) adoonly degree(1) nog
*non-track
locpoly total percentile if tracking==0 , gen(lcontract_nontrack) at(percentile) adoonly degree(1) nog
collapse total lcontract_track lcontract_nontrack, by(realpercentile tracking)
gen t=lcontract_track-lcontract_nontrack
twoway (line t realpercentile), title("Treatment Effect Low Ability with Contract Teacher") ///
xline(25) 
graph export P2b4.png , replace
restore


