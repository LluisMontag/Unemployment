use "G:\OV20_0544\EXPORT\DATASETS\WAVE_1to4_Merged.CORRECT150520.dta", clear

*Load stata packages
cd "G:\OV20_0544\stata packages"

**Fill Empty Cells Age  
gen Age_Baseline = AGE_1A1
bysort PSEUDOIDEXT ( Age_Baseline ) : replace Age_Baseline = Age_Baseline[1] if missing(Age_Baseline)
order Age_Baseline , before( AGE_1A1 )

**Drop older than 50
drop if Age_Baseline > 50
drop AGE_1A1

**Participants at each wave 
gen W1=1 if VMID==1 | VMID==2
replace W1=0 if W1==. 
gen W2=1 if VMID==6 
replace W2=0 if W2==. 
gen W3=1 if VMID==7 
replace W3=0 if W3==. 
gen W4=1 if VMID==10 | VMID==11
replace W4=0 if W4==. 
label var W1"Wave 1"
label var W2"Wave 2"
label var W3"Wave 3"
label var W4"Wave 4"

**Dummies per Questionnaire
gen Q1_1=1 if VMID==1
gen Q1_2=1 if VMID==2
gen Q2=1 if VMID==6
gen Q3=1 if VMID==7
gen Q4_1=1 if VMID==10
gen Q4_2=1 if VMID==11
label var Q1_1 "Wave 1, 1st Questionnaire"
label var Q1_2 "Wave 1, 2nd Questionnaire"
label var Q2 "Wave 2"
label var Q3 "Wave 3"
label var Q4_1 "Wave 4, 1st Questionnaire"
label var Q4_2 "Wave 4, 2nd Questionnaire"


*Recode & fill empty cells for Gender
recode GESLACHT 1=0 2=1
label def GESLACHT 0"Male" 1"Female", modify
label val GESLACHT GESLACHT
rename GESLACHT Gender
bysort PSEUDOIDEXT ( Gender ) : replace Gender = Gender[1] if missing(Gender)

*Partner status at baseline
gen Marital_W1=1 if DEMO7==1 | DEMO7==2 | DEMO7==7 | DEMO7C==1 | DEMO7C==2 |  DEMO7C==3 | DEMO12A1==1
replace Marital_W1=0 if Marital_W1==.
replace Marital_W1=. if (DEMO7==. & DEMO7C==. & DEMO12A1==. & DEMO12A8==.) & VMID==1
label def Marital_W1 0"Single/Divorded/Other" 1"Married/Partnered", modify
label val Marital_W1 Marital_W1
label var Marital_W1 "Partner Status, Baseline"


***********************************************
**************ALCOHOL MEASUREMENTS*************
**********************************************

**BASELINE: 
***Identify early participants recruited before 2009***
gen Early=1 if (FOOD29!=. | FOOD30!=.| FOOD31!=.| FOOD33!=. | FOOD34!=. | FOOD28A!=. | FOOD28B!=. | FOOD28C!=.)
replace Early=0 if Early==.
label var Early "Early participants before 2009"
order Early, after( INT_1A1_2A1)
*BEER
label var FOOD28A "How often, a can of Beer?"
label var FOOD28B "How often, a bottle/pint of Beer?"
label var FOOD28C "How often, a glass of beer?"
*Average number of beers/day for early participants
gen FOOD_29 = FOOD29
recode FOOD_29 1=1.5 2=3.5 3=5.5 4=7.5 5=9.5 6=12 7=12 8=12
label var FOOD_29 "On the days you drank beer, how many? (early participants)" 
**Frequency: 1 day/month= 1/30; 2-3 days/month= 1.5/30, etc. 
gen Alc_FrequencyW1=FOOD27 
recode Alc_FrequencyW1 (1=0) (2=0.03) (3=0.083) (4=0.14) (5=0.36) (6=0.64) (7=0.93)
**Abstainers
replace FOOD_29=0 if Alc_FrequencyW1==0 & Early==1
gen Alcohol_QuantW1 = FOOD27A 
replace Alcohol_QuantW1=0 if Alc_FrequencyW1==0
*WINE & LIQUOR
gen Wine_FrequencyW1 = FOOD30
recode Wine_FrequencyW1 (1=0) (2=0.03) (3=0.083) (4=0.14) (5=0.36) (6=0.64) (7=0.93)
replace FOOD31=0 if Wine_FrequencyW1==0 
gen LiquorFrequencyW1 = FOOD33 
recode LiquorFrequencyW1 (1=0) (2=0.03) (3=0.083) (4=0.14) (5=0.36) (6=0.64) (7=0.93)
replace FOOD34=0 if LiquorFrequencyW1==0 

