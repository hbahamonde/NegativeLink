* Negative Link Paper


set scheme  s1color, permanently
set more off, permanently

****************************
* DESCRIBING THE DATA
****************************


* Declare data
clear all
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta"

* set ts data
tsset, clear
tsset country year, yearly


* Plot the data 
	tsline constagricult constmanufact if country==4, title("Chile") xtitle("") ytitle("") name(Chile_TS, replace) legend(label(1 "Agriculture") label(2 "Industry")) legend(cols(2)) ylabel(#3, labsize(vsmall)) ymtick(##3) 

	tsline constagricult constmanufact if country==5, title("Colombia") xtitle("") ytitle("") name(Colombia_TS, replace) legend(label(1 "Agriculture") label(2 "Industry")) legend(cols(2)) ylabel(#3, labsize(vsmall)) ymtick(##3)
	
	tsline constagricult constmanufact if country==8, title("Ecuador") xtitle("") ytitle("") name(Ecuador_TS, replace) legend(label(1 "Agriculture") label(2 "Industry")) legend(cols(2)) ylabel(#3, labsize(vsmall)) ymtick(##3)
	
	tsline constagricult constmanufact if country==10, title("Guatemala") xtitle("") ytitle("") name(Guatemala_TS, replace) legend(label(1 "Agriculture") label(2 "Industry")) legend(cols(2)) ylabel(#3, labsize(vsmall)) ymtick(##3)
	
	tsline constagricult constmanufact if country==14, title("Nicaragua") xtitle("") ytitle("") name(Nicaragua_TS, replace) legend(label(1 "Agriculture") label(2 "Industry")) legend(cols(2)) ylabel(#3, labsize(vsmall)) ymtick(##3)
	
	tsline constagricult constmanufact if country==17, title("Peru") xtitle("") ytitle("") name(Peru_TS, replace) legend(label(1 "Agriculture") label(2 "Industry")) legend(cols(2)) ylabel(#3, labsize(vsmall)) ymtick(##3)

	tsline constagricult constmanufact if country==20, title("Venezuela") xtitle("") ytitle("") name(Venezuela_TS, replace) legend(label(1 "Agriculture") label(2 "Industry")) legend(cols(2)) ylabel(#3, labsize(vsmall)) ymtick(##3)
	* combining all ts graphs // install package grc1leg
	grc1leg Chile_TS Venezuela_TS Peru_TS Nicaragua_TS Guatemala_TS Ecuador_TS Colombia_TS, legendfrom(Chile_TS) cols(3) 
	graph export "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/ts_graphs.pdf", replace
	



* Now I estimate the cointegrating regressions, 
* that is, I regress one series on the other, and predict the residuals,
* and then run DF test on the saved residuals.

* Cointegration means series that are integrated individually
* but jointly stationary. Hence, these residuals should be
* stationary.

** SEE ALTERNATIVE CRITICAL VALUES HERE!
** DONT INCLUDE DRIFT TERM HERE!!!!
** DONT USE D FULLER, BUT USE JOHANNSEN

*** PUT LAGS IN THE DF TEST!
*** sign. pvalue = stationarity

**** ECM
**** "VECMs "fix" integrated series that [are] cointegrated and first 
**** differences "fix" integrated series that do not cointegrate".
**** THE ONE THAT'S SIGNIFICANT TRIES TO CATCH UP WITH THE OTHER ONE
**** DO NOT TAKE THE DIFFERENCE,
**** THEY GO UNTRANSFORMED INTO THE TEST (MARK SAID THAT).





********************************************************************************************************************************************
* 																	C 	H 	I 	 L 	  	E 
********************************************************************************************************************************************




****************************
* UNIT ROOT TESTS
****************************

* CHILE

clear all
cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta"

* Keeping one country
keep if country==4

* set ts data
tsset, clear
tsset year, yearly


************
* ADF
************

** MacKinnon approximate sign. p-value = stationarity

** 
dfuller constmanufact, lag(1) reg // I(1)
dfuller constmanufact, lag(1) reg drift // I(1)
dfuller constmanufact, lag(1) reg trend // I(1) // trend term not stationary: don't include one.
// conclusion: I(1)

dfuller constagricult, lag(1) reg // I(1)
dfuller constagricult, lag(1) reg drift // I(1)
dfuller constagricult, lag(1) reg trend // I(1) // trend term not stationary: don't include one.
// conclusion: I(1)


************
* Phillips–Perron // See Phillips (1987) and Phillips and Perron (1988)
************

** MacKinnon approximate sign. p-value = stationarity

** 
pperron constmanufact, lag(1) // I(1)
pperron constmanufact, lag(1) trend // I(1)
// conclusion: I(1)

pperron constagricult, lag(1) // I(1)
pperron constagricult, lag(1) trend // I(1)
// conclusion: I(1)



************
* KPSS  \\  Kwiatkowski, Phillips, Schmidt, and Shin (KPSS, 1992)
************

* null hypothesis of stationarity \\ statistic > critical value = nonstationary/integrated/unit root

** 
// search kpss ado
kpss constmanufact // I(1)
kpss constmanufact, qs auto // I(1)
// conclusion: I(1)

kpss constagricult // I(1)
kpss constagricult, qs auto // I(1)
// conclusion: I(1)




************
* GLS detrended augmented Dickey–Fuller test // See Elliott et al. (1996)
************

* null hypothesis of stationarity \\ statistic > critical value = nonstationary/integrated/unit root


** 
// search dfgls ado
dfgls constmanufact, maxlag(3) // I(1)
dfgls constmanufact, maxlag(3) trend // I(1) 
// conclusion: I(1)

dfgls constagricult, maxlag(3) // I(1)
dfgls constagricult, maxlag(3) trend // I(1)
// conclusion: I(1)


****************************
* Engle-Granger
****************************


* Cointegrating Regression -- first stage
// reg constmanufact L1.constagricult L1.constmanufact
// capture drop res*
// predict res_Chile, res
// 
// * Second Stage
// 
// reg D.constmanufact L1D.constagricult L1D.constmanufact L.res_Chile // eq 1
// reg D.constagricult L1D.constmanufact L1D.constagricult L.res_Chile // eq 2
// 
// 
// 
// * Testing Stationarity of Residuals of Cointegrating Regression
// tsline res_Chile, title("Chile") xtitle("") ytitle("") name(Chile_CoIntReg_Res, replace)
// 
// ** MacKinnon approximate sign. p-value = stationarity
// dfuller res_Chile, reg lag(1) // stationary 
// dfuller res_Chile, reg lag(1) drift // stationary
// dfuller res_Chile, reg lag(1) trend // stationary
// conclusion: stationary
// 
// Auto-Correlation Functions for Cointegrating Regression Residuals
// ac res_Chile, xtitle("AC") ytitle("") note("") name(Chile_AC_Res_CoIntReg, replace) ylabel(#3, labsize(vsmall)) ymtick(##3)  
// pac res_Chile, xtitle("PAC") ytitle("") note("") name(Chile_PAC_Res_CoIntReg, replace) ylabel(#3, labsize(vsmall)) ymtick(##3) 
// graph combine Chile_AC_Res_CoIntReg Chile_PAC_Res_CoIntReg, cols(1) title("Chile: Cointegrating Regression Residuals")
// graph save "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/chile_res.gph"



****************************
* ECM // Engle-Granger via OLS
****************************

** Cointegrating Regression -- First stage
reg constmanufact constagricult // averiguar bien como se hace esta etapa: mande un mail a Janet Box-St. Nov 21st. 2016.
capture drop res*
predict res_Chile, res

// testing stationarity of cointegrating vector: Janet Box-St.'s book, p. 161, eq. 6.11 // 
// reg d.res_Chile l.res_Chile // p-value no sign: no cointegration

** Second Stage
reg D.constmanufact L(1/3)D.constagricult L(1/3)D.constmanufact L.res_Chile // eq 1
reg D.constagricult L(1/3)D.constmanufact L(1/3)D.constagricult L.res_Chile // eq 2



****************************
*  ECM // via Johansen's MLE procedure.
****************************

* 
varsoc constmanufact constagricult, maxlag(5) // lag 3 // test for lag lenght
vecrank constmanufact constagricult, lags(5) max // rank 1: This is the number of cointegrating vectors in the system. // report LL and significance level
vec constmanufact constagricult, alpha rank(1) lags(5)  trend(trend) 
// interpreation: in the IND equation, the error correction term is NEG and SIGN, meaning that as the growth differentials 'drift appart the IND sector slows down a bit (as the size of the change is not tha big).' this confirms the inter-sectoral dependence: as both sectors drift appart, food prices rise, limiting the expansion of the IND sector. Also, in the AGR equation, as both sectors drif appart, the AGR sector speeds up a little bit (as the size of the effect is not that big). I took this interpretation from Box's book p. 168.

// post-estimation
<<<<<<< HEAD
	// veclmar // won't compute.

	// vecnorm // won't compute.
=======
	veclmar // won't compute.

	vecnorm // won't compute.
>>>>>>> master

	vecstable, graph // results: alright.


****************************
* IMPULSE RESPONSE FUNCTIONS from VECM
****************************

* create IRF "object"
// irf create Chile, step(10) set(Chile, replace)

// 'simple' IRF
// irf graph irf, impulse(constmanufact) response(constagricult) byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Chile_Man_Agr, replace) title("") subtitle("Response of Agriculture to Industry")
// irf graph irf, impulse(constagricult) response(constmanufact) note("") byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Chile_Agr_Man, replace)  subtitle("Response of Industry to Agriculture") title("")
// gr combine irf_ce_Chile_Man_Agr.gph  irf_ce_Chile_Agr_Man.gph, col(2) saving(Chile_irf_ECM, replace) title("Chile")
// graph export "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/Chile_irf_ECM.pdf", replace


****************************
* VAR
****************************

* 
var d.constmanufact d.constagricult, lags(1/3) // put the differenced variables (as the STATA manual does). // put this in appendix // 4 lags as that gives me good results with post-estimation

// post-estimation
	varlmar, mlag(5) // implements a Lagrange multiplier (LM) test for autocorrelation in the residuals of VAR models, which was presented in Johansen (1995) // no significative, no model specification // results: no evidence of model misspecification.

	varnorm // Compute Jarque–Bera, skewness, and kurtosis statistics to test the null hypothesis that the residuals are normally distributed // sign p-value = non normal residuals. // results: non normal residuals

<<<<<<< HEAD
		varstable, graph // results: alright.

=======
>>>>>>> master

vargranger //  Granger causality Wald tests // 'excluded causes 'equation.' // this is the main finding



****************************
* IMPULSE RESPONSE FUNCTIONS from VAR
****************************

* create IRF "object"
<<<<<<< HEAD
irf create Chile, step(5) set(Chile, replace)

// 'simple' IRF
irf graph irf, impulse(D.constmanufact) response(D.constagricult) byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Chile_Man_Agr, replace) title("") subtitle("Response of Agriculture to Industry") xmtick(##10) xmtick(##5) ylabel(#5) ytick(#5) ymtick(#3) yscale(range(-1(.1)2)) xscale(range(0(1)5)) 
irf graph irf, impulse(D.constagricult) response(D.constmanufact) note("") byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Chile_Agr_Man, replace) title("") subtitle("Response of Industry to Agriculture")  xmtick(##10) xmtick(##5) ylabel(#5) ytick(#5) ymtick(#3) yscale(range(-1(.1)2)) xscale(range(0(1)5)) 
=======
irf create Chile, step(10) set(Chile, replace)

// 'simple' IRF
irf graph irf, impulse(D.constmanufact) response(D.constagricult) byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Chile_Man_Agr, replace) title("") subtitle("Response of Agriculture to Industry") noci xmtick(##10) ymtick(##5) 
irf graph irf, impulse(D.constagricult) response(D.constmanufact) note("") byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Chile_Agr_Man, replace) title("") subtitle("Response of Industry to Agriculture")  noci xmtick(##10) ymtick(##5)
>>>>>>> master
gr combine irf_ce_Chile_Man_Agr.gph  irf_ce_Chile_Agr_Man.gph, col(2) saving(Chile_irf_VAR, replace) title("Chile")
graph export "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/Chile_irf_VAR.pdf", replace


// residuals appear to be normal.
// capture drop ce1_chile 
// predict ce1_chile, ce equation(_ce1)
// tsline ce1_chile, yline(0) ytitle("Disequilibria")


// IRF
// THESE PLOTS IN GENERAL SUGGEST THAT INDUSTRY TAKES LONGER TO ADJUST
// THIS COULD BE BECAUSE THEY NEED TO ADJUST A MUCH SLOWER FACTOR, I.E.
// TECHNOLOGY.

// However, the plot does show that once agriculture 

// orthogonalized IRF's
// irf graph irf, impulse(constmanufact) response(constagricult) saving(oirf_ce_Chile_Man_Agr, replace) title("Chile: Response of Agriculture")
// irf graph oirf, impulse(constagricult) response(constmanufact) saving(oirf_ce_Chile_Agr_Man, replace) title("Chile: Response of Manufacture")
// gr combine oirf_ce_Chile_Man_Agr.gph  oirf_ce_Chile_Agr_Man.gph, col(2) saving(oirf, replace) title("OIRF")


// keep working on this, and plot the two stuff together, 
// modify the Y-scales for all plots.

// FORECASTING
// fcast compute O_, step(20) replace
// fcast graph O_D_constmanufact O_D_constagricult


************************************
////////// DCC Models //////////////
************************************

// Dynamic conditional correlation multivariate GARCH models


// Series have to be longer than 100 datapoints.
// Dynamic correlation: positive, negative, null.

// Steps

/// First: make sure series are stationary (take difference 1st if nec.)
///			Use ARIMA/ARFIMA and reach stationarity.
			
/// Second: Test whether correlations are constant over time.
/// 		If not constant, estimate DCC (using Tse LM test).
///			Use "mgarch dcc" comand. 


// Checking for stationarity (whole seires)


/*

clear all
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta"

* keep only Chile and before 1970.
keep if country == 4


* set ts data
tsset, clear /* lets clean prior settings, if any */
tsset year


* Plot the data 
tsline constagricult constmanufact, title("Chile") ytitle("Output")


** sign. pvalue = stationarity

** Tested with both, but no difference (except for Guatemala, manufacture
*** trend
*** drift

** 
dfuller constmanufact // I(1)
dfuller constmanufact, drift // I(1)
dfuller constmanufact, trend // I(1)
// conclusion: I(1)

dfuller constagricult // I(1)
dfuller constagricult, drift // I(1)
dfuller constagricult, trend // I(1)
// conclusion: I(1)

// All of them I(1), take first difference.


** 
dfuller D.constmanufact // stationary
dfuller D.constmanufact, drift // stationary
dfuller D.constmanufact, trend // stationary
// conclusion: stationary

dfuller D.constagricult // stationary
dfuller D.constagricult, drift // stationary
dfuller D.constagricult, trend // stationary
// conclusion: stationary


// Check for GARCH effects

arch constmanufact,  arch(1) /* ar(1) */ // IT SEEMS TO BE ARCH ORDER 1
capture drop residuals
predict residuals, r
tsline residuals
// Checked for ar(X), but asrch(1) seems to capture this series well "enough"


// Fit "mgarch dcc" model 

// Do I have Integration or Fractional Integration? Fit an arfima model

arfima constmanufact // d= .49 (fractionally integrated??)
arfima constagricult // d= .49 (fractionally integrated??)



// mgarch dcc
mgarch dcc (constmanufact = constagricult), arch(1/4)

mgarch dcc (constmanufact constagricult = L.constmanufact L.constagricult), arch(1/2)

mgarch dcc (constmanufact constagricult = D.constmanufact D.constagricult), arch(1)


mgarch dcc (constmanufact constagricult = , noconstant arch(1))




capture drop xb
predict xb, xb
tsline xb




capture drop mgarch_man_agr
predict mgarch_man_agr, xb


mgarch dcc (constagricult = constmanufact), arch(1)
capture drop mgarch_agr_man
predict mgarch_agr_man,  xb

tsline mgarch_man_agr mgarch_agr_man


************************************
////////// ADL-Bounds //////////////
************************************


clear all
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta"

* keep only Chile and before 1970.
keep if country == 4 &  year <= 1970

* set ts data
tsset, clear /* lets clean prior settings, if any */
tsset year



* Test for I(0):
dfuller constmanufact, regress drift lags(1) // I(1)
pperron constmanufact, regress lags(1) // I(1) w/o drift
// dfgls constmanufact, maxlag(1) // I(1) w/ trend
// dfgls constmanufact, not maxlag(1) // I(1) w/o trend
// dfgls constmanufact, ers maxlag(1) // I(1)


kpss constmanufact, maxlag(3) // I(1)
** Conclusion: constmanufact is I(1)

*/





********************************************************************************************************************************************
* 																 V	 E 	 N 	 E 	 Z 	 U 	 E 	 L 	 A
********************************************************************************************************************************************




****************************
* UNIT ROOT TESTS
****************************

* VENEZUELA
cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
keep if country==20

* set ts data
tsset, clear
tsset year, yearly


************
* ADF
************

** MacKinnon approximate sign. p-value = stationarity

** 
dfuller constmanufact, lag(1) reg // I(1)
dfuller constmanufact, lag(1) reg drift // I(1)
dfuller constmanufact, lag(1) reg trend // trend is significant // I(1)
// conclusion: I(1)

dfuller constagricult, lag(1) reg // I(1)
dfuller constagricult, lag(1) reg drift // I(1)
dfuller constagricult, lag(1) reg trend // trend is significant // I(1)
// conclusion: I(1)


************
* Phillips–Perron // See Phillips (1987) and Phillips and Perron (1988)
************

** MacKinnon approximate sign. p-value = stationarity

** 
pperron constmanufact, lag(1) reg // I(1)
pperron constmanufact, lag(1) reg trend // I(1) // trend is significant
// conclusion: I(1)

pperron constagricult, lag(1) reg // I(1)
pperron constagricult, lag(1) reg trend // I(1) // trend is significant
// conclusion: I(1)



************
* KPSS  \\  Kwiatkowski, Phillips, Schmidt, and Shin (KPSS, 1992)
************

* null hypothesis of stationarity \\ statistic > critical value = nonstationary/integrated/unit root

** 
// search kpss ado
kpss constmanufact // I(1)
kpss constmanufact, qs auto // I(1)
// conclusion: I(1)

kpss constagricult // I(1)
kpss constagricult, qs auto // I(1)
// conclusion: I(1)




************
* GLS detrended augmented Dickey–Fuller test // See Elliott et al. (1996)
************

* null hypothesis of stationarity \\ statistic > critical value = nonstationary/integrated/unit root


** 
// search dfgls ado
dfgls constmanufact, maxlag(3) // I(1)
dfgls constmanufact, maxlag(3) trend //  I(1)
// conclusion: I(1)

dfgls constagricult, maxlag(3) // I(1)
dfgls constagricult, maxlag(3) trend // I(1)
// conclusion: I(1)


****************************
* ECM // Engle-Granger via OLS
****************************

** Cointegrating Regression -- First stage
reg constmanufact constagricult // averiguar bien como se hace esta etapa: mande un mail a Janet Box-St. Nov 21st. 2016.
capture drop res*
predict res_Venezuela, res

// testing stationarity of cointegrating vector: Janet Box-St.'s book, p. 161, eq. 6.11 // 
// reg d.res_Venezuela l.res_Venezuela // p-value no sign: no cointegration

** Second Stage
reg D.constmanufact L(1/3)D.constagricult L(1/3)D.constmanufact L.res_Venezuela // eq 1
reg D.constagricult L(1/3)D.constmanufact L(1/3)D.constagricult L.res_Venezuela // eq 2



****************************
*  ECM // via Johansen's MLE procedure.
****************************

* 
<<<<<<< HEAD
varsoc constmanufact constagricult, maxlag(5) // lag 2  // test for lag lenght
=======
varsoc constmanufact constagricult, maxlag(10) // lag 2  // test for lag lenght
>>>>>>> master
vecrank constmanufact constagricult, lags(2) max trend(rc) // with restricted constant // rank 1: This is the number of cointegrating vectors in the system. // from STATA Manual: "By adding the restriction that gamma = 0, we assume there are no linear time trends in the levels of the data. This specification allows the cointegrating equations to be stationary around a constant mean, but it allows no other trends or constant terms" // report LL and significance level
vec constmanufact constagricult, alpha rank(1) lags(2) trend(rc)  // this combination gives me good residuals.
// interpreation: cuando los dos sectores se separan, el sector IND se desacelera mas rapido que el sector AGR. El precio de la comida afecta el supply of food to the industrial sector, limiting its rising.

// post-estimation
	veclmar // results: alright.

	vecnorm // results: alright.

	vecstable, graph // results: alright.


// restricted constant in which there is no linear or quadratic trend in the undifferenced data fits the data best. see graph below.
// interpreation: agr is NEGATIVE and SIGNIFICANT, that is, when the industrial sector grows, the agr sector catches up GOING DOWN, not 'growing even faster.'
// interpreation: agr is POSITIVE and SIGNIFICANT, that is, when the industrial sector grows, the agr sector catches up GOING UP, trying to 'grow even faster.'


// Disequilibria graph
// residuals appear to be normal ?
capture drop ce1_Venezuela 
predict ce1_Venezuela, ce equation(_ce1)
tsline ce1_Venezuela, yline(0) ytitle("Disequilibria")


****************************
* IMPULSE RESPONSE FUNCTIONS from VECM
****************************

* create IRF "object"
irf create Venezuela, step(10) set(Venezuela, replace)

// 'simple' IRF
// irf graph irf, impulse(constmanufact) response(constagricult) byopts(note("") legend(off)) xtitle(Years)  saving(irf_ce_Venezuela_Man_Agr, replace) title("") subtitle("Response of Agriculture to Industry")
// irf graph irf, impulse(constagricult) response(constmanufact) note("") byopts(note("") legend(off)) xtitle(Years)  saving(irf_ce_Venezuela_Agr_Man, replace)  subtitle("Response of Industry to Agriculture") title("")
// gr combine irf_ce_Venezuela_Man_Agr.gph  irf_ce_Venezuela_Agr_Man.gph, col(2) saving(Venezuela_irf_ECM, replace) title("Venezuela")
// graph export "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/Venezuela_irf_ECM.pdf", replace


****************************
* VAR
****************************

* 
var d.constmanufact d.constagricult, lags(1/2) // put the differenced variables (as the STATA manual does). // put this in appendix


	varlmar, mlag(5) // implements a Lagrange multiplier (LM) test for autocorrelation in the residuals of VAR models, which was presented in Johansen (1995) // no significative, no model specification // results: no evidence of model misspecification.

	varnorm // Compute Jarque–Bera, skewness, and kurtosis statistics to test the null hypothesis that the residuals are normally distributed // sign p-value = non normal residuals. // results: normal residuals

<<<<<<< HEAD
	varstable

=======
>>>>>>> master
vargranger //  Granger causality Wald tests // 'excluded causes 'equation.' // this is the main finding: AGR does NOT cause IND, IND causes AGR.

****************************
* IMPULSE RESPONSE FUNCTIONS from VAR
****************************

* create IRF "object"
irf create Venezuela, step(5) set(Venezuela, replace)

// 'simple' IRF
<<<<<<< HEAD
irf graph irf, impulse(D.constmanufact) response(D.constagricult) byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Venezuela_Man_Agr, replace) subtitle("Response of Agriculture to Industry") title("") xmtick(##5) ytick(#5) ymtick(#3) yscale(range(-2(.1)2)) xscale(range(0(1)5))
irf graph irf, impulse(D.constagricult) response(D.constmanufact) byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Venezuela_Agr_Man, replace) subtitle("Response of Industry to Agriculture") title("") xmtick(##5) ytick(#5) ymtick(#3) yscale(range(-2(.1)2)) xscale(range(0(1)5))
=======
irf graph irf, impulse(D.constmanufact) response(D.constagricult) byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Venezuela_Man_Agr, replace) subtitle("Response of Agriculture to Industry") title("") noci xmtick(##5) ymtick(##3)
irf graph irf, impulse(D.constagricult) response(D.constmanufact) note("") byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Venezuela_Agr_Man, replace)  subtitle("Response of Industry to Agriculture") title("") noci xmtick(##5) ymtick(##3)
>>>>>>> master
gr combine irf_ce_Venezuela_Man_Agr.gph  irf_ce_Venezuela_Agr_Man.gph, col(2) saving(Venezuela_irf_VAR, replace) title("Venezuela")
graph export "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/Venezuela_irf_VAR.pdf", replace




********************************************************************************************************************************************
* 																	P 	 	E 	  R 	 U 
********************************************************************************************************************************************




****************************
* UNIT ROOT TESTS
****************************

* PERU

cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
keep if country==17

* set ts data
tsset, clear
tsset year, yearly


************
* ADF
************

** MacKinnon approximate sign. p-value = stationarity

** 
dfuller constmanufact, lag(1) reg // I(1)
dfuller constmanufact, lag(1) reg drift // I(1)
dfuller constmanufact, lag(1) reg trend // trend is significant // I(1)
// conclusion: I(1), no trend.

dfuller constagricult, lag(1) reg // I(1)
dfuller constagricult, lag(1) reg drift // I(1)
dfuller constagricult, lag(1) reg trend // trend is NOT significant // I(1)
// conclusion: I(1), no trend.


************
* Phillips–Perron // See Phillips (1987) and Phillips and Perron (1988)
************

** MacKinnon approximate sign. p-value = stationarity

** 
pperron constmanufact, lag(1) reg // I(1)
pperron constmanufact, lag(1) reg trend // I(1) // trend is significant at 10% level.
// conclusion: I(1)

pperron constagricult, lag(1) reg // I(1)
pperron constagricult, lag(1) reg trend // I(1) // trend is NOT significant
// conclusion: I(1), no trend.



************
* KPSS  \\  Kwiatkowski, Phillips, Schmidt, and Shin (KPSS, 1992)
************

* null hypothesis of stationarity \\ statistic > critical value = nonstationary/integrated/unit root

** 
// search kpss ado
kpss constmanufact // I(1)
kpss constmanufact, qs auto // I(1) @ 5%, but I(0) @ 10%
// conclusion: ?

kpss constagricult // I(1)
kpss constagricult, qs auto // I(1)
// conclusion: I(1)




************
* GLS detrended augmented Dickey–Fuller test // See Elliott et al. (1996)
************

* null hypothesis of stationarity \\ statistic > critical value = nonstationary/integrated/unit root


** 
// search dfgls ado
dfgls constmanufact, maxlag(3) // I(1)
dfgls constmanufact, maxlag(3) trend //  I(1)
// conclusion: I(1)

dfgls constagricult, maxlag(3) // I(1)
dfgls constagricult, maxlag(3) trend // I(1)
// conclusion: I(1)


****************************
* ECM // Engle-Granger via OLS
****************************

** Cointegrating Regression -- First stage
reg constmanufact constagricult // averiguar bien como se hace esta etapa: mande un mail a Janet Box-St. Nov 21st. 2016.
capture drop res*
predict res_Peru, res

// testing stationarity of cointegrating vector: Janet Box-St.'s book, p. 161, eq. 6.11 // 
// reg d.res_Peru l.res_Peru // p-value no sign: no cointegration

** Second Stage
reg D.constmanufact L(1/3)D.constagricult L(1/3)D.constmanufact L.res_Peru // eq 1
reg D.constagricult L(1/3)D.constmanufact L(1/3)D.constagricult L.res_Peru // eq 2



****************************
*  ECM // via Johansen's MLE procedure.
****************************

* 
varsoc constmanufact constagricult, maxlag(5) // lag 1  // test for lag lenght
vecrank constmanufact constagricult, lags(5) max // given prior tests, I will not include a trend term // rank 1: This is the number of cointegrating vectors in the system. // from STATA Manual: "By adding the restriction that gamma = 0, we assume there are no linear time trends in the levels of the data. This specification allows the cointegrating equations to be stationary around a constant mean, but it allows no other trends or constant terms" // report LL and significance level
vec constmanufact constagricult, alpha rank(1) lags(5) trend(t)  // it does not matter the trend I put, all results are the same.

// post-estimation
<<<<<<< HEAD
	// veclmar // results: won't compute.

	// vecnorm // results: won't compute.
=======
	veclmar // results: won't compute.

	vecnorm // results: won't compute.
>>>>>>> master

	vecstable, graph // results: alright.



// Disequilibria graph
// residuals appear to be normal ?
capture drop ce1_Peru 
predict ce1_Peru, ce equation(_ce1)
tsline ce1_Peru, yline(0) ytitle("Disequilibria")


****************************
* IMPULSE RESPONSE FUNCTIONS from VECM
****************************

* create IRF "object"
// irf create Peru, step(5) set(Peru, replace)

// 'simple' IRF
// irf graph irf, impulse(constmanufact) response(constagricult) byopts(note("") legend(off)) xtitle(Years)  saving(// irf_ce_Peru_Man_Agr, replace) title("") subtitle("Response of Agriculture to Industry")
// irf graph irf, impulse(constagricult) response(constmanufact) note("") byopts(note("") legend(off)) xtitle(Years)  saving(irf_ce_Peru_Agr_Man, replace)  subtitle("Response of Industry to Agriculture") title("")
// gr combine irf_ce_Peru_Man_Agr.gph  irf_ce_Peru_Agr_Man.gph, col(2) saving(Peru_irf_VEC, replace) title("Peru")
// graph export "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/Peru_irf_VEC.pdf", replace


****************************
* VAR
****************************

* 
var d.constmanufact d.constagricult, lags(1) // put the differenced variables (as the STATA manual does). // put this in appendix

// post-estimation
	varlmar, mlag(6) // results: it's OK.

	varnorm // results: non normal residuals.

	varstable, graph // results: alright.



vargranger //  Granger causality Wald tests // 'excluded causes 'equation.' // this is the main finding: AGR does NOT cause IND, IND causes AGR.


****************************
* IMPULSE RESPONSE FUNCTIONS from VAR
****************************

* create IRF "object"
irf create Peru, step(5) set(Peru, replace)

// 'simple' IRF
<<<<<<< HEAD
irf graph irf, impulse(D.constmanufact) response(D.constagricult) byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Peru_Man_Agr, replace) subtitle("Response of Agriculture to Industry") title("") ylabel(#4) xmtick(##2) ytick(#4) ymtick(#4) yscale(range(-.5(.1).5)) xscale(range(0(1)5))
irf graph irf, impulse(D.constagricult) response(D.constmanufact) byopts(note("") legend(off)) xtitle(Years)  saving(irf_ce_Peru_Agr_Man, replace)  subtitle("Response of Industry to Agriculture") title("") ylabel(#4) xmtick(##2) ytick(#4) ymtick(#4) yscale(range(-.5(.1).5)) xscale(range(0(1)5))
=======
irf graph irf, impulse(D.constmanufact) response(D.constagricult) byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Peru_Man_Agr, replace) subtitle("Response of Agriculture to Industry") title("") noci xmtick(##5) ymtick(##3)
irf graph irf, impulse(D.constagricult) response(D.constmanufact) note("") byopts(note("") legend(off)) xtitle(Years)  saving(irf_ce_Peru_Agr_Man, replace)  subtitle("Response of Industry to Agriculture") title("") noci xmtick(##5) ymtick(##3)
>>>>>>> master
gr combine irf_ce_Peru_Man_Agr.gph  irf_ce_Peru_Agr_Man.gph, col(2) saving(Peru_irf_VAR, replace) title("Peru")
graph export "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/Peru_irf_VAR.pdf", replace



********************************************************************************************************************************************
* 															N	 I 	 C 	 A 	 R 	 A 	 G 	 U 	 A
********************************************************************************************************************************************




****************************
* UNIT ROOT TESTS
****************************

* NICARAGUA
cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
keep if country==14

* set ts data
tsset, clear
tsset year, yearly


************
* ADF
************

** MacKinnon approximate sign. p-value = stationarity

** 
dfuller constmanufact, lag(1) reg // I(1)
dfuller constmanufact, lag(1) reg drift // I(1)
dfuller constmanufact, lag(1) reg trend // I(1) // trend is significant at 10% // 
// conclusion: I(1)

dfuller constagricult, lag(1) reg // I(1)
dfuller constagricult, lag(1) reg drift // I(1)
dfuller constagricult, lag(1) reg trend // I(1) // trend IS significant // 
// conclusion: I(1)


************
* Phillips–Perron // See Phillips (1987) and Phillips and Perron (1988)
************

** MacKinnon approximate sign. p-value = stationarity

** 
pperron constmanufact, lag(1) reg // I(1)
pperron constmanufact, lag(1) reg trend // I(1)  // trend IS significant @ 10%.
// conclusion: I(1)

pperron constagricult, lag(1) reg // I(1)
pperron constagricult, lag(1) reg trend //  // trend IS significant @ 10%.
// conclusion: I(1)



************
* KPSS  \\  Kwiatkowski, Phillips, Schmidt, and Shin (KPSS, 1992)
************

* null hypothesis of stationarity \\ statistic > critical value = nonstationary/integrated/unit root

** 
// search kpss ado
kpss constmanufact // I(1)
kpss constmanufact, qs auto // I(1)
// conclusion: I(1)

kpss constagricult // I(1)
kpss constagricult, qs auto // I(1)
// conclusion: I(1)




************
* GLS detrended augmented Dickey–Fuller test // See Elliott et al. (1996)
************

* null hypothesis of stationarity \\ statistic > critical value = nonstationary/integrated/unit root


** 
// search dfgls ado
dfgls constmanufact, maxlag(3) // I(1)
dfgls constmanufact, maxlag(3) trend //  I(1)
// conclusion: I(1)

dfgls constagricult, maxlag(3) // I(1)
dfgls constagricult, maxlag(3) trend // I(1)
// conclusion: I(1)


****************************
* ECM // Engle-Granger via OLS
****************************

** Cointegrating Regression -- First stage
reg constmanufact constagricult // averiguar bien como se hace esta etapa: mande un mail a Janet Box-St. Nov 21st. 2016.
capture drop res*
predict res_Nicaragua, res

// testing stationarity of cointegrating vector: Janet Box-St.'s book, p. 161, eq. 6.11 // 
reg d.res_Nicaragua l.res_Nicaragua // p-value no sign: no cointegration // it is integrated

** Second Stage
reg D.constmanufact L(1/3)D.constagricult L(1/3)D.constmanufact L.res_Nicaragua // eq 1
reg D.constagricult L(1/3)D.constmanufact L(1/3)D.constagricult L.res_Nicaragua // eq 2



****************************
*  ECM // via Johansen's MLE procedure.
****************************

* 
varsoc constmanufact constagricult, maxlag(5) // lag 2 // test for lag lenght
vecrank constmanufact constagricult, lags(1) max trend(n)   // given prior tests, I will include a trend term // I included all kinds of trends, and all of them gave me rank = 0 // rank 1: This is the number of cointegrating vectors in the system. // from STATA Manual: "By adding the restriction that gamma = 0, we assume there are no linear time trends in the levels of the data. This specification allows the cointegrating equations to be stationary around a constant mean, but it allows no other trends or constant terms" // report LL and significance level

vec constmanufact constagricult, alpha rank(1) lags(1) trend(n) // WILL NOT FIT, SINCE THERE ARE ZERO COINTEGRATED VECTORS.


// post-estimation
	veclmar // results: 

	vecnorm // results: 

	vecstable, graph // results: 




// Disequilibria graph
// residuals appear to be normal ?
// capture drop ce1_Nicaragua 
// predict ce1_Nicaragua, ce equation(_ce1)
// tsline ce1_Nicaragua, yline(0) ytitle("Disequilibria")


****************************
* VAR
****************************

* 
var D.constmanufact D.constagricult, lags(1) // put the differenced variables (as the STATA manual does). // put this in appendix

// post-estimation
	varlmar // results: 

	varnorm // results: 

	varstable, graph // results: 



vargranger //  Granger causality Wald tests // 'excluded causes 'equation.' // this is the main finding: AGR does NOT cause IND, IND causes AGR.

// var d.constmanufact d.constagricult, exog(l.res_Venezuela) lags(1/3)
// We can test for the absence of Granger causality by estimating a VAR model
// interpreation: both are Granger causes by the other, no real conflict exists. 

****************************
* IMPULSE RESPONSE FUNCTIONS from VAR
****************************

* create IRF "object"
irf create Nicaragua, step(3) set(Nicaragua, replace)

// 'simple' IRF
<<<<<<< HEAD
irf graph irf, impulse(D.constmanufact) response(D.constagricult) byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Nicaragua_Man_Agr, replace) subtitle("Response of Agriculture to Industry") title("") ylabel(#5) ytick(#5) ymtick(#3) yscale(range(-.5(.1)1)) xscale(range(0(1)3))
irf graph irf, impulse(D.constagricult) response(D.constmanufact) byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Nicaragua_Agr_Man, replace)  subtitle("Response of Industry to Agriculture") title("") ylabel(#5) ytick(#5) ymtick(#3) yscale(range(-.5(.1)1)) xscale(range(0(1)3))
=======
irf graph irf, impulse(D.constmanufact) response(D.constagricult) byopts(note("") legend(off)) xtitle(Years) /*ytitle(Impulse Response)*/ saving(irf_ce_Nicaragua_Man_Agr, replace) subtitle("Response of Agriculture to Industry") title("") noci xmtick(##5) ymtick(##3)
irf graph irf, impulse(D.constagricult) response(D.constmanufact) note("") byopts(note("") legend(off)) xtitle(Years) /*ytitle(Impulse Response)*/ saving(irf_ce_Nicaragua_Agr_Man, replace)  subtitle("Response of Industry to Agriculture") title("") noci xmtick(##5) ymtick(##3)
>>>>>>> master
gr combine irf_ce_Nicaragua_Man_Agr.gph  irf_ce_Nicaragua_Agr_Man.gph, col(2) saving(Nicaragua_irf_VAR, replace) title("Nicaragua")
graph export "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/Nicaragua_irf_VAR.pdf", replace



********************************************************************************************************************************************
* 															G 	U 	A 	T 	E 	M 	A 	L 	A
********************************************************************************************************************************************




****************************
* UNIT ROOT TESTS
****************************

* GUATEMALA
cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
keep if country==10

* set ts data
tsset, clear
tsset year, yearly


************
* ADF
************

** MacKinnon approximate sign. p-value = stationarity

** 
dfuller constmanufact, lag(1) reg // I(1)
dfuller constmanufact, lag(1) reg drift // I(1)
dfuller constmanufact, lag(1) reg trend // I(1) // trend IS significant // 
// conclusion: I(1)

dfuller constagricult, lag(1) reg // I(1)
dfuller constagricult, lag(1) reg drift // I(1)
dfuller constagricult, lag(1) reg trend // I(1) // trend IS NOT significant // 
// conclusion: I(1)


************
* Phillips–Perron // See Phillips (1987) and Phillips and Perron (1988)
************

** MacKinnon approximate sign. p-value = stationarity

** 
pperron constmanufact, lag(1) reg // I(1)
pperron constmanufact, lag(1) reg trend // I(1)  // trend IS significant
// conclusion: I(1)

pperron constagricult, lag(1) reg // I(1)
pperron constagricult, lag(1) reg trend // I(1) // trend IS NOT significant
// conclusion: I(1)



************
* KPSS  \\  Kwiatkowski, Phillips, Schmidt, and Shin (KPSS, 1992)
************

* null hypothesis of stationarity \\ statistic > critical value = nonstationary/integrated/unit root

** 
// search kpss ado
kpss constmanufact // I(1)
kpss constmanufact, qs auto // I(1)
// conclusion: I(1)

kpss constagricult // I(1)
kpss constagricult, qs auto // I(1)
// conclusion: I(1)




************
* GLS detrended augmented Dickey–Fuller test // See Elliott et al. (1996)
************

* null hypothesis of stationarity \\ statistic > critical value = nonstationary/integrated/unit root


** 
// search dfgls ado
dfgls constmanufact, maxlag(3) // I(1)
dfgls constmanufact, maxlag(3) trend //  I(1)
// conclusion: I(1)

dfgls constagricult, maxlag(3) // I(1)
dfgls constagricult, maxlag(3) trend // I(1)
// conclusion: I(1)


****************************
* ECM // Engle-Granger via OLS
****************************

** Cointegrating Regression -- First stage
reg constmanufact constagricult // averiguar bien como se hace esta etapa: mande un mail a Janet Box-St. Nov 21st. 2016.
capture drop res*
predict res_Guatemala, res

tsline res_Guatemala


// testing stationarity of cointegrating vector: Janet Box-St.'s book, p. 161, eq. 6.11 // 
reg d.res_Guatemala l.res_Guatemala // p-value no sign: no cointegration // it is integrated

** Second Stage
reg D.constmanufact L(1/2)D.constagricult L(1/2)D.constmanufact L.res_Guatemala // eq 1
reg D.constagricult L(1/2)D.constmanufact L(1/2)D.constagricult L.res_Guatemala // eq 2



****************************
*  ECM // via Johansen's MLE procedure.
****************************

* 
varsoc constmanufact constagricult, maxlag(5) // lag 3 // test for lag lenght
vecrank constmanufact constagricult, lags(1) max trend(t) // report LL and significance level

// lag 1, t
// lag 3, rt


vec constmanufact constagricult, alpha rank(1) lags(3) trend(rt) // 

// post-estimation
	veclmar // results: alright.

	vecnorm // results: non-normal residuals.

	vecstable, graph // results: alright.


// Disequilibria graph
// residuals appear to be normal ?
// capture drop ce1_Guatemala 
// predict ce1_Guatemala, ce equation(_ce1)
// tsline ce1_Guatemala, yline(0) ytitle("Disequilibria")


****************************
* VAR
****************************

* 
<<<<<<< HEAD
var D.constmanufact D.constagricult, lags(1)  // put the differenced variables (as the STATA manual does). // put this in appendix
=======
var D.constmanufact D.constagricult, lags(2)  // put the differenced variables (as the STATA manual does). // put this in appendix
>>>>>>> master

// post-estimation
	varlmar // results: 

	varnorm // results:

	varstable, graph // results: 



vargranger //  Granger causality Wald tests // 'excluded causes 'equation.' // this is the main finding: AGR does NOT cause IND, IND causes AGR.

// var d.constmanufact d.constagricult, exog(l.res_Guatemala) lags(1/3)
// We can test for the absence of Granger causality by estimating a VAR model
// interpreation: both are Granger causes by the other, no real conflict exists. 

****************************
* IMPULSE RESPONSE FUNCTIONS from VAR
****************************

* create IRF "object"
irf create Guatemala, step(5) set(Guatemala, replace)
<<<<<<< HEAD
* HERE
// 'simple' IRF // 
irf graph irf, impulse(D.constmanufact) response(D.constagricult) byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Guatemala_Man_Agr, replace) subtitle("Response of Agriculture to Industry") title("") ymtick(#3) xmtick(#3) xlabel(#5)  yscale(range(-.5(.2)1)) xscale(range(0(1)5)) 
irf graph irf, impulse(D.constagricult) response(D.constmanufact) byopts(note("") legend(off)) xtitle(Years)  saving(irf_ce_Guatemala_Agr_Man, replace) subtitle("Response of Industry to Agriculture") title("") ymtick(#3) xmtick(#3) xlabel(#5) yscale(range(-.5(.2)1)) xscale(range(0(1)5)) 
=======

// 'simple' IRF
irf graph irf, impulse(D.constmanufact) response(D.constagricult) byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Guatemala_Man_Agr, replace) subtitle("Response of Agriculture to Industry") title("") noci xmtick(##5) ymtick(##3)
irf graph irf, impulse(D.constagricult) response(D.constmanufact) byopts(note("") legend(off)) xtitle(Years)  saving(irf_ce_Guatemala_Agr_Man, replace) subtitle("Response of Industry to Agriculture") title("") noci xmtick(##5) ymtick(##3)
>>>>>>> master
gr combine irf_ce_Guatemala_Man_Agr.gph  irf_ce_Guatemala_Agr_Man.gph, col(2) saving(Guatemala_irf_VAR, replace) title("Guatemala")
graph export "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/Guatemala_irf_VAR.pdf", replace






********************************************************************************************************************************************
* 															N	 I 	 C 	 A 	 R 	 A 	 G 	 U 	 A
********************************************************************************************************************************************




****************************
* UNIT ROOT TESTS
****************************

* NICARAGUA
cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
keep if country==14

* set ts data
tsset, clear
tsset year, yearly


************
* ADF
************

** MacKinnon approximate sign. p-value = stationarity

** 
dfuller constmanufact, lag(1) reg // I(1)
dfuller constmanufact, lag(1) reg drift // I(1)
dfuller constmanufact, lag(1) reg trend // I(1) // trend is significant at 10% // 
// conclusion: I(1)

dfuller constagricult, lag(1) reg // I(1)
dfuller constagricult, lag(1) reg drift // I(1)
dfuller constagricult, lag(1) reg trend // I(1) // trend IS significant // 
// conclusion: I(1)


************
* Phillips–Perron // See Phillips (1987) and Phillips and Perron (1988)
************

** MacKinnon approximate sign. p-value = stationarity

** 
pperron constmanufact, lag(1) reg // I(1)
pperron constmanufact, lag(1) reg trend // I(1)  // trend IS significant @ 10%.
// conclusion: I(1)

pperron constagricult, lag(1) reg // I(1)
pperron constagricult, lag(1) reg trend //  // trend IS significant @ 10%.
// conclusion: I(1)



************
* KPSS  \\  Kwiatkowski, Phillips, Schmidt, and Shin (KPSS, 1992)
************

* null hypothesis of stationarity \\ statistic > critical value = nonstationary/integrated/unit root

** 
// search kpss ado
kpss constmanufact // I(1)
kpss constmanufact, qs auto // I(1)
// conclusion: I(1)

kpss constagricult // I(1)
kpss constagricult, qs auto // I(1)
// conclusion: I(1)




************
* GLS detrended augmented Dickey–Fuller test // See Elliott et al. (1996)
************

* null hypothesis of stationarity \\ statistic > critical value = nonstationary/integrated/unit root


** 
// search dfgls ado
dfgls constmanufact, maxlag(3) // I(1)
dfgls constmanufact, maxlag(3) trend //  I(1)
// conclusion: I(1)

dfgls constagricult, maxlag(3) // I(1)
dfgls constagricult, maxlag(3) trend // I(1)
// conclusion: I(1)


****************************
* ECM // Engle-Granger via OLS
****************************

** Cointegrating Regression -- First stage
reg constmanufact constagricult // averiguar bien como se hace esta etapa: mande un mail a Janet Box-St. Nov 21st. 2016.
capture drop res*
predict res_Nicaragua, res

// testing stationarity of cointegrating vector: Janet Box-St.'s book, p. 161, eq. 6.11 // 
reg d.res_Nicaragua l.res_Nicaragua // p-value no sign: no cointegration // it is integrated

** Second Stage
reg D.constmanufact L(1/3)D.constagricult L(1/3)D.constmanufact L.res_Nicaragua // eq 1
reg D.constagricult L(1/3)D.constmanufact L(1/3)D.constagricult L.res_Nicaragua // eq 2



****************************
*  ECM // via Johansen's MLE procedure.
****************************

* 
varsoc constmanufact constagricult, maxlag(5) // lag 1 or 2 // test for lag lenght
vecrank constmanufact constagricult, lags(1) max trend(n) // report LL and significance level

vec constmanufact constagricult, alpha rank(1) lags(1) trend(n)


// post-estimation
	veclmar // results: 

	vecnorm // results:

	vecstable, graph // results: 



// Disequilibria graph
// residuals appear to be normal ?
// capture drop ce1_Nicaragua 
// predict ce1_Nicaragua, ce equation(_ce1)
// tsline ce1_Nicaragua, yline(0) ytitle("Disequilibria")


****************************
* VAR
****************************

* 
var D.constmanufact D.constagricult, lags(1) // put the differenced variables (as the STATA manual does). // put this in appendix


// post-estimation
	varlmar // results: 

	varnorm // results:

	varstable, graph // results: 




vargranger //  Granger causality Wald tests // 'excluded causes 'equation.' // this is the main finding: AGR does NOT cause IND, IND causes AGR.

// var d.constmanufact d.constagricult, exog(l.res_Venezuela) lags(1/3)
// We can test for the absence of Granger causality by estimating a VAR model
// interpreation: both are Granger causes by the other, no real conflict exists. 

****************************
* IMPULSE RESPONSE FUNCTIONS from VAR
****************************

* create IRF "object"
irf create Nicaragua, step(5) set(Nicaragua, replace)

// 'simple' IRF
<<<<<<< HEAD
irf graph irf, impulse(D.constmanufact) response(D.constagricult) byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Nicaragua_Man_Agr, replace) subtitle("Response of Agriculture to Industry") title("") xmtick(##5) ytick(#5) ymtick(#3) yscale(range(-.5(.2)1)) xscale(range(0(1)5)) 
irf graph irf, impulse(D.constagricult) response(D.constmanufact) note("") byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Nicaragua_Agr_Man, replace)  subtitle("Response of Industry to Agriculture") title("") xmtick(##5) ytick(#5) ymtick(#3) yscale(range(-.5(.2)1)) xscale(range(0(1)5)) 
=======
irf graph irf, impulse(D.constmanufact) response(D.constagricult) byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Nicaragua_Man_Agr, replace) subtitle("Response of Agriculture to Industry") title("") noci xmtick(##5) ymtick(##3)
irf graph irf, impulse(D.constagricult) response(D.constmanufact) note("") byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Nicaragua_Agr_Man, replace)  subtitle("Response of Industry to Agriculture") title("") noci xmtick(##5) ymtick(##3)
>>>>>>> master
gr combine irf_ce_Nicaragua_Man_Agr.gph  irf_ce_Nicaragua_Agr_Man.gph, col(2) saving(Nicaragua_irf_VAR, replace) title("Nicaragua")
graph export "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/Nicaragua_irf_VAR.pdf", replace



********************************************************************************************************************************************
* 																	E	C 	U 	A 	D 	O 	R
********************************************************************************************************************************************




****************************
* UNIT ROOT TESTS
****************************

* ECUADOR
cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
keep if country==8

* set ts data
tsset, clear
tsset year, yearly


************
* ADF
************

** MacKinnon approximate sign. p-value = stationarity

** 
dfuller constmanufact, lag(1) reg // I(1)
dfuller constmanufact, lag(1) reg drift // I(1)
dfuller constmanufact, lag(1) reg trend // I(1) // trend IS significant // 
// conclusion: I(1)

dfuller constagricult, lag(1) reg // I(1)
dfuller constagricult, lag(1) reg drift // I(1)
dfuller constagricult, lag(1) reg trend // I(1)  // trend is NOT significant // 
// conclusion: I(1)


************
* Phillips–Perron // See Phillips (1987) and Phillips and Perron (1988)
************

** MacKinnon approximate sign. p-value = stationarity

** 
pperron constmanufact, lag(1) reg // I(1)
pperron constmanufact, lag(1) reg trend // I(1)   // trend IS significant
// conclusion: I(1)

pperron constagricult, lag(1) reg // I(1)
pperron constagricult, lag(1) reg trend // I(1)  // trend is NOT significant
// conclusion: I(1)



************
* KPSS  \\  Kwiatkowski, Phillips, Schmidt, and Shin (KPSS, 1992)
************

* null hypothesis of stationarity \\ statistic > critical value = nonstationary/integrated/unit root

** 
// search kpss ado
kpss constmanufact // I(1)
kpss constmanufact, qs auto // I(1)
// conclusion: I(1)

kpss constagricult // I(1)
kpss constagricult, qs auto // I(1)
// conclusion: I(1)




************
* GLS detrended augmented Dickey–Fuller test // See Elliott et al. (1996)
************

* null hypothesis of stationarity \\ statistic > critical value = nonstationary/integrated/unit root


** 
// search dfgls ado
dfgls constmanufact, maxlag(3) // I(1)
dfgls constmanufact, maxlag(3) trend //  I(1)
// conclusion: I(1)

dfgls constagricult, maxlag(3) // I(1)
dfgls constagricult, maxlag(3) trend // I(1)
// conclusion: I(1)


****************************
* ECM // Engle-Granger via OLS
****************************

** Cointegrating Regression -- First stage
reg constmanufact constagricult // averiguar bien como se hace esta etapa: mande un mail a Janet Box-St. Nov 21st. 2016.
capture drop res*
predict res_Ecuador, res

tsline res_Ecuador


// testing stationarity of cointegrating vector: Janet Box-St.'s book, p. 161, eq. 6.11 // 
reg d.res_Ecuador l.res_Ecuador // p-value no sign: no cointegration // it is NOT integrated

** Second Stage
reg D.constmanufact L(1/2)D.constagricult L(1/2)D.constmanufact L.res_Ecuador // eq 1
reg D.constagricult L(1/2)D.constmanufact L(1/2)D.constagricult L.res_Ecuador // eq 2



****************************
*  ECM // via Johansen's MLE procedure.
****************************

* 
varsoc constmanufact constagricult, maxlag(10) // lag 2 // test for lag lenght
vecrank constmanufact constagricult, lags(2) max trend(none) // report LL and significance level
vec constmanufact constagricult, alpha rank(1) lags(2) trend(n) //


// post-estimation
	veclmar // results: no serial correlation.

	vecnorm // results: non normal residuals

	vecstable, graph // results: more or less fine.





// Disequilibria graph
// residuals appear to be normal ?
// capture drop ce1_Ecuador 
// predict ce1_Ecuador, ce equation(_ce1)
// tsline ce1_Ecuador, yline(0) ytitle("Disequilibria")


// irf from ECM
// irf create Ecuador, step(3) set(Ecuador, replace)
// 'simple' IRF
// irf graph irf, impulse(constmanufact) response(constagricult) byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Ecuador_Man_Agr, replace) subtitle("Response of Agriculture to Industry") title("") noci
// irf graph irf, impulse(constagricult) response(constmanufact) note("") byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Ecuador_Agr_Man, replace)  subtitle("Response of Industry to Agriculture") title("") noci
// gr combine irf_ce_Ecuador_Man_Agr.gph  irf_ce_Ecuador_Agr_Man.gph, col(2) saving(Ecuador_irf_ECM, replace) title("Ecuador")
// graph export "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/Ecuador_irf_ECM.pdf", replace
// interpreation: Both are the same. My interpreation is that the industrial sector is not strong enough to challenge the agricultural sector and borrow labor from the traditional sector. It is in a very early stage of industrialization.

****************************
* VAR
****************************

* 
<<<<<<< HEAD
var d.constmanufact d.constagricult, lags(1 2) // put the differenced variables (as the STATA manual does). // put this in appendix


// post-estimation
	varlmar, mlag(15)  // results: ok
=======
var D.constmanufact D.constagricult, lags(1) // put the differenced variables (as the STATA manual does). // put this in appendix

// post-estimation
	varlmar // results: ok
>>>>>>> master

	varnorm // results: ok 

	varstable, graph // results: ok


vargranger //  Granger causality Wald tests // 'excluded causes 'equation.' // this is the main finding: AGR does NOT cause IND, IND causes AGR.

// var d.constmanufact d.constagricult, exog(l.res_Guatemala) lags(1/3)
// We can test for the absence of Granger causality by estimating a VAR model
// interpreation: both are Granger causes by the other, no real conflict exists. 

****************************
* IMPULSE RESPONSE FUNCTIONS from VAR
****************************

* create IRF "object"
<<<<<<< HEAD
irf create Ecuador, step(5) set(Ecuador, replace)

// 'simple' IRF
irf graph irf, impulse(D.constmanufact) response(D.constagricult) byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Ecuador_Man_Agr, replace) subtitle("Response of Agriculture to Industry") title("") xmtick(##5) ytick(#5) ymtick(#3) yscale(range(-.7(.1).7)) xscale(range(0(1)5))  
irf graph irf, impulse(D.constagricult) response(D.constmanufact) note("") byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Ecuador_Agr_Man, replace)  subtitle("Response of Industry to Agriculture") title("") xmtick(##5) ytick(#5) ymtick(#3) yscale(range(-.7(.1).7)) xscale(range(0(1)5)) 
=======
irf create Ecuador, step(10) set(Ecuador, replace)

// 'simple' IRF
irf graph irf, impulse(D.constmanufact) response(D.constagricult) byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Ecuador_Man_Agr, replace) subtitle("Response of Agriculture to Industry") title("") noci xmtick(##10) ymtick(##5)  
irf graph irf, impulse(D.constagricult) response(D.constmanufact) note("") byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Ecuador_Agr_Man, replace)  subtitle("Response of Industry to Agriculture") title("") noci xmtick(##10) ymtick(##5) 
>>>>>>> master
gr combine irf_ce_Ecuador_Man_Agr.gph  irf_ce_Ecuador_Agr_Man.gph, col(2) saving(Ecuador_irf_VAR, replace) title("Ecuador")
graph export "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/Ecuador_irf_VAR.pdf", replace
// interpretation: I think that it does not show a clear pattern. In Fact, once each series is shocked, both react in the same way. This explanation NOT contradictory with the IRF from the ECM.





********************************************************************************************************************************************
* 																C 	O 	L 	O 	M 	B 	I 	A
********************************************************************************************************************************************




****************************
* UNIT ROOT TESTS
****************************

* COLOMBIA
cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
keep if country==5

* set ts data
tsset, clear
tsset year, yearly


************
* ADF
************

** MacKinnon approximate sign. p-value = stationarity

** 
dfuller constmanufact, lag(1) reg // I(1)
dfuller constmanufact, lag(1) reg drift // I(1)
dfuller constmanufact, lag(1) reg trend // I(1)  // trend IS significant // 
// conclusion: I(1)

dfuller constagricult, lag(1) reg // I(1)
dfuller constagricult, lag(1) reg drift // I(1)
dfuller constagricult, lag(1) reg trend // I(1) // trend IS significant // 
// conclusion: I(1)


************
* Phillips–Perron // See Phillips (1987) and Phillips and Perron (1988)
************

** MacKinnon approximate sign. p-value = stationarity

** 
pperron constmanufact, lag(1) reg // I(1)
pperron constmanufact, lag(1) reg trend // I(1) // trend IS significant
// conclusion: I(1)

pperron constagricult, lag(1) reg // I(1)
pperron constagricult, lag(1) reg trend // I(1) // trend IS significant
// conclusion: I(1)



************
* KPSS  \\  Kwiatkowski, Phillips, Schmidt, and Shin (KPSS, 1992)
************

* null hypothesis of stationarity \\ statistic > critical value = nonstationary/integrated/unit root

** 
// search kpss ado
kpss constmanufact // I(1)
kpss constmanufact, qs auto // I(1)
// conclusion: I(1)

kpss constagricult // I(1)
kpss constagricult, qs auto // I(1)
// conclusion: I(1)




************
* GLS detrended augmented Dickey–Fuller test // See Elliott et al. (1996)
************

* null hypothesis of stationarity \\ statistic > critical value = nonstationary/integrated/unit root


** 
// search dfgls ado
dfgls constmanufact, maxlag(3) // I(1)
dfgls constmanufact, maxlag(3) trend //  I(1)
// conclusion: 

dfgls constagricult, maxlag(3) // I(1)
dfgls constagricult, maxlag(3) trend // I(1)
// conclusion: I(1)


****************************
* ECM // Engle-Granger via OLS
****************************

** Cointegrating Regression -- First stage
reg constmanufact constagricult // averiguar bien como se hace esta etapa: mande un mail a Janet Box-St. Nov 21st. 2016.
capture drop res*
predict res_Colombia, res

tsline res_Colombia


// testing stationarity of cointegrating vector: Janet Box-St.'s book, p. 161, eq. 6.11 // 
reg d.res_Colombia l.res_Colombia // p-value no sign: no cointegration // it IS cointegrated

** Second Stage
reg D.constmanufact L(1/2)D.constagricult L(1/2)D.constmanufact L.res_Colombia // eq 1
reg D.constagricult L(1/2)D.constmanufact L(1/2)D.constagricult L.res_Colombia // eq 2



****************************
*  ECM // via Johansen's MLE procedure.
****************************

* 
varsoc constmanufact constagricult, maxlag(10) // lag 2 // test for lag lenght
vecrank constmanufact constagricult, lags(2) max trend(rt) // given prior tests, I will not include a trend term // from STATA Manual: "By adding the restriction that gamma = 0, we assume there are no linear time trends in the levels of the data. This specification allows the cointegrating equations to be stationary around a constant mean, but it allows no other trends or constant terms" // report LL and significance level
vec constmanufact constagricult, alpha rank(1) lags(2) //


// post-estimation
	veclmar // results: ok

	vecnorm // results: ok 

	vecstable, graph // results: ok




// Disequilibria graph
// residuals appear to be normal ?
// capture drop ce1_Colombia 
// predict ce1_Colombia, ce equation(_ce1)
// tsline ce1_Colombia, yline(0) ytitle("Disequilibria")


// irf from ECM
// irf create Colombia, step(3) set(Colombia, replace)
// 'simple' IRF
// irf graph irf, impulse(constmanufact) response(constagricult) byopts(note("") legend(off)) xtitle(Years) /*ytitle(Impulse Response)*/ saving(irf_ce_Colombia_Man_Agr, replace) subtitle("Response of Agriculture to Industry") title("") noci
// irf graph irf, impulse(constagricult) response(constmanufact) note("") byopts(note("") legend(off)) xtitle(Years) /*ytitle(Impulse Response)*/ saving(irf_ce_Colombia_Agr_Man, replace)  subtitle("Response of Industry to Agriculture") title("") noci
// gr combine irf_ce_Colombia_Man_Agr.gph  irf_ce_Colombia_Agr_Man.gph, col(2) saving(Colombia_irf_ECM, replace) title("Colombia")
// graph export "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/Colombia_irf_ECM.pdf", replace
// interpreation: both sectors respond the same when shocked, meaning that the industrial sector is not strong enough to gain superiority.

****************************
* VAR
****************************

* 
var D.constmanufact D.constagricult, lags(1/3) // put the differenced variables (as the STATA manual does). // put this in appendix


// post-estimation
	varlmar // results: ok

	varnorm // results: ok 

	varstable, graph // results: ok


vargranger //  Granger causality Wald tests // 'excluded causes 'equation.' // this is the main finding: AGR does NOT cause IND, IND causes AGR.

// var d.constmanufact d.constagricult, exog(l.res_Guatemala) lags(1/3)
// We can test for the absence of Granger causality by estimating a VAR model
// interpreation: agr Granger-causes ind.

****************************
* IMPULSE RESPONSE FUNCTIONS from VAR
****************************

* create IRF "object"
<<<<<<< HEAD
irf create Colombia, step(5) set(Colombia, replace)

// 'simple' IRF
irf graph irf, impulse(D.constmanufact) response(D.constagricult) byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Colombia_Man_Agr, replace) subtitle("Response of Agriculture to Industry") title("") xmtick(##5) ytick(#5) ymtick(#3) yscale(range(-.5(.2)1)) xscale(range(0(1)5))  
irf graph irf, impulse(D.constagricult) response(D.constmanufact) note("") byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Colombia_Agr_Man, replace)  subtitle("Response of Industry to Agriculture") title("") xmtick(##5) ytick(#5) ymtick(#3) yscale(range(-.5(.2)1)) xscale(range(0(1)5))  
=======
irf create Colombia, step(10) set(Colombia, replace)

// 'simple' IRF
irf graph irf, impulse(D.constmanufact) response(D.constagricult) byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Colombia_Man_Agr, replace) subtitle("Response of Agriculture to Industry") title("") noci xmtick(##10) ymtick(##5) 
irf graph irf, impulse(D.constagricult) response(D.constmanufact) note("") byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Colombia_Agr_Man, replace)  subtitle("Response of Industry to Agriculture") title("") noci xmtick(##10) ymtick(##5) 
>>>>>>> master
gr combine irf_ce_Colombia_Man_Agr.gph  irf_ce_Colombia_Agr_Man.gph, col(2) saving(Colombia_irf_VAR, replace) title("Colombia")
graph export "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/Colombia_irf_VAR.pdf", replace
// interpretation: the industrial sector does react positively when the agricultural sector grows, but then it decays. it complements with the IRF (ECM) above: it is not strong enough to gain superiority or to sustain growth. // use this one.



********************************************************************************************************************************************
* 																			A L L
********************************************************************************************************************************************

// export all IRFs
graph combine Chile_irf_VAR.gph Venezuela_irf_VAR.gph Peru_irf_VAR.gph Nicaragua_irf_VAR.gph Guatemala_irf_VAR.gph Ecuador_irf_VAR.gph Colombia_irf_VAR.gph, cols(2) title("") iscale(.6) graphregion(margin(zero))
graph export "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/All_IRF.pdf", replace
