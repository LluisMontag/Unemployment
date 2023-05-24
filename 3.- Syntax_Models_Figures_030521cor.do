use "G:\OV20_0544\EXPORT\DATASETS\Cleaning_WIDE_020521.dta", clear
sysdir set PLUS "I:\Lifelines\Programs\STATA-packages-installed"


**Table 2: MULTINOMIAL LOGISTIC REGRESSION MODELS**
**Comparative measurements of unemployment HEAVY DRINKING (corrected so they all have same observations for LRTEST)
mlogit Alcohol_cat2W4 i.Unemployment_W4 i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.Alcohol_cat2W1 if Unemp2W4_cat!=.,base(1) rrr
mlogit Alcohol_cat2W4 i.Unemp2W4_cat i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.Alcohol_cat2W1 ,base(1)rrr  
mlogit Alcohol_cat2W4 i.Unempspells_cat i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.Alcohol_cat2W1 if Unemp2W4_cat!=.,base(1) rrr 
mlogit Alcohol_cat2W4 i.LongUnempSpells2_cat i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.Alcohol_cat2W1 if Unemp2W4_cat!=. ,base(1) rrr 
mlogit Alcohol_cat2W4 i.DurationTotal2_cat i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.Alcohol_cat2W1 if Unemp2W4_cat!=.,base(1)  rrr
mlogit Alcohol_cat2W4 i.Trajectories i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.Alcohol_cat2W1 if Unemp2W4_cat!=.,base(1) rrr 

***BINGE DRINKING*** **HED (>5 drinks/occasion for men, >4 for women ONCE a month)
mlogit HEDcat2W4 i.Unemployment_W4 i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.HEDcat2W1 if Unemp2W4_cat!=.,base(1)rrr  
mlogit HEDcat2W4 i.Unemp2W4_cat i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.HEDcat2W1 ,base(1) rrr 
mlogit HEDcat2W4 i.Unempspells_cat i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1  ib1.HEDcat2W1 if Unemp2W4_cat!=. ,base(1) rrr 
mlogit HEDcat2W4 i.LongUnempSpells2_cat i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.HEDcat2W1 if Unemp2W4_cat!=.,base(1)rrr  
mlogit HEDcat2W4 i.DurationTotal2_cat i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.HEDcat2W1 if Unemp2W4_cat!=.,base(1)rrr  
mlogit HEDcat2W4 i.Trajectories i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.HEDcat2W1 if Unemp2W4_cat!=.,base(1)rrr 


********************************************
*********************************************
********Average Marginal Effects**************
***********************************************
*Abstinence
mlogit Alcohol_cat2W4 i.Unemployment_W4 i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.Alcohol_cat2W1 if Unemp2W4_cat!=.,base(1) rrr
margins, dydx(Unemployment_W4) post
est store HD1
mlogit Alcohol_cat2W4 i.Unemp2W4_cat i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.Alcohol_cat2W1 ,base(1)rrr  
margins, dydx(Unemp2W4_cat) post
est store HD2
mlogit Alcohol_cat2W4 i.LongUnempSpells2_cat i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.Alcohol_cat2W1 if Unemp2W4_cat!=. ,base(1) rrr 
margins, dydx(LongUnempSpells2_cat) post
est store HD4
mlogit Alcohol_cat2W4 i.Trajectories i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.Alcohol_cat2W1 if Unemp2W4_cat!=.,base(1) rrr 
margins, dydx(Trajectories) post
est store HD5

*Heavy Drinking
mlogit Alcohol_cat2W4 i.Unemployment_W4 i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.Alcohol_cat2W1 if Unemp2W4_cat!=.,base(1) rrr
margins, dydx(Unemployment_W4) predict (outcome(2))  post
est store HD12
mlogit Alcohol_cat2W4 i.Unemp2W4_cat i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.Alcohol_cat2W1 ,base(1)rrr  
margins, dydx(Unemp2W4_cat) predict (outcome(2))  post
est store HD22
mlogit Alcohol_cat2W4 i.LongUnempSpells2_cat i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.Alcohol_cat2W1 if Unemp2W4_cat!=. ,base(1) rrr 
margins, dydx(LongUnempSpells2_cat) predict (outcome(2))  post
est store HD42
mlogit Alcohol_cat2W4 i.Trajectories i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.Alcohol_cat2W1 if Unemp2W4_cat!=.,base(1) rrr 
margins, dydx(Trajectories) predict(outcome(2)) post
est store HD52

