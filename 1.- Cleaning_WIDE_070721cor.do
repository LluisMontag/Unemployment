use "G:\OV20_0544\EXPORT\DATASETS\MERGED_5_WAVES_070721.dta", clear


********DROP CASES*********************
***********18-60 at Baseline, active in the labor market (keeping the unfit for work)*********************
****************
**Drop older than 60 at Baseline
drop if Age_W1>60 
***********
**Drop retired at any wave
drop if employment_retired_W1==1 
drop if employment_retired_W2==1
drop if employment_retired_W3==1
drop if employment_retired_W4==1
drop if employment_retired_W5==1
drop if employment_early_W1==1 | employment_situation_adu_q_11==5
drop if employment_early_W2==1
drop if employment_early_W3==1
drop if employment_early_W4==1
drop if employment_early_W5==1

**Drop housewives at each wave
drop if employment_housewife_W1==1 | employment_situation_adu_q_11==9
drop if employment_housewife_W2==1  
drop if employment_housewife_W3==1
drop if employment_housewife_W4==1
drop if employment_housewife_W5==1
    
**Drop students at each wave 
drop if employment_student_W1==1 | employment_situation_adu_q_11==10
drop if employment_student_W2==1 
drop if employment_student_W3==1
drop if employment_student_W4==1
drop if employment_student_W5==1


*********
drop workweek* Q1 Q2 VARIANT_ID1 VARIANT_ID2 unemployment_duration_W4

drop GenderW2 Gender GenderW4 GenderW5
rename GenderW1 Gender
rename DATE DateW3
drop DATE_Q2

***Dates & Periods
gen Date2W1 = date(DateW1, "YM")
order Date2W1, after(DateW1)
gen Date2W2 = date(DateW2, "YM")
order Date2W2, after(DateW2)
gen Date2W3 = date(DateW3, "YM")
order Date2W3, after(DateW3)
gen Date2W4 = date(DateW4, "YM")
order Date2W4, after(DateW4)
gen Date2W5 = date(Date_W5, "YM")
order Date2W5, after(Date_W5)
format Date2W1 Date2W2 Date2W3 Date2W4 Date2W5 %td

drop DateW1 DateW2 DateW3 DateW4 DateW4 Date_W5
rename Date2W1 DateW1
rename Date2W2 DateW2 
rename Date2W3 DateW3
rename Date2W4 DateW4
rename Date2W5 DateW5

gen MonthsBaselineW2 = (DateW2 - DateW1)/30 
gen MonthsBaselineW3 = (DateW3 - DateW1)/30 
gen MonthsBaselineW4 = (DateW4 - DateW1)/30
gen MonthsBaselineW5 = (DateW5 - DateW1)/30

gen MonthslastinterviewW2 = MonthsBaselineW2
gen MonthslastinterviewW5 = (DateW5 - DateW4)/30

gen YearW1 = year(DateW1)
order YearW1, after(DateW1)
gen YearW2 = year(DateW2)
order YearW2, after(DateW2)
gen YearW3 = year(DateW3)
order YearW3, after(DateW3)
gen YearW4 = year(DateW4)
order YearW4, after(DateW4)
gen YearW5 = year(DateW5)
order YearW5, after(DateW5)

**ABSTAINERS
gen AbstainerW1=1 if GLASSDAYW1==0
replace AbstainerW1=0 if AbstainerW1==.
replace AbstainerW1=. if GLASSDAYW1==.

gen AbstainerW4=1 if GLASSDAYW4==0
replace AbstainerW4=0 if AbstainerW4==.
replace AbstainerW4=. if GLASSDAYW4==.

gen AbstainerW5=1 if GLASSDAYW5==0
replace AbstainerW5=0 if AbstainerW5==.
replace AbstainerW5=. if GLASSDAYW5==.


**Disabled
rename employment_unfit_W1 UnfitW1
rename employment_unfit_W2 UnfitW2
rename employment_unfit_W3 UnfitW3
rename employment_unfit_W4 UnfitW4
rename employment_unfit_W5 UnfitW5
recode UnfitW1 UnfitW2 UnfitW3 UnfitW4 UnfitW5 (999=.) (99=.)

