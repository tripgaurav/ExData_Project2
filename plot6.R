# Read Files
sourceClassCode <- readRDS("./data/exdata_data_NEI_data/Source_Classification_Code.rds")
summarySCC <- readRDS("./data/exdata_data_NEI_data/summarySCC_PM25.rds")

# Subset Data to include SCC for Motor Vehicle sources information only
# Assumption on Motor Vehicle Source definition:
# - Lines for which EI Source column contains "Mobile - On-Road" value
sourceClassCodeSub <- as.data.frame(sourceClassCode[grep("Mobile - On-Road", 
                                                         sourceClassCode$EI.Sector),]$SCC)

names(sourceClassCodeSub) <- "SCC"
sourceClassCodeSub$SCC <- as.character(sourceClassCodeSub$SCC)

# Merge filtered SCC with original summary data
filteredOutp <- merge(summarySCC, sourceClassCodeSub, by="SCC")

# Calculate total Emission for each year for Baltimore
sumYearBaltimore <- with(filteredOutp[filteredOutp$fips == "24510", ], 
                         aggregate(x=Emissions, by=list(year), FUN=sum))

names(sumYearBaltimore) = c("Year", "Total_Emission")

# Calculate total Emission for each year for Los Angeles County
sumYearLA <- with(filteredOutp[filteredOutp$fips == "06037", ], 
                         aggregate(x=Emissions, by=list(year), FUN=sum))

names(sumYearLA) = c("Year", "Total_Emission")

# Initiate png graphic device and create histogram in it
png(file = "./CourseworkEDA/plot6.png", width = 480, height = 480)

# Plot Year (on x-axis) and Total Emission (on y-axis)
plot(sumYearBaltimore$Year, sumYearBaltimore$Total_Emission, type = "n", 
     main="PM2.5 emission from Motor Vehicles - Baltimore vs. LA", xlab = "Year", 
     ylab = "Total PM2.5 Emission", xaxt = 'n', ylim = c(0,5100))

points(sumYearBaltimore$Year, sumYearBaltimore$Total_Emission, col="blue", pch=20)
points(sumYearLA$Year, sumYearLA$Total_Emission, col="red", pch = 20)

modelBaltimore <- lm(Total_Emission ~ Year,sumYearBaltimore)
modelLA <- lm(Total_Emission ~ Year,sumYearLA)

abline(modelBaltimore, lwd=1, col="blue")
abline(modelLA, lwd=1, col="red")

axis(1, xaxp = c(1999, 2008, 3), las=2)

legend("topright", col=c("blue", "red"), legend=c("Baltimore", "Los Angeles"), pch=20)

# Close device
dev.off()