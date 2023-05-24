use "G:\OV20_0544\EXPORT\DATASETS\Clean_wide_IMPUTED_150621.dta", clear

**Table 1 (descriptives before imputation)
tab Gender Unemp2W4_cat if Alcohol_cat2W4!=., col chi
tab Age_cat Unemp2W4_cat if Alcohol_cat2W4!=., col chi
tab Marital_W1 if Alcohol_cat2W4!=. & Unemp2W4_cat!=., m
tab Marital_W1 Unemp2W4_cat if Alcohol_cat2W4!=., col chi
tab EAW1 if Alcohol_cat2W4!=. & Unemp2W4_cat!=., m

***********IMPUTED DATASET************************* 
*******Average Marginal Effects**************
mi set wide
mi estimate, rrr: mlogit Alcohol_cat2W4 i.Unemp2W4_cat i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.Alcohol_cat2W1, base(1)rrr
est store ModelHD
mi estimate, rrr: mlogit Alcohol_cat2W4 i.LongSpells i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.Alcohol_cat2W1,base(1) rrr  
est store ModelHDlong
mi estimate, rrr: mlogit Alcohol_cat2W4 i.DurationTotal2_cat i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.Alcohol_cat2W1,base(1) rrr  
est store ModelHDduration

mi estimate, rrr: mlogit HEDcat2W4 i.Unemp2W4_cat i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.HEDcat2W1 if Alcohol_cat2W4!=.,base(1) rrr 
est store ModelBD
mi estimate, rrr: mlogit HEDcat2W4 i.LongSpells i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.HEDcat2W1 if Alcohol_cat2W4!=.,base(1) rrr 
est store ModelBDlong
mi estimate, rrr: mlogit HEDcat2W4 i.DurationTotal2_cat i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.HEDcat2W1 if Alcohol_cat2W4!=.,base(1) rrr 
est store ModelBDduration

*Marginal effects
*Abstinence
est restore ModelHD
mimrgns, dydx(Unemp2W4_cat) predict (outcome(0)) post
est store HD0
*HD
est restore ModelHD
mimrgns, dydx(Unemp2W4_cat) predict (outcome(2))  post
est store HD1
*BD
est restore ModelBD
mimrgns, dydx(Unemp2W4_cat) predict (outcome(2))  post
est store BD1
*Abstinence long
est restore ModelHDlong
mimrgns, dydx(LongSpells) predict (outcome(0)) post
est store HD01
*HD long
est restore ModelHDlong
mimrgns, dydx(LongSpells) predict (outcome(2))  post
est store HD2
*BDlong
est restore ModelBDlong
mimrgns, dydx(LongSpells) predict(outcome(2))  post
est store BD2
*Abstinence duration
est restore ModelHDduration 
mimrgns, dydx(DurationTotal2_cat) predict (outcome(0))  post
est store HD02
*HD Duration
est restore ModelHDduration 
mimrgns, dydx(DurationTotal2_cat) predict (outcome(2))  post
est store HD3
*BD Duration
est restore ModelBDduration 
mimrgns, dydx(DurationTotal2_cat) predict(outcome(2))  post
est store BD3

*Figure 1
coefplot (HD0, offset(-0.1)msymbol(S) mcol(black) lcolor(black) ciopts(lcolor(black))) /// 
(HD1, offset(0)msymbol(O) mcol(black) lcolor(black) ciopts(lcolor(black))) /// 
(BD1, offset(0.1 )msymbol(T) mcol(black) lcolor(black) ciopts(lcolor(black))) ///
(HD01, offset(-0.1) msymbol(S)mcol(black) lcolor(black) ciopts(lcolor(black))) /// 
(HD2, msymbol(O) mcol(black) lcolor(black) ciopts(lcolor(black))) /// 
(BD2, offset(0.1) msymbol(T) mcol(black) lcolor(black) ciopts(lcolor(black))) ///
(HD02, offset(-0.1) msymbol(S)mcol(black) lcolor(black) ciopts(lcolor(black))) /// 
(HD3, msymbol(O) mcol(black) lcolor(black) ciopts(lcolor(black))) /// 
(BD3, offset(0.1) msymbol(T) mcol(black) lcolor(black) ciopts(lcolor(black))), vertical title("Unemployment measurements & drinking patterns. Average Marginal Effects", color(black) size(medium))  legend(order(1 "Abstinence"  3 "HD"  5 "BD")) ytitle("Pr(A.M.E)") coeflabels(,labsize(small) wrap(12)) yline(0) color(gray)  