**********************
**Calculate number of Glasses x Day 
*Early participants
gen Beer_GlassxDay=FOOD_29 * Alc_FrequencyW1
replace Beer_GlassxDay=0 if FOOD_29==0 
replace Beer_GlassxDay=. if Early==0
gen Wine_GlassxDay = FOOD31 * Wine_FrequencyW1
replace Wine_GlassxDay=0 if FOOD31==0
replace Wine_GlassxDay=. if Early==0
gen Liquor_GlassxDay= FOOD34 * LiquorFrequencyW1
replace Liquor_GlassxDay=0 if FOOD34==0  
replace Liquor_GlassxDay=. if Early==0
gen Alcohol_GlassxDay= Beer_GlassxDay + Wine_GlassxDay  + Liquor_GlassxDay
replace Alcohol_GlassxDay=. if (Beer_GlassxDay==. & Wine_GlassxDay==. &  Liquor_GlassxDay==.)
****Rest of the Sample **********
gen Alc_GlassxDayW1 = Alc_FrequencyW1 * Alcohol_QuantW1
replace Alc_GlassxDayW1=0 if Alc_FrequencyW1==0
replace Alc_GlassxDayW1=. if Early==1
**Unify Both
egen GLASSDAYW1 = rowtotal (Alcohol_GlassxDay Alc_GlassxDayW1)
replace GLASSDAYW1=. if Alcohol_QuantW1==. & (FOOD_29==. & FOOD30==. & FOOD34==.)

****************************
***WAVE 4: It does not specify different types of drinks so syntax is much more simple:
****************************
rename FOOD27A_W4 Alcohol_QuantW4
gen Alc_FrequencyW4=FOOD27_W4
recode Alc_FrequencyW4 (1=0) (2=0.03) (3=0.083) (4=0.14) (5=0.36) (6=0.64) (7=0.93)
replace Alcohol_QuantW4=0 if Alc_FrequencyW4==0
**Wave 4
gen GLASSDAYW4 = Alc_FrequencyW4 * Alcohol_QuantW4
replace GLASSDAYW4=0 if Alc_FrequencyW4==0


********************************
**BINGE DRINKING: >5 drinks/occasion for men, >4 for women once a month 
**Baseline:
gen HED2W1=1 if (Early==0 & FOOD27>1 & FOOD27!=. & Alcohol_QuantW1>4 & Gender==0) | (Early==0 & FOOD27>1 & FOOD27!=. & Alcohol_QuantW1>3 & Gender==1)
replace HED2W1=0 if HED2W1==.
replace HED2W1=1 if (Early==1 & FOOD29>2 & FOOD29!=. & Alc_FrequencyW1>0.01 & Gender==0) | (Early==1 & FOOD29>1 & FOOD29!=. & Alc_FrequencyW1>0.01 & Gender==1) 
replace HED2W1=1 if (Early==1 & FOOD31>4 & FOOD31!=. & Alc_FrequencyW1>0.01 & Gender==0)| (Early==1 & FOOD31>3 & FOOD31!=. & Alc_FrequencyW1>0.01 & Gender==1)
replace HED2W1=1 if (Early==1 & FOOD34>4 & FOOD34!=. & Alc_FrequencyW1>0.01 & Gender==0)| (Early==1 & FOOD34>3 & FOOD34!=. & Alc_FrequencyW1>0.01 & Gender==1)
replace HED2W1=. if FOOD27==. & Alcohol_QuantW1==. & FOOD_29==. & FOOD31==. & FOOD34==.
**Wave 4:
gen HED2W4=1 if (FOOD27_W4>1 & Alcohol_QuantW4>4 & Gender==0) | (FOOD27_W4>1 & Alcohol_QuantW4>3 & Gender==1)
replace HED2W4=0 if HED2W4==.
replace HED2W4=. if FOOD27_W4==. & Alcohol_QuantW4==.

