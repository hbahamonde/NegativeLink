##################################################################
# Suze, 11.28.2012 Added code to estimate constant corr models to
# get const corr and se for plots. These results are in tables.
# Suzie, 10.29.2012 Estimating DCC Pairs for ICS and its components
# also ICS and CCI.  Using residuals from ARFIMA models estimated 
# in Stata and exported from M_Identification.do
# icsres4 is ARFIMA(1,d,0), pagores7 is ARIMA(0,1,1) This one isn't
# pretty but none for pago are, pexpres5 is ARIMA(1,1,1), bus12res6
# is ARFIMA(0,d,1), bus5res4 is ARFIMA(0,d,0) and durres4 is ARIMA(1,1,1)
# ccires5 is ARIMA(0,1,0)
# Suzie, 2.4.2012 Trying to estimate some DCC models that I also 
# tried to estimate in Stata. I'm hoping the results are the same
# This merges in the Conference Board Data
##################################################################
setwd("/Users/slinn/Dropbox/Sentiment/ICS_Data/Monthly_Data/Identification/M_Stata_Files") 

library(ccgarch)
library(utils)
library(foreign)
library(stats)
library(graphics)
library(lmtest)
library(TSA)
library(urca)
rm(list=ls())	#Clears the memory


filteredICS<-read.csv("M_Filtered_Sentiment.csv")
attach(filteredICS)
filteredICS<-ts(filteredICS,start=c(1978,2),freq=12)
icsres4<-ts(icsres4,start=c(1978,2),freq=12)
pagores7<-ts(pagores7,start=c(1978,2), freq=12)
pexpres5<-ts(pexpres5,start=c(1978,2), freq=12)
bus12res6<-ts(bus12res6,start=c(1978,2), freq=12)
bus5res4<-ts(bus5res4,start=c(1978,2), freq=12)
durres4<-ts(durres4,start=c(1978,2), freq=12)
ccires5<-ts(ccires5,start=c(1978,2), freq=12)

filtered<-ts.intersect(icsres4,pagores7,pexpres5,bus12res6,bus5res4,durres4)

####Graph### JUST SAMPLE###
ts.plot(filtered, xlab="Month", ylab="Correlation", main="Filtered Series", lty=1, col=c("steelblue", "goldenrod","forest green","black"))
legend(locator(1), c("ICS-PAGO", "ICS-PEXP", "ICS-BUS12", 'ICS-BUS5'), fill=c("red", "steelblue", "goldenrod","forest green","black"))


####Bind each ICS pairing###
ics.pago.bound<-ts.intersect(icsres4,pagores7)
ics.pexp.bound<-ts.intersect(icsres4,pexpres5)
ics.bus12.bound<-ts.intersect(icsres4,bus12res6)
ics.bus5.bound<-ts.intersect(icsres4,bus5res4)
ics.dur.bound<-ts.intersect(icsres4,durres4)
ics.cci.bound<-ts.intersect(icsres4,ccires5)



###########################################################
###########################################################
# ICS AND CCI
###########################################################
###########################################################
a<-c(1,0)
A<-diag(c(.1,.3))	
B<-diag(c(.1,.4))
dcc.para<-c(.22,.53)

dcc.results.ics.cci<-dcc.estimation(inia=a,iniA=A,iniB=B,ini.dcc=dcc.para,dvar=ics.cci.bound,model="diagonal")

###pull out the results of first stage estimation###
first.cci<-dcc.results.ics.cci$first
first.cci
###pull out the results for the second stage estimation###
second.cci<-dcc.results.ics.cci$second
second.cci

####Pull out coefficient estimates and standard errors###
coeffs.cci<-dcc.results.ics.cci$out
coeffs.cci

###pull out the conditional variances###

cond.var.cci<-dcc.results.ics.cci$h
cond.var.cci[1:5]


####Pull out dynamic correlations###
cors.cci<-dcc.results.ics.cci$DCC
ics.cci.cors<-ts(cors.cci[,2],start=c(1978,2),freq=12)


