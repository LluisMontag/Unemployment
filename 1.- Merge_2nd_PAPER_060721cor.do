**WAVE 1**
use "G:\OV20_0544\EXPORT\DATASETS\1A_Merged_ABWide.dta", clear

gen W1=1
order W1, after (Gender)

foreach var of varlist employment_situation*{
recode `var' 999=. 99=.
}


*Employment status
*LET OP! in this variable, the unfit are included in the 0 value. This may be only used as dummy if combined with "Unfit" dummy in a model. 
gen Unemployment_W1=1 if employment_situation_adu_q_11==6 | employment_situation_adu_q_11==8 | employment_situation_adu_q_1_f1==1 | employment_situation_adu_q_1_h1==1
replace Unemployment_W1=0 if Unemployment_W1==.
replace Unemployment_W1=. if employment_situation_adu_q_11==. & employment_situation_adu_q_1_a1==. & employment_situation_adu_q_1_b1==. & employment_situation_adu_q_1_c1==. & employment_situation_adu_q_1_d1==. & employment_situation_adu_q_1_f1==. & employment_situation_adu_q_1_g1==. & employment_situation_adu_q_1_h1==. & employment_situation_adu_q_1_i1==. & employment_situation_adu_q_1_j1==. & employment_situation_adu_q_1_k1==. & employment_situation_adu_q_1_l1==. 

*Mean duration of unemployment
gen DurationUnempW1 = unemployment_current_adu_q_11
recode DurationUnempW1 1=3 2=9 3=24 4=39
label var DurationUnempW1 "Mean duration of unemployment (months). Baseline"

*Long-term unemployment 
gen LTUnempW1 = DurationUnempW1
recode LTUnempW1 1=0 2=1 3=1 4=1 
replace LTUnempW1=. if (unemployment_current_adu_q_11==. & Unemployment_W1==1)
label var LTUnempW1 "Long-term unemployment (>6months). Baseline"

*Unemployment Categorical
gen UnempW1_cat=0 if Unemployment_W1==0
replace UnempW1_cat=1 if DurationUnempW1==3
replace UnempW1_cat=2 if DurationUnempW1==9 | DurationUnempW1==24 | DurationUnempW1==39
replace UnempW1_cat=. if Unemployment_W1==1 & DurationUnempW1==.
label def UnempW1_cat 0"Employed" 1"Short-term unemployed" 2"Long-term unemployed", modify
label val UnempW1_cat UnempW1_cat
label var UnempW1_cat "Unemployment categorical. Baseline"

gen Work_W1= workweek_hours_adu_q_11
recode Work_W1 (1/32=1) (32/max=2) 
replace Work_W1=. if workweek_hours_adu_q_11==.
replace Work_W1=0 if Unemployment_W1==1
label def Work_W1 0"Unemployed" 1"Part-time" 2"Full-time job", modify
label val Work_W1 Work_W1 
label var Work_W1 "Working Status at Wave 1"

gen Unfit2W1=1 if employment_situation_adu_q_11==7 | employment_situation_adu_q_1_g==1
replace Unfit2W1=0 if Unfit2W1==.
replace Unfit2W1=. if employment_situation_adu_q_11==. & employment_situation_adu_q_1_a1==. & employment_situation_adu_q_1_b1==. & employment_situation_adu_q_1_c1==. & employment_situation_adu_q_1_d1==. & employment_situation_adu_q_1_f1==. & employment_situation_adu_q_1_g1==. & employment_situation_adu_q_1_h1==. & employment_situation_adu_q_1_i1==. & employment_situation_adu_q_1_j1==. & employment_situation_adu_q_1_k1==. & employment_situation_adu_q_1_l1==. 

rename employment_current_adu_q_1 employment_current_W1
rename employment_situation_adu_q_1_f employment_situation_W1
rename employment_situation_W1 employment_unemployed_W1
rename employment_situation_adu_q_1_g employment_unfit_W1
rename employment_situation_adu_q_1_h employment_benefits_W1
rename employment_situation_adu_q_1_i employment_housewife_W1
rename employment_situation_adu_q_1_j employment_student_W1
rename employment_situation_adu_q_1_k employment_retired_W1
rename employment_situation_adu_q_1_l employment_early_W1
rename employment_situation_adu_q_1_b1 employment_fulltime2_W1
rename employment_situation_adu_q_1_c1 employment_parttime_W1
rename employment_situation_adu_q_1_d1 employment_parttime2_W1

*******************************************
***ALCOHOL USE********
*****
rename ffqh_alcohol_adu_q_292 ffqh_alcohol_adu_quant2
rename ffqh_alcohol_adu_q_27_a2 ffqh_alcohol_adu_quant
recode ffqh_alcohol_adu_quant2 1=1.5 2=3.5 3=5.5 4=7.5 5=9.5 6=11.5 7=12 8=12

**ALCOHOL Frequency: 1 day/month= 1/30; 2-3 days/month= 1.5/30, etc. 
gen Alc_FrequencyW1=ffqh_alcohol_adu_q_272 
recode Alc_FrequencyW1 (1=0) (2=0.03) (3=0.083) (4=0.14) (5=0.36) (6=0.64) (7=0.93) (999=.)

**ALCOHOL Quantity
egen Alcohol_QuantW1 = rowtotal (ffqh_alcohol_adu_quant ffqh_alcohol_adu_quant2) 
replace Alcohol_QuantW1=0 if Alc_FrequencyW1==0
replace Alcohol_QuantW1=. if ffqh_alcohol_adu_quant==. & ffqh_alcohol_adu_quant2==.

*GLASSES X DAY
gen GLASSDAYW1 = Alc_FrequencyW1 * Alcohol_QuantW1
replace GLASSDAYW1=0 if Alc_FrequencyW1==0
replace GLASSDAYW1=. if Alc_FrequencyW1==. & Alcohol_QuantW1==.

*Alcohol categorical
gen Alcohol_catW1=0 if GLASSDAYW1==0
replace Alcohol_catW1=1 if GLASSDAYW1>0.01 & GLASSDAYW1<1.5
replace Alcohol_catW1=2 if GLASSDAYW1>1.5
replace Alcohol_catW1=. if GLASSDAYW1==.
label def Alcohol_catW1 0"Abstainer" 1"Moderate" 2"Heavy Drinker", modify
label val Alcohol_catW1 Alcohol_catW1
label var Alcohol_catW1 "Alcohol at Baseline. Categorical" 

*HD dummy
gen HDW1=1 if GLASSDAYW1>1.5
replace HDW1=0 if HDW1==.
replace HDW1=. if GLASSDAYW1==.

*Binge Drinking dummy: 5+ drinks (4+ women) at least once a month!!!)
gen BDW1=1 if ( ffqh_alcohol_adu_q_272>1 & Alcohol_QuantW1>4 & Gender==0) | (ffqh_alcohol_adu_q_272>1 & Alcohol_QuantW1>3 & Gender==1)
replace BDW1=0 if BDW1==.
replace BDW1=. if GLASSDAYW1==.

gen BDcatW1=2 if BDW1==1
replace BDcatW1=0 if GLASSDAYW1==0 
replace BDcatW1=1 if BDcatW1==.
replace BDcatW1=. if BDW1==.
label def BDcatW1 0"Abstainer" 1"Moderate" 2"Binge Drinking", modify
label val BDcatW1 BDcatW1 
label var BDcatW1 "Binge Drinking at Baseline, categorical"

******************************************
rename degree_highest_adu_q_11  EducationW1

gen PartnerW1 = partner_presence_adu_q_11
recode PartnerW1 1=1 2=1 3=1 4=0 5=0 
replace PartnerW1=1 if maritalstatus_current_adu_q_11==1 | maritalstatus_current_adu_q_11==2 | maritalstatus_current_adu_q_11==7
replace PartnerW1=0 if PartnerW1==.
replace PartnerW1=. if partner_presence_adu_q_11==. & maritalstatus_current_adu_q_11==.
label def PartnerW1 0"Single/Divorced" 1"Married/Partnered", modify
label val PartnerW1 PartnerW1
label var PartnerW1 "Partner Status at Baseline"

rename educational_attainment_adu_c_11 EAW1
label var EAW1 "Educational Attainment at Baseline" 


 merge 1:1 PROJECT_PSEUDO_ID using "G:\OV20_0544\EXPORT\DATASETS\1A_Health.dta", nogenerate update

gen HealthW1 = rand_generalhealth_adu_q_01
recode HealthW1 1=5 2=4 3=3 4=2 5=1
label def HealthW1 1"Poor" 2"Mediocre" 3"Good" 4"Very good" 5"Excellent", modify
label val HealthW1 HealthW1

drop ZIPCODE1 income* jobcode* maritalstatus_current_adu_q_11 partner_presence_adu_q_11 ffqh_alcohol_adu_q_272- ffqh_alcohol_adu_q_352
drop employment_stopped_adu_q_1_a1- employment_stopped_adu_q_1_d1 rand_generalhealth_adu_q_01
drop lte* member* Member* SPFIL* 

rename Gender GenderW1
rename DATE1 DateW1
drop DATE_B2

save "G:\OV20_0544\EXPORT\DATASETS\CLEANING_1A_070721.dta", replace


****************************
***************************
***WAVE 2***
use "G:\OV20_0544\EXPORT\DATASETS\1B_ABC.RED.dta", clear

gen W2=1
order W2, after (Gender)
rename AGE Age_W2
drop GENDER
rename Gender GenderW2
rename DATE DateW2

foreach var of varlist employment_situation*{
recode `var' 999=. 99=.
}
**Employment Status**
gen Unemployment_W2=1 if employment_situation_adu_q_1_f==1 | employment_situation_adu_q_1_h==1
replace Unemployment_W2=0 if Unemployment_W2==.
replace Unemployment_W2=. if employment_situation_adu_q_1_f==. & employment_situation_adu_q_1_g==. & employment_situation_adu_q_1_h==. & employment_situation_adu_q_1_i==. & employment_situation_adu_q_1_j==. & employment_situation_adu_q_1_k==. & employment_situation_adu_q_1_l==. & employment_situation_adu_q_1_m==.    