**Binge Drinking categorical
gen HEDcat2W1=2 if HED2W1==1
replace HEDcat2W1=0 if GLASSDAYW1==0 
replace HEDcat2W1=1 if HEDcat2W1==.
replace HEDcat2W1=. if HED2W1==.
replace HEDcat2W1=2 if HED2W1==1
label def HEDcat2W1 0"Abstainer" 1"Drinker non-HED" 2"Heavy Episodic Drinking", modify
label val HEDcat2W1 HEDcat2W1 
label var HEDcat2W1 "Heavy Episodic Drinking at Baseline, categorical"

gen HEDcat2W4=2 if HED2W4==1
replace HEDcat2W4=0 if GLASSDAYW4==0
replace HEDcat2W4=1 if HEDcat2W4==.
replace HEDcat2W4=. if HED2W4==.
label def HEDcat2W4 0"Abstainer" 1"Drinker non-HED" 2"Heavy Episodic Drinking", modify
label val HEDcat2W4 HEDcat2W4 
label var HEDcat2W4 "Heavy Episodic Drinking at wave 4, categorical"

***HEAVY DRINKING according to Dutch Nutritional Guidelines (> 1.5 glasses/day)
gen HD2_W1=1 if GLASSDAYW1 > 1.5
replace HD2_W1=0 if HD2_W1==.
replace HD2_W1=. if GLASSDAYW1==.
label var HD2_W1 "Heavy Drinking (> 1.5 glasses/day)"

gen HD2_W4=1 if GLASSDAYW4 > 1.5
replace HD2_W4=0 if HD2_W4==.
replace HD2_W4=. if GLASSDAYW4==.
label var HD2_W4 "Heavy Drinking (> 1.5 glasses/day)"

***Heavy Drinking categorical*** 
gen Alcohol_cat2W1=GLASSDAYW1
recode Alcohol_cat2W1 (0=0) (0.00001/1.5=1) (1.5/max=2) (.=.)
label def Alcohol_cat2W1 0"No alcohol" 1"Moderate Drinking" 2"Hazardous Drinking", modify
label val Alcohol_cat2W1 Alcohol_cat2W1
label var Alcohol_cat2W1 "Alcohol at Baseline categorical (Glasses/Day)"

gen Alcohol_cat2W4= GLASSDAYW4
recode Alcohol_cat2W4 (0=0) (0.00001/1.5=1) (1.5/max=2) (.=.)
label def Alcohol_cat2W4 0"No alcohol" 1"Moderate Drinking" 2"Hazardous Drinking", modify
label val Alcohol_cat2W4 Alcohol_cat2W4
label var Alcohol_cat2W4 "Alcohol at 4th Wave categorical (Glasses/Day)"