****************
**TABLE 2****** 
*(all models are run using only observed values in the outcome. Hence: drop if Alcohol_cat2W4==.)
mi set wide
preserve
drop if Alcohol_cat2W4==. 
*Unemployment at wave 4 (dummy)
mi estimate, rrr: mlogit Alcohol_cat2W4 i.Unemployment_W4 i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.Alcohol_cat2W1, base(1)rrr 
mi estimate, rrr: mlogit HEDcat2W4 i.Unemployment_W4 i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.HEDcat2W1, base(1)rrr
*Unemployment at wave 4 (categorical)
mi estimate, rrr: mlogit Alcohol_cat2W4 i.Unemp2W4_cat i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.Alcohol_cat2W1, base(1)rrr
mi estimate, rrr: mlogit HEDcat2W4 i.Unemp2W4_cat i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.HEDcat2W1, base(1)rrr
restore
*Number of Unemployment Spells
preserve
drop if Alcohol_cat2W4==. 
mi estimate, rrr: mlogit Alcohol_cat2W4 i.UnempSpells i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.Alcohol_cat2W1, base(1)rrr
mi estimate, rrr: mlogit HEDcat2W4 i.UnempSpells i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.HEDcat2W1, base(1)rrr
restore 
*Number of LONG Unemployment Spells
preserve
drop if Alcohol_cat2W4==. 
mi estimate, rrr: mlogit Alcohol_cat2W4 i.LongSpells i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.Alcohol_cat2W1, base(1)rrr
mi estimate, rrr: mlogit HEDcat2W4 i.LongSpells i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.HEDcat2W1, base(1)rrr
restore
*Unemployment Trajectories
preserve
drop if Alcohol_cat2W4==. 
mi estimate, rrr: mlogit Alcohol_cat2W4 i.Traject i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.Alcohol_cat2W1, base(1)rrr
mi estimate, rrr: mlogit HEDcat2W4 i.Traject i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.HEDcat2W1, base(1)rrr
restore
*Total Duration of Unemployment
preserve
drop if Alcohol_cat2W4==. 
mi estimate, rrr: mlogit Alcohol_cat2W4 i.DurationTotal2_cat i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.Alcohol_cat2W1, base(1)rrr
mi estimate, rrr: mlogit HEDcat2W4 i.DurationTotal2_cat i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.HEDcat2W1, base(1)rrr
restore

************
**TABLE 3** 
preserve
drop if Alcohol_cat2W4==.
*Model 0
mi estimate, rrr: mlogit Alcohol_cat2W4 i.Unemp2W4_cat i.Gender i.Age_cat  ib3.EAW1 ib1.Marital_W1 ib3.HealthW1 ib1.Alcohol_cat2W1 ,base(1)
est store ModelHD
*Model 1
mi estimate, rrr: mlogit Alcohol_cat2W4 i.Unemp2W4_cat##ib3.EAW1 i.Gender i.Age_cat ib1.Marital_W1 ib3.HealthW1 ib1.Alcohol_cat2W1 ,base(1)

************
**Figure 2**
est store ModelHDEA
restore 
est restore ModelHDEA
mimrgns Unemp2W4_cat, at (EAW1=1) predict (outcome(2)) post
est store hdea1
est restore ModelHDEA
mimrgns Unemp2W4_cat, at (EAW1=2) predict (outcome(2)) post
est store hdea2
est restore ModelHDEA
mimrgns Unemp2W4_cat, at (EAW1=3) predict (outcome(2)) post
est store hdea3
*Coefplot black and white
coefplot (hdea1, offset(-0.03) msymbol(S) mcol(black) lcolor(black) ciopts(lcolor(black))) ///
(hdea2, offset(.03) msymbol(O) mcol(black) lcolor(black) ciopts(lcolor(black))) ///
(hdea3, msymbol(T) mcol(black) lcolor(black) ciopts(lcolor(black))), vertical recast(connected) title("Unemployment, SES & Heavy Drinking", color(black)) plotlabels(Low Middle High) xlab(1"Employed" 2"Short Unemp." 3"Long Unemp.") yscale(r(.05 (.05) .15)) ytitle("Pr(Heavy Drinking)") 


*************************
**********************
*******************
***APPENDIX****
****
**
*Table A1
sum Age_W1 if Alcohol_cat2W4!=.
sum Age_W1 if Alcohol_cat2W4==.
tab Gender if Alcohol_cat2W4!=.
tab Gender if Alcohol_cat2W4==.
tab Marital_W1 if Alcohol_cat2W4==.
tab Marital_W1 if Alcohol_cat2W4!=.
tab EAW1 if Alcohol_cat2W4==.
tab EAW1 if Alcohol_cat2W4!=.
tab HealthW1 if Alcohol_cat2W4==.
tab HealthW1 if Alcohol_cat2W4!=.
tab Unemployment_W1 if Alcohol_cat2W4==.
tab Unemployment_W1 if Alcohol_cat2W4!=.
tab Unemployment_W4 if Alcohol_cat2W4==.
tab Unemployment_W4 if Alcohol_cat2W4!=.
tab SOURCE if Alcohol_cat2W4==.
tab SOURCE if Alcohol_cat2W4!=.
tab Alcohol_cat2W1 if Alcohol_cat2W4==.
tab Alcohol_cat2W1 if Alcohol_cat2W4!=.

