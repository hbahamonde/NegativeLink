* Negative Link Paper


* ssc install blindschemes, replace all
* set scheme plotplainblind, permanently


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
	tsline constagricult constmanufact if country==4, title("Chile") xtitle("") ytitle("") name(Chile_TS, replace) legend(label(1 "Agriculture") label(2 "Industry")) legend(cols(2))
	tsline constagricult constmanufact if country==5, title("Colombia") xtitle("") ytitle("") name(Colombia_TS, replace) legend(label(1 "Agriculture") label(2 "Industry")) legend(cols(2))
	
	tsline constagricult constmanufact if country==8, title("Ecuador") xtitle("") ytitle("") name(Ecuador_TS, replace) legend(label(1 "Agriculture") label(2 "Industry")) legend(cols(2))
	
	tsline constagricult constmanufact if country==10, title("Guatemala") xtitle("") ytitle("") name(Guatemala_TS, replace) legend(label(1 "Agriculture") label(2 "Industry")) legend(cols(2))
	
	tsline constagricult constmanufact if country==14, title("Nicaragua") xtitle("") ytitle("") name(Nicaragua_TS, replace) legend(label(1 "Agriculture") label(2 "Industry")) legend(cols(2))
	
	tsline constagricult constmanufact if country==17, title("Peru") xtitle("") ytitle("") name(Peru_TS, replace) legend(label(1 "Agriculture") label(2 "Industry")) legend(cols(2))

	tsline constagricult constmanufact if country==20, title("Venezuela") xtitle("") ytitle("") name(Venezuela_TS, replace) legend(label(1 "Agriculture") label(2 "Industry")) legend(cols(2))
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
* KPSS 
************





************
* GLS detrended augmented Dickey–Fuller test // See Elliott et al. (1996)
************
** 
dfgls constmanufact, maxlag(3) // 
dfgls constmanufact, maxlag(3) trend // 
// conclusion: 

dfgls constagricult, maxlag(3) // 
dfgls constagricult, maxlag(3) trend // 
// conclusion: 




************
* Engle-Granger
************

* Cointegrating Regression
capture drop res*
reg constmanufact L1.constmanufact constagricult
predict res_Chile, res
tsline res_Chile, title("Chile") xtitle("") ytitle("") name(Chile_CoIntReg_Res, replace)

* Testing Stationarity of Residuals of Cointegrating Regression
dfuller res_Chile, reg lag(1) // stationary 
dfuller res_Chile, reg lag(1) drift // stationary
dfuller res_Chile, reg lag(1) trend // stationary
// conclusion: stationary



// Auto-Correlation Functions for Cointegrating Regression Residuals
ac res_Chile, xtitle("AC") ytitle("") note("") name(Chile_AC_Res_CoIntReg, replace) 
pac res_Chile, xtitle("PAC") ytitle("") note("") name(Chile_PAC_Res_CoIntReg, replace) 
graph combine Chile_AC_Res_CoIntReg Chile_PAC_Res_CoIntReg, cols(1) title("Chile: Cointegrating Regression Residuals")
graph save "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/chile_res.gph"











****************************
* ECM
****************************


* Chile
varsoc constmanufact constagricult, maxlag(10) /* lag 2 */
vecrank constmanufact constagricult, lags(2) trend(trend) /* rank 1 */
vec constmanufact constagricult, rank(1) lags(2) trend(trend)  /* trend(trend) IF I INCLUDE THIS IT WONT COMPUTE NORMALITY TESTS */


vecstable // STABLE
// veclmar, mlag(6) 
// vecnorm


// residuals appear to be normal.
capture drop ce1_chile 
predict ce1_chile, ce equation(_ce1)
tsline ce1_chile, yline(0) ytitle("Disequilibria")




* create IRF "object"
irf create Chile, step(4) set(Chile, replace)

irf graph irf, impulse(constmanufact) response(constagricult) saving(irf_ce_Chile_Man_Agr, replace) title("Chile: Response of Agriculture")
irf graph irf, impulse(constagricult) response(constmanufact) saving(irf_ce_Chile_Agr_Man, replace) title("Chile: Response of Manufacture")
gr combine irf_ce_Chile_Man_Agr.gph  irf_ce_Chile_Agr_Man.gph, col(2) saving(irf, replace) title("IRF")

irf graph oirf, impulse(constmanufact) response(constagricult) saving(oirf_ce_Chile_Man_Agr, replace) title("Chile: Response of Agriculture")
irf graph oirf, impulse(constagricult) response(constmanufact) saving(oirf_ce_Chile_Agr_Man, replace) title("Chile: Response of Manufacture")
gr combine oirf_ce_Chile_Man_Agr.gph  oirf_ce_Chile_Agr_Man.gph, col(2) saving(oirf, replace) title("OIRF")


irf graph fevd, impulse(constmanufact) response(constagricult) saving(fevd_ce_Chile_Man_Agr, replace) title("Chile: Response of Agriculture")
irf graph fevd, impulse(constagricult) response(constmanufact) saving(fevd_ce_Chile_Agr_Man, replace) title("Chile: Response of Manufacture")
gr combine fevd_ce_Chile_Man_Agr.gph  fevd_ce_Chile_Agr_Man.gph, col(2) saving(fevd, replace) title("FEVD")

irf graph cirf, impulse(constmanufact) response(constagricult) saving(cirf_ce_Chile_Man_Agr, replace) title("Chile: Response of Agriculture")
irf graph cirf, impulse(constagricult) response(constmanufact) saving(cirf_ce_Chile_Agr_Man, replace) title("Chile: Response of Manufacture")
gr combine cirf_ce_Chile_Man_Agr.gph  cirf_ce_Chile_Agr_Man.gph, col(2) saving(cirf, replace) title("CIRF")


gr combine irf.gph cirf.gph oirf.gph fevd.gph, col(2) title("Chile: Impulse Response Functions")

// THESE PLOTS IN GENERAL SUGGEST THAT INDUSTRY TAKES LONGER TO ADJUST
// THIS COULD BE BECAUSE THEY NEED TO ADJUST A MUCH SLOWER FACTOR, I.E.
// TECHNOLOGY.


// keep working on this, and plot the two stuff together, 
// modify the Y-scales for all plots.

fcast compute O_, step(40) replace
fcast graph O_constmanufact O_constagricult


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