****************************************************
*****************************************************
*****************************************************
****************** UNEMPLOYMENT *********************
**Unemployment 1st WAVE (first generate "infowork" to identify those with no information on employment status)
gen Infoworkw1=1 if (WORK_2C!=. | WORK2C!=. | WORK2C1!=. | WORK2C2!=. | WORK2C3!=. | WORK2C4!=. | WORK2C6!=. | WORK2C7!=. | WORK2C8!=. | WORK2C9!=. | WORK2C10!=. | WORK2C11!=. | WORK2C12!=.) 
gen Unemployment_W1=1 if WORK_2C==3| WORK_2C==5| WORK2C==6 | WORK2C==8 | WORK2C6==1 |  WORK2C8==1 
replace Unemployment_W1=0 if Unemployment_W1==.
replace Unemployment_W1=. if (Unemployment_W1==0 & VMID!=1 & Infoworkw1!=1)
label def Unemployment_W1 0"No" 1"Yes", modify
label val Unemployment_W1 Unemployment_W1
label var Unemployment_W1 "Are you unemployed"
***2nd WAVE 
gen Infoworkw2=1 if (WORK2C6_W2!=. | WORK2C7_W2!=. | WORK2C8_W2!=. | WORK2C9_W2!=. | WORK2C10_W2!=. | WORK2C11_W2!=. | WORK2C12_W2!=. | WORK11_W2!=.)
gen Unemployment_W2=1 if WORK2C6_W2==1| WORK2C8_W2==1
replace Unemployment_W2=0 if Unemployment_W2==.
replace Unemployment_W2=. if (Unemployment_W2==0 & VMID!=6 & Infoworkw2!=1)
label def Unemployment_W2 0"No" 1"Yes", modify
label val Unemployment_W2 Unemployment_W2
label var Unemployment_W2 "Are you unemployed. Wave 2"
*3rd WAVE
gen Infoworkw3=1 if (WORK11_W3!=. | WORK2C_W3!=. | WORK2C6_W3!=. | WORK2C7_W3!=. | WORK2C8_W3!=. | WORK2C9_W3!=. | WORK2C10_W3!=. | WORK2C11_W3!=. | WORK2C12_W3!=.)
gen Unemployment_W3=1 if WORK2C6_W3==1| WORK2C8_W3==1
replace Unemployment_W3=0 if Unemployment_W3==.
replace Unemployment_W3=. if (Unemployment_W3==0 & VMID!=7 & Infoworkw3!=1)
label def Unemployment_W3 0"No" 1"Yes", modify
label val Unemployment_W3 Unemployment_W3
label var Unemployment_W3 "Are you unemployed. Wave 3"
*WAVE 4
gen Infoworkw4=1 if (WORK11_W4!=. | WORK2A2_W4!=. | WORK2C10_W4!=. | WORK2C11_W4!=. | WORK2C12_W4!=. | WORK2C6_W4!=. | WORK2C7_W4!=. | WORK2C8_W4!=. | WORK2C9_W4!=.)
gen Unemployment_W4=1 if WORK2C6_W4==1| WORK2C8_W4==1
replace Unemployment_W4=0 if Unemployment_W4==.
replace Unemployment_W4=. if (Unemployment_W4==0 & VMID!=10 & Infoworkw4!=1)
label def Unemployment_W4 0"No" 1"Yes", modify
label val Unemployment_W4 Unemployment_W4
label var Unemployment_W4 "Are you unemployed. Wave 4"


***Unemployment Trajectories
gen Unemployment_Traject=1 if Unemployment_W1==0 & Unemployment_W2==0 & Unemployment_W3==0 & Unemployment_W4==0
replace Unemployment_Traject=2  if Unemployment_W1==0 & Unemployment_W2==0 & Unemployment_W3==0 & Unemployment_W4==1
replace Unemployment_Traject=3  if Unemployment_W1==0 & Unemployment_W2==0 & Unemployment_W3==1 & Unemployment_W4==1
replace Unemployment_Traject=4  if Unemployment_W1==0 & Unemployment_W2==0 & Unemployment_W3==1 & Unemployment_W4==0
replace Unemployment_Traject=5  if Unemployment_W1==0 & Unemployment_W2==1 & Unemployment_W3==1 & Unemployment_W4==1
replace Unemployment_Traject=6  if Unemployment_W1==0 & Unemployment_W2==1 & Unemployment_W3==0 & Unemployment_W4==1
replace Unemployment_Traject=7  if Unemployment_W1==0 & Unemployment_W2==1 & Unemployment_W3==1 & Unemployment_W4==0
replace Unemployment_Traject=8  if Unemployment_W1==0 & Unemployment_W2==1 & Unemployment_W3==0 & Unemployment_W4==0
replace Unemployment_Traject=9  if Unemployment_W1==1 & Unemployment_W2==1 & Unemployment_W3==1 & Unemployment_W4==1
replace Unemployment_Traject=10 if Unemployment_W1==1 & Unemployment_W2==1 & Unemployment_W3==1 & Unemployment_W4==0
replace Unemployment_Traject=11 if Unemployment_W1==1 & Unemployment_W2==1 & Unemployment_W3==0 & Unemployment_W4==0
replace Unemployment_Traject=12 if Unemployment_W1==1 & Unemployment_W2==0 & Unemployment_W3==0 & Unemployment_W4==0
replace Unemployment_Traject=13 if Unemployment_W1==1 & Unemployment_W2==0 & Unemployment_W3==1 & Unemployment_W4==0
replace Unemployment_Traject=14 if Unemployment_W1==1 & Unemployment_W2==0 & Unemployment_W3==0 & Unemployment_W4==1
replace Unemployment_Traject=15 if Unemployment_W1==1 & Unemployment_W2==0 & Unemployment_W3==1 & Unemployment_W4==1
replace Unemployment_Traject=16 if Unemployment_W1==1 & Unemployment_W2==1 & Unemployment_W3==0 & Unemployment_W4==1
label def Unemployment_Traject 1"0000" 2"0001" 3"0011" 4"0010" 5"0111" 6"0101" 7"0110" 8"0100" 9"1111" 10"1110" 11"1100" 12"1000" 13"1010" 14"1001" 15" 1011" 16"1101", modify
label val Unemployment_Traject Unemployment_Traject