*Binge Drinking
mlogit HEDcat2W4 i.Unemployment_W4 i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.HEDcat2W1 if Unemp2W4_cat!=.,base(1)rrr  
margins, dydx(Unemployment_W4) predict (outcome(2)) post
est store BD1
mlogit HEDcat2W4 i.Unemp2W4_cat i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.HEDcat2W1 ,base(1) rrr 
margins, dydx(Unemp2W4_cat) predict (outcome(2)) post
est store BD2
mlogit HEDcat2W4 i.LongUnempSpells2_cat i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.HEDcat2W1 if Unemp2W4_cat!=.,base(1)rrr  
margins, dydx(LongUnempSpells2_cat) predict (outcome(2)) post
est store BD4
mlogit HEDcat2W4 i.Trajectories i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.HEDcat2W1 if Unemp2W4_cat!=.,base(1)rrr 
margins, dydx(Trajectories) predict(outcome(2)) post
est store BD5

*Figure 2
coefplot (HD2, offset(-0.1)msymbol(S) mcol(black) lcolor(black) ciopts(lcolor(black))) /// 
(HD22, offset(0)msymbol(O) mcol(grey) lcolor(grey) ciopts(lcolor(grey))) /// 
(BD2, offset(0.1 )msymbol(T) mcol(grey) lcolor(grey) ciopts(lcolor(grey))) ///
(HD4, offset(-0.1) msymbol(S)mcol(black) lcolor(black) ciopts(lcolor(black))) /// 
(HD42, msymbol(O) mcol(grey) lcolor(grey) ciopts(lcolor(grey))) /// 
(BD4, offset(0.1) msymbol(T) mcol(grey) lcolor(grey) ciopts(lcolor(grey))), vertical title("Unemployment measurements & drinking patterns. Average Marginal Effects", color(black) size(medium))  legend(order(1 "Abstinence"  3 "HD"  5 "BD")) ytitle("Pr(A.M.E)") coeflabels(,labsize(small) wrap(12)) yline(0)   


*****************************************************
******TABLE 3: Interaction Models********************
**
*Model 1
mlogit Alcohol_cat2W4 i.Unemp2W4_cat##ib3.EAW1 i.Gender i.Age_cat ib1.Marital_W1 ib3.HealthW1 ib1.Alcohol_cat2W1 ,base(1)rrr 
est store Modelea
 
*Model 2
mlogit HEDcat2W4 i.Unemp2W4_cat##ib1.Marital_W1 ib3.EAW1 i.Gender i.Age_cat ib3.HealthW1 ib1.HEDcat2W1 ,base(1)rrr  
est store BDpartner

*******************
**Figure 3
est restore Modelea
**Adjusted margins coefplot
quietly margins Unemp2W4_cat, at (EAW1=1) predict (outcome(2)) post
est store hdea1
est restore Modelea
quietly margins Unemp2W4_cat, at (EAW1=2) predict (outcome(2)) post
est store hdea2
est restore Modelea
quietly margins Unemp2W4_cat, at (EAW1=3) predict (outcome(2)) post
est store hdea3
*Coefplot black and white
coefplot (hdea1, offset(-0.03) msymbol(S) mcol(black) lcolor(black) ciopts(lcolor(black))) ///
(hdea2, offset(.03) msymbol(O) mcol(grey) lcolor(grey) ciopts(lcolor(grey))) ///
(hdea3, msymbol(T) mcol(grey) lcolor(grey) ciopts(lcolor(grey))), vertical recast(connected) title("Unemployment, SES & Heavy Drinking", color(black)) plotlabels(Low Middle High) xlab(1"Employed" 2"Short Unemp." 3"Long Unemp.") yscale(r(.05 (.05) .15)) ytitle("Pr(Heavy Drinking)") 

