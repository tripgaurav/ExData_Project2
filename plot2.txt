# Read Files
sourceClassCode <- readRDS("./data/exdata_data_NEI_data/Source_Classification_Code.rds")
summarySCC <- readRDS("./data/exdata_data_NEI_data/summarySCC_PM25.rds")

# Calculate total Emission for each year
sumYearBaltimore <- with(summarySCC[summarySCC$fips == "24510", ], 
                         aggregate(x=Emissions, by=list(year), FUN=sum))

# Convert Total Emission to Kilotons
names(sumYearBaltimore) = c("Year", "Total_Emission")
sumYearBaltimore$KTTotal_Emission <- sumYearBaltimore$Total_Emission / 1000

# Initiate png graphic device and create histogram in it
png(file = "./CourseworkEDA/plot2.png", width = 480, height = 480)

# Plot Year (on x-axis) and Total Emission (on y-axis)
plot(sumYearBaltimore$Year, sumYearBaltimore$KTTotal_Emission, type = "l", col="blue", 
     main="PM2.5 total emission trend in Baltimore City, Maryland", xlab = "Year", 
     ylab = "Total PM2.5 Emission (Kiloton)", xaxt = 'n')

axis(1, xaxp = c(1999, 2008, 3), las=2)

# Close device
dev.off()