gen Trajectories=Unemployment_Traject
recode Trajectories 1=0 10=1 11=1 12=1 2=2 3=2 5=2 9=3 4=4 6=4 7=4 8=4 13=4 14=4 15=4 16=4
label def Trajectories 0"Continuously Employed" 1"Upward Trajectory" 2"Downward Trajectory" 3"Chronic Unemployment" 4"Intermitent spells", replace
label val Trajectories Trajectories
label var Trajectories "Unemployment Trajectories"

**Number of unemployment spells
gen Unemp_spells=Unemployment_Traject
recode Unemp_spells 1=0 2=1 3=2 4=1 5=3 6=2 7=2 8=1 9=4 10=3 11=2 12=1 13=2 14=2 15=3 16=3
label var Unemp_spells "Number of unemployment spells"
*Categorical
gen Unempspells_cat = Unemp_spells
recode Unempspells_cat 0=0 1=1 2=2 3=2 4=2
label def Unempspells_cat 0"No unemployment" 1"1 spell" 2"2 or more spells", modify
label val Unempspells_cat Unempspells_cat
label var Unempspells_cat "Number of unemployment spells. Categorical"

*Number of LONG Unemployment spells
gen LTU2W1= WORK2D
replace LTU2W1=. if Unemployment_W1==0
recode LTU2W1 1=0 2=1 3=1 4=1 
replace LTU2W1=0 if LTU2W1==.
replace LTU2W1=. if Unemployment_W1==. & WORK2D==.
gen LTU2W2= WORK2D_W2
replace LTU2W2=. if Unemployment_W2==0 
recode LTU2W2 1=0 2=1 3=1 4=1
replace LTU2W2=0 if LTU2W2==.
replace LTU2W2=. if Unemployment_W2==. & WORK2D_W2==.
gen LTU2W3= WORK2D_W3
replace LTU2W3=. if Unemployment_W3==0
recode LTU2W3 1=0 2=1 3=1 4=1
replace LTU2W3=0 if LTU2W3==.
replace LTU2W3=. if Unemployment_W3==. & WORK2D_W3==.
gen LTU2W4= WORK2D_W4
replace LTU2W4=. if Unemployment_W4==0
recode LTU2W4 1=0 2=1 3=1 4=1
replace LTU2W4=0 if LTU2W4==.
replace LTU2W4=. if Unemployment_W4==. & WORK2D_W4==.

gen LongUnempSpells2=LTU2W1 + LTU2W2 + LTU2W3 + LTU2W4
*Categorical
gen LongUnempSpells2_cat = LongUnempSpells2
recode LongUnempSpells2_cat 0=0 1=1 2=2 3=2 4=2
label def LongUnempSpells2_cat 0"No long unemployment" 1"1 long spell" 2"2 or more long spells", modify
label val LongUnempSpells2_cat LongUnempSpells2_cat
label var LongUnempSpells2_cat "Number of long (>6 months) unemployment spells. Categorical"