***************
**Figure 4
mlogit HEDcat2W4 i.Unemp2W4_cat##ib3.HealthW1 i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib1.HEDcat2W1,base(1)rrr
est store BDhealth
margins Unemp2W4_cat, at(HealthW1=1) predict (outcome(0)) post
est store health1
est restore BDhealth
margins Unemp2W4_cat, at(HealthW1=2) predict (outcome(0)) post
est store health2
est restore BDhealth
margins Unemp2W4_cat, at(HealthW1=3) predict (outcome(0)) post
est store health3
coefplot (health1, offset(-0.03) msymbol(S) mcol(black) lcolor(black) ciopts(lcolor(black))) /// 
 (health2, msymbol(O) mcol(black) lcolor(black) ciopts(lcolor(black))) (health3, offset(.03) msymbol(T) mcol(black) lcolor(black) ciopts(lcolor(black))), vertical recast(connected) title("Unemployment, Health & Abstinence", color(black))  plotlabels(Poor/Mediocre Good Very_Good/Excellent) xlab(1"Employed" 2"Short Unemp." 3"Long Unemp.") ytitle("Pr(Abstinence)")
 
 **************
 **************
 **Figure 5
est restore BDpartner
margins Unemp2W4_cat, at(Marital_W1=0) predict (outcome(0)) post
est store BD00
est restore BDpartner
margins Unemp2W4_cat, at(Marital_W1=1) predict (outcome(0)) post
est store BD10
coefplot (BD00, offset(-0.03) msymbol(S) mcol(black) lcolor(black) ciopts(lcolor(black))) /// 
 (BD10, msymbol(T) mcol(black) lcolor(black) ciopts(lcolor(black))), vertical recast(connected) lwidth(medium) title("Abstinence", color(black))  plotlabels(Single/Divorced Partnered/Married) xlab(1"Employed" 2"Short Unemp." 3"Long Unemp.") ytitle("Pr(Abstinence)") name(BD0, replace)

est restore BDpartner
margins Unemp2W4_cat, at(Marital_W1=0) predict (outcome(2)) post
est store BD02
est restore BDpartner
margins Unemp2W4_cat, at(Marital_W1=1) predict (outcome(2)) post
est store BD12
coefplot (BD02, offset(-0.03) msymbol(S) mcol(black) lcolor(black) ciopts(lcolor(black))) /// 
 (BD12, msymbol(T) mcol(black) lcolor(black) ciopts(lcolor(black))), vertical recast(connected) title("Binge Drinking", color(black)) plotlabels(Single/Divorced Partnered/Married) xlab(1"Employed" 2"Short Unemp." 3"Long Unemp.") ytitle("Pr(Binge Drinking)") name(BD2, replace)

grc1leg2 BD0 BD2, legendfrom(BD0) title("Unemployment and Partner status", color(black))


**************APPENDIX********
******************************

**Table A4**
*Model 1
mlogit Alcohol_cat2W4 i.Unemp2W4_cat ib3.EAW1 i.Gender i.Age_cat ib1.Marital_W1 ib3.HealthW1 ib1.Alcohol_cat2W1,base(1)rrr 
*Model 2
mlogit Alcohol_cat2W4 i.Unemp2W4_cat ib3.EAW1 i.Gender i.Age_cat ib1.Marital_W1 ib1.Alcohol_cat2W1 if HealthW1!=1,base(1)rrr 
*Model 3
mlogit Alcohol_cat2W4 i.Unemp2W4_cat ib3.EAW1 i.Gender i.Age_cat ib1.Marital_W1 ib1.Alcohol_cat2W1 if HealthW1==1,base(1)rrr 


**Table A5**
*Model 0
mlogit Alcohol_cat2W4 i.Unemp2W4_cat ib3.EAW1 i.Gender i.Age_cat ib1.Alcohol_cat2W1,base(1)rrr 

*******************************************************************************



*********************************************
************ATTRITION BIAS**************
use "G:\OV20_0544\EXPORT\DATASETS\Clean_Attrition_030521.dta", clear

***Table A1: Logistic regression Attrition
gen Attrition=1 if AllQuest==0
replace Attrition=0 if AllQuest==1

logit Attrition i.Gender Age_W1 ib1.Marital_W1 ib2.EAW1 i.Unemployment_W1 ib1.SOURCE Income ib1.Alcohol_cat2W1 ib3.HealthW1, or


