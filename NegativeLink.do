* Negative Link Paper


clear all
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta"


* set ts data
tsset, clear /* lets clean prior settings, if any */
tsset country year


* Plot the data 
tsline constagricult constmanufact if country==4 & year <= 1970, saving(plot_1, replace) title("Chile") ytitle("Output")
tsline constagricult constmanufact if country==5 & year <= 1970, saving(plot_2, replace) title("Colombia") ytitle("Output")
tsline constagricult constmanufact if country==8 & year <= 1970, saving(plot_3, replace) title("Ecuador") ytitle("Output")
tsline constagricult constmanufact if country==10 & year <= 1970, saving(plot_4, replace) title("Guatemala") ytitle("Output")
tsline constagricult constmanufact if country==14 & year <= 1970, saving(plot_5, replace) title("Nicaragua") ytitle("Output")
tsline constagricult constmanufact if country==17 & year <= 1970, saving(plot_6, replace) title("Peru") ytitle("Output")
tsline constagricult constmanufact if country==20 & year <= 1970, saving(plot_7, replace) title("Venezuela") ytitle("Output")
gr combine plot_1.gph  plot_2.gph  plot_3.gph  plot_4.gph  ///
plot_5.gph  plot_6.gph plot_7.gph, col(2) iscale(0.4)


* Before testing for cointegration, 
* we need to make sure all series are 
* integrated of order one.

** sign. pvalue = stationarity

