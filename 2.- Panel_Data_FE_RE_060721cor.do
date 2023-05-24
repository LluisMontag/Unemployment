 use "G:\OV20_0544\EXPORT\DATASETS\MERGED_2ndPAPER_PANEL_070721.dta", clear
 sysdir set PLUS "I:\Lifelines\Programs\STATA-packages-installed"

 *Panel Data specification
xtset PSEUDOIDEXT Wave

**RANDOM EFFECTS

**Social Causation 
mlogit BDcat i.Work5 ib1.Partner Age_c Health Gender Years_Education, vce(cluster PSEUDOIDEXT)

**Health selection
mlogit Work5 ib1.BDcat ib1.Partner Age_c Health Gender Years_Education, vce(cluster PSEUDOIDEXT)


**FIXED EFFECTS
***Social Causation 
femlogit BDcat ShortUnemp LongUnemp2 Unfit Age_c Partner2 Health 

**Health Selection
femlogit Work5 Abstainer BD Age_c Partner2 Health 


*************************************************************
*********************************************************
**Compare RE and FE populations:
*Mark those with no changes in the outcome:
by PSEUDOIDEXT (Work5), sort: gen Work_change = (Work5[1] != Work5[_N])
by PSEUDOIDEXT (BDcat), sort: gen BD_change = (BDcat[1] != BDcat[_N])

*****
*Even better: identify those in the models
mlogit Work5 ib1.BDcat ib1.Partner Age_c Health Gender Years_Education, vce(cluster PSEUDOIDEXT)
predict p1 if e(sample)==1
gen SelectRE=1 if p1!=.
replace SelectRE=0 if SelectRE==.

femlogit Work5 Abstainer BD Age_c Partner2 Health 
predict p2 if e(sample)==1
gen SelectFE=1 if p2!=.
replace SelectFE=0 if SelectFE==.

mlogit BDcat i.Work5 ib1.Partner Age_c Health Gender Years_Education, vce(cluster PSEUDOIDEXT)
predict p3 if e(sample)==1
gen CausatRE=1 if p3!=.
replace CausatRE=0 if CausatRE==.

femlogit BDcat ShortUnemp LongUnemp2 Unfit Age_c Partner2 Health 
predict p4 if e(sample)==1
gen CausatFE=1 if p4!=.
replace CausatFE=0 if CausatFE==.