*Mean duration of unemployment
gen DurationUnempW2 = unemployment_current_adu_q_1
recode DurationUnempW2 1=3 2=9 3=24 4=39 99=. 999=.
label var DurationUnempW2 "Mean duration of unemployment (months). Wave 2"

*Long-term unemployment 
gen LTUnempW2 = DurationUnempW2
recode LTUnempW2 1=0 2=1 3=1 4=1 
replace LTUnempW2=. if (unemployment_current_adu_q_1==. & Unemployment_W2==1)
label var LTUnempW2 "Long-term unemployment (>6months). Wave 2"

*Unemployment Categorical
gen UnempW2_cat=0 if Unemployment_W2==0
replace UnempW2_cat=1 if DurationUnempW2==3
replace UnempW2_cat=2 if DurationUnempW2==9 | DurationUnempW2==24 | DurationUnempW2==39
replace UnempW2_cat=. if Unemployment_W2==1 & DurationUnempW2==.
label def UnempW2_cat 0"Employed" 1"Short-term unemployed" 2"Long-term unemployed", modify
label val UnempW2_cat UnempW2_cat
label var UnempW2_cat "Unemployment categorical. Wave 2"

recode workweek_hours_adu_q_1 999=.
gen Work_W2= workweek_hours_adu_q_1
recode Work_W2 (1/32=1) (32/max=2) 
replace Work_W2=. if workweek_hours_adu_q_1==.
replace Work_W2=0 if Unemployment_W2==1
label def Work_W2 0"Unemployed" 1"Part-time" 2"Full-time job", modify
label val Work_W2 Work_W2 
label var Work_W2 "Working Status at Wave 2"

