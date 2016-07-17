* Negative Link Paper

clear all
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta"


* set ts data
tsset, clear /* lets clean prior settings, if any */
tsset year

** egranger democ constagricult propagrmanu, regress
** egranger polity constagricult propagrmanu, regress
** egranger polity2 constagricult propagrmanu, regress
** egranger durable constagricult propagrmanu, regress
** egranger xropen constagricult propagrmanu, regress
** egranger parreg constagricult propagrmanu, regress
** egranger parcomp constagricult propagrmanu, regress


/*
xrcomp: 

Competitiveness of Executive Recruitment: 
Competitiveness refers to the extent that prevailing 
modes of advancement give subordinates equal opportunities 
to become superordinates.


selection of chief executives through popular elections 
matching two or more viable parties or candidates is 
regarded as competitive.
*/




/*
Grant2016: 6
The two-step ECM approach begins with I(1) variables and 
tests whether they are cointegrated—that is, 
is a linear combination of them I(0)? In the 
first step, Yt is regressed on covariates and 
residuals are tested for stationarity. If the 
residuals are I(0), then a second step uses the 
lagged residuals as the ECM in a differenced model
*/


* testing for panel cointegration
** findit egranger
egranger constagricult propagrmanu, regress










