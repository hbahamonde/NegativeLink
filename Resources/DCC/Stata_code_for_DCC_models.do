/*

This is the very last step in the process, 
and produces a graph of the correlations over time. 
(A pain!)

-- Paul

*/



**************************************;
* ICSRES and CCIRES   *;
**************************************;
mgarch dcc (icsres4 =, noconstant) (ccires5 =, noconstant),  arch(1) garch(1) nolog;
    predict ics_var, equation(icsres4) variance;
    predict cci_var, equation (ccires5) variance;
    predict icscci_covar, equation (icsres4, ccires5) variance;
    generate ics_stdev=sqrt(ics_var);
    generate cci_stdev=sqrt(cci_var);
    generate denomicscci=ics_stdev*cci_stdev;
    generate dccsicscci=icscci_covar/denomicscci;
   
       
twoway (tsline dccsicscci), ytitle(Dynamic Correlations ICS and CCI) ttitle(Month)
title(Dynamic Conditional Correlations) subtitle(Filtered ICS and CCI)
note("ICS: ARFIMA(1,1,0)) CCI: ARIMA(0,1,0)") name(ICS_CCI_DCC, replace);
graph export "ICS_CCI_DCCS.pdf", replace;