rename employment_current_adu_q_1 employment_current_W2
rename employment_situation_adu_q_1_f employment_situation_W2
rename employment_situation_W2 employment_unemployed_W2
rename employment_situation_adu_q_1_g employment_unfit_W2
rename employment_situation_adu_q_1_h employment_benefits_W2
rename employment_situation_adu_q_1_i employment_housewife_W2
rename employment_situation_adu_q_1_j employment_student_W2
rename employment_situation_adu_q_1_k employment_retired_W2
rename employment_situation_adu_q_1_l employment_early_W2
rename employment_situation_adu_q_1_m employment_none_W2
rename unemployment_current_adu_q_1 unemployment_current_W2
rename workweek_hours_adu_q_1 workweek_hours_W2
rename employment_lifetime_adu_q_1 employment_lifetime_W2

*******************************************
gen PartnerW2=1 if maritalstatus_current_adu_q_1==1 | maritalstatus_current_adu_q_1==2 | maritalstatus_current_adu_q_1==7 | partner_presence_adu_q_1==1 | partner_presence_adu_q_1==2 | partner_presence_adu_q_1==3
replace PartnerW2=0 if maritalstatus_current_adu_q_1==3 | maritalstatus_current_adu_q_1==4 | maritalstatus_current_adu_q_1==5 | maritalstatus_current_adu_q_1==6 | partner_presence_adu_q_1==4 | partner_presence_adu_q_1==5
replace PartnerW2=. if  maritalstatus_current_adu_q_1==99 | maritalstatus_current_adu_q_1==999 | partner_presence_adu_q_1==99 | partner_presence_adu_q_1==999
label def PartnerW2 0"Single/Divorced" 1"Married/Partnered", modify
label val PartnerW2 PartnerW2
label var PartnerW2 "Partner Status at Wave 2"

drop maritalstatus_current_adu_q_1 partner_presence_adu_q_1

gen HealthW2 = rand_generalhealth_adu_q_01
recode HealthW2 1=5 2=4 3=3 4=2 5=1 99=. 999=.
label def HealthW2 1"Poor" 2"Mediocre" 3"Good" 4"Very good" 5"Excellent", modify
label val HealthW2 HealthW2

drop ZIP_CODE jobcode* jobname* smoking* rand_generalhealth_adu_q_01 employment_stopped_adu_q_1_b employment_stopped_adu_q_1_c employment_stopped_adu_q_1_d maritalstatus_current_adu_q_1_a rand_generalhealth_adu_q_02

save "G:\OV20_0544\EXPORT\DATASETS\CLEANING_1B_070721.dta", replace

********************
***WAVE 3**************
*******
use "G:\OV20_0544\EXPORT\DATASETS\1C_ABC.RED.dta", clear

gen W3=1
order W3, after (Gender)
rename AGE Age_W3

