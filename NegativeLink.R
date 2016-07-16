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
data = subset(dissertation, country == "Chile" | country ==  "Colombia" | country ==  "Ecuador" | country ==  "Guatemala" | country ==  "Nicaragua" | country ==  "Peru" | country ==  "Venezuela")
data = subset(data, select = c(country, year, democ, autoc, polity, polity2, urbpop, totpop, constmanufact, constagricult, exports, ppp, propagrmanu, realgdp, incometax, madisongdp, madisonpop, boix_democracy, madisonpercapgdp, customtax))
data = subset(data, constmanufact != "NA" & constagricult != "NA")

## Construct a the outcome variable (0,1) for when the income tax was imposed.

## Saving Data
save(data, file = "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/negativelink.RData") # in paper's folder


library(foreign)
write.dta(data, "/Users/hectorbahamonde/RU/Dissertation/Papers/NegativeLink/data.dta")



