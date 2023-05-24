**IMPUTATION (instead of dropping missings) 
use "G:\OV20_0544\EXPORT\DATASETS\PANEL_pre_drop_070721.dta", clear
drop if Wave==2 | Wave==3


***Imputation
mi set mlong
mi register impute BDcat Work5 Health Years_Education Partner Age_c
mi impute chained (mlogit)BDcat (mlogit)Work5 (mlogit)Health (truncreg, ll(5) ul(16))Years_Education (logit)Partner (truncreg, ll(22) ul(75))Age_c  = Gender, add(40) augment force

save "G:\OV20_0544\EXPORT\DATASETS\PANEL_pre_drop_IMPUTED_170721.dta", replace

*All values
mi estimate: mlogit BDcat i.Work5 i.Gender c.Age_c ib1.Partner Years_Education Health, base(1) vce(cluster PSEUDOIDEXT)
mi estimate: mlogit Work5 ib1.BDcat i.Gender c.Age_c ib1.Partner Years_Education Health, vce(cluster PSEUDOIDEXT)

*Drop missings in outcome
preserve
contract PSEUDOIDEXT Wave BDcat Work5 Age_c Gender Partner Years_Education Health _mi_miss _mi_m _mi_id
sort PSEUDOIDEXT Wave _mi_m
bysort PSEUDOIDEXT Wave (_mi_m) : replace _mi_miss = _mi_miss[_n-1] if missing(_mi_miss) 
replace BDcat=. if _mi_miss==1
mi estimate: mlogit BDcat i.Work5 i.Gender c.Age_c ib1.Partner Years_Education Health, base(1) vce(cluster PSEUDOIDEXT)
restore

preserve
contract PSEUDOIDEXT Wave BDcat Work5 Age_c Gender Partner Years_Education Health _mi_miss _mi_m _mi_id
sort PSEUDOIDEXT Wave _mi_m
bysort PSEUDOIDEXT Wave (_mi_m) : replace _mi_miss = _mi_miss[_n-1] if missing(_mi_miss) 
replace Work5=. if _mi_miss==1
mi estimate: mlogit BDcat i.Work5 i.Gender c.Age_c ib1.Partner Years_Education Health, base(1) vce(cluster PSEUDOIDEXT)
restore


*Try FE

mi passive: gen BDimp=1 if BDcat==2
mi passive: replace BDimp=0 if BDimp==.
mi passive: gen Abstimp=1 if BDcat==0
mi passive: replace Abstimp=0 if Abstimp==.
mi xtset PSEUDOIDEXT Wave
mi estimate: xtlogit BDimp i.Work5 Abstimp c.Age_c ib1.Partner Health, fe