**Mean duration of Unemployment at each wave(ONLY the unemployed)
gen Duration2W1=WORK2D
recode Duration2W1 1=3 2=9 3=24 4=39
replace Duration2W1=. if Unemployment_W1==0
replace Duration2W1=. if Unemployment_W1==.
gen Duration2W2=WORK2D_W2
recode Duration2W2 1=3 2=9 3=24 4=39
replace Duration2W2=. if Unemployment_W2==0
gen Duration2W3=WORK2D_W3
recode Duration2W3 1=3 2=9 3=24 4=39
replace Duration2W3=. if Unemployment_W3==0
gen Duration2W4=WORK2D_W4
recode Duration2W4 1=3 2=9 3=24 4=39
replace Duration2W4=. if Unemployment_W4==0

***Average TOTAL Duration in months
egen DurationTotal = rowtotal ( Duration2W1 Duration2W2 Duration2W3 Duration2W4)
replace DurationTotal=. if Unemployment_W1==. & Unemployment_W2==. &Unemployment_W3==. &Unemployment_W4==. 

*****Categorical Unemployment: Distinction between short and long unemployment
gen Unemp2W1_cat=0 if Unemployment_W1==0
replace Unemp2W1_cat=1 if Duration2W1==3
replace Unemp2W1_cat=2 if Duration2W1==9 | Duration2W1==24 | Duration2W1==39
replace Unemp2W1_cat=. if Unemployment_W1==1 & Duration2W1==.
label def Unemp2W1_cat 0"Employed" 1"Short-term unemployed" 2"Long-term unemployed", modify
label val Unemp2W1_cat Unemp2W1_cat
label var Unemp2W1_cat "Unemployment categorical. Baseline (corrected)"
 
gen Unemp2W2_cat=0 if Unemployment_W2==0
replace Unemp2W2_cat=1 if Duration2W2==3
replace Unemp2W2_cat=2 if Duration2W2==9 | Duration2W2==24 | Duration2W2==39
replace Unemp2W2_cat=. if Unemployment_W2==1 & Duration2W2==.
label def Unemp2W2_cat 0"Employed" 1"Short-term unemployed" 2"Long-term unemployed", modify
label val Unemp2W2_cat Unemp2W2_cat
label var Unemp2W2_cat "Unemployment categorical. Wave 2 (Corrected)"

gen Unemp2W3_cat=0 if Unemployment_W3==0
replace Unemp2W3_cat=1 if Duration2W3==3
replace Unemp2W3_cat=2 if Duration2W3==9 | Duration2W3==24 | Duration2W3==39
replace Unemp2W3_cat=. if Unemployment_W3==1 & Duration2W3==.
label def Unemp2W3_cat 0"Employed" 1"Short-term unemployed" 2"Long-term unemployed", modify
label val Unemp2W3_cat Unemp2W3_cat
label var Unemp2W3_cat "Unemployment categorical. Wave 3 (corrected)"

gen Unemp2W4_cat=0 if Unemployment_W4==0
replace Unemp2W4_cat=1 if Duration2W4==3
replace Unemp2W4_cat=2 if Duration2W4==9 | Duration2W4==24 | Duration2W4==39
replace Unemp2W4_cat=. if Unemployment_W4==1 & Duration2W4==.
label def Unemp2W4_cat 0"Employed" 1"Short-term unemployed" 2"Long-term unemployed", modify
label val Unemp2W4_cat Unemp2W4_cat
label var Unemp2W4_cat "Unemployment categorical. Wave 4 (corrected)"


***********************
****Reshape to WIDE***
drop CLUBS* CONTACT* INF* TIJD*
rename WORK2C WORK__2C
rename WORK2C1 WORK2C_1  
rename FOOD32A FOOD32_A
rename FOOD32B FOOD32_B
reshape wide DNBRON-Unemp2W4_cat, i(PSEUDOIDEXT) j(VMID)
******************
*****************************************************


