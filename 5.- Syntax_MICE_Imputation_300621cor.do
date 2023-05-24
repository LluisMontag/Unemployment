
*****************************************
********MULTIPLE IMPUTATION CHAINED ESTIMATION (MICE)********************

use "G:\OV20_0544\EXPORT\DATASETS\Cleaning_WIDE_020521.dta", clear

cd "G:\OV20_0544\stata packages"

net install mimrgns, replace

*1)Unemployment Dummy
mi set wide
mi register imputed Unemployment_W1 Unemployment_W2 Unemployment_W3 Unemployment_W4 Income Alcohol_cat2W4 Alcohol_cat2W1 Marital_W1 EAW1 HealthW1      
mi impute chained (logit)Unemployment_W1 Unemployment_W2 Unemployment_W3 Unemployment_W4 (truncreg, ll(500) ul(3750))Income (mlogit)Alcohol_cat2W4 (mlogit)Alcohol_cat2W1 (logit)Marital_W1 (mlogit)EAW1 (mlogit)HealthW1 = Gender Age_W1, add(50) rseed(1) force 

*2)Categorical
use "G:\OV20_0544\EXPORT\DATASETS\Clean_RED_WIDE_no_drop_AllQuest_050621.dta", clear
mi set wide
mi register imputed Unemp2W1_cat Unemp2W2_cat Unemp2W3_cat Unemp2W4_cat Income Alcohol_cat2W4 Alcohol_cat2W1 Marital_W1 EAW1 HealthW1
mi impute chained (mlogit)Unemp2W1_cat Unemp2W2_cat Unemp2W3_cat Unemp2W4_cat (truncreg, ll(500) ul(3750))Income (mlogit)Alcohol_cat2W4 Alcohol_cat2W1 (logit)Marital_W1 (mlogit)EAW1 (mlogit)HealthW1 = Gender Age_W1, add(50) rseed(1) force 

*3)Number of Unemployment Spells 
mi passive: egen UnempSpells = rowtotal(Unemployment_W1 Unemployment_W2 Unemployment_W3 Unemployment_W4)
foreach var of varlist UnempSpells _1_UnempSpells - _50_UnempSpells{
recode `var' (3=2) (4=2)
label def `var' 0"No unemployment" 1"1 Spell" 2"2+ Spells", modify
}
label val UnempSpells _1_UnempSpells - _50_UnempSpells  UnempSpells

*4)Long Unemployment Spells
mi passive: gen L1=1 if Unemp2W1_cat==2
mi passive: replace L1=0 if Unemp2W1_cat==1 | Unemp2W1_cat==0
mi passive: gen L2=1 if Unemp2W2_cat==2
mi passive: replace L2=0 if Unemp2W2_cat==1 | Unemp2W2_cat==0
mi passive: gen L3=1 if Unemp2W3_cat==2
mi passive: replace L3=0 if Unemp2W3_cat==1 | Unemp2W3_cat==0
mi passive: gen L4=1 if Unemp2W4_cat==2
mi passive: replace L4=0 if Unemp2W4_cat==1 | Unemp2W4_cat==0
mi passive: egen LongSpells = rowtotal (L1 L2 L3 L4)
foreach var of varlist LongSpells _1_LongSpells - _50_LongSpells{
recode `var' (3=2) (4=2)
label def `var' 0"No unemployment" 1"1 Long Spell" 2"2+ Long Spells", modify
}
label val LongSpells _1_LongSpells - _50_LongSpells LongSpells

*5)Unemployment Trajectories
mi passive: gen Traject=1 if Unemployment_W1==0 & Unemployment_W2==0 & Unemployment_W3==0 & Unemployment_W4==0
mi passive: replace Traject=2  if Unemployment_W1==0 & Unemployment_W2==0 & Unemployment_W3==0 & Unemployment_W4==1
mi passive: replace Traject=2  if Unemployment_W1==0 & Unemployment_W2==0 & Unemployment_W3==0 & Unemployment_W4==1
mi passive: replace Traject=3  if Unemployment_W1==0 & Unemployment_W2==0 & Unemployment_W3==1 & Unemployment_W4==1
mi passive: replace Traject=4  if Unemployment_W1==0 & Unemployment_W2==0 & Unemployment_W3==1 & Unemployment_W4==0
mi passive: replace Traject=5  if Unemployment_W1==0 & Unemployment_W2==1 & Unemployment_W3==1 & Unemployment_W4==1
mi passive: replace Traject=6  if Unemployment_W1==0 & Unemployment_W2==1 & Unemployment_W3==0 & Unemployment_W4==1
mi passive: replace Traject=7  if Unemployment_W1==0 & Unemployment_W2==1 & Unemployment_W3==1 & Unemployment_W4==0
mi passive: replace Traject=8  if Unemployment_W1==0 & Unemployment_W2==1 & Unemployment_W3==0 & Unemployment_W4==0
mi passive: replace Traject=9  if Unemployment_W1==1 & Unemployment_W2==1 & Unemployment_W3==1 & Unemployment_W4==1
mi passive: replace Traject=10 if Unemployment_W1==1 & Unemployment_W2==1 & Unemployment_W3==1 & Unemployment_W4==0
mi passive: replace Traject=11 if Unemployment_W1==1 & Unemployment_W2==1 & Unemployment_W3==0 & Unemployment_W4==0
mi passive: replace Traject=12 if Unemployment_W1==1 & Unemployment_W2==0 & Unemployment_W3==0 & Unemployment_W4==0
mi passive: replace Traject=13 if Unemployment_W1==1 & Unemployment_W2==0 & Unemployment_W3==1 & Unemployment_W4==0
mi passive: replace Traject=14 if Unemployment_W1==1 & Unemployment_W2==0 & Unemployment_W3==0 & Unemployment_W4==1
mi passive: replace Traject=15 if Unemployment_W1==1 & Unemployment_W2==0 & Unemployment_W3==1 & Unemployment_W4==1
mi passive: replace Traject=16 if Unemployment_W1==1 & Unemployment_W2==1 & Unemployment_W3==0 & Unemployment_W4==1
mi passive: replace Traject=. if Unemployment_W1==. & Unemployment_W2==. & Unemployment_W3==. & Unemployment_W4==.
foreach var of varlist Traject _1_Traject - _50_Traject{
recode `var' (1=0) (10=1) (11=1) (12=1) (2=2) (3=2) (5=2) (9=3) (4=4) (6=4) (7=4) (8=4) (13=4) (14=4) (15=4) (16=4)
label def `var' 0"Continuously Employed" 1"Upward Trajectory" 2"Downward Trajectory" 3"Chronic Unemployment" 4"Intermitent spells", modify
}
label val Traject _1_Traject - _50_Traject Traject

*6) Total duration of unemployment
mi set wide
mi register imputed DurationTotal2_cat Income Alcohol_cat2W4 Alcohol_cat2W1 Marital_W1 EAW1 HealthW1  
mi impute chained (mlogit)DurationTotal2_cat (truncreg, ll(500) ul(3750))Income (mlogit)Alcohol_cat2W4 Alcohol_cat2W1 (logit)Marital_W1 (mlogit)EAW1 (mlogit)HealthW1 = Gender Age_W1, add(50) rseed(1) force 


******Models
mi estimate, rrr: mlogit Alcohol_cat2W4 i.Unemp2W4_cat i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.Alcohol_cat2W1, base(1) 
mi estimate, rrr: mlogit HEDcat2W4 i.Unemp2W4_cat i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.HEDcat2W1, base(1)


save "G:\OV20_0544\EXPORT\DATASETS\Clean_wide_IMPUTED_150621.dta"