foreach var of varlist employment_situation*{
recode `var' 999=. 99=.
}
**Employment status**
gen Unemployment_W3=1 if employment_situation_adu_q_1_f==1 | employment_situation_adu_q_1_h==1
replace Unemployment_W3=0 if Unemployment_W3==.
replace Unemployment_W3=. if employment_situation_adu_q_1_f==. & employment_situation_adu_q_1_g==. & employment_situation_adu_q_1_h==. & employment_situation_adu_q_1_i==. & employment_situation_adu_q_1_j==. & employment_situation_adu_q_1_k==. & employment_situation_adu_q_1_l==. & employment_situation_adu_q_1_m==.    

*Mean duration of unemployment
gen DurationUnempW3 = unemployment_current_adu_q_1
recode DurationUnempW3 1=3 2=9 3=24 4=39 99=. 999=.
label var DurationUnempW3 "Mean duration of unemployment (months). Wave 2"

*Long-term unemployment 
gen LTUnempW3 = DurationUnempW3
recode LTUnempW3 1=0 2=1 3=1 4=1 
replace LTUnempW3=. if (unemployment_current_adu_q_1==. & Unemployment_W3==1)
label var LTUnempW3 "Long-term unemployment (>6months). Wave 2"

*Unemployment Categorical
gen UnempW3_cat=0 if Unemployment_W3==0
replace UnempW3_cat=1 if DurationUnempW3==3
replace UnempW3_cat=2 if DurationUnempW3==9 | DurationUnempW3==24 | DurationUnempW3==39
replace UnempW3_cat=. if Unemployment_W3==1 & DurationUnempW3==.
label def UnempW3_cat 0"Employed" 1"Short-term unemployed" 2"Long-term unemployed", modify
label val UnempW3_cat UnempW3_cat
label var UnempW3_cat "Unemployment categorical. Wave 2"

recode workweek_hours_adu_q_1 999=.
gen Work_W3= workweek_hours_adu_q_1
recode Work_W3 (1/32=1) (32/max=2) 
replace Work_W3=. if workweek_hours_adu_q_1==.
replace Work_W3=0 if Unemployment_W3==1
label def Work_W3 0"Unemployed" 1"Part-time" 2"Full-time job", modify
label val Work_W3 Work_W3 
label var Work_W3 "Working Status at Wave 3"

rename employment_current_adu_q_1 employment_current_W3
rename employment_situation_adu_q_1_f employment_situation_W3
rename employment_situation_W3 employment_unemployed_W3
rename employment_situation_adu_q_1_g employment_unfit_W3
rename employment_situation_adu_q_1_h employment_benefits_W3
rename employment_situation_adu_q_1_i employment_housewife_W3
rename employment_situation_adu_q_1_j employment_student_W3
rename employment_situation_adu_q_1_k employment_retired_W3
rename employment_situation_adu_q_1_l employment_early_W3
rename employment_situation_adu_q_1_m employment_none_W3
rename unemployment_current_adu_q_1 unemployment_durationW3
rename workweek_hours_adu_q_1 workweek_hoursW3

*******************************************
gen PartnerW3=1 if partner_presence_adu_q_1==1 | partner_presence_adu_q_1==2 | partner_presence_adu_q_1==3
replace PartnerW3=0 if partner_presence_adu_q_1==4 | partner_presence_adu_q_1==5
replace PartnerW3=. if  partner_presence_adu_q_1==99 | partner_presence_adu_q_1==999
label def PartnerW3 0"Single/Divorced" 1"Married/Partnered", modify
label val PartnerW3 PartnerW3
label var PartnerW3 "Partner Status at Wave 2"

drop partner_presence_adu_q_1

gen HealthW3 = rand_generalhealth_adu_q_01
recode HealthW3 1=5 2=4 3=3 4=2 5=1 99=. 999=.
label def HealthW3 1"Poor" 2"Mediocre" 3"Good" 4"Very good" 5"Excellent", modify
label val HealthW3 HealthW3

drop rand_generalhealth_adu_q_01 ZIP* jobcode* smoking* employment_stopped_adu_q_1_b employment_stopped_adu_q_1_c employment_stopped_adu_q_1_d partner_presence_adu_q_1_a rand_generalhealth_adu_q_02

 save "G:\OV20_0544\EXPORT\DATASETS\CLEANING_1C_070721.dta", replace

 
 ****************************
 ****WAVE 4****************
 *******
 use "G:\OV20_0544\EXPORT\DATASETS\2A_MergedQ1Q2.1dta", clear

rename Gender GenderW4
rename DATE DateW4

gen EAW4 = degree_highest_adu_q_1
recode EAW4 1=1 2=1 3=1 4=1 5=2 6=2 7=3 8=3 9=. 99=.
label def EAW4 1"Low" 2"Middle" 3"High", modify
label val EAW4 EAW4 
replace EAW4=educational_attainment_adu_c_1 if degree_highest_adu_q_1==.
label def EAW4 1"Low" 2"Middle" 3"High", modify
label val EAW4 EAW4
rename degree_highest_adu_q_1 EducationW4
recode EducationW4 99=. 
drop educational_attainment_adu_c_1
drop partner_presence_adu_q_1_a


foreach var of varlist employment_situation*{
recode `var' 999=. 99=.
}
***EMployment status**
gen Unemployment_W4=1 if employment_situation_adu_q_1_f==1 | employment_situation_adu_q_1_h==1
replace Unemployment_W4=0 if Unemployment_W4==.
replace Unemployment_W4=. if employment_situation_adu_q_1_f==. & employment_situation_adu_q_1_g==. & employment_situation_adu_q_1_h==. & employment_situation_adu_q_1_i==. & employment_situation_adu_q_1_j==. & employment_situation_adu_q_1_k==. & employment_situation_adu_q_1_l==. & employment_situation_adu_q_1_m==.    

 *Mean duration of unemployment
gen DurationUnempW4 = unemployment_current_adu_q_1
recode DurationUnempW4 1=3 2=9 3=24 4=39 99=. 999=.
label var DurationUnempW4 "Mean duration of unemployment (months). Wave 4"

*Long-term unemployment 
gen LTUnempW4 = DurationUnempW4
recode LTUnempW4 1=0 2=1 3=1 4=1 
replace LTUnempW4=. if (unemployment_current_adu_q_1==. & Unemployment_W4==1)
label var LTUnempW4 "Long-term unemployment (>6months). Wave 4"

*Unemployment Categorical
gen UnempW4_cat=0 if Unemployment_W4==0
replace UnempW4_cat=1 if DurationUnempW4==3
replace UnempW4_cat=2 if DurationUnempW4==9 | DurationUnempW4==24 | DurationUnempW4==39
replace UnempW4_cat=. if Unemployment_W4==1 & DurationUnempW4==.
label def UnempW4_cat 0"Employed" 1"Short-term unemployed" 2"Long-term unemployed", modify
label val UnempW4_cat UnempW4_cat
label var UnempW4_cat "Unemployment categorical. Wave 4"

