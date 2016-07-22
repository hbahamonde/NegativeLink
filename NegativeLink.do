* Negative Link Paper

clear all
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta"


* set ts data
tsset, clear /* lets clean prior settings, if any */
tsset country year


* Plot the data 
tsline constagricult constmanufact if country==4, saving(plot_1, replace) title("Chile") ytitle("Output")
tsline constagricult constmanufact if country==5, saving(plot_2, replace) title("Colombia") ytitle("Output")
tsline constagricult constmanufact if country==8, saving(plot_3, replace) title("Ecuador") ytitle("Output")
tsline constagricult constmanufact if country==10, saving(plot_4, replace) title("Guatemala") ytitle("Output")
tsline constagricult constmanufact if country==14, saving(plot_5, replace) title("Nicaragua") ytitle("Output")
tsline constagricult constmanufact if country==17, saving(plot_6, replace) title("Peru") ytitle("Output")
tsline constagricult constmanufact if country==20, saving(plot_7, replace) title("Venezuela") ytitle("Output")
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
dfuller constmanufact if country==4  /* integrated */
dfuller constagricult if country==4 /* integrated */
 

** Colombia
dfuller constmanufact if country==5  /* integrated */
dfuller constagricult if country==5 /* integrated */



** Ecuador
dfuller constmanufact if country==8 /* integrated */
dfuller constagricult if country==8 /* integrated */


 ** Guatemala
dfuller constmanufact if country==10, trend /* stationary with trend  */
dfuller constagricult if country==10 /* integrated */


 ** Nicaragua
dfuller constmanufact if country==14 /* integrated */
dfuller constagricult if country==14 /* integrated */


 ** Peru
dfuller constmanufact if country==17 /* integrated */
dfuller constagricult if country==17 /* integrated */


 ** Venezuela
dfuller constmanufact if country==20 /* integrated */
dfuller constagricult if country==20 /* integrated */




* Now I estimate the cointegrating regressions, 
* that is, I regress one series on the other, and predict the residuals,
* and then run DF test on the saved residuals.

* Cointegration means series that are integrated individually
* but jointly stationary. Hence, these residuals should be
* stationary.

capture drop res*

reg constmanufact constagricult if country==4
predict res4 if country==4, res


reg constmanufact constagricult if country==5
predict res5 if country==5, res


reg constmanufact constagricult if country==8
predict res8 if country==8, res


reg constmanufact constagricult if country==10
predict res10 if country==10, res


reg constmanufact constagricult if country==14
predict res14 if country==14, res


reg constmanufact constagricult if country==17
predict res17 if country==17, res


reg constmanufact constagricult if country==20
predict res20 if country==20, res

* how do I read these critical values?
* country 14 says stationary with drift but integrated with trend...?

dfuller res4 if country==4, drift /* stationary with drift */
dfuller res5 if country==5, drift /* stationary with drift: Colombia */
dfuller res8 if country==8, drift /* stationary?? */
dfuller res10 if country==10, drift /* stationary with drift or trend: Guatemala */
dfuller res14 if country==14, drift /* stationary with drift */
dfuller res17 if country==17, drift /* stationary with drift */
dfuller res20 if country==20, drift /* stationary with drift: Venezuela */




* "VECMs "fix" integrated series that [are] cointegrated and first 
* differences "fix" integrated series that do not cointegrate".