**Drop retired at any wave
drop if WORK__2C1==5
drop if WORK2C111==1
drop if WORK2C121==1
drop if WORK2C11_W26==1
drop if WORK2C12_W26==1
drop if WORK2C11_W37==1
drop if WORK2C12_W37==1
drop if WORK2C11_W410==1
drop if WORK2C12_W410==1   

**Drop housewives at 1st wave
drop  if (WORK_2C1==6 | WORK__2C1==9| WORK2C91==1)
**Drop housewives at 2nd wave
drop  if WORK2C9_W26==1  
**Drop housewives at 3rd wave
drop  if WORK2C9_W37==1
**Drop housewives at 4th wave
drop  if WORK2C9_W410==1

**Drop students at 1st wave 
drop  if (WORK_2C1==7 | WORK__2C1==10| WORK2C101==1)
**Drop students at 2nd wave 
drop  if WORK2C10_W26==1
**Drop students at 3rd wave 
drop  if WORK2C10_W37==1
**Drop students at 4th wave 
drop  if WORK2C10_W410==1

**Drop Unfit at 1st wave
drop  if (WORK_2C1==4 | WORK__2C1==7| WORK2C71==1)
**Drop Unfit at 2nd wave
drop  if WORK2C7_W26==1
**Drop Unfit at 3rd wave
drop  if WORK2C7_W37==1
**Drop Unfit at 4th wave
drop  if WORK2C7_W410==1
*****************

*Drop empty/redundant variables
save "G:\OV20_0544\EXPORT\DATASETS\Final_DATASET_WIDE_020521.dta", replace

*Many variables do not have a wave (Duration, unemp_spells...), so they will be dropped! 
missings dropvars
drop Gender2 Gender6 Gender7 Gender10 Gender11
drop Early1 Early6 Early7 Early10 Early11
drop Marital_W12 Marital_W16 Marital_W17 Marital_W110 Marital_W111 
drop WORK*
drop FOOD* 
drop EDUCOTHER*
drop W411 W16 W17 W110 W111 W12 W21 W22 W27 W210 W211 W31 W32 W36 W310 W311 W42 W46 W47 W41
drop INT_1A1_1C1 INT_1A1_1B1 INT_1A1_1A31 INT_1A1_1A21
drop DEMO* FORM_ID1 AGE_1B1 AGE_1C1 EDUCATION1 Beer* Wine* Liquor* 


*Rename variables
rename W11 W1 
rename W26 W2
rename W37 W3
rename W410 W4
rename Unemployment_W11 Unemployment_W1
rename Unemployment_W26 Unemployment_W2
rename Unemployment_W37 Unemployment_W3 
rename Unemployment_W410 Unemployment_W4 
rename Unemp2W1_cat1 Unemp2W1_cat 
rename Unemp2W2_cat6 Unemp2W2_cat
rename Unemp2W3_cat7 Unemp2W3_cat
rename Unemp2W4_cat10 Unemp2W4_cat
rename Gender1 Gender
rename GLASSDAYW411 GLASSDAYW4
rename GLASSDAYW12 GLASSDAYW1
rename HD2_W12 HD2_W1 
rename HD2_W411 HD2_W4
rename Marital_W11 Marital_W1
rename EA1 EAW1
rename EA10 EAW4
rename DNBRON1 SOURCE 
rename Q1_11 Q1_1
rename Q1_22 Q1_2
rename Q26 Q2
rename Q37 Q3
rename Q4_110 Q4_1
rename Q4_211 Q4_2
rename Early2 Early

rename *W11 *W1
rename *W26 *W2
rename *W37 *W3
rename *W410 *W4
rename *W411 *W4

**************************************
*Corrections after reshape************
****************************************
**Unify Age at Baseline from both questionnaires Q1_1 & Q1_2
gen Age_W1=Age_Baseline1 if Age_Baseline1!=.
replace Age_W1=Age_Baseline2 if (Age_Baseline1==. & Age_Baseline2!=.)
replace Age_W1=. if (Age_Baseline1==. & Age_Baseline2==.)
drop Age_Baseline1 Age_Baseline2 Age_Baseline10 Age_Baseline11 Age_Baseline6 Age_Baseline7
order Age_W1, after(Gender)
*Categorical
gen Age_cat = Age_W1
recode Age_cat (min/35=1) (35/45=2) (45/max=3)
label def Age_cat 1"18-35" 2"35-45" 3"45-50", modify
label val Age_cat Age_cat