########################################################################
# Estimate a constant conditional correlation model to get standard    #
# error on the constant correlation									   #
########################################################################
ccc.results.ics.cci<-eccc.estimation(a,A,B,dcc.para,dvar=ics.cci.bound,model="diagonal", method="BFGS")
####Pull out coefficient estimates and standard errors###
ccc.coeffs.ics.cci<-ccc.results.ics.cci$out
ccc.coeffs.ics.cci

####Compute confidence bounds###
ics.cci.concor<-ccc.coeffs.ics.cci[1,7]
ics.cci.concor
ics.cci.concorse<-ccc.coeffs.ics.cci[4,7]
ics.cci.concorse
ics.cci.posconf<-ics.cci.concor+(2*ics.cci.concorse)
ics.cci.negconf<-ics.cci.concor-(2*ics.cci.concorse)


####Plot dynamic correlations and constant correlation with confidence bounds ###
ts.plot(ics.cci.cors,ics.cci.concor,ics.cci.posconf,ics.cci.negconf, xlab="Month", ylab="Correlation", main="Dynamic Conditional Correlations", sub="ICS AND CCI, 1978:2-2010M11",lty=c("solid","solid","dashed","dashed"), col=c("black","green","blue","blue"))


########################################################################
########################################################################
# ICS AND PAGO
########################################################################
########################################################################

dcc.results.ics.pago<-dcc.estimation(inia=a,iniA=A,iniB=B,ini.dcc=dcc.para,dvar=ics.pago.bound,model="diagonal")

###pull out the results of first stage estimation###
first.pago<-dcc.results.isc.pago$first
first.pago
###pull out the results for the second stage estimation###
second.pago<-dcc.results.ics.pago$second
second.pago

####Pull out coefficient estimates and standard errors###
coeffs.pago<-dcc.results.ics.pago$out
coeffs.pago

###pull out the conditional variances###

cond.var.pago<-dcc.results.ics.pago$h
cond.var.pago[1:5]


####Pull out dynamic correlations###
cors.pago<-dcc.results.ics.pago$DCC
ics.pago.cors<-ts(cors.pago[,2],start=c(1978,2),freq=12)

########################################################################
# Estimate a constant conditional correlation model to get standard    #
# error on the constant correlation									   #
########################################################################
ccc.results.ics.pago<-eccc.estimation(a,A,B,dcc.para,dvar=ics.pago.bound,model="diagonal", method="BFGS")
####Pull out coefficient estimates and standard errors###
ccc.coeffs.ics.pago<-ccc.results.ics.pago$out
ccc.coeffs.ics.pago


########################################################################
# Estimate a constant conditional correlation model to get standard    #
# error on the constant correlation									   #
########################################################################
ccc.results.ics.pago<-eccc.estimation(a,A,B,dcc.para,dvar=ics.pago.bound,model="diagonal", method="BFGS")
####Pull out coefficient estimates and standard errors###
ccc.coeffs.ics.pago<-ccc.results.ics.pago$out
ccc.coeffs.ics.pago

####Compute confidence bounds###
ics.pago.concor<-ccc.coeffs.ics.pago[1,7]
ics.pago.concor
ics.pago.concorse<-ccc.coeffs.ics.pago[4,7]
ics.pago.concorse
ics.pago.posconf<-ics.pago.concor+(2*ics.pago.concorse)
ics.pago.negconf<-ics.pago.concor-(2*ics.pago.concorse)


####Plot dynamic correlations and constant correlation with confidence bounds ###
ts.plot(ics.pago.cors,ics.pago.concor,ics.pago.posconf,ics.pago.negconf, xlab="Month", ylab="Correlation", main="Dynamic Conditional Correlations", sub="ICS AND PAGO, 1978:2-2010M11",lty=c("solid","solid","dashed","dashed"), col=c("black","green","blue","blue"))


