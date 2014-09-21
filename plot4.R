# Read Files
sourceClassCode <- readRDS("./data/exdata_data_NEI_data/Source_Classification_Code.rds")
summarySCC <- readRDS("./data/exdata_data_NEI_data/summarySCC_PM25.rds")

# Subset Data to include SCC for Coal Combustion information only
# Assumption on Coal Combustion definition:
# - EI Source column containing "Comb" (for Combustion) and "Coal" in the same line
sourceClassCodeSub <- as.data.frame(sourceClassCode[grep("Coal", grep("Comb", 
                                        sourceClassCode$EI.Sector, value = TRUE)),]$SCC)

names(sourceClassCodeSub) <- "SCC"
sourceClassCodeSub$SCC <- as.character(sourceClassCodeSub$SCC)

# Merge filtered SCC with original summary data
filteredOutp <- merge(summarySCC, sourceClassCodeSub, by="SCC")

# Calculate total Emission for each year
sumYear <- with(filteredOutp, aggregate(x=Emissions, by=list(year), FUN=sum))

# Convert Total Emission to Megatons
names(sumYear) = c("Year", "Total_Emission")
sumYear$MTTotal_Emission <- sumYear$Total_Emission / 1000000

# Initiate png graphic device and create histogram in it
png(file = "./CourseworkEDA/plot4.png", width = 480, height = 480)

# Plot Year (on x-axis) and Total Emission (on y-axis)
plot(sumYear$Year, sumYear$MTTotal_Emission, type = "l", col="blue", 
     main="PM2.5 emission from Coal Combustion Sources in US", xlab = "Year", 
     ylab = "Total PM2.5 Emission (Megaton)", xaxt = 'n')

axis(1, xaxp = c(1999, 2008, 3), las=2)

# Close device
dev.off()