replace W4=1 if Q4_1==1 | Q4_2==1

************************
***Merge new variables
************************
*Educational Attainment: 
merge 1:1 PSEUDOIDEXT using "G:\OV20_0544\EXPORT\DATASETS\EDUCOTHER_wide.dta", nogenerate
rename EAW1 EAW1_1
rename EAW4 EAW4_1
rename EA_OtherW1 EAW1 
rename EA_OtherW4 EAW4 

***Add self-rated health
merge 1:1 PSEUDOIDEXT using "G:\OV20_0544\EXPORT\DATASETS\SelfRatedHealth_Wide_W1.dta", keepusing(SR_HealthW1 RAND_21) nogenerate
gen HealthW1 = SR_HealthW1
recode HealthW1 1=1 2=1 3=2 4=3 5=3
label def HealthW1 1"Excellent/Very good" 2"Good" 3"Mediocre/Poor", modify
label val HealthW1 HealthW1
label var HealthW1 "Self-rated health at Baseline (recode)"
recode SR_HealthW1 1=5 2=4 3=3 4=2 5=1
label def SR_HealthW1 1"Poor" 2"Mediocre" 3"Good" 4"Very good" 5"Excellent", modify
label val SR_HealthW1 SR_HealthW1
recode HealthW1 1=3 2=2 3=1
label def HealthW1 3"Excellent/Very good" 2"Good" 1"Mediocre/Poor", modify
label val HealthW1 HealthW1
label var HealthW1 "Self-rated health at Baseline (recode)"
**Add Health at Wave 4
merge 1:1 PSEUDOIDEXT using "G:\OV20_0544\EXPORT\DATASETS\SelfRatedHealth_W4_Wide.dta", keepusing(HealthW4) nogenerate
rename HealthW4 SRHealthW4
recode SRHealthW4 1=5 2=4 3=3 4=2 5=1
label def SRHealthW4 1"Poor" 2"Mediocre" 3"Good" 4"Very good" 5"Excellent", modify
label val SRHealthW4 SRHealthW4
gen HealthW4 = SRHealthW4
recode HealthW4 1=1 2=1 3=2 4=3 5=3
label def HealthW4 1"Mediocre/Poor" 2"Good"  3"Excellent/Very good" , modify
label val HealthW4 HealthW4
label var HealthW4 "Self-rated health at Wave 4 (recode)"

drop if Gender==.


*****DROP Participants who did not respond all Questionnaires*****
********************************************************************
gen AllQuest=1 if Q1_1==1 & Q1_2==1 & Q2==1 & Q3==1 & Q4_1==1 & Q4_2==1
replace AllQuest=0 if AllQuest==.
label var AllQuest "Participants with observations in all Questionnaires"

drop if AllQuest!=1

**********************
**********************
**Drop if missings on the outcome variables
drop if GLASSDAYW1==.
drop if GLASSDAYW4==.

*Drop if they have missing values in < 30% of the covariates
missings tag Unemployment_W1, generate (UnempW1_Miss)
missings tag Unemployment_W2, generate (UnempW2_Miss)
missings tag Unemployment_W3, generate (UnempW3_Miss)
missings tag Unemployment_W4, generate (UnempW4_Miss)
missings tag Marital_W1, generate (Partner_Miss)
missings tag EAW1, generate (EA_Miss)
missings tag HealthW1, generate (Health_Miss)
missings tag Age_W1, generate (AgeW1_Miss)

gen SumMiss =  UnempW1_Miss+ UnempW2_Miss+ UnempW3_Miss + UnempW4_Miss + Partner_Miss + EA_Miss + Health_Miss + AgeW1_Miss

*Drop Participants with missings in 30% of the variables 
drop if SumMiss>4

drop UnempW1_Miss- SumMiss

save "G:\OV20_0544\EXPORT\DATASETS\Final_DATASET_WIDE_020521.dta", replace