recode workweek_hours_adu_q_1 999=.
gen Work_W4= workweek_hours_adu_q_1
recode Work_W4 (1/32=1) (32/max=2) 
replace Work_W4=. if workweek_hours_adu_q_1==.
replace Work_W4=0 if Unemployment_W4==1
label def Work_W4 0"Unemployed" 1"Part-time" 2"Full-time job", modify
label val Work_W4 Work_W4 
label var Work_W4 "Working Status at Wave 4"

rename employment_current_adu_q_1 employment_current_W4
rename employment_situation_adu_q_1_f employment_situation_W4
rename employment_situation_W4 employment_unemployed_W4
rename employment_situation_adu_q_1_g employment_unfit_W4
rename employment_situation_adu_q_1_h employment_benefits_W4
rename employment_situation_adu_q_1_i employment_housewife_W4
rename employment_situation_adu_q_1_j employment_student_W4
rename employment_situation_adu_q_1_k employment_retired_W4
rename employment_situation_adu_q_1_l employment_early_W4
rename employment_situation_adu_q_1_m employment_none_W4
rename unemployment_current_adu_q_1 unemployment_duration_W4
rename workweek_days_adu_q_1 workweek_days_W4
rename workweek_hours_adu_q_1 workweek_hours_W4

*************************

foreach var of varlist ffqh_alcohol_adu*{
recode `var' 999=. 99=.
}
**ALCOHOL Frequency: 1 day/month= 1/30; 2-3 days/month= 1.5/30, etc. 
gen Alc_FrequencyW4=ffqh_alcohol_adu_q_27 
recode Alc_FrequencyW4 (1=0) (2=0.03) (3=0.083) (4=0.14) (5=0.36) (6=0.64) (7=0.93)

**ALCOHOL Quantity
gen Alcohol_QuantW4 = ffqh_alcohol_adu_q_27_a 
replace Alcohol_QuantW4=0 if Alc_FrequencyW4==0

*GLASSES X DAY
gen GLASSDAYW4 = Alc_FrequencyW4 * Alcohol_QuantW4
replace GLASSDAYW4=0 if Alc_FrequencyW4==0

*Alcohol categorical
gen Alcohol_catW4=0 if GLASSDAYW4==0
replace Alcohol_catW4=1 if GLASSDAYW4>0.01 & GLASSDAYW4<1.5
replace Alcohol_catW4=2 if GLASSDAYW4>1.5
replace Alcohol_catW4=. if GLASSDAYW4==.
label def Alcohol_catW4 0"Abstainer" 1"Moderate" 2"Heavy Drinker", modify
label val Alcohol_catW4 Alcohol_catW4
label var Alcohol_catW4 "Alcohol at wave 4. Categorical" 

*HD dummy
gen HDW4=1 if GLASSDAYW4>1.5
replace HDW4=0 if HDW4==.
replace HDW4=. if GLASSDAYW4==.

*Binge Drinking dummy
gen BDW4=1 if ( ffqh_alcohol_adu_q_27>1 & Alcohol_QuantW4>4 & Gender==0) | (ffqh_alcohol_adu_q_27>1 & Alcohol_QuantW4>3 & Gender==1)
replace BDW4=0 if BDW4==.
replace BDW4=. if GLASSDAYW4==.

*BD categorical
gen BDcatW4=2 if BDW4==1
replace BDcatW4=0 if GLASSDAYW4==0 
replace BDcatW4=1 if BDcatW4==.
replace BDcatW4=. if BDW4==.
replace BDcatW4=2 if BDW4==1
label def BDcatW4 0"Abstainer" 1"Moderate" 2"Binge Drinking", modify
label val BDcatW4 BDcatW4 
label var BDcatW4 "Binge Drinking at Wave 4, categorical"


*************************************************
gen PartnerW4=1 if partner_presence_adu_q_1==1 | partner_presence_adu_q_1==2 | partner_presence_adu_q_1==3 
replace PartnerW4=0 if PartnerW4==.
replace PartnerW4=. if (partner_presence_adu_q_1==999 | partner_presence_adu_q_1==.) 
label def PartnerW4 0"Single/Divorced" 1"Married/Partnered", modify
label val PartnerW4 PartnerW4
label var PartnerW4 "Partner Status at Wave 4"

gen MaritalW4=1 if partner_presence_adu_q_1==1 | partner_presence_adu_q_1==2 | partner_presence_adu_q_1==3 | inhouse_partner_adu_q_1==1
replace MaritalW4=0 if MaritalW4==.
replace MaritalW4=. if (partner_presence_adu_q_1==999 | partner_presence_adu_q_1==.) & (inhouse_partner_adu_q_1==99 | inhouse_partner_adu_q_1==.)
label def MaritalW4 0"Single/Divorced" 1"Married/Partnered", modify
label val MaritalW4 MaritalW4
label var MaritalW4 "Partner status at Wave 4 (add-on variation)"
drop partner_presence_adu_q_1

gen HealthW4 = rand_generalhealth_adu_q_01
recode HealthW4 1=5 2=4 3=3 4=2 5=1 99=. 999=.
label def HealthW4 1"Poor" 2"Mediocre" 3"Good" 4"Very good" 5"Excellent", modify
label val HealthW4 HealthW4

drop jobcode* jobname* smoking* eq5d* rand_generalhealth_adu_q_01 rand_generalhealth_adu_q_02 ffqh_alcohol_adu_q_27- ffqh_alcohol_adu_q_35 unemployment_current_adu_q_1_a
drop heroine_frequency_adu_q_1- otherdrugs_startage_adu_q_1 xtc_frequency_adu_q_1 xtc_lifetime_adu_q_1 xtc_pastyear_adu_q_1 xtc_startage_adu_q_1 amphetamines_frequency_adu_q_1- druguse_lifetime_adu_q_1

save "G:\OV20_0544\EXPORT\DATASETS\CLEANING_2A_070721.dta", replace
 
 *********************
 ****WAVE 5*********
 ******
use "G:\OV20_0544\EXPORT\DATASETS\2B.RED.dta", clear

merge 1:1 PROJECT_PSEUDO_ID using "G:\OV20_0544\EXPORT\DATASETS\Linkage_Old_New_Data.dta", nogenerate

order PSEUDOIDEXT, after(PROJECT_PSEUDO_ID)
encode GENDER, generate (GenderW5)
recode GenderW5 2=0
label def GenderW5 0"Male" 1"Female", modify
label val GenderW5 GenderW5 
order GenderW5, after(VARIANT_ID)
drop GENDER
drop if GenderW5==.
  
gen W5=1
order W5, after (GenderW5)
rename DATE Date_W5
rename AGE Age_W5

foreach var of varlist employment_situation*{
recode `var' 999=. 99=.
}

