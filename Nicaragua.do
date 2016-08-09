* Negative Link Paper
* Nicaragua

clear all
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta"

* keep only Chile and before 1970.
keep if country == 14 &  year <= 1990

* set ts data
tsset, clear /* lets clean prior settings, if any */
tsset year


* Plot the data 
tsline constagricult constmanufact, title("Nicaragua") ytitle("Output")


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
reg L(1/2)constmanufact L(1/2)constagricult
predict res14, res



** SEE ALTERNATIVE CRITICAL VALUES HERE!
** DONT INCLUDE DRIFT TERM HERE!!!!
** DONT USE D FULLER, BUT USE JOHANNSEN

**** PUT LAGS IN THE DF TEST!

** sign. pvalue = stationarity


dfuller res14 // ~ stationary 
dfuller res14, drift // stationary
dfuller res14, trend // stationary
// conclusion: stationary taking the second lag

varsoc res14, maxlag(10) /* lag 6 */



//  Residuals: regression plot
tsline res14, saving(plot_12, replace) title("Residuals: Nicaragua")

// Auto-Correlation Functions
ac res14
pac res14 

* VEC
varsoc constmanufact constagricult, maxlag(10) /* lag 1 */
vecrank constmanufact constagricult, lags(1) trend(trend) /* rank 2: NO COINTEGRATION */
vec constmanufact constagricult, rank(1) lags(2) trend(trend)  /* trend(trend) IF I INCLUDE THIS IT WONT COMPUTE NORMALITY TESTS */





// residuals appear to be normal.
capture drop ce1_chile 
predict ce1_chile, ce equation(_ce1)
tsline ce1_chile, yline(0) ytitle("Disequilibria")
