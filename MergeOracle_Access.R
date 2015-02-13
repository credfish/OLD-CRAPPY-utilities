rm(list=ls())
library(gdata)             # needed for drop_levels()

setwd("...") # local fishpaste/data folder which has Rdata and access file

load("ALL_REA_FISH_RAW.rdata")
x<-df

#change to factor to merge... change back to date format later
x$DATE_<-as.factor(x$DATE_)
x$SECTOR<-as.factor(x$SECTOR)

# clean up the data to only fields we currently use
DATA_COLS<-c("SITEVISITID", "METHOD", "DATE_", "OBS_YEAR",
             "SITE", "REEF_ZONE",  "DEPTH_BIN",  "ISLAND",
             "LATITUDE",  "LONGITUDE",  "REGION" , "REGION_NAME",
             "SECTOR", "SPECIAL_AREA", "EXCLUDE_FLAG", "REP",
             "REPLICATEID", "DIVER", "HABITAT_CODE", "DEPTH",
             "HARD_CORAL", "MA",  "TA",  "CCA",  "SAND",  "SOFT_CORAL",
             "CLAM" , "SPONGE", "CORALLIMORPH", "CYANO", "TUNICATE",
             "ZOANTHID" , "COMPLEXITY", "SPECIES", "COUNT", "SIZE_",
             "OBS_TYPE",  "SUBSTRATE_HEIGHT_0", "SUBSTRATE_HEIGHT_20",
             "SUBSTRATE_HEIGHT_50", "SUBSTRATE_HEIGHT_100",
             "SUBSTRATE_HEIGHT_150", "MAX_HEIGHT", "SCIENTIFIC_NAME",
             "TAXONNAME", "COMMONNAME", "GENUS", "FAMILY",
             "COMMONFAMILYALL", "LMAX", "LW_A",  "LW_B",
             "LENGTH_CONVERSION_FACTOR", "TROPHIC", "TROPHIC_MONREP")
head(x[,DATA_COLS])
x<-x[,DATA_COLS]

## HABITAT_TYPE changed to "HABITAT_CODE" in ORACLE, CHECK THAT HAS BEEN DONE IN ACCESS TOO
## HABITAT_TYPE changed to "HABITAT_CODE" in ORACLE, CHECK THAT HAS BEEN DONE IN ACCESS TOO
## HABITAT_TYPE changed to "HABITAT_CODE" in ORACLE, CHECK THAT HAS BEEN DONE IN ACCESS TOO
## HABITAT_TYPE changed to "HABITAT_CODE" in ORACLE, CHECK THAT HAS BEEN DONE IN ACCESS TOO
## HABITAT_TYPE changed to "HABITAT_CODE" in ORACLE, CHECK THAT HAS BEEN DONE IN ACCESS TOO


### MERGING WITH ACCESS DATABASE OUTPUT ....
newdata<-read.csv("REA FISH BASE_FOR_R.csv")
#NB... 'REA FISH BASE FOR R' IS THE ACCESS QUERY THAT GENERATES
## OUTPUT TO MATCH THE DATA_COLS ABOVE
newdata<-newdata[,DATA_COLS]
newdata$SITEVISITID<-newdata$SITEVISITID+max(x$SITEVISITID)
# this line necessary to ensure that the data from the
# Access database do not have same SITEVISITID as the data from Oracle
#doing same for REPLICATEID, but now treating them as
max_xR<-as.double(max(x$REPLICATEID))
newdata$REPLICATEID<-newdata$REPLICATEID+max_xR

#have to have same date types!
newdata$DATE_<-as.Date(newdata$DATE_, "%m/%d/%Y")
##change to factor for merge
newdata$DATE_<-as.factor(newdata$DATE_)

x<-rbind(x, newdata)

# change format of DATE_ from character to date
x$DATE_<-as.Date(x$DATE_)
# set year to factor rather than default interval
x$OBS_YEAR<-as.factor(x$OBS_YEAR)

df<-x
save(df, file="ALL_REA_FISH_RAW_INCLUDING_ACCESS.rdata")

## can now run standard fish paste scripts with this data
## push this merged version to master fish paste on github