###########################################################
###########################################################
# ICS AND PEXP
###########################################################
###########################################################
dcc.results.ics.pexp<-dcc.estimation(inia=a,iniA=A,iniB=B,ini.dcc=dcc.para,dvar=ics.pexp.bound,model="diagonal")

###pull out the results of first stage estimation###
first.pexp<-dcc.results.ics.pexp$first
first.pexp
###pull out the results for the second stage estimation###
second.pexp<-dcc.results.ics.pexp$second
second.pexp

####Pull out coefficient estimates and standard errors###
coeffs.pexp<-dcc.results.ics.pexp$out
coeffs.pexp

###pull out the conditional variances###

cond.var.pexp<-dcc.results.ics.pexp$h
cond.var.pexp[1:5]


####Pull out dynamic correlations###
cors.pexp<-dcc.results.ics.pexp$DCC
ics.pexp.cors<-ts(cors.pexp[,2],start=c(1978,2),freq=12)

########################################################################
# Estimate a constant conditional correlation model to get standard    #
# error on the constant correlation									   #
########################################################################
ccc.results.ics.pexp<-eccc.estimation(a,A,B,dcc.para,dvar=ics.pexp.bound,model="diagonal", method="BFGS")
####Pull out coefficient estimates and standard errors###
ccc.coeffs.ics.pexp<-ccc.results.ics.pexp$out
ccc.coeffs.ics.pexp


####Compute confidence bounds###
ics.pexp.concor<-ccc.coeffs.ics.pexp[1,7]
ics.pexp.concor
ics.pexp.concorse<-ccc.coeffs.ics.pexp[4,7]
ics.pexp.concorse
ics.pexp.posconf<-ics.pexp.concor+(2*ics.pexp.concorse)
ics.pexp.negconf<-ics.pexp.concor-(2*ics.pexp.concorse)


####Plot dynamic correlations and constant correlation with confidence bounds ###
ts.plot(ics.pexp.cors,ics.pexp.concor,ics.pexp.posconf,ics.pexp.negconf, xlab="Month", ylab="Correlation", main="Dynamic Conditional Correlations", sub="ICS AND PEXP, 1978:2-2010M11",lty=c("solid","solid","dashed","dashed"), col=c("black","green","blue","blue"))


###########################################################
###########################################################
# ICS AND BUS12
###########################################################
###########################################################
dcc.results.ics.bus12<-dcc.estimation(inia=a,iniA=A,iniB=B,ini.dcc=dcc.para,dvar=ics.bus12.bound,model="diagonal")

###pull out the results of first stage estimation###
first.bus12<-dcc.results.ics.bus12$first
first.bus12
###pull out the results for the second stage estimation###
second.bus12<-dcc.results.ics.bus12$second
second.bus12

####Pull out coefficient estimates and standard errors###
coeffs.bus12<-dcc.results.ics.bus12$out
coeffs.bus12

###pull out the conditional variances###

cond.var.bus12<-dcc.results.ics.bus12$h
cond.var.bus12[1:5]

####Pull out dynamic correlations###
cors.bus12<-dcc.results.ics.bus12$DCC
ics.bus12.cors<-ts(cors.bus12[,2],start=c(1978,2),freq=12)

########################################################################
# Estimate a constant conditional correlation model to get standard    #
# error on the constant correlation									   #
########################################################################
ccc.results.ics.bus12<-eccc.estimation(a,A,B,dcc.para,dvar=ics.bus12.bound,model="diagonal", method="BFGS")
####Pull out coefficient estimates and standard errors###
ccc.coeffs.ics.bus12<-ccc.results.ics.bus12$out
ccc.coeffs.ics.bus12


####Compute confidence bounds###
ics.bus12.concor<-ccc.coeffs.ics.bus12[1,7]
ics.bus12.concor
ics.bus12.concorse<-ccc.coeffs.ics.bus12[4,7]
ics.bus12.concorse
ics.bus12.posconf<-ics.bus12.concor+(2*ics.bus12.concorse)
ics.bus12.negconf<-ics.bus12.concor-(2*ics.bus12.concorse)


####Plot dynamic correlations and constant correlation with confidence bounds ###
ts.plot(ics.bus12.cors,ics.bus12.concor,ics.bus12.posconf,ics.bus12.negconf, xlab="Month", ylab="Correlation", main="Dynamic Conditional Correlations", sub="ICS AND BUS12, 1978:2-2010M11",lty=c("solid","solid","dashed","dashed"), col=c("black","green","blue","blue"))


###########################################################
###########################################################
# ICS AND BUS5
###########################################################
###########################################################
dcc.results.ics.bus5<-dcc.estimation(inia=a,iniA=A,iniB=B,ini.dcc=dcc.para,dvar=ics.bus5.bound,model="diagonal")

###pull out the results of first stage estimation###
first.bus5<-dcc.results.ics.bus5$first
first.bus5
###pull out the results for the second stage estimation###
second.bus5<-dcc.results.ics.bus5$second
second.bus5

####Pull out coefficient estimates and standard errors###
coeffs.bus5<-dcc.results.ics.bus5$out
coeffs.bus5

###pull out the conditional variances###

cond.var.bus5<-dcc.results.ics.bus5$h
cond.var.bus5[1:5]

####Pull out dynamic correlations###
cors.bus5<-dcc.results.ics.bus5$DCC
ics.bus5.cors<-ts(cors.bus5[,2],start=c(1978,2),freq=12)

########################################################################
# Estimate a constant conditional correlation model to get standard    #
# error on the constant correlation									   #
########################################################################
ccc.results.ics.bus5<-eccc.estimation(a,A,B,dcc.para,dvar=ics.bus5.bound,model="diagonal", method="BFGS")
####Pull out coefficient estimates and standard errors###
ccc.coeffs.ics.bus5<-ccc.results.ics.bus5$out
ccc.coeffs.ics.bus5


####Compute confidence bounds###
ics.bus5.concor<-ccc.coeffs.ics.bus5[1,7]
ics.bus5.concor
ics.bus5.concorse<-ccc.coeffs.ics.bus5[4,7]
ics.bus5.concorse
ics.bus5.posconf<-ics.bus5.concor+(2*ics.bus5.concorse)
ics.bus5.negconf<-ics.bus5.concor-(2*ics.bus5.concorse)


####Plot dynamic correlations and constant correlation with confidence bounds ###
ts.plot(ics.bus5.cors,ics.bus5.concor,ics.bus5.posconf,ics.bus5.negconf, xlab="Month", ylab="Correlation", main="Dynamic Conditional Correlations", sub="ICS AND BUS5, 1978:2-2010M11",lty=c("solid","solid","dashed","dashed"), col=c("black","green","blue","blue"))


###########################################################
###########################################################
# ICS AND DUR
###########################################################
###########################################################
dcc.results.ics.dur<-dcc.estimation(inia=a,iniA=A,iniB=B,ini.dcc=dcc.para,dvar=ics.dur.bound,model="diagonal")

###pull out the results of first stage estimation###
first.dur<-dcc.results.ics.dur$first
first.dur
###pull out the results for the second stage estimation###
second.dur<-dcc.results.ics.dur$second
second.dur

####Pull out coefficient estimates and standard errors###
coeffs.dur<-dcc.results.ics.dur$out
coeffs.dur

###pull out the conditional variances###

cond.var.dur<-dcc.results.ics.dur$h
cond.var.dur[1:5]

####Pull out dynamic correlations###
cors.dur<-dcc.results.ics.dur$DCC
ics.dur.cors<-ts(cors.dur[,2],start=c(1978,2),freq=12)

########################################################################
# Estimate a constant conditional correlation model to get standard    #
# error on the constant correlation									   #
########################################################################
ccc.results.ics.dur<-eccc.estimation(a,A,B,dcc.para,dvar=ics.dur.bound,model="diagonal", method="BFGS")
####Pull out coefficient estimates and standard errors###
ccc.coeffs.ics.dur<-ccc.results.ics.dur$out
ccc.coeffs.ics.dur


