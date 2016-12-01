

* Chile // pretax

clear all
cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
keep if country==4 & year<=1924

* set ts data
tsset, clear
tsset year, yearly

* plot
tsline constagricult constmanufact, subtitle("Pre Income Tax") xtitle("") ytitle("") saving(Chile_TS_PRE.gph, replace) legend(label(1 "Agriculture") label(2 "Industry")) legend(cols(2)) ylabel(#3, labsize(vsmall)) ymtick(##3)

** MacKinnon approximate sign. p-value = stationarity
dfuller constmanufact, lag(1) reg // I(1)
dfuller constagricult, lag(1) reg // I(1)
*
pperron constmanufact, lag(1) // I(1)
pperron constagricult, lag(1) // I(1)


var d.constmanufact d.constagricult, lags(1/4)

	varlmar, mlag(5)
	varnorm
	varstable

vargranger 
// IND -> AGR (.016)
// AGR -> IND (.470)

* IRF
irf create Chile, step(5) set(Chile, replace)

// 'simple' IRF
irf graph irf, impulse(D.constmanufact) response(D.constagricult) byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Chile_Man_Agr_SB_PRE, replace) title("") subtitle("Response of Agriculture to Industry") xmtick(#3) xlabel(#5) ylabel(#5) ytick(#5) ymtick(#3)  noci  yscale(range(-1(.25)1))
irf graph irf, impulse(D.constagricult) response(D.constmanufact) note("") byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Chile_Agr_Man_SB_PRE, replace) title("") subtitle("Response of Industry to Agriculture")  xmtick(#3) xlabel(#5) ylabel(#5) ytick(#5) ymtick(#3)  noci yscale(range(-1(.25)1))
gr combine irf_ce_Chile_Man_Agr_SB_PRE.gph  irf_ce_Chile_Agr_Man_SB_PRE.gph, col(2) name(Chile_irf_PRE, replace) subtitle("Pre Income Tax") saving(Chile_irf_PRE.gph, replace)



* Chile // post tax


cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
keep if country==4 & year>1924

* set ts data
tsset, clear
tsset year, yearly

* plot
tsline constagricult constmanufact, subtitle("Post Income Tax") xtitle("") ytitle("") saving(Chile_TS_POST.gph, replace) legend(label(1 "Agriculture") label(2 "Industry")) legend(cols(2)) ylabel(#3, labsize(vsmall)) ymtick(##3) xscale(range(1925(20)2015))

** MacKinnon approximate sign. p-value = stationarity
dfuller constmanufact, lag(1) reg // I(1)
dfuller constagricult, lag(1) reg // I(1)
*
pperron constmanufact, lag(1) // I(1)
pperron constagricult, lag(1) // I(1)


var d.constmanufact d.constagricult, lags(1/2)

	varlmar, mlag(5)
	varnorm
	varstable

vargranger
// IND -> AGR (.068)
// AGR -> IND (.003)



* IRF
irf create Chile, step(5) set(Chile, replace)

// 'simple' IRF
irf graph irf, impulse(D.constmanufact) response(D.constagricult) byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Chile_Man_Agr_SB_POST, replace) title("") subtitle("Response of Agriculture to Industry") xmtick(#3) xlabel(#5) ylabel(#5) ytick(#5) ymtick(#3)  noci  yscale(range(0(.025)2))
irf graph irf, impulse(D.constagricult) response(D.constmanufact) note("") byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Chile_Agr_Man_SB_POST, replace) title("") subtitle("Response of Industry to Agriculture")  xmtick(#3) xlabel(#5) ylabel(#5) ytick(#5) ymtick(#3)  noci yscale(range(0(.025)2))
gr combine irf_ce_Chile_Man_Agr_SB_POST.gph  irf_ce_Chile_Agr_Man_SB_POST.gph, col(2) saving(Chile_irf_POST.gph, replace) subtitle("Post Income Tax")



graph combine Chile_TS_PRE.gph Chile_TS_POST.gph, rows(2) title("Sectoral Growth") iscale(.6) graphregion(margin(zero)) name(Chile_Sectoral_Growth, replace)
graph combine Chile_irf_PRE.gph Chile_irf_POST.gph, rows(4) title("IRF") iscale(.6) graphregion(margin(zero)) name(Chile_IRF, replace)
graph combine Chile_IRF Chile_Sectoral_Growth, cols(3) title("Chile") iscale(.6) graphregion(margin(zero))


