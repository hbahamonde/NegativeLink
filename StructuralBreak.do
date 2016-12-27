set more off, permanently
set scheme s1color, permanently


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
tsline constagricult constmanufact, subtitle("Pre Income Tax") xtitle("") ytitle("") saving(Chile_TS_PRE.gph, replace) legend(label(1 "Agriculture") label(2 "Industry")) legend(cols(2)) ylabel(#3, labsize(vsmall)) ymtick(##3) legend(size(small))

** MacKinnon approximate sign. p-value = stationarity
dfuller constmanufact, lag(1) reg // I(1)
dfuller constagricult, lag(1) reg // I(1)
*  Phillips-Perron
pperron constmanufact, lag(1) // I(1)
pperron constagricult, lag(1) // I(1)
* kpss
kpss constagricult, auto
kpss constmanufact, auto

* lags
varsoc constmanufact constagricult, maxlag(5) // lag 3 // test for lag lenght



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
* Phillips-Perron
pperron constmanufact, lag(1) // I(1)
pperron constagricult, lag(1) // I(1)
* kpss
kpss constagricult, auto
kpss constmanufact, auto

var d.constmanufact d.constagricult, lags(1/2)

	varlmar, mlag(5)
	varnorm
	varstable

vargranger
// IND -> AGR (.068)
// AGR -> IND (.003)


* Chile // All periods
cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
keep if country==4

* set ts data
tsset, clear
tsset year, yearly

** MacKinnon approximate sign. p-value = stationarity
dfuller constmanufact, lag(1) reg 
dfuller constagricult, lag(1) reg 
*
pperron constmanufact, lag(1) 
pperron constagricult, lag(1) 
* kpss
kpss constagricult, auto
kpss constmanufact, auto



* IRF
irf create Chile, step(5) set(Chile, replace)

// 'simple' IRF
irf graph irf, impulse(D.constmanufact) response(D.constagricult) byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Chile_Man_Agr_SB_POST, replace) title("") subtitle("Response of Agriculture to Industry") xmtick(#3) xlabel(#5) ylabel(#5) ytick(#5) ymtick(#3)  noci  yscale(range(0(.025)2))
irf graph irf, impulse(D.constagricult) response(D.constmanufact) note("") byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Chile_Agr_Man_SB_POST, replace) title("") subtitle("Response of Industry to Agriculture")  xmtick(#3) xlabel(#5) ylabel(#5) ytick(#5) ymtick(#3)  noci yscale(range(0(.025)2))
gr combine irf_ce_Chile_Man_Agr_SB_POST.gph  irf_ce_Chile_Agr_Man_SB_POST.gph, col(2) saving(Chile_irf_POST.gph, replace) subtitle("Post Income Tax")



graph combine Chile_TS_PRE.gph Chile_TS_POST.gph, rows(2) title("Sectoral Growth") iscale(.6) graphregion(margin(zero)) name(Chile_Sectoral_Growth, replace)
graph combine Chile_irf_PRE.gph Chile_irf_POST.gph, rows(4) title("IRF") iscale(.6) graphregion(margin(zero)) name(Chile_IRF, replace)
graph combine Chile_IRF Chile_Sectoral_Growth, cols(3) title("Chile") iscale(.6) graphregion(margin(zero))
graph export "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/Chile_StructuralBreak.pdf", replace



* Test for a structural break with an KNOWN break date

cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
keep if country==4

* set ts data
tsset, clear
tsset year, yearly

reg constmanufact constagricult
estat sbknown, break(1924) breakvars(constagricult)





* Test for a structural break with an UNKNOWN break date

// cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
// use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
// keep if country==4

* set ts data
// tsset, clear
// tsset year, yearly

// reg constmanufact l.constagricult f.constmanufact l.constmanufact
// estat sbsingle, breakvars(l.constagricult)



********************************************************************************************************************************************
* 																C 	O 	L 	O 	M 	B 	I 	A
********************************************************************************************************************************************


* Colombia // pretax

clear all
cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
drop if year <1900
keep if country==5 & year<=1935

* set ts data
tsset, clear
tsset year, yearly

* plot
tsline constagricult constmanufact, subtitle("Pre Income Tax") xtitle("") ytitle("") saving(Colombia_TS_PRE.gph, replace) legend(label(1 "Agriculture") label(2 "Industry")) legend(cols(2)) ylabel(#3, labsize(vsmall)) ymtick(##3) xscale(range(1890(10)1940))

** MacKinnon approximate sign. p-value = stationarity
dfuller constmanufact, lag(1) reg // I(1)
dfuller constagricult, lag(1) reg // I(1)
* Phillips-Perron
pperron constmanufact, lag(1) // I(1)
pperron constagricult, lag(1) // I(1)
* kpss
kpss constagricult, auto
kpss constmanufact, auto

var d.constmanufact d.constagricult, lags(1)

	varlmar, mlag(5)
	varnorm
	varstable

vargranger 
// IND -> AGR (.026)
// AGR -> IND (.001)

* IRF
irf create Colombia, step(5) set(Colombia, replace)

// 'simple' IRF
irf graph irf, impulse(D.constmanufact) response(D.constagricult) byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Colombia_Man_Agr_SB_PRE, replace) title("") subtitle("Response of Agriculture to Industry") xmtick(#3) xlabel(#5) ylabel(#5) ytick(#5) ymtick(#3)  noci  yscale(range(-1(.25)1))
irf graph irf, impulse(D.constagricult) response(D.constmanufact) note("") byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Colombia_Agr_Man_SB_PRE, replace) title("") subtitle("Response of Industry to Agriculture")  xmtick(#3) xlabel(#5) ylabel(#5) ytick(#5) ymtick(#3)  noci yscale(range(-1(.25)1))
gr combine irf_ce_Colombia_Man_Agr_SB_PRE.gph  irf_ce_Colombia_Agr_Man_SB_PRE.gph, col(2) name(Colombia_irf_PRE, replace) subtitle("Pre Income Tax") saving(Colombia_irf_PRE.gph, replace)



* Colombia // post tax

cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
keep if country==5 & year>1935

* set ts data
tsset, clear
tsset year, yearly

* plot
tsline constagricult constmanufact, subtitle("Post Income Tax") xtitle("") ytitle("") saving(Colombia_TS_POST.gph, replace) legend(label(1 "Agriculture") label(2 "Industry")) legend(cols(2)) ylabel(#3, labsize(vsmall)) ymtick(##3) xscale(range(1935(20)2015))

** MacKinnon approximate sign. p-value = stationarity
dfuller constmanufact, lag(1) reg // I(1)
dfuller constagricult, lag(1) reg // I(1)
* Phillips-Perron
pperron constmanufact, lag(1) // I(1)
pperron constagricult, lag(1) // I(1)
* kpss
kpss constagricult, auto
kpss constmanufact, auto

var d.constmanufact d.constagricult, lags(1)

	varlmar, mlag(5)
	varnorm
	varstable

vargranger
// IND -> AGR (.202)
// AGR -> IND (.038)



* IRF
irf create Colombia, step(5) set(Colombia, replace)

// 'simple' IRF
irf graph irf, impulse(D.constmanufact) response(D.constagricult) byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Colombia_Man_Agr_SB_POST, replace) title("") subtitle("Response of Agriculture to Industry") xmtick(#3) xlabel(#5) ylabel(#5) ytick(#5) ymtick(#3)  noci  yscale(range(0(.025).5))
irf graph irf, impulse(D.constagricult) response(D.constmanufact) note("") byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Colombia_Agr_Man_SB_POST, replace) title("") subtitle("Response of Industry to Agriculture")  xmtick(#3) xlabel(#5) ylabel(#5) ytick(#5) ymtick(#3)  noci yscale(range(0(.025).5))
gr combine irf_ce_Colombia_Man_Agr_SB_POST.gph  irf_ce_Colombia_Agr_Man_SB_POST.gph, col(2) saving(Colombia_irf_POST.gph, replace) subtitle("Post Income Tax")



graph combine Colombia_TS_PRE.gph Colombia_TS_POST.gph, rows(2) title("Sectoral Growth") iscale(.6) graphregion(margin(zero)) name(Colombia_Sectoral_Growth, replace)
graph combine Colombia_irf_PRE.gph Colombia_irf_POST.gph, rows(4) title("IRF") iscale(.6) graphregion(margin(zero)) name(Colombia_IRF, replace)
graph combine Colombia_IRF Colombia_Sectoral_Growth, cols(3) title("Colombia") iscale(.6) graphregion(margin(zero))
graph export "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/Colombia_StructuralBreak.pdf", replace


* Test for a structural break with an KNOWN break date

cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
keep if country==5

* set ts data
tsset, clear
tsset year, yearly

reg constmanufact constagricult
estat sbknown, break(1935) breakvars(constagricult)



* All periods
cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
keep if country==5

* set ts data
tsset, clear
tsset year, yearly

** MacKinnon approximate sign. p-value = stationarity
dfuller constmanufact, lag(1) reg 
dfuller constagricult, lag(1) reg 
*
pperron constmanufact, lag(1) 
pperron constagricult, lag(1) 
* kpss
kpss constagricult, auto
kpss constmanufact, auto
********************************************************************************************************************************************
* 																A 	R 	G 	E 	N 	T 	I 	N 	A
********************************************************************************************************************************************


* Argentina // pretax

clear all
cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
drop if year <1900
keep if country==1 & year<=1933

* SOURCE confirming that the law was passed:
* http://servicios.infoleg.gob.ar/infolegInternet/verNorma.do?id=185729
* REGIMEN SOBRE IMPUESTO A LOS REDITOS. TODOS LOS REDITOS PRODUCIDOS A PARTIR DEL 1 DE ENERO DE 1932 O CORRESPONDIENTES AL TIEMPO TRANSCURRIDO DESDE EL 1 DE ENERO DE 1932 Y DERIVADOS DE FUENTE ARGENTINA, A FAVOR DE ARGENTINOS O EXTRANJEROS, RESIDENTES O NO RESIDENTES EN EL TERRITORIO DE LA REPUBLICA, CON EXCEPCION DE LOS EXPRESAMENTE EXCLUIDOS EN LAS DISPOSICIONES SIGUIENTES, QUEDAN SUJETOS AL GRAVAMEN DE EMERGENCIA NACIONAL QUE ESTABLECE LA PRESENTE. EL PRESENTE IMPUESTO CADUCARA EL 31 DE DICIEMBRE DE 1934.
** Esta norma no modifica ni complementa a ninguna norma.
** Esta norma es complementada o modificada por 52 norma(s).
** Ley 11682 HONORABLE CONGRESO DE LA NACION ARGENTINA 04-ene-1933
** Publicada en el Boletín Oficial del 12-ene-1933    Número: 11586    Página: 2

* set ts data
tsset, clear
tsset year, yearly

* plot
tsline constagricult constmanufact, subtitle("Pre Income Tax") xtitle("") ytitle("") saving(Argentina_TS_PRE.gph, replace) legend(label(1 "Agriculture") label(2 "Industry")) legend(cols(2)) ylabel(#3, labsize(vsmall)) ymtick(##3) xscale(range(1890(10)1940))

** MacKinnon approximate sign. p-value = stationarity
dfuller constmanufact, lag(1) reg // I(1)
dfuller constagricult, lag(1) reg // I(1)
* Phillips-Perron
pperron constmanufact, lag(1) // I(1)
pperron constagricult, lag(1) // I(1)
* kpss
kpss constagricult, auto
kpss constmanufact, auto

var d.constmanufact d.constagricult, lags(1/2)

	varlmar, mlag(5)
	varnorm
	varstable, graph

vargranger 
// IND -> AGR (.000)
// AGR -> IND (.015)

* IRF
irf create Argentina, step(5) set(Argentina, replace)

// 'simple' IRF
irf graph irf, impulse(D.constmanufact) response(D.constagricult) byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Argentina_Man_Agr_SB_PRE, replace) title("") subtitle("Response of Agriculture to Industry") xmtick(#3) xlabel(#5) ylabel(#5) ytick(#5) ymtick(#3)  noci  yscale(range(-.5(.25).5))
irf graph irf, impulse(D.constagricult) response(D.constmanufact) note("") byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Argentina_Agr_Man_SB_PRE, replace) title("") subtitle("Response of Industry to Agriculture")  xmtick(#3) xlabel(#5) ylabel(#5) ytick(#5) ymtick(#3)  noci yscale(range(-.5(.25).5))
gr combine irf_ce_Argentina_Man_Agr_SB_PRE.gph  irf_ce_Argentina_Agr_Man_SB_PRE.gph, col(2) name(Argentina_irf_PRE, replace) subtitle("Pre Income Tax") saving(Argentina_irf_PRE.gph, replace)



* Argentina // post tax

cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
keep if country==1 & year>1933

* set ts data
tsset, clear
tsset year, yearly

* plot
tsline constagricult constmanufact, subtitle("Post Income Tax") xtitle("") ytitle("") saving(Argentina_TS_POST.gph, replace) legend(label(1 "Agriculture") label(2 "Industry")) legend(cols(2)) ylabel(#3, labsize(vsmall)) ymtick(##3) xscale(range(1930(20)2015))

** MacKinnon approximate sign. p-value = stationarity
dfuller constmanufact, lag(1) reg // I(1)
dfuller constagricult, lag(1) reg // I(1)
* Phillips-Perron
pperron constmanufact, lag(1) // I(1)
pperron constagricult, lag(1) // I(1)
* kpss
kpss constagricult, auto
kpss constmanufact, auto

var d.constmanufact d.constagricult, lags(1/2)

	varlmar, mlag(5)
	varnorm
	varstable

vargranger
// IND -> AGR (.505)
// AGR -> IND (.913)



* IRF
irf create Argentina, step(5) set(Argentina, replace)

// 'simple' IRF
irf graph irf, impulse(D.constmanufact) response(D.constagricult) byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Argentina_Man_Agr_SB_POST, replace) title("") subtitle("Response of Agriculture to Industry") xmtick(#3) xlabel(#5) ylabel(#5) ytick(#5) ymtick(#3)  noci  yscale(range(-.2(.05).2))
irf graph irf, impulse(D.constagricult) response(D.constmanufact) note("") byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Argentina_Agr_Man_SB_POST, replace) title("") subtitle("Response of Industry to Agriculture")  xmtick(#3) xlabel(#5) ylabel(#5) ytick(#5) ymtick(#3)  noci yscale(range(-.2(.05).2))
gr combine irf_ce_Argentina_Man_Agr_SB_POST.gph  irf_ce_Argentina_Agr_Man_SB_POST.gph, col(2) saving(Argentina_irf_POST.gph, replace) subtitle("Post Income Tax")



graph combine Argentina_TS_PRE.gph Argentina_TS_POST.gph, rows(2) title("Sectoral Growth") iscale(.6) graphregion(margin(zero)) name(Argentina_Sectoral_Growth, replace)
graph combine Argentina_irf_PRE.gph Argentina_irf_POST.gph, rows(4) title("IRF") iscale(.6) graphregion(margin(zero)) name(Argentina_IRF, replace)
graph combine Argentina_IRF Argentina_Sectoral_Growth, cols(3) title("Argentina") iscale(.6) graphregion(margin(zero))
graph export "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/Argentina_StructuralBreak.pdf", replace


* Test for a structural break with an KNOWN break date

cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
keep if country==1

* set ts data
tsset, clear
tsset year, yearly

reg constmanufact constagricult
estat sbknown, break(1933) breakvars(constagricult)


* All periods
cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
keep if country==1

* set ts data
tsset, clear
tsset year, yearly

** MacKinnon approximate sign. p-value = stationarity
dfuller constmanufact, lag(1) reg 
dfuller constagricult, lag(1) reg 
*
pperron constmanufact, lag(1) 
pperron constagricult, lag(1) 
* kpss
kpss constagricult, auto
kpss constmanufact, auto
********************************************************************************************************************************************
*																 M 	E 	X 	I 	C 	O
********************************************************************************************************************************************


* Mexico // pretax

clear all
cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
drop if year <1900
keep if country==13 & year<=1965

* SOURCE confirming that the law was passed:
* \citet[130-133]{DiazGonzalez2013}: "En México, la historia fiscal se puede dividir en dos segmentos, en el primero los ingresos fiscales dependen crucialmente de impuestos indirectos, esto se prolonga hasta 1963-1965; a partir de ese año los ingresos tributarios empiezan de nuevo a depender de los impuestos sobre el ingreso [...] La reforma fiscal que entró en vigor a partir de 1965 suprimió el impuesto cedular y se implantó el impuesto al ingreso global de las empresas e impuestos al ingreso de las personas físicas, entre otros cambios relativos a las ganancias de capital, dividendos pagados, amortización de pérdidas y utilidades excedentes."


* set ts data
tsset, clear
tsset year, yearly

* plot
tsline constagricult constmanufact, subtitle("Pre Income Tax") xtitle("") ytitle("") saving(Mexico_TS_PRE.gph, replace) legend(label(1 "Agriculture") label(2 "Industry")) legend(cols(2)) ylabel(#3, labsize(vsmall)) ymtick(##3)

** MacKinnon approximate sign. p-value = stationarity
dfuller constmanufact, lag(1) reg // I(1)
dfuller constagricult, lag(1) reg // I(1)
* Phillips-Perron
pperron constmanufact, lag(1) // I(1)
pperron constagricult, lag(1) // I(1)
* kpss
kpss constagricult, auto
kpss constmanufact, auto

var d.constmanufact d.constagricult, lags(1)

	varlmar, mlag(5)
	varnorm
	varstable, graph

vargranger 
// IND -> AGR (.001)
// AGR -> IND (.393)

* IRF
irf create Mexico, step(5) set(Mexico, replace)

// 'simple' IRF
irf graph irf, impulse(D.constmanufact) response(D.constagricult) byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Mexico_Man_Agr_SB_PRE, replace) title("") subtitle("Response of Agriculture to Industry") xmtick(#3) xlabel(#5) ylabel(#5) ytick(#5) ymtick(#3)  noci  yscale(range(-.5(.25).5))
irf graph irf, impulse(D.constagricult) response(D.constmanufact) note("") byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Mexico_Agr_Man_SB_PRE, replace) title("") subtitle("Response of Industry to Agriculture")  xmtick(#3) xlabel(#5) ylabel(#5) ytick(#5) ymtick(#3)  noci yscale(range(-.5(.25).5))
gr combine irf_ce_Mexico_Man_Agr_SB_PRE.gph  irf_ce_Mexico_Agr_Man_SB_PRE.gph, col(2) name(Mexico_irf_PRE, replace) subtitle("Pre Income Tax") saving(Mexico_irf_PRE.gph, replace)



* Mexico // post tax
clear
cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
keep if country==13 & year>1965

* set ts data
tsset, clear
tsset year, yearly

* plot
tsline constagricult constmanufact, subtitle("Post Income Tax") xtitle("") ytitle("") saving(Mexico_TS_POST.gph, replace) legend(label(1 "Agriculture") label(2 "Industry")) legend(cols(2)) ylabel(#3, labsize(vsmall)) ymtick(##3)

** MacKinnon approximate sign. p-value = stationarity
dfuller constmanufact, lag(1) reg // I(1)
dfuller constagricult, lag(1) reg // I(1)
* Phillips-Perron
pperron constmanufact, lag(1) // I(1)
pperron constagricult, lag(1) // I(1)
* kpss
kpss constagricult, auto
kpss constmanufact, auto

var d.constmanufact d.constagricult, lags(1/2)

	varlmar, mlag(5)
	varnorm
	varstable

vargranger
// IND -> AGR (.518)
// AGR -> IND (.062)



* IRF
irf create Mexico, step(5) set(Mexico, replace)

// 'simple' IRF
irf graph irf, impulse(D.constmanufact) response(D.constagricult) byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Mexico_Man_Agr_SB_POST, replace) title("") subtitle("Response of Agriculture to Industry") xmtick(#3) xlabel(#5) ylabel(#5) ytick(#5) ymtick(#3)  noci  yscale(range(-2(.5)1))
irf graph irf, impulse(D.constagricult) response(D.constmanufact) note("") byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Mexico_Agr_Man_SB_POST, replace) title("") subtitle("Response of Industry to Agriculture")  xmtick(#3) xlabel(#5) ylabel(#5) ytick(#5) ymtick(#3)  noci yscale(range(-2(.5)1))
gr combine irf_ce_Mexico_Man_Agr_SB_POST.gph  irf_ce_Mexico_Agr_Man_SB_POST.gph, col(2) saving(Mexico_irf_POST.gph, replace) subtitle("Post Income Tax")



graph combine Mexico_TS_PRE.gph Mexico_TS_POST.gph, rows(2) title("Sectoral Growth") iscale(.6) graphregion(margin(zero)) name(Mexico_Sectoral_Growth, replace)
graph combine Mexico_irf_PRE.gph Mexico_irf_POST.gph, rows(4) title("IRF") iscale(.6) graphregion(margin(zero)) name(Mexico_IRF, replace)
graph combine Mexico_IRF Mexico_Sectoral_Growth, cols(3) title("Mexico") iscale(.6) graphregion(margin(zero))
graph export "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/Mexico_StructuralBreak.pdf", replace


* Test for a structural break with an KNOWN break date

cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
keep if country==13

* set ts data
tsset, clear
tsset year, yearly

reg constmanufact constagricult
estat sbknown, break(1965) breakvars(constagricult)


* All periods
cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
keep if country==13

* set ts data
tsset, clear
tsset year, yearly

** MacKinnon approximate sign. p-value = stationarity
dfuller constmanufact, lag(1) reg 
dfuller constagricult, lag(1) reg 
*
pperron constmanufact, lag(1) 
pperron constagricult, lag(1) 
* kpss
kpss constagricult, auto
kpss constmanufact, auto
********************************************************************************************************************************************
* 															N	 I 	 C 	 A 	 R 	 A 	 G 	 U 	 A
********************************************************************************************************************************************



* Nicaragua // pretax

clear
cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
drop if year <1900
keep if country==14  & year<=1974

* set ts data
tsset, clear
tsset year, yearly

* plot
tsline constagricult constmanufact, subtitle("Pre Income Tax") xtitle("") ytitle("") saving(Nicaragua_TS_PRE.gph, replace) legend(label(1 "Agriculture") label(2 "Industry")) legend(cols(2)) ylabel(#3, labsize(vsmall)) ymtick(##3)

** MacKinnon approximate sign. p-value = stationarity
dfuller constmanufact, lag(1) reg // I(1)
dfuller constagricult, lag(1) reg // I(1)
* Phillips-Perron
pperron constmanufact, lag(1) // I(1)
pperron constagricult, lag(1) // I(1)
* kpss
kpss constagricult, auto
kpss constmanufact, auto

var d.constmanufact d.constagricult, lags(1/2)

	varlmar, mlag(5)
	varnorm
	varstable, graph

vargranger 
// IND -> AGR (.033)
// AGR -> IND (.787)

* IRF
irf create Nicaragua, step(5) set(Nicaragua, replace)

// 'simple' IRF
irf graph irf, impulse(D.constmanufact) response(D.constagricult) byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Nicaragua_Man_Agr_SB_PRE, replace) title("") subtitle("Response of Agriculture to Industry") xmtick(#3) xlabel(#5) ylabel(#5) ytick(#5) ymtick(#3)  noci  yscale(range(-.5(.25)1))
irf graph irf, impulse(D.constagricult) response(D.constmanufact) note("") byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Nicaragua_Agr_Man_SB_PRE, replace) title("") subtitle("Response of Industry to Agriculture")  xmtick(#3) xlabel(#5) ylabel(#5) ytick(#5) ymtick(#3)  noci yscale(range(-.5(.25)1))
gr combine irf_ce_Nicaragua_Man_Agr_SB_PRE.gph  irf_ce_Nicaragua_Agr_Man_SB_PRE.gph, col(2) name(Nicaragua_irf_PRE, replace) subtitle("Pre Income Tax") saving(Nicaragua_irf_PRE.gph, replace)



* Nicaragua // post tax

cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
keep if country==14  & year>1974

* set ts data
tsset, clear
tsset year, yearly

* plot
tsline constagricult constmanufact, subtitle("Post Income Tax") xtitle("") ytitle("") saving(Nicaragua_TS_POST.gph, replace) legend(label(1 "Agriculture") label(2 "Industry")) legend(cols(2)) ylabel(#3, labsize(vsmall)) ymtick(##3)

** MacKinnon approximate sign. p-value = stationarity
dfuller constmanufact, lag(1) reg // I(1)
dfuller constagricult, lag(1) reg // I(1)
* Phillips-Perron
pperron constmanufact, lag(1) // I(1)
pperron constagricult, lag(1) // I(1)
* kpss
kpss constagricult, auto
kpss constmanufact, auto

var d.constmanufact d.constagricult, lags(1)

	varlmar, mlag(5)
	varnorm
	varstable

vargranger
// IND -> AGR (.026)
// AGR -> IND (.906)



* IRF
irf create Nicaragua, step(5) set(Nicaragua, replace)

// 'simple' IRF
irf graph irf, impulse(D.constmanufact) response(D.constagricult) byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Nicaragua_Man_Agr_SB_POST, replace) title("") subtitle("Response of Agriculture to Industry") xmtick(#3) xlabel(#5) ylabel(#5) ytick(#5) ymtick(#3)  noci  yscale(range(-.5(.25).5))
irf graph irf, impulse(D.constagricult) response(D.constmanufact) note("") byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Nicaragua_Agr_Man_SB_POST, replace) title("") subtitle("Response of Industry to Agriculture")  xmtick(#3) xlabel(#5) ylabel(#5) ytick(#5) ymtick(#3)  noci yscale(range(-.5(.25).5))
gr combine irf_ce_Nicaragua_Man_Agr_SB_POST.gph  irf_ce_Nicaragua_Agr_Man_SB_POST.gph, col(2) saving(Nicaragua_irf_POST.gph, replace) subtitle("Post Income Tax")



graph combine Nicaragua_TS_PRE.gph Nicaragua_TS_POST.gph, rows(2) title("Sectoral Growth") iscale(.6) graphregion(margin(zero)) name(Nicaragua_Sectoral_Growth, replace)
graph combine Nicaragua_irf_PRE.gph Nicaragua_irf_POST.gph, rows(4) title("IRF") iscale(.6) graphregion(margin(zero)) name(Nicaragua_IRF, replace)
graph combine Nicaragua_IRF Nicaragua_Sectoral_Growth, cols(3) title("Nicaragua") iscale(.6) graphregion(margin(zero))
graph export "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/Nicaragua_StructuralBreak.pdf", replace


* Test for a structural break with an KNOWN break date

cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
keep if country==14

* set ts data
tsset, clear
tsset year, yearly

reg constmanufact constagricult
estat sbknown, break(1974) breakvars(constagricult)



* All periods
cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
keep if country==14

* set ts data
tsset, clear
tsset year, yearly

** MacKinnon approximate sign. p-value = stationarity
dfuller constmanufact, lag(1) reg 
dfuller constagricult, lag(1) reg 
*
pperron constmanufact, lag(1) 
pperron constagricult, lag(1)
* kpss
kpss constagricult, auto
kpss constmanufact, auto 

********************************************************************************************************************************************
* 															G 	U 	A 	T 	E 	M 	A 	L 	A
********************************************************************************************************************************************



* Guatemala // pretax

clear
cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
drop if year <1900
keep if country==10  & year<=1963

* set ts data
tsset, clear
tsset year, yearly

* plot
tsline constagricult constmanufact, subtitle("Pre Income Tax") xtitle("") ytitle("") saving(Guatemala_TS_PRE.gph, replace) legend(label(1 "Agriculture") label(2 "Industry")) legend(cols(2)) ylabel(#3, labsize(vsmall)) ymtick(##3)

** MacKinnon approximate sign. p-value = stationarity
dfuller constmanufact, lag(1) reg // I(1)
dfuller constagricult, lag(1) reg // I(1)
* Phillips-Perron
pperron constmanufact, lag(1) // I(1)
pperron constagricult, lag(1) // I(1)
* kpss
kpss constagricult, auto
kpss constmanufact, auto

var d.constmanufact d.constagricult, lags(1/3)

	varlmar, mlag(5)
	varnorm
	varstable, graph

vargranger 
// IND -> AGR (.081)
// AGR -> IND (.536)

* IRF
irf create Guatemala, step(5) set(Guatemala, replace)

// 'simple' IRF
irf graph irf, impulse(D.constmanufact) response(D.constagricult) byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Guatemala_Man_Agr_SB_PRE, replace) title("") subtitle("Response of Agriculture to Industry") xmtick(#3) xlabel(#5) ylabel(#5) ytick(#5) ymtick(#3)  noci  yscale(range(-1.5(.25)1))
irf graph irf, impulse(D.constagricult) response(D.constmanufact) note("") byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Guatemala_Agr_Man_SB_PRE, replace) title("") subtitle("Response of Industry to Agriculture")  xmtick(#3) xlabel(#5) ylabel(#5) ytick(#5) ymtick(#3)  noci yscale(range(-1.5(.25)1))
gr combine irf_ce_Guatemala_Man_Agr_SB_PRE.gph  irf_ce_Guatemala_Agr_Man_SB_PRE.gph, col(2) name(Guatemala_irf_PRE, replace) subtitle("Pre Income Tax") saving(Guatemala_irf_PRE.gph, replace)



* Guatemala // post tax

cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
keep if country==10  & year>1963

* set ts data
tsset, clear
tsset year, yearly

* plot
tsline constagricult constmanufact, subtitle("Post Income Tax") xtitle("") ytitle("") saving(Guatemala_TS_POST.gph, replace) legend(label(1 "Agriculture") label(2 "Industry")) legend(cols(2)) ylabel(#3, labsize(vsmall)) ymtick(##3)

** MacKinnon approximate sign. p-value = stationarity
dfuller constmanufact, lag(1) reg // I(1)
dfuller constagricult, lag(1) reg // I(1)
* Phillips-Perron
pperron constmanufact, lag(1) // I(1)
pperron constagricult, lag(1) // I(1)
* kpss
kpss constagricult, auto
kpss constmanufact, auto

var d.constmanufact d.constagricult, lags(1)

	varlmar, mlag(5)
	varnorm
	varstable

vargranger
// IND -> AGR (.014)
// AGR -> IND (.446)



* IRF
irf create Guatemala, step(5) set(Guatemala, replace)

// 'simple' IRF
irf graph irf, impulse(D.constmanufact) response(D.constagricult) byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Guatemala_Man_Agr_SB_POST, replace) title("") subtitle("Response of Agriculture to Industry") xmtick(#3) xlabel(#5) ylabel(#5) ytick(#5) ymtick(#3)  noci  yscale(range(-.5(.5).5))
irf graph irf, impulse(D.constagricult) response(D.constmanufact) note("") byopts(note("") legend(off)) xtitle(Years) saving(irf_ce_Guatemala_Agr_Man_SB_POST, replace) title("") subtitle("Response of Industry to Agriculture")  xmtick(#3) xlabel(#5) ylabel(#5) ytick(#5) ymtick(#3)  noci yscale(range(-.5(.5).5))
gr combine irf_ce_Guatemala_Man_Agr_SB_POST.gph  irf_ce_Guatemala_Agr_Man_SB_POST.gph, col(2) saving(Guatemala_irf_POST.gph, replace) subtitle("Post Income Tax")



graph combine Guatemala_TS_PRE.gph Guatemala_TS_POST.gph, rows(2) title("Sectoral Growth") iscale(.6) graphregion(margin(zero)) name(Guatemala_Sectoral_Growth, replace)
graph combine Guatemala_irf_PRE.gph Guatemala_irf_POST.gph, rows(4) title("IRF") iscale(.6) graphregion(margin(zero)) name(Guatemala_IRF, replace)
graph combine Guatemala_IRF Guatemala_Sectoral_Growth, cols(3) title("Guatemala") iscale(.6) graphregion(margin(zero))
graph export "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/Guatemala_StructuralBreak.pdf", replace



* Test for a structural break with an KNOWN break date

cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
keep if country==10

* set ts data
tsset, clear
tsset year, yearly

reg constmanufact constagricult
estat sbknown, break(1963) breakvars(constagricult)



* All periods
cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
keep if country==10

* set ts data
tsset, clear
tsset year, yearly

** MacKinnon approximate sign. p-value = stationarity
dfuller constmanufact, lag(1) reg 
dfuller constagricult, lag(1) reg 
*
pperron constmanufact, lag(1) 
pperron constagricult, lag(1) 
* kpss
kpss constagricult, auto
kpss constmanufact, auto



******************************************************************************************************************************************** Structural Breaks Graph
*******************************************************************************************************************************************

net install grc1leg, replace

** this below is just to create a fake Chile plot with a smaller legend.
clear all
cd "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink"
use "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta", clear

* Keeping one country
keep if country==4 & year<=1924

* set ts data
tsset, clear
tsset year, yearly

tsline constagricult constmanufact, subtitle("Pre Income Tax") xtitle("") ytitle("") saving(Chile_TS_PRE_legend.gph, replace) legend(label(1 "Agriculture") label(2 "Industry")) legend(cols(2)) ylabel(#3, labsize(vsmall)) ymtick(##3)  legend(size(tiny))

** now I combine different graphs to plot the final one that will go to the paper.
grc1leg Chile_TS_PRE_legend.gph Chile_TS_POST.gph, legendfrom(Chile_TS_PRE_legend.gph) col(2) title("Chile") iscale(.6) graphregion(margin(zero)) saving(Chile_Sectoral_Growth_Paper.gph, replace)


grc1leg Colombia_TS_PRE.gph Colombia_TS_POST.gph, legendfrom(Colombia_TS_PRE.gph) col(2) title("Colombia") iscale(.6) graphregion(margin(zero)) saving(Colombia_Sectoral_Growth_Paper.gph, replace)
grc1leg Argentina_TS_PRE.gph Argentina_TS_POST.gph, legendfrom(Argentina_TS_PRE.gph) col(2) title("Argentina") iscale(.6) graphregion(margin(zero)) saving(Argentina_Sectoral_Growth_Paper.gph, replace)
grc1leg Mexico_TS_PRE.gph Mexico_TS_POST.gph, legendfrom(Mexico_TS_PRE.gph) col(2) title("Mexico") iscale(.6) graphregion(margin(zero)) saving(Mexico_Sectoral_Growth_Paper.gph, replace)
grc1leg Nicaragua_TS_PRE.gph Nicaragua_TS_POST.gph, legendfrom(Nicaragua_TS_PRE.gph) col(2) title("Nicaragua") iscale(.6) graphregion(margin(zero)) saving(Nicaragua_Sectoral_Growth_Paper.gph, replace)
grc1leg Guatemala_TS_PRE.gph Guatemala_TS_POST.gph, legendfrom(Guatemala_TS_PRE.gph) col(2) title("Guatemala") iscale(.6) graphregion(margin(zero)) saving(Guatemala_Sectoral_Growth_Paper.gph, replace)

grc1leg Chile_Sectoral_Growth_Paper.gph Colombia_Sectoral_Growth_Paper.gph Argentina_Sectoral_Growth_Paper.gph Mexico_Sectoral_Growth_Paper.gph Nicaragua_Sectoral_Growth_Paper.gph Guatemala_Sectoral_Growth_Paper.gph, legendfrom(Chile_Sectoral_Growth_Paper.gph) col(2) iscale(.6) graphregion(margin(zero)) name(Structural_Breaks_Paper, replace)
graph export "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/Structural_Breaks_Paper.pdf", replace


******************************************************************************************************************************************** IRF Graph
*******************************************************************************************************************************************


graph combine Chile_irf_PRE.gph Chile_irf_POST.gph, rows(2) title("Chile") iscale(.6) graphregion(margin(zero)) saving(Chile_IRF_paper.gph, replace)
graph combine Colombia_irf_PRE.gph Colombia_irf_POST.gph, rows(2) title("Colombia") iscale(.6) graphregion(margin(zero)) saving(Colombia_IRF_paper.gph, replace)
graph combine Argentina_irf_PRE.gph Argentina_irf_POST.gph, rows(2) title("Argentina") iscale(.6) graphregion(margin(zero)) saving(Argentina_IRF_paper.gph, replace)
graph combine Mexico_irf_PRE.gph Mexico_irf_POST.gph, rows(2) title("Mexico") iscale(.6) graphregion(margin(zero)) saving(Mexico_IRF_paper.gph, replace)
graph combine Nicaragua_irf_PRE.gph Nicaragua_irf_POST.gph, rows(2) title("Nicaragua") iscale(.6) graphregion(margin(zero)) saving(Nicaragua_IRF_paper.gph, replace)
graph combine Guatemala_irf_PRE.gph Guatemala_irf_POST.gph, rows(2) title("Guatemala") iscale(.6) graphregion(margin(zero)) saving(Guatemala_IRF_paper.gph, replace)

graph combine Chile_IRF_paper.gph Colombia_IRF_paper.gph Argentina_IRF_paper.gph Mexico_IRF_paper.gph Nicaragua_IRF_paper.gph Guatemala_IRF_paper.gph, iscale(.6) graphregion(margin(zero)) name(IRF_paper, replace)
graph export "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/IRF_Paper.pdf", replace