####Compute confidence bounds###
ics.dur.concor<-ccc.coeffs.ics.dur[1,7]
ics.dur.concor
ics.dur.concorse<-ccc.coeffs.ics.dur[4,7]
ics.dur.concorse
ics.dur.posconf<-ics.dur.concor+(2*ics.dur.concorse)
ics.dur.negconf<-ics.dur.concor-(2*ics.dur.concorse)


####Plot dynamic correlations and constant correlation with confidence bounds ###
ts.plot(ics.dur.cors,ics.dur.concor,ics.dur.posconf,ics.dur.negconf, xlab="Month", ylab="Correlation", main="Dynamic Conditional Correlations", sub="ICS AND DUR, 1978:2-2010M11",lty=c("solid","solid","dashed","dashed"), col=c("black","green","blue","blue"))


####Plot dynamic correlations and constant correlation with confidence bounds ###
ts.plot(ics.dur.cors, xlab="Month", ylab="Correlation", main="Dynamic Conditional Correlations", sub="ICS AND DUR, 1978:2-2010M11",lty=1, col=c("black","green"))

########################################################################
#####################################################################################KEEPING CODE BELOW HERE ### SUZIE OCTOBER 29, 2012 #######
########################################################################
########################################################################
########################################################################
# Totally screwing around here with ARMA series#
########################################################################
# ICS ARMA(2,0,0) WITH PAGO ARMA(2,0,0) Residuals are white noise 
########################################################################
armaics<-arima(ics,order=c(2,0,0))
armaics
armaicsfilter<-armaics$residuals
Box.test(armaicsfilter, lag=1, type="Ljung")

armapago<-arima(pago,order=c(2,0,0))
armapago
armapagofilter<-armapago$residuals
Box.test(armapagofilter, lag=1, type="Ljung")

mean(armaicsfilter)
mean(armapagofilter)

armaincpago.bind<-ts.intersect(armaicsfilter,armapagofilter)


a<-c(1,1)
A<-diag(c(.3,.3))	
B<-diag(c(.4,.4))
dcc.para<-c(.22,.53)

dcc.results9<-dcc.estimation(inia=a,iniA=A,iniB=B,ini.dcc=dcc.para,dvar=armaincpago.bind,model="diagonal")

###pull out the results of first stage estimation###
first<-dcc.results9$first
first
###pull out the results for the second stage estimation###
second<-dcc.results9$second
second

####Pull out coefficient estimates and standard errors###
coeffs<-dcc.results9$out
coeffs

###pull out the conditional variances###

cond.var<-dcc.results9$h
cond.var


####Pull out dynamic correlations###
cors<-dcc.results9$DCC
armaicspago<-ts(cors[,2],start=c(1978,2),freq=12)

ts.plot(cors[,2], xlab="Month", ylab="Correlation", main="Dynamic Conditional Correlations", sub="ICS and PAGO, 1978:2-2010M11",lty=1, col=c("black","green"))
#legend(locator(1), c("ICS-PAGO", "ICS-PEXP", "ICS-BUS12", 'ICS-BUS5',"ICS-DUR"), fill=c("red", "steelblue", #"goldenrod","forest green","black"))

########################################################################
########################################################################
########################################################################
# Totally screwing around here with ARMA series#
######################################################################### ICS ARMA(2,0,0) WITH PEXP ARMA(2,0,0) Residuals are white noise 
########################################################################
########################################################################
armapexp<-arima(pexp,order=c(2,0,0))
armapexp
armapexpfilter<-armapexp$residuals
Box.test(armapexpfilter, lag=1, type="Ljung")

armaicspexp.bind<-ts.intersect(armaicsfilter,armapexpfilter)

a<-c(1,1)
A<-diag(c(.3,.3))	
B<-diag(c(.4,.4))
dcc.para<-c(.22,.53)

dcc.results10<-dcc.estimation(inia=a,iniA=A,iniB=B,ini.dcc=dcc.para,dvar=armaicspexp.bind,model="diagonal")