*Table A2
sum Age_W1 if Alcohol_cat2W4==0 & Unemp2W4_cat!=.
sum Age_W1 if Alcohol_cat2W4==1 & Unemp2W4_cat!=.
sum Age_W1 if Alcohol_cat2W4==2 & Unemp2W4_cat!=.
tab Gender Alcohol_cat2W4 if Alcohol_cat2W4!=. & Unemp2W4_cat!=., col chi
tab Marital_W1 if Alcohol_cat2W4!=. & Unemp2W4_cat!=., m
tab Marital_W1 Alcohol_cat2W4 if Alcohol_cat2W4!=. & Unemp2W4_cat!=., col chi
tab EAW1 Alcohol_cat2W4 if Alcohol_cat2W4!=. & Unemp2W4_cat!=., col chi
tab HealthW1 Alcohol_cat2W4 if Alcohol_cat2W4!=. & Unemp2W4_cat!=., col chi

*Table A3 
tab Unemployment_W4 if Alcohol_cat2W4!=., m
tab Unemp2W4_cat if Alcohol_cat2W4!=., m
tab Unempspells_cat if Alcohol_cat2W4!=., m
tab LongSpells if Alcohol_cat2W4!=., m 
tab Traject if Alcohol_cat2W4!=., m
tab DurationTotal2_cat if Alcohol_cat2W4!=., m

**Table A4
*Model 0 
mi estimate, rrr: mlogit Alcohol_cat2W4 i.Unemp2W4_cat i.Gender i.Age_cat  ib3.EAW1 ib1.Alcohol_cat2W1 ,base(1)
*Model 1
mi estimate, rrr: mlogit Alcohol_cat2W4 i.Unemp2W4_cat i.Gender i.Age_cat ib3.EAW1 ib1.Marital_W1 ib3.HealthW1 ib1.Alcohol_cat2W1 ,base(1)

**Table A5
mlogit Alcohol_cat2W4 i.Unemployment_W4 i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.Alcohol_cat2W1 if Unemp2W4_cat!=.,base(1) rrr
mlogit Alcohol_cat2W4 i.Unemp2W4_cat i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.Alcohol_cat2W1 ,base(1)rrr  
mlogit Alcohol_cat2W4 i.Unempspells_cat i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.Alcohol_cat2W1 if Unemp2W4_cat!=.,base(1) rrr 
mlogit Alcohol_cat2W4 i.LongUnempSpells2_cat i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.Alcohol_cat2W1 if Unemp2W4_cat!=. ,base(1) rrr 
mlogit Alcohol_cat2W4 i.DurationTotal2_cat i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.Alcohol_cat2W1 if Unemp2W4_cat!=.,base(1)  rrr
mlogit Alcohol_cat2W4 i.Trajectories i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.Alcohol_cat2W1 if Unemp2W4_cat!=.,base(1) rrr 

mlogit HEDcat2W4 i.Unemployment_W4 i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.HEDcat2W1 if Unemp2W4_cat!=.,base(1)rrr  
mlogit HEDcat2W4 i.Unemp2W4_cat i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.HEDcat2W1 ,base(1) rrr 
mlogit HEDcat2W4 i.Unempspells_cat i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1  ib1.HEDcat2W1 if Unemp2W4_cat!=. ,base(1) rrr 
mlogit HEDcat2W4 i.LongUnempSpells2_cat i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.HEDcat2W1 if Unemp2W4_cat!=.,base(1)rrr  
mlogit HEDcat2W4 i.DurationTotal2_cat i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.HEDcat2W1 if Unemp2W4_cat!=.,base(1)rrr  
mlogit HEDcat2W4 i.Trajectories i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.HEDcat2W1 if Unemp2W4_cat!=.,base(1)rrr

*Figure A1 (CCA: interaction Ed.Attainment##Unemployment)
mlogit Alcohol_cat2W4 i.Unemp2W4_cat i.Gender i.Age_cat ib1.Marital_W1 ib3.EAW1 ib3.HealthW1 ib1.Alcohol_cat2W1 ,base(1)rrr  
est store ModelEA
quietly margins Unemp2W4_cat, at (EAW1=1) predict (outcome(2)) post
est store hdea1
est restore ModelEA
quietly margins Unemp2W4_cat, at (EAW1=2) predict (outcome(2)) post
est store hdea2
est restore ModelEA
quietly margins Unemp2W4_cat, at (EAW1=3) predict (outcome(2)) post
est store hdea3
coefplot (hdea1, offset(-0.03) msymbol(S) mcol(black) lcolor(black) ciopts(lcolor(black))) ///
(hdea2, offset(.03) msymbol(O) mcol(grey) lcolor(grey) ciopts(lcolor(grey))) ///
(hdea3, msymbol(T) mcol(grey) lcolor(grey) ciopts(lcolor(grey))), vertical recast(connected) title("Unemployment, SES & Heavy Drinking") plotlabels(Low Middle High) xlab(1"Employed" 2"Short Unemp." 3"Long Unemp.") yscale(r(.05 (.05) .15)) ytitle("Pr(Heavy Drinking)") 

*Figure A2
mlogit HEDcat2W4 i.Unemp2W4_cat##ib1.Marital_W1 i.Gender i.Age_cat ib3.EAW1 ib3.HealthW1 ib1.HEDcat2W1 ,base(1)rrr  
est store BDPartner
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

**Figure A3
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
 




