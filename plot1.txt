# Read Files
sourceClassCode <- readRDS("./data/exdata_data_NEI_data/Source_Classification_Code.rds")
summarySCC <- readRDS("./data/exdata_data_NEI_data/summarySCC_PM25.rds")

# Calculate total Emission for each year
sumYear <- with(summarySCC, aggregate(x=Emissions, by=list(year), FUN=sum))

# Convert Total Emission to Megatons
names(sumYear) = c("Year", "Total_Emission")
sumYear$MTTotal_Emission <- sumYear$Total_Emission / 1000000

# Initiate png graphic device and create histogram in it
png(file = "./CourseworkEDA/plot1.png", width = 480, height = 480)

# Plot Year (on x-axis) and Total Emission (on y-axis)
plot(sumYear$Year, sumYear$MTTotal_Emission, type = "l", col="blue", 
     main="PM2.5 total emission Yearly trend", xlab = "Year", 
     ylab = "Total PM2.5 Emission (Megaton)", xaxt = 'n')

axis(1, xaxp = c(1999, 2008, 3), las=2)

# Close device
dev.off()