###pull out the results of first stage estimation###
first<-dcc.results10$first
first
###pull out the results for the second stage estimation###
second<-dcc.results10$second
second

####Pull out coefficient estimates and standard errors###
coeffs<-dcc.results10$out
coeffs

###pull out the conditional variances###

cond.var<-dcc.results10$h
cond.var


####Pull out dynamic correlations###
cors<-dcc.results10$DCC
armaicspexp<-ts(cors[,2],start=c(1978,2),freq=12)

ts.plot(cors[,2], xlab="Month", ylab="Correlation", main="Dynamic Conditional Correlations", sub="ICS AND PEXP, 1978:2-2010M11",lty=1, col=c("black","green"))
#legend(locator(1), c("ICS-PAGO", "ICS-PEXP", "ICS-BUS12", 'ICS-BUS5',"ICS-DUR"), fill=c("red", "steelblue", #"goldenrod","forest green","black"))

########################################################################
########################################################################
########################################################################
# Totally screwing around here with ARMA series#
########################################################################
# ICS ARMA(2,0,0) WITH BUS12 ARMA(2,0,0) Residuals are white noise 
########################################################################
########################################################################
armabus12<-arima(bus12,order=c(2,0,0))
armabus12
armabus12filter<-armabus12$residuals
Box.test(armabus12filter, lag=1, type="Ljung")

armaicsbus12.bind<-ts.intersect(armaicsfilter,armabus12filter)
a<-c(1,1)
A<-diag(c(.3,.3))	
B<-diag(c(.4,.4))
dcc.para<-c(.22,.53)

dcc.results11<-dcc.estimation(inia=a,iniA=A,iniB=B,ini.dcc=dcc.para,dvar=armaicsbus12.bind,model="diagonal")

###pull out the results of first stage estimation###
first<-dcc.results11$first
first
###pull out the results for the second stage estimation###
second<-dcc.results11$second
second

####Pull out coefficient estimates and standard errors###
coeffs<-dcc.results11$out
coeffs

###pull out the conditional variances###

cond.var<-dcc.results11$h
cond.var


####Pull out dynamic correlations###
cors<-dcc.results11$DCC
armaicsbus12<-ts(cors[,2],start=c(1978,2),freq=12)

ts.plot(cors[,2], xlab="Month", ylab="Correlation", main="Dynamic Conditional Correlations", sub="ICS AND BUS12, 1978:2-2010M11",lty=1, col=c("black","green"))
#legend(locator(1), c("ICS-PAGO", "ICS-PEXP", "ICS-BUS12", 'ICS-BUS5',"ICS-DUR"), fill=c("red", "steelblue", #"goldenrod","forest green","black"))

########################################################################
########################################################################
########################################################################
# Totally screwing around here with ARMA series#
######################################################################### ICS ARMA(2,0,0) WITH BUS5 ARMA(2,0,0) Residuals are white noise 
########################################################################
########################################################################
armabus5<-arima(bus5,order=c(2,0,0))
armabus5
armabus5filter<-armabus5$residuals
Box.test(armabus5filter, lag=1, type="Ljung")

armaicsbus5.bind<-ts.intersect(armaicsfilter,armabus5filter)
a<-c(1,1)
A<-diag(c(.3,.3))	
B<-diag(c(.4,.4))
dcc.para<-c(.22,.53)

dcc.results12<-dcc.estimation(inia=a,iniA=A,iniB=B,ini.dcc=dcc.para,dvar=armaicsbus5.bind,model="diagonal")

###pull out the results of first stage estimation###
first<-dcc.results12$first
first
###pull out the results for the second stage estimation###
second<-dcc.results12$second
second

####Pull out coefficient estimates and standard errors###
coeffs<-dcc.results12$out
coeffs

###pull out the conditional variances###

cond.var<-dcc.results12$h
cond.var


####Pull out dynamic correlations###
cors<-dcc.results12$DCC
armaicsbus5<-ts(cors[,2],start=c(1978,2),freq=12)

ts.plot(cors[,2], xlab="Month", ylab="Correlation", main="Dynamic Conditional Correlations", sub="ICS AND BUS5, 1978:2-2010M11",lty=1, col=c("black","green"))
#legend(locator(1), c("ICS-PAGO", "ICS-PEXP", "ICS-BUS12", 'ICS-BUS5',"ICS-DUR"), fill=c("red", "steelblue", #"goldenrod","forest green","black"))

########################################################################
########################################################################
########################################################################
########################################################################
########################################################################
# Totally screwing around here with ARMA series#
######################################################################### ICS ARMA(2,0,0) WITH DUR ARMA(2,0,0) Residuals are white noise 
########################################################################
########################################################################
armadur<-arima(dur,order=c(2,0,0))
armadur
armadurfilter<-armadur$residuals
Box.test(armadurfilter, lag=1, type="Ljung")

armaicsdur.bind<-ts.intersect(armaicsfilter,armadurfilter)
a<-c(1,1)
A<-diag(c(.3,.3))	
B<-diag(c(.4,.4))
dcc.para<-c(.22,.53)

dcc.results13<-dcc.estimation(inia=a,iniA=A,iniB=B,ini.dcc=dcc.para,dvar=armaicsdur.bind,model="diagonal")


###pull out the results of first stage estimation###
first<-dcc.results13$first
first
###pull out the results for the second stage estimation###
second<-dcc.results13$second
second

####Pull out coefficient estimates and standard errors###
coeffs<-dcc.results13$out
coeffs

###pull out the conditional variances###

cond.var<-dcc.results13$h
cond.var


####Pull out dynamic correlations###
cors<-dcc.results13$DCC
armaicsdur<-ts(cors[,2],start=c(1978,2),freq=12)

ts.plot(cors[,2], xlab="Month", ylab="Correlation", main="Dynamic Conditional Correlations", sub="ICS AND BUS5, 1978:2-2010M11",lty=1, col=c("black","green"))
#legend(locator(1), c("ICS-PAGO", "ICS-PEXP", "ICS-BUS12", 'ICS-BUS5',"ICS-DUR"), fill=c("red", "steelblue", #"goldenrod","forest green","black"))

########################################################################
########################################################################

####Graph dynamic correlations###
ts.plot(armaicspago,armaicspexp,armaicsbus12,armaicsbus5,armaicsdur, xlab="Month", ylab="Correlation", main="Dynamic Conditional Correlations", sub="ICS and it's Components, 1978M1:2010M10",lty=1, col=c("red", "steelblue", "goldenrod","forest green","black"))
legend(locator(1), c("ICS-PAGO", "ICS-PEXP", "ICS-BUS12", 'ICS-BUS5',"ICS-DUR"), fill=c("red", "steelblue", "goldenrod","forest green","black"))
fix()
is.ts(armaicspago)
subsettrial<-as.data.frame(armaicspago[2:length(armaicspago),1],armaicspexp)
subsetDCCsARMA<-cbind(armaicspago,armaicspexp,armaicsbus12,armaicsbus5,armaicsdur) fix(armaicspago)


first<-as.data.frame(armaicspago)
write.csv(first,file="/Users/slinn/Dropbox/Sentiment/DCCModels/armaicspago.csv")	
second<-as.data.frame(armaicspexp)
write.csv(second,file="/Users/slinn/Dropbox/Sentiment/DCCModels/armaicsexp.csv")	
third<-as.data.frame(armaicspago)
write.csv(third,file="/Users/slinn/Dropbox/Sentiment/DCCModels/armaicsbus12.csv")	
fourth<-as.data.frame(armaicspago)
write.csv(fourth,file="/Users/slinn/Dropbox/Sentiment/DCCModels/armaicsbus5.csv")	
fifth<-as.data.frame(armaicspago)
write.csv(fifth,file="/Users/slinn/Dropbox/Sentiment/DCCModels/armaicsdur.csv")	
