* Negative Link Paper
* Chile

clear all
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta"

* keep only Chile and before 1970.
keep if country == 4 &  year <= 1970

* set ts data
tsset, clear /* lets clean prior settings, if any */
tsset year


* Plot the data 
tsline constagricult constmanufact, title("Chile") ytitle("Output")


* Before testing for cointegration, 
* we need to make sure all series are 
* integrated of order one.

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


* Now I estimate the cointegrating regressions, 
* that is, I regress one series on the other, and predict the residuals,
* and then run DF test on the saved residuals.

* Cointegration means series that are integrated individually
* but jointly stationary. Hence, these residuals should be
* stationary.

capture drop res*
reg L1.constmanufact L2.constmanufact constagricult
predict res4, res



** SEE ALTERNATIVE CRITICAL VALUES HERE!
** DONT INCLUDE DRIFT TERM HERE!!!!
** DONT USE D FULLER, BUT USE JOHANNSEN

**** PUT LAGS IN THE DF TEST!

** sign. pvalue = stationarity


dfuller res4 // ~ stationary 
dfuller res4, drift // stationary
dfuller res4, trend // I(1)
// conclusion: stationary

dfuller res4, reg lag(2) // I(1)
dfuller res4, reg lag(2) drift // ~ stationary
dfuller res4, reg lag(2) trend // I(1)
// conclusion: I(1)

//  Residuals: regression plot
tsline res4, saving(plot_12, replace) title("Residuals: Chile")

// Auto-Correlation Functions
ac res4
pac res4 


* "VECMs "fix" integrated series that [are] cointegrated and first 
* differences "fix" integrated series that do not cointegrate".
* THE ONE THAT'S SIGNIFICANT TRIES TO CATCH UP WITH THE OTHER ONE


** DO NOT TAKE THE DIFFERENCE,
** THEY GO UNTRANSFORMED INTO THE TEST (MARK SAID THAT).

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
////////// ARDL-Bounds //////////////
************************************