**EMployment status
gen Unemployment_W5=1 if employment_situation_adu_q_1_n==1 | employment_situation_adu_q_1_h==1
replace Unemployment_W5=0 if Unemployment_W5==.
replace Unemployment_W5=. if employment_situation_adu_q_1_g==. & employment_situation_adu_q_1_h==. & employment_situation_adu_q_1_i==. & employment_situation_adu_q_1_j==. & employment_situation_adu_q_1_k==. & employment_situation_adu_q_1_l==. & employment_situation_adu_q_1_m==. & employment_situation_adu_q_1_n==.  

*Mean duration of unemployment
gen DurationUnempW5 = unemployment_current_adu_q_1
recode DurationUnempW5 1=3 2=9 3=24 4=39
label var DurationUnempW5 "Mean duration of unemployment (months). Wave 5"

*Long-term unemployment 
gen LTUnempW5 = DurationUnempW5
recode LTUnempW5 1=0 2=1 3=1 4=1 
replace LTUnempW5=. if (unemployment_current_adu_q_1==. & Unemployment_W5==1)
label var LTUnempW5 "Long-term unemployment (>6months). Wave 5"

*Unemployment Categorical
gen UnempW5_cat=0 if Unemployment_W5==0
replace UnempW5_cat=1 if DurationUnempW5==3
replace UnempW5_cat=2 if DurationUnempW5==9 | DurationUnempW5==24 | DurationUnempW5==39
replace UnempW5_cat=. if Unemployment_W5==1 & DurationUnempW5==.
label def UnempW5_cat 0"Employed" 1"Short-term unemployed" 2"Long-term unemployed", modify
label val UnempW5_cat UnempW5_cat
label var UnempW5_cat "Unemployment categorical. Wave 5"


gen Work_W5= workweek_hours_adu_q_1
recode Work_W5 (1/32=1) (32/max=2) 
replace Work_W5=. if workweek_hours_adu_q_1==.
replace Work_W5=0 if Unemployment_W5==1
label def Work_W5 0"Unemployed" 1"Part-time" 2"Full-time job", modify
label val Work_W5 Work_W5
label var Work_W5 "Working Status at Wave 5"

rename unemployment_current_adu_q_1 unemployment_current_W5
rename employment_current_adu_q_1 employment_current_W5
rename employment_situation_adu_q_1_n employment_unemployed_W5
rename employment_situation_adu_q_1_g employment_unfit_W5
rename employment_situation_adu_q_1_h employment_benefits_W5
rename employment_situation_adu_q_1_i employment_housewife_W5
rename employment_situation_adu_q_1_j employment_student_W5
rename employment_situation_adu_q_1_k employment_retired_W5
rename employment_situation_adu_q_1_l employment_early_W5
rename employment_situation_adu_q_1_m employment_none_W5
rename workweek_days_adu_q_1 workweek_days_W5
rename workweek_hours_adu_q_1 workweek_hours_W5
rename degree_highest_adu_q_1 EducationW5

