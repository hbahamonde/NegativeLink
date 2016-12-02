********************************************************************************************************************************************
*				 													C 	H 	I 	L 	E 	
********************************************************************************************************************************************


clear all
cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
keep if country==4
drop if incometax==.


** FROM SOURCE // MOXLAD DATASET
* Tax on Income, Profit and Capital Gains (million current LCU): Figures for 1900-1984 are from Mitchell (1993). Figures from 1900-1927 refer to all direct taxes. Figures for 1928-1952 refer to income tax only. Figures for 1985-2000 are from IMF GFSY (1993, 2000, 2001), figures are for tax on income, profits and capital gains. Break in series 1989/90 unexplained in source. 

* Currency Notes: 
** On 1 January 1960 the Old Peso (OP) was replaced by the Escudo (E) at a rate of 1000 OP = 1 E. 
** On 29 September 1975 the New Peso (NP) replaced the E at a rate of 1000 E = 1 NP, see Officer (2002). 
** Figures are expressed in OP from 1900-1959, E from 1960-1975, and NP from 1976 onward.

* set ts data
tsset, clear
tsset year, yearly





* plot
tsline /*constagricult constmanufact*/ customtax, subtitle("") xtitle("") ytitle("") saving(Chile_TS_PRE.gph, replace) legend(label(1 "Agriculture") label(2 "Industry")) legend(cols(2)) ylabel(#3, labsize(vsmall)) ymtick(##3)














* normalize to New Peso
gen intaxPRE1960 = incometax/1000 if year <= 1959 // from Old Peso (OP) to Escudo (E)
gen intaxESCUDO = incometax if year >= 1960 & year <= 1975  // in Escudo (E)


gen intaxPRE1960toPESO = intaxPRE1960/1000 if year <= 1959 // from Escudo (E) to New Peso (PE)
gen intaxESCUDOtoPESO = intaxESCUDO/1000 if year >= 1960 & year <= 1975  // from Escudo (E) to New Peso (PE)
gen intaxNewPeso = incometax if year >= 1976 // New Peso (NP)

egen incometax_peso = rowtotal(intaxPRE1960toPESO intaxESCUDOtoPESO intaxNewPeso) 


* Convert to Constant Dollars 1970
incometax_peso_over_


order year incometax incometax_peso intaxPRE1960 intaxPRE1960toPESO intaxESCUDO intaxESCUDOtoPESO intaxNewPeso
br


* plot
tsline /*constagricult constmanufact*/ incometax_peso, subtitle("") xtitle("") ytitle("") saving(Chile_TS_PRE.gph, replace) legend(label(1 "Agriculture") label(2 "Industry")) legend(cols(2)) ylabel(#3, labsize(vsmall)) ymtick(##3)
