use "G:\OV20_0544\EXPORT\DATASETS\CLEAN_WIDE_RED_070721.dta", clear


*FIXED EFFECTS
*GSEM based on Allison's slides 
*Constraints force the coefficients to be the same at the different waves.

*With Beta (error) constrained to 1	 
gsem (shortunempw4 <- shortunempw1@a longunemp2w1@b unfitw1@c bdw1@d abstainerw1@e healthw1@f agew1@g partner2w1@h Alpha@1, logit) ///
     (longunemp2w4 <- shortunempw1@i longunemp2w1@j unfitw1@k bdw1@l abstainerw1@m healthw1@n agew1@o partner2w1@p Alpha@1, logit) ///
     (unfitw4 <- shortunempw1@q longunemp2w1@r unfitw1@s bdw1@t abstainerw1@u healthw1@v agew1@x partner2w1@y Alpha@1, logit) ///
     (shortunempw5 <- shortunempw4@a longunemp2w4@b unfitw4@c bdw4@d abstainerw4@e healthw4@f agew4@g partner2w4@h Alpha@1, logit) ///
     (longunemp2w5 <- shortunempw4@i longunemp2w4@j unfitw4@k bdw4@l abstainerw4@m healthw4@n agew4@o partner2w4@p Alpha@1, logit) ///
     (unfitw5 <- shortunempw4@q longunemp2w4@r unfitw4@s bdw4@t abstainerw4@u healthw4@v agew4@x partner2w4@y Alpha@1, logit) ///
     (Alpha <- healthw1 healthw4 age* partner2*) ///
	 (bdw4 <- bdw1@aa abstainerw1@bb shortunempw1@cc longunemp2w1@dd unfitw1@ee healthw1@ff agew1@gg partner2w1@hh Alpha@1, logit) ///
	 (abstainerw4 <- bdw1@ii abstainerw1@jj shortunempw1@kk longunemp2w1@ll unfitw1@mm healthw1@nn agew1@oo partner2w1@pp Alpha@1, logit)  ///
	 (bdw5 <- bdw4@aa abstainerw4@bb shortunempw4@cc longunemp2w4@dd unfitw4@ee healthw4@ff agew4@gg partner2w4@hh Alpha@1, logit) ///
     (abstainerw5 <- bdw4@ii abstainerw4@jj shortunempw4@kk longunemp2w4@ll unfitw4@mm healthw4@nn agew4@oo partner2w4@pp Alpha@1, logit) 
estimates save ShortUnemp4


*Different constraints per both waves
gsem (shortunempw4 <- shortunempw1@a longunemp2w1@b unfitw1@c bdw1@d abstainerw1@e healthw1@f agew1@g partner2w1@h Alpha@1, logit) ///
     (longunemp2w4 <- shortunempw1@i longunemp2w1@j unfitw1@k bdw1@l abstainerw1@m healthw1@n agew1@o partner2w1@p Alpha@1, logit) ///
     (unfitw4 <- shortunempw1@q longunemp2w1@r unfitw1@s bdw1@t abstainerw1@u healthw1@v agew1@x partner2w1@y Alpha@1, logit) ///
     (shortunempw5 <- shortunempw4@aaa longunemp2w4@bbb unfitw4@ccc bdw4@ddd abstainerw4@eee healthw4@fff agew4@ggg partner2w4@hhh Alpha@1, logit) ///
     (longunemp2w5 <- shortunempw4@iii longunemp2w4@jjj unfitw4@kkk bdw4@lll abstainerw4@mmm healthw4@nnn agew4@ooo partner2w4@ppp Alpha@1, logit) ///
     (unfitw5 <- shortunempw4@qqq longunemp2w4@rrr unfitw4@sss bdw4@ttt abstainerw4@uuu healthw4@vvv agew4@xxx partner2w4@yyy Alpha@1, logit) ///
     (Alpha <- healthw1 healthw4 age* partner2*) ///
	 (bdw4 <- bdw1@aa abstainerw1@bb shortunempw1@cc longunemp2w1@dd unfitw1@ee healthw1@ff agew1@gg partner2w1@hh Alpha@1, logit) ///
	 (abstainerw4 <- bdw1@ii abstainerw1@jj shortunempw1@kk longunemp2w1@ll unfitw1@mm healthw1@nn agew1@oo partner2w1@pp Alpha@1, logit)  ///
	 (bdw5 <- bdw4@aax abstainerw4@bbx shortunempw4@ccx longunemp2w4@ddx unfitw4@eex healthw4@ffx agew4@ggx partner2w4@hhx Alpha@1, logit) ///
     (abstainerw5 <- bdw4@iix abstainerw4@jjx shortunempw4@kkx longunemp2w4@llx unfitw4@mmx healthw4@nnx agew4@oox partner2w4@ppx Alpha@1, logit) 
	 
estimates save ShortUnemp5


estimates table ShortUnemp4 ShortUnemp5, b(%12.2fc)eform star stfmt(%-9.3f)stats(N)

save "G:\OV20_0544\EXPORT\DATASETS\CLEAN_WIDE_RED_170921.dta" 