*The Unemployed & unfit partly overlap. I think it's better to do it this way and "benefit" the unfit, as the unemployed also include those "receiving social benefits", which could be misleading. 
gen Work2W1 = Unemployment_W1
replace Work2W1=2 if UnfitW1==1 | Unfit2W1==1
replace Work2W1=. if Unemployment_W1==. & UnfitW1==.

gen Work2W2=Unemployment_W2
replace Work2W2=2 if UnfitW2==1
replace Work2W2=. if Unemployment_W2==. & UnfitW2==.

gen Work2W3=Unemployment_W3
replace Work2W3=2 if UnfitW3==1
replace Work2W3=. if Unemployment_W3==. & UnfitW3==.

gen Work2W4=Unemployment_W4
replace Work2W4=2 if UnfitW4==1
replace Work2W4=. if Unemployment_W4==. & UnfitW4==.

gen Work2W5=Unemployment_W5
replace Work2W5=2 if UnfitW5==1
replace Work2W5=. if Unemployment_W5==. & UnfitW5==.

foreach var of varlist Work2W2 Work2W3 Work2W4 Work2W5{
label def `var' 0"Employed" 1"Unemployed" 2"Unfit", modify
}
label val Work2W2 Work2W3 Work2W4 Work2W5


*Improve unemployment measurements 
*Unemployed & Unfit Together
gen Work4W1 = Work2W1
recode Work4W1 2=1
label def Work4W1 0"Employed" 1"Unemployed/Unfit", modify
label val Work4W1 Work4W1
gen Work4W2 = Work2W2
recode Work4W2 2=1
label def Work4W2 0"Employed" 1"Unemployed/Unfit", modify
label val Work4W2 Work4W2
gen Work4W3 = Work2W3
recode Work4W3 2=1
label def Work4W3 0"Employed" 1"Unemployed/Unfit", modify
label val Work4W3 Work4W3
gen Work4W4 = Work2W4
recode Work4W4 2=1
label def Work4W4 0"Employed" 1"Unemployed/Unfit", modify
label val Work4W4 Work4W4
gen Work4W5 = Work2W5
recode Work4W5 2=1
label def Work4W5 0"Employed" 1"Unemployed/Unfit", modify
label val Work4W5 Work4W5

*Outcome with 4 categories
gen Work5W1=0 if Work2W1==0
replace Work5W1=1 if DurationUnempW1==3
replace Work5W1=2 if DurationUnempW1>3 & DurationUnempW1<=39
replace Work5W1=3 if UnfitW1==1
label def Work5W1 0"Employed" 1"Short Unemp." 2"Long Unemp." 3"Unfit", modify
label val Work5W1 Work5W1

gen Work5W2=0 if Work2W2==0
replace Work5W2=1 if DurationUnempW2==3
replace Work5W2=2 if DurationUnempW2>3 & DurationUnempW2<=39
replace Work5W2=3 if UnfitW2==1
label def Work5W2 0"Employed" 1"Short Unemp." 2"Long Unemp." 3"Unfit", modify
label val Work5W2 Work5W2

gen Work5W3=0 if Work2W3==0
replace Work5W3=1 if DurationUnempW3==3
replace Work5W3=2 if DurationUnempW3>3 & DurationUnempW3<=39
replace Work5W3=3 if UnfitW3==1
label def Work5W3 0"Employed" 1"Short Unemp." 2"Long Unemp." 3"Unfit", modify
label val Work5W3 Work5W3

gen Work5W4=0 if Work2W4==0
replace Work5W4=1 if DurationUnempW4==3
replace Work5W4=2 if DurationUnempW4>3 & DurationUnempW4<=39
replace Work5W4=3 if UnfitW4==1
label def Work5W4 0"Employed" 1"Short Unemp." 2"Long Unemp." 3"Unfit", modify
label val Work5W4 Work5W4

gen Work5W5=0 if Work2W5==0
replace Work5W5=1 if DurationUnempW5==3
replace Work5W5=2 if DurationUnempW5>3 & DurationUnempW5<=39
replace Work5W5=3 if UnfitW5==1
label def Work5W5 0"Employed" 1"Short Unemp." 2"Long Unemp." 3"Unfit", modify
label val Work5W5 Work5W5

replace UnfitW1=0 if UnfitW1==. & Work5W1!=.
replace UnfitW2=0 if UnfitW2==. & Work5W2!=.
replace UnfitW3=0 if UnfitW3==. & Work5W3!=.
replace UnfitW4=0 if UnfitW4==. & Work5W4!=.
replace UnfitW5=0 if UnfitW5==. & Work5W5!=.

****Long term unemployment (without duration of unfit)*
gen LongUnemp2W1 = 1 if Work5W1==2
replace LongUnemp2W1=0 if LongUnemp2W1==.
gen LongUnemp2W2 = 1 if Work5W2==2
replace LongUnemp2W2=0 if LongUnemp2W2==.
gen LongUnemp2W3 = 1 if Work5W3==2
replace LongUnemp2W3=0 if LongUnemp2W3==.
gen LongUnemp2W4 = 1 if Work5W4==2
replace LongUnemp2W4=0 if LongUnemp2W4==.
gen LongUnemp2W5 = 1 if Work5W5==2
replace LongUnemp2W5=0 if LongUnemp2W5==.

gen ShortUnempW1 = 1 if Work5W1==1
replace ShortUnempW1=0 if ShortUnempW1==.
gen ShortUnempW2 = 1 if Work5W2==1
replace ShortUnempW2=0 if ShortUnempW2==.
gen ShortUnempW3 = 1 if Work5W3==1
replace ShortUnempW3=0 if ShortUnempW3==.
gen ShortUnempW4 = 1 if Work5W4==1
replace ShortUnempW4=0 if ShortUnempW4==.
gen ShortUnempW5 = 1 if Work5W5==1
replace ShortUnempW5=0 if ShortUnempW5==.


**Incidence of unemployment
gen UnempAllWavesW5=1 if Work2W1==1 & Work2W2==1 & Work2W3==1 & Work2W4==1 & Work2W5==1
replace UnempAllWavesW5=1 if Work2W1==2 & Work2W2==2 & Work2W3==2 & Work2W4==2 & Work2W5==2
replace UnempAllWavesW5=0 if UnempAllWavesW5==.
replace UnempAllWavesW5=. if Work2W1==. & Work2W2==. & Work2W3==. & Work2W4==. & Work2W5==.

gen Unemp_since_lastwaveW2=1 if (Work2W1==0 & Work2W2==1) | (Work2W1==0 & Work2W2==2)
replace Unemp_since_lastwaveW2=0 if Unemp_since_lastwaveW2==.
replace Unemp_since_lastwaveW2=. if Work2W2==. | Work2W1==.

gen Unemp_since_lastwaveW5=1 if (Work2W4==0 & Work2W5==1) | (Work2W4==0 & Work2W5==2)
replace Unemp_since_lastwaveW5=0 if Unemp_since_lastwaveW5==.
replace Unemp_since_lastwaveW5=. if Work2W4==. | Work2W5==.


***Convert into Years of Education
gen Years_EducationW1 = EducationW1
recode Years_EducationW1 1=5 2=6 3=9 4=10 5=12 6=12 7=15 8=16 9=. 999=.
gen Years_EducationW4 = EducationW4
recode Years_EducationW4 1=5 2=6 3=9 4=10 5=12 6=12 7=15 8=16 9=. 999=.
gen Years_EducationW5 = EducationW5
recode Years_EducationW5 1=5 2=6 3=9 4=10 5=12 6=12 7=15 8=16 9=. 999=.


*Partner with reverse ref. category
gen Partner2W1=PartnerW1
recode Partner2W1 1=0 0=1
label def Partner2W1 0"Partnered" 1"Single", modify
label val Partner2W1 Partner2W1 

gen Partner2W4=PartnerW4
recode Partner2W4 1=0 0=1
label def Partner2W4 0"Partnered" 1"Single", modify
label val Partner2W4 Partner2W4 

save "G:\OV20_0544\EXPORT\DATASETS\CLEAN_WIDE_RED_070721.dta", replace

**PLEASE NOTE: In wide format, we don't drop waves 2 & 3 nor individuals with only 1 wave...they will automatically drop from the models**