***************************************************************************
foreach var of varlist ffqh_alcohol_adu*{
recode `var' 999=. 99=.
}
**ALCOHOL Frequency: 1 day/month= 1/30; 2-3 days/month= 1.5/30, etc. 
gen Alc_FrequencyW5=ffqh_alcohol_adu_q_95 
recode Alc_FrequencyW5 (1=0) (2=0.03) (3=0.083) (4=0.14) (5=0.36) (6=0.64) (7=0.93)

**ALCOHOL Quantity
gen Alcohol_QuantW5 = ffqh_alcohol_adu_q_95_a 
replace Alcohol_QuantW5=0 if Alc_FrequencyW5==0

*GLASSES X DAY
gen GLASSDAYW5 = Alc_FrequencyW5 * Alcohol_QuantW5
replace GLASSDAYW5=0 if Alc_FrequencyW5==0
replace GLASSDAYW5=. if Alc_FrequencyW5==. & Alcohol_QuantW5==.

*Alcohol categorical
gen Alcohol_catW5=0 if GLASSDAYW5==0
replace Alcohol_catW5=1 if GLASSDAYW5>0.01 & GLASSDAYW5<1.5
replace Alcohol_catW5=2 if GLASSDAYW5>1.5
replace Alcohol_catW5=. if GLASSDAYW5==.
label def Alcohol_catW5 0"Abstainer" 1"Moderate" 2"Heavy Drinker", modify
label val Alcohol_catW5 Alcohol_catW5
label var Alcohol_catW5 "Alcohol at wave 5. Categorical" 

*HD dummy
gen HDW5=1 if Alcohol_catW5==2
replace HDW5=0 if HDW5==.
replace HDW5=. if GLASSDAYW5==.

*Binge Drinking dummy
gen BDW5=1 if ( ffqh_alcohol_adu_q_95>1 & Alcohol_QuantW5>4 & GenderW5==0) | (ffqh_alcohol_adu_q_95>1 & Alcohol_QuantW5>3 & GenderW5==1)
replace BDW5=0 if BDW5==.
replace BDW5=. if GLASSDAYW5==.

*BD cat
gen BDcatW5=2 if BDW5==1
replace BDcatW5=0 if GLASSDAYW5==0 
replace BDcatW5=1 if BDcatW5==.
replace BDcatW5=. if BDW5==.
replace BDcatW5=2 if BDW5==1
label def BDcatW5 0"Abstainer" 1"Moderate" 2"Binge Drinking", modify
label val BDcatW5 BDcatW5 
label var BDcatW5 "Binge Drinking at Wave 5, categorical"

************************************
gen PartnerW5=partner_presence_adu_q_1
recode PartnerW5 1=1 2=1 3=1 4=0 5=0 999=. 
label def PartnerW5 0"Single/Widow/Divorded/Other" 1"Married/Partnered/LAT", modify
label val PartnerW5 PartnerW5
label var PartnerW5 "Partner Status Wave 5"

gen HealthW5 = rand_generalhealth_adu_q_01
recode HealthW5 1=5 2=4 3=3 4=2 5=1
label def HealthW5 1"Poor" 2"Mediocre" 3"Good" 4"Very good" 5"Excellent", modify
label val HealthW5 HealthW5
label var HealthW5 "Self-rated Health at Wave 5"

gen EAW5 = EducationW5
recode EAW5 1=1 2=1 3=1 4=1 5=2 6=2 7=3 8=3 9=. 99=. 999=.
label def EAW5 1"Low" 2"Middle" 3"High", modify
label val EAW5 EAW5
label var EAW5 "Educational Level. Wave 5" 

drop income* jobcode* jobname* loneliness* smoking* ZIP* spfil* contacts*
gen VMID=20
drop amphetamines_pastyear_adu_q_1 cannabis_pastyear_adu_q_1 cocaine_pastyear_adu_q_1 degree_highest_adu_q_1_a ffqh_alcohol_adu_q_95- heroine_pastyear_adu_q_1 unemployment_current_adu_q_1_a xtc_pastyear_adu_q_1
drop mushrooms_pastyear_adu_q_1 otherdrugs_pastyear_adu_q_1 partner_presence_adu_q_1 partner_presence_adu_q_1_a rand_generalhealth_adu_q_01 rand_generalhealth_adu_q_02

save "G:\OV20_0544\EXPORT\DATASETS\CLEANING_2B_070721.dta", replace

**********************************
**MERGE**********************
**********
use "G:\OV20_0544\EXPORT\DATASETS\CLEANING_1A_070721.dta", clear

merge 1:1 PROJECT_PSEUDO_ID PSEUDOIDEXT using "G:\OV20_0544\EXPORT\DATASETS\CLEANING_1B_070721.dta", nogenerate
merge 1:1 PROJECT_PSEUDO_ID PSEUDOIDEXT using "G:\OV20_0544\EXPORT\DATASETS\CLEANING_1C_070721.dta", nogenerate
merge 1:1 PROJECT_PSEUDO_ID PSEUDOIDEXT using "G:\OV20_0544\EXPORT\DATASETS\CLEANING_2A_070721.dta", nogenerate
merge 1:1 PROJECT_PSEUDO_ID PSEUDOIDEXT using "G:\OV20_0544\EXPORT\DATASETS\CLEANING_2B_070721.dta", nogenerate

rename UnempW1_cat Unemp_catW1
rename UnempW2_cat Unemp_catW2
rename UnempW3_cat Unemp_catW3
rename UnempW4_cat Unemp_catW4 
rename UnempW5_cat Unemp_catW5

save "G:\OV20_0544\EXPORT\DATASETS\MERGED_5_WAVES_070721.dta", replace

 
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



**************************************
********************************
**************************

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


**Abstinence
gen AbstainerW1=1 if GLASSDAYW1==0
replace AbstainerW1=0 if AbstainerW1==.
replace AbstainerW1=. if GLASSDAYW1==.

gen AbstainerW4=1 if GLASSDAYW4==0
replace AbstainerW4=0 if AbstainerW4==.
replace AbstainerW4=. if GLASSDAYW4==.

gen AbstainerW5=1 if GLASSDAYW5==0
replace AbstainerW5=0 if AbstainerW5==.
replace AbstainerW5=. if GLASSDAYW5==.

sort PSEUDOIDEXT
gen pseudoidext = _n if PSEUDOIDEXT==.
replace PSEUDOIDEXT = pseudoidext if PSEUDOIDEXT==.
drop pseudoidext

rename Gender GenderW1
rename Age_W1 AgeW1
rename Unemployment_W1 UnemploymentW1           
rename Work_W1 WorkW1
rename Age_W2 AgeW2
rename Unemployment_W2 UnemploymentW2
rename Work_W2 WorkW2
rename Age_W3 AgeW3
rename Unemployment_W3 UnemploymentW3
rename Work_W3 WorkW3
rename Age_W4 AgeW4
rename Unemployment_W4 UnemploymentW4
rename Work_W4 WorkW4
rename Age_W5 AgeW5
rename Unemployment_W5 UnemploymentW5
rename Work_W5 WorkW5

*****************************************
******************************
*******PREPARE PANEL DATA**
***** 
*Reshape to long
reshape long Gender Date Year MonthsBaseline Age EA Education Unemployment DurationUnemp LTUnemp Unemp_cat Unemp2_cat Alc_Frequency Alcohol_Quant GLASSDAY Alcohol_cat Abstainer HD BD Work BDcat Health Partner Unfit Work2, i(PSEUDOIDEXT) j(wave W1 W2 W3 W4 W5)
encode wave, gen (Wave)
drop wave

drop QA1 QB2 current_smoker_adu_c_12 ever_smoker_adu_c_12 ex_smoker_adu_c_12 Monthslastinterview*


bysort PSEUDOIDEXT ( Gender ) : replace Gender = Gender[1] if missing(Gender)

**Convert into Years of Education
gen Years_Education = Education
recode Years_Education 1=5 2=6 3=9 4=10 5=12 6=12 7=15 8=16 9=. 999=.

label def Gender 0"Men" 1"Women", modify
label val Gender Gender

*New work derivatives
label def Work2 0"Employed" 1"Unemployed" 2"Unfit", modify
label val Work2 Work2

gen Work3=1 if Unemp_cat==2
replace Work3=2 if Unfit==1
replace Work3=0 if Work3==.
replace Work3=. if Unemp_cat==. & Unfit==.
label def Work3 0"Employed/Short unemp." 1"Long-term unemployed" 2"Disabled", modify
label val Work3 Work3

*Unemployed & Unfit Together
gen Work4 = Work2
recode Work4 2=1
label def Work4 0"Employed" 1"Unemployed/Unfit", modify
label val Work4 Work4

*Outcome with 4 categories
gen Work5=0 if Work2==0
replace Work5=1 if DurationUnemp==3
replace Work5=2 if DurationUnemp>3 & DurationUnemp<=39
replace Work5=3 if Unfit==1
label def Work5 0"Employed" 1"Short Unemp." 2"Long Unemp." 3"Unfit", modify
label val Work5 Work5


**Sensitivity Analyses Alcohol
*Alcohol 4 categories
gen Alc_cat=3 if BD==1
replace Alc_cat=2 if HD==1 & BD!=1
replace Alc_cat=1 if Alcohol_cat==1 & BD!=1
replace Alc_cat=0 if Abstainer==1
label def Alc_cat 0"Abstainer" 1"Moderate" 2"Heavy Drinking" 3"Binge Drinking", modify
label val Alc_cat Alc_cat

*Dummy HD without BD
gen HD2=1 if Alc_cat==2
replace HD2=0 if HD2==.
replace HD2=. if Alc_cat==.

*New temporal variables
replace MonthsBaseline=0 if Wave==1
replace MonthsBaseline=0 if MonthsBaseline<0
gen YearsBaseline = trunc(MonthsBaseline/12)
gen Age_c = Age + (MonthsBaseline/12)

*Years of Education at Baseline as time-invariant 
gen YearsEducationBaseline = Years_Education if Wave==1
bysort PSEUDOIDEXT (YearsEducationBaseline) : replace YearsEducationBaseline = YearsEducationBaseline[1] if missing(YearsEducationBaseline) 
rename Education Education_raw
rename Years_Education Education
rename YearsEducationBaseline Years_Education

*Short Unemployment dummy
 gen ShortUnemp2 = 1 if Work5==1
replace ShortUnemp2=0 if ShortUnemp2==.

*Long Unemployment dummy
gen LongUnemp2 = 1 if Work5==2
replace LongUnemp2=0 if LongUnemp2==.

*Partner with reverse ref. category
 gen Partner2 = Partner
 recode Partner2 0=1 1=0
 label def Partner2 0"Partnered" 1"Single", modify
 label val Partner2 Partner2 
 
replace MonthsBaseline=0 if Wave==1
replace Unfit=0 if Unfit==.
replace Unfit=. if Work3==.

order PROJECT_PSEUDO_ID, after (Work3)
order Wave, after(Date)

drop *W1 *W2 *W3 *W4 *W5


save "G:\OV20_0544\EXPORT\DATASETS\PANEL_pre_drop_070721.dta", replace

************************************
****LAST DROPS FOR PANEL DATA******
*Keep only 1st, 4th, 5th waves (with all indeps and dependent variable)
drop if Wave==2 | Wave==3
drop if Work5==. 
drop if BDcat==.

*DROP INDIVIDUALS WITH ONLY ONE WAVE!!! 
bys PSEUDOIDEXT: gen ID = _n
order ID, after(PSEUDOIDEXT)
bysort PSEUDOIDEXT: egen count=count(ID)
order count, after(ID)
drop if count==1

drop VARIANT* VMID inhouse_partner_adu_q_1 
recode Health 999=. 


 save "G:\OV20_0544\EXPORT\DATASETS\MERGED_2ndPAPER_PANEL_070721.dta", replace
