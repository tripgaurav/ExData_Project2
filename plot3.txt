library(ggplot2)

# Read Files
sourceClassCode <- readRDS("./data/exdata_data_NEI_data/Source_Classification_Code.rds")
summarySCC <- readRDS("./data/exdata_data_NEI_data/summarySCC_PM25.rds")

# Calculate total Emission for each year
sumYearBaltimoreAllTypes <- aggregate(Emissions ~ year+type, data = summarySCC[summarySCC$fips == "24510", ], FUN=sum)

# Initiate png graphic device and create histogram in it
png(file = "./CourseworkEDA/plot3.png", width = 480, height = 480)

# Plot each type in a different color
qplot(year, Emissions, data = sumYearBaltimoreAllTypes, color = type, 
      geom = c("point","smooth"), method = "lm", se=FALSE) + 
    labs(x = "Year", y = "Total PM2.5 Emission", 
         title = "PM2.5 emission trend by source 'type' in Baltimore, Maryland") +
    scale_colour_discrete(name = "Source Type")

# Close device
dev.off()