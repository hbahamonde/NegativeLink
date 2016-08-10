* Here we're going to try to ARDL-bounds method with Philips first application
* Kelly and Enns (2010)

* First you need to download clarify for dynpss
findit clarify

* Now install packages

* Get pssbounds here:
*http://andyphilips.github.io/pssbounds/

* Get dynpss here:
*https://andyphilips.github.io/dynpss/

adopath

* open up the KE data:
cd "/Users/ericguntermann/Documents/Teaching/ICPSR 2016/Time Series II/Data"
insheet using "KellyEnns_data.tab", tab clear
tsset year

* 1. Unit Root test on DV
dfuller mood
dfuller mood, trend 

pperron mood
pperron mood, trend 

* NOTE: may need to download kpss.
kpss mood, notrend
kpss mood, trend  
** Conclusion: mood is I(1)

* 2. Ensure that no regressor is >I(1)
dfuller d.policy
dfuller d.gini

* 3. Table 1, Model 1 (Original GECM):
regress d.mood l.mood d.policy l.policy d.gini l.gini

* Check for white-noise residuals:
estat ic
predict resids, res
dfuller resids			
estat bgodfrey, lags(1/3) 
estat durbina , lags(1/3)
estat hettest 
ac resids
pac resids
swilk resids
qnorm resids
drop resids

* Table 1, Model 2 (ARDL-Bounds)
regress d.mood l.mood d.policy l.policy d.gini l.gini


* 4. Bounds test for cointegration.
test l.mood l.policy l.gini 


pssbounds , case(3) fstat(7.62) tstat(-3.85) k(2) observations(55)

*  We can reject null of no cointegration using both t and F statistics at 0.05 level.
set matsize 6000
dynpss mood policy gini,lags(1 1 1) diffs(. 1 1) shockval(0.1) shockvar(gini) ec graph sims(4000)
