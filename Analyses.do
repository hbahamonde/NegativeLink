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
dfuller constmanufact, lag(1) // I(1)
dfuller constmanufact, lag(1) drift // I(1)
dfuller constmanufact, lag(1) trend // I(1)
// conclusion: I(1)

dfuller constagricult, lag(1) // I(1)
dfuller constagricult, lag(1) drift // I(1)
dfuller constagricult, lag(1) trend // I(1)
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
varsoc constmanufact constagricult, maxlag(5) // lag 4 // test for lag lenght
vecrank constmanufact constagricult, lags(3) max // rank 1: This is the number of cointegrating vectors in the system.
vec constmanufact constagricult, rank(1) lags(3) 
// interpreation: agr is NEGATIVE and SIGNIFICANT, that is, when the industrial sector grows, the agr sector catches up GOING DOWN, not 'growing even faster.'
// interpreation: agr is POSITIVE and SIGNIFICANT, that is, when the industrial sector grows, the agr sector catches up GOING UP, trying to 'grow even faster.'



****************************
* VAR
****************************

* 
var d.constmanufact d.constagricult, lags(1/3) // put the differenced variables (as the STATA manual does). // put this in appendix
vargranger //  Granger causality Wald tests // 'excluded causes 'equation.' // this is the main finding

// var d.constmanufact d.constagricult, exog(l.res_Chile) lags(1/3)
// We can test for the absence of Granger causality by estimating a VAR model
// interpreation: agr is NEGATIVE and SIGNIFICANT, that is, when the industrial sector grows, the agr sector catches up GOING DOWN, not 'growing even faster.'



// residuals appear to be normal.
// capture drop ce1_chile 
// predict ce1_chile, ce equation(_ce1)
// tsline ce1_chile, yline(0) ytitle("Disequilibria")


****************************
* IMPULSE RESPONSE FUNCTIONS from VECM
****************************

* create IRF "object"
irf create Chile, step(3) set(Chile, replace)

// 'simple' IRF
irf graph irf, impulse(constmanufact) response(constagricult) byopts(note("") legend(off)) xtitle(Years) ytitle(Impulse Response) saving(irf_ce_Chile_Man_Agr, replace) title("") subtitle("Response of Agriculture to  Industry")
irf graph irf, impulse(constagricult) response(constmanufact) note("") byopts(note("") legend(off)) xtitle(Years) ytitle(Impulse Response) saving(irf_ce_Chile_Agr_Man, replace)  subtitle("Response of Industry to Agriculture") title("")
gr combine irf_ce_Chile_Man_Agr.gph  irf_ce_Chile_Agr_Man.gph, col(2) saving(Chile_irf, replace) title("Chile")
graph export "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/Chile_irf.pdf", replace

// THESE PLOTS IN GENERAL SUGGEST THAT INDUSTRY TAKES LONGER TO ADJUST
// THIS COULD BE BECAUSE THEY NEED TO ADJUST A MUCH SLOWER FACTOR, I.E.
// TECHNOLOGY.

// However, the plot does show that once agriculture 

// orthogonalized IRF's
// irf graph oirf, impulse(constmanufact) response(constagricult) saving(oirf_ce_Chile_Man_Agr, replace) title("Chile: Response of Agriculture")
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
dfuller constmanufact, lag(1) // 
dfuller constmanufact, lag(1) drift // 
dfuller constmanufact, lag(1) trend // 
// conclusion: 

dfuller constagricult, lag(1) // 
dfuller constagricult, lag(1) drift // 
dfuller constagricult, lag(1) trend // 
// conclusion: 


************
* Phillips–Perron // See Phillips (1987) and Phillips and Perron (1988)
************

** MacKinnon approximate sign. p-value = stationarity

** 
pperron constmanufact, lag(1) // 
pperron constmanufact, lag(1) trend // 
// conclusion: 

pperron constagricult, lag(1) // 
pperron constagricult, lag(1) trend // 
// conclusion: 



************
* KPSS  \\  Kwiatkowski, Phillips, Schmidt, and Shin (KPSS, 1992)
************

* null hypothesis of stationarity \\ statistic > critical value = nonstationary/integrated/unit root

** 
// search kpss ado
kpss constmanufact // 
kpss constmanufact, qs auto // 
// conclusion: 

kpss constagricult // 
kpss constagricult, qs auto // 
// conclusion: 




************
* GLS detrended augmented Dickey–Fuller test // See Elliott et al. (1996)
************

* null hypothesis of stationarity \\ statistic > critical value = nonstationary/integrated/unit root


** 
// search dfgls ado
dfgls constmanufact, maxlag(3) // 
dfgls constmanufact, maxlag(3) trend //  
// conclusion: 

dfgls constagricult, maxlag(3) // 
dfgls constagricult, maxlag(3) trend // 
// conclusion: 


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
varsoc constmanufact constagricult, maxlag(5) // ?  // test for lag lenght
vecrank constmanufact constagricult, lags() max // rank ?: This is the number of cointegrating vectors in the system.
vec constmanufact constagricult, rank() lags() 
// interpreation: agr is NEGATIVE and SIGNIFICANT, that is, when the industrial sector grows, the agr sector catches up GOING DOWN, not 'growing even faster.'
// interpreation: agr is POSITIVE and SIGNIFICANT, that is, when the industrial sector grows, the agr sector catches up GOING UP, trying to 'grow even faster.'



****************************
* VAR
****************************

* 
var d.constmanufact d.constagricult, lags(1/3) // put the differenced variables (as the STATA manual does). // put this in appendix
vargranger //  Granger causality Wald tests // 'excluded causes 'equation.' // this is the main finding

// var d.constmanufact d.constagricult, exog(l.res_Venezuela) lags(1/3)
// We can test for the absence of Granger causality by estimating a VAR model
// interpreation: agr is NEGATIVE and SIGNIFICANT, that is, when the industrial sector grows, the agr sector catches up GOING DOWN, not 'growing even faster.'



// residuals appear to be normal.
// capture drop ce1_Venezuela 
// predict ce1_Venezuela, ce equation(_ce1)
// tsline ce1_Venezuela, yline(0) ytitle("Disequilibria")


****************************
* IMPULSE RESPONSE FUNCTIONS from VECM
****************************

* create IRF "object"
irf create Venezuela, step(3) set(Venezuela, replace)

// 'simple' IRF
irf graph irf, impulse(constmanufact) response(constagricult) byopts(note("") legend(off)) xtitle(Years) ytitle(Impulse Response) saving(irf_ce_Venezuela_Man_Agr, replace) title("") subtitle("Response of Agriculture to  Industry")
irf graph irf, impulse(constagricult) response(constmanufact) note("") byopts(note("") legend(off)) xtitle(Years) ytitle(Impulse Response) saving(irf_ce_Venezuela_Agr_Man, replace)  subtitle("Response of Industry to Agriculture") title("")
gr combine irf_ce_Venezuela_Man_Agr.gph  irf_ce_Venezuela_Agr_Man.gph, col(2) saving(Venezuela_irf, replace) title("Venezuela")
graph export "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/Venezuela_irf.pdf", replace