** Tested with both, but no difference (except for Guatemala, manufacture
*** trend
*** drift

** Chile
dfuller constmanufact if country==4 & year <= 1970  /* integrated */
dfuller constagricult if country==4 & year <= 1970 /* integrated */
 

** Colombia
dfuller constmanufact if country==5 & year <= 1970  /* integrated */
dfuller constagricult if country==5 & year <= 1970 /* integrated */



** Ecuador
dfuller constmanufact if country==8 & year <= 1970 /* integrated */
dfuller constagricult if country==8 & year <= 1970 /* integrated */


 ** Guatemala
dfuller constmanufact if country==10 & year <= 1970, trend /* stationary around a trend  */
dfuller constagricult if country==10 & year <= 1970 /* integrated */


 ** Nicaragua
dfuller constmanufact if country==14 & year <= 1970 /* integrated */
dfuller constagricult if country==14 & year <= 1970 /* integrated */


 ** Peru
dfuller constmanufact if country==17 & year <= 1970 /* integrated */
dfuller constagricult if country==17 & year <= 1970 /* integrated */


 ** Venezuela
dfuller constmanufact if country==20 & year <= 1970 /* integrated */
dfuller constagricult if country==20 & year <= 1970 /* integrated */




* Now I estimate the cointegrating regressions, 
* that is, I regress one series on the other, and predict the residuals,
* and then run DF test on the saved residuals.

* Cointegration means series that are integrated individually
* but jointly stationary. Hence, these residuals should be
* stationary.

capture drop res*

reg constmanufact constagricult if country==4 & year <= 1970
predict res4 if country==4 & year <= 1970, res


reg constmanufact constagricult if country==5 & year <= 1970
predict res5 if country==5 & year <= 1970, res


reg constmanufact constagricult if country==8 & year <= 1970
predict res8 if country==8 & year <= 1970, res


reg constmanufact constagricult if country==10 & year <= 1970
predict res10 if country==10 & year <= 1970, res


reg constmanufact constagricult if country==14 & year <= 1970
predict res14 if country==14 & year <= 1970, res


reg constmanufact constagricult if country==17 & year <= 1970
predict res17 if country==17 & year <= 1970, res


reg constmanufact constagricult if country==20 & year <= 1970
predict res20 if country==20 & year <= 1970, res




** SEE ALTERNATIVE CRITICAL VALUES HERE!
** DONT INCLUDE DRIFT TERM HERE!!!!
** DONT USE D FULLER, BUT USE JOHANNSEN

**** PUT LAGS IN THE DF TEST!

** sign. pvalue = stationarity

dfuller res4 if country==4, reg lag(2) /* Chile: unit root */
qui tsline res4, saving(plot_12, replace) title("Chile: stationary")

dfuller res5 if country==5 /* Colombia: stationary */
qui tsline res5, saving(plot_22, replace) title("Colombia: stationary")

dfuller res8 if country==8 /* Ecuador: non stationary */
qui tsline res8, saving(plot_32, replace) title("Ecuador: stationary")

dfuller res10 if country==10 /* Guatemala: stationary */
qui tsline res10, saving(plot_42, replace) title("Guatemala: stationary")

dfuller res14 if country==14 /* Nicaragua: non-stationary */
qui tsline res14, saving(plot_52, replace) title("Nicaragua: stationary")

dfuller res17 if country==17 /* Peru: stationary */
qui tsline res14, saving(plot_62, replace) title("Peru: stationary")

dfuller res20 if country==20 /* Venezuela: stationary (but not at 5%)  */
qui tsline res20, saving(plot_72, replace) title("Venezuela: stationary")


gr combine plot_12.gph  plot_22.gph  plot_32.gph  plot_42.gph  ///
plot_52.gph  plot_62.gph plot_72.gph, col(2) iscale(0.4)


* "VECMs "fix" integrated series that [are] cointegrated and first 
* differences "fix" integrated series that do not cointegrate".


** DO NOT TAKE THE DIFFERENCE,
** THEY GO UNTRANSFORMED INTO THE TEST (MARK SAID THAT).

* Chile
varsoc constmanufact constagricult if country==4 & year <= 1970, maxlag(10) /* lag 1 */
vecrank constmanufact constagricult if country==4 & year <= 1970, lags(1) trend(trend) /* rank 1 */
vec constmanufact constagricult if country==4 & year <= 1970, rank(1) lags(3) trend(trend)  /* trend(trend) IF I INCLUDE THIS IT WONT COMPUTE NORMALITY TESTS */

vecstable /* STABLE */
veclmar, mlag(6) 
vecnorm


capture drop ce1_chile 
predict ce1_chile, ce equation(_ce1)
tsline ce1_chile


** THE ONE THAT'S SIGNIFICANT TRIES TO CATCH UP WITH THE OTHER ONE


* Colombia
varsoc constmanufact constagricult if country==5 & year <= 1970 /* lag 2 */
vecrank constmanufact constagricult if country==5 & year <= 1970, lags(2) /* rank 1 */
vec constmanufact constagricult if country==5 & year <= 1970, rank(1) lags(2)
vecstable, graph /* NOT STABLE? */


* Ecuador
varsoc constmanufact constagricult if country==8 & year <= 1970 /* lag 1 */ 
vecrank constmanufact constagricult if country==8 & year <= 1970, lags(1) /* rank 0 */ 


* Guatemala
varsoc constmanufact constagricult if country==10 & year <= 1970 /* lag 3 */ 
vecrank constmanufact constagricult if country==10 & year <= 1970, lags(3) /* rank 2 */ 


* Nicaragua
varsoc constmanufact constagricult if country==14 & year <= 1970 /* lag 1 */ 
vecrank constmanufact constagricult if country==14 & year <= 1970, lags(1) trend(trend) /* rank 0 */ 
** VAR or VECm


* Peru
varsoc constmanufact constagricult if country==17 & year <= 1970 /* lag 1 */ 
vecrank constmanufact constagricult if country==17 & year <= 1970, lags(1) /* rank 1 */ 
vec constmanufact constagricult if country==17 & year <= 1970, rank(1) lags(1)
** ?? Why am I getting just the c equation?
vecstable, graph /* NOT STABLE? */

 
* Venezuela
varsoc constmanufact constagricult if country==20 & year <= 1970 /* lag 1 */  
vecrank constmanufact constagricult if country==20 & year <= 1970, lags(1) /* rank 1 */  
vec constmanufact constagricult if country==20 & year <= 1970, rank(1) lags(1)
** ?? Why am I getting just the c equation?
vecstable, graph /* NOT STABLE? */






