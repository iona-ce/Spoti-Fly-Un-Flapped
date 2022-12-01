#MY SPOTI-FLY UNWRAPPED 

##1. Downloading eBird data

#Go to https://ebird.org/downloadMyData and click Submit 
#Open email (should only take a couple of minutes to receive) and download zip folder 
#Unzip folder; this contains a .csv file of all your ebird data 

##2. Loading data to R

#Set working directory
#Set this to the file where the data is
setwd("~/Documents/eBird")

#Load data
ebird <- read.csv("MyEBirdData.csv")


##3. Formatting data

#Remove anything with brackets, i.e. sub-species names (e.g. Long-tailed Tit (europaeus Group)). 
#I have this issue because of shared checklists, whereby the other person's eBird has subspecies and mine does not. 
#If you do not have any shared checklists/do not need or want to remove sub-species, then there is no need for this line of code
ebird$Common.Name <- gsub(pattern = "\\(.*", replacement = "", x = ebird$Common.Name)

#Remove spaces at the end of any words
#This is only applicable if there was any need to remove brackets 
ebird$Common.Name <- trimws(ebird$Common.Name)

#4. Subsetting data only to year of interest 

#Make a new dataframe dividing the eBird date data (in the form (YYYY-MM-DD) into different columns)
#This will help subset the data to year only 

#Load library
library(stringr)

#Make a dataframe called ebird dates 
ebird_dates <- as.data.frame(str_split_fixed(ebird$Date, "-", 3))

#Name columns 
colnames(ebird_dates) <- c("Year", "Month", "Day")

#Add this to main eBird data frame
ebird <- cbind(ebird, ebird_dates)

#Subset the data only for 2022 data 
ebird2022 <- subset(ebird, ebird$Year == "2022")

##5. Getting frequency data for each species 

#Make frequency table 
species_frequency <- as.data.frame(table(ebird2022$Common.Name))

#Rename columns 
colnames(species_frequency) <- c("Species", "Frequency")

#6. Sort by frequency 
library(tidyverse)
ebird2022 <- species_frequency %>%
  arrange(desc(Frequency))

#Show the dataframe 
ebird2022

#List your top species
head(ebird2022) 

#Make a histogram of this 
barplot(ebird2022$Frequency)
   

