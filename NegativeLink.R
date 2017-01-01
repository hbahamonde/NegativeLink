#######################################################
# Data Prep
#######################################################

####### GENERAL PREP

cat("\014")
rm(list=ls())
setwd("/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink")

# Load/Transform the data
load("/Users/hectorbahamonde/RU/Dissertation/Data/dissertation.Rdata") # Load data

## Keep sample countries and variables
#data = subset(dissertation, country == "Chile" | country ==  "Colombia" | country ==  "Ecuador" | country ==  "Guatemala" | country ==  "Nicaragua" | country ==  "Peru" | country ==  "Venezuela")
#data = subset(data, select = c(country, year, democ, autoc, polity, polity2, urbpop, totpop, constmanufact, constagricult, exports, ppp, propagrmanu, realgdp, incometax, madisongdp, madisonpop, boix_democracy, madisonpercapgdp, customtax))

data = dissertation
data = subset(data, constmanufact != "NA" & constagricult != "NA")

## Construct a the outcome variable (0,1) for when the income tax was imposed.

## Saving Data
save(data, file = "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/negativelink.RData") # in paper's folder


library(foreign)
write.dta(data, "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta")


########################################################################################
# Structural Breaks with cointegrated vectors // I should NOT find a structural break.

## Chile

library(foreign) # install.packages("foreign")
data <- read.dta("/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta")
chile.dat = subset(data, country == "Chile")
chile.dat <- chile.dat[c("year", "constagricult", "constmanufact")]


library(xts) # install.packages("xts")
chile.dat.ts <- ts(chile.dat, start=c(1900,1), frequency=1)


coint.res <- residuals(lm(constagricult ~ constmanufact, data = chile.dat.ts)) 
coint.res <- lag(ts(coint.res, start = c(1900,1), freq = 1), k = -3) 
chile.dat.ts <- cbind(chile.dat.ts, diff(chile.dat.ts), coint.res) 
chile.dat.ts <- window(chile.dat.ts, start = c(1900,1), end = c(2009,1))

colnames(chile.dat.ts) <- c(
        "year",
        "constagricult",
        "constmanufact",
        "diff.year",
        "diff.constagricult",
        "diff.constmanufact",
        "coint.res")

## inspection of the series
# plot.ts(chile.dat.ts)

## save formula
ecm.model <- diff.constagricult ~ coint.res + diff.constmanufact

library(strucchange) # install.packages("strucchange")

#
ocus <- efp(ecm.model, type="Rec-MOSUM", data=chile.dat.ts) ## Empirical fluctuation processes
dev.off();dev.off()
bound.ocus <- boundary(ocus, alpha=0.10)
plot(ocus) 

#
dev.off();dev.off()
plot(me, functional = NULL)
me <- efp(ecm.model, type="ME", data=chile.dat.ts, h=0.1) ## Moving Estimates


## 
fs <- Fstats(ecm.model, from = 5, to = 40, data = chile.dat.ts)


plot(fs, pval=TRUE, alpha = 0.1)
plot(fs, alpha = 0.1)
### note: the null hypthesis is: no structural change boundaries


plot(fs)

sctest(fs, type="aveF") 


sctest(ecm.model, type = "aveF", from = 5, to = 40, data = chile.dat.ts)


## monitoring
chile.dat.ts.monitor <- window(chile.dat.ts, start = c(1905, 1), end = c(1990,1)) 
me.mefp <- mefp(ecm.model, type = "ME", data = chile.dat.ts.monitor, alpha = 0.1)
me.mefp <- monitor(me.mefp)
plot(me.mefp)



y <- c(rnorm(20), 2+rnorm(20), rnorm(10)) # 2 breakpoints
b <- breakpoints( y ~ 1 )
f <- Fstats( y ~ 1 )
plot(b)  # 2 breakpoints
plot(f)  # Only 1 F-statistic above the threshold
lines(b)



