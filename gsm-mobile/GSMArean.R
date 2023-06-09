
library(ggplot2)
library(ggthemes)
library(extrafont)
library(RColorBrewer)
library(dplyr)
library(tidyverse)
library(knitr)

# Read the mobile data from a CSV file
mobile <- read.csv("data/mobile_data.csv")

# Group the mobile data by company and count the number of rows in each group
# Then sort the data by the number of rows in each group in descending order
l1 <- mobile %>% 
  group_by(company) %>% 
  summarise(number = n()) %>%
  arrange(desc(number))

# Display the first 10 rows of the summarized data in a table
head(l1, 10)


# Define a custom theme with minimal style
# and gray grid lines and axis text
my_theme <- theme_minimal() + 
  theme(panel.grid.major = element_line(size = 0.2, color = "gray90"),
        panel.grid.minor = element_blank(),
        axis.title = element_text(size = 10, color = "gray10"),
        axis.text = element_text(size = 8, color = "gray10"))

# Select the "year" and "dim_length" variables
# from the "mobile" dataset, group by "year", and
# calculate the mean "dim_length" for each group
mobile %>%
  select(year, dim_length) %>%
  group_by(year) %>%
  summarise(mean_len = mean(dim_length, na.rm = TRUE)) -> len_per_year

# Calculate the regression coefficients for "dim_length" vs. "year"
coef <- coef(lm(dim_length ~ year, data = mobile))

# Create a scatter plot of "year" vs. "dim_length"
# with a regression line, and apply the custom theme
p <- ggplot(data = mobile, aes(x = year, y = dim_length)) +
  geom_point(size = 1, alpha = 0.2, na.rm = TRUE, colour = "#2196F3") +
  xlab('year') + ylab('Mobile length') + ggtitle("Length in Time") +
  geom_abline(intercept = coef[1], slope = coef[2], colour = "#F44336") +
  my_theme
p

# Create a bar chart of "year" vs. "mean_len",
# and apply the custom theme
p <- ggplot(data = len_per_year, aes(x = year, y = mean_len)) +
  geom_col(fill = "steelblue", na.rm = TRUE) +
  xlab('year') + ylab('Mobile length') +
  ggtitle("Average Length in Time") +
  my_theme
p

# Selecting the year and breadth columns, grouping by year,
# and calculating the mean breadth for each year
breadth_per_year <- mobile %>%
  select(year, dim_breadth) %>%
  group_by(year) %>%
  summarise(mean_breadth = mean(dim_breadth, na.rm = TRUE))

# Calculating the coefficients for the
# linear regression model of breadth against year
coef <- coef(lm(dim_breadth ~ year, data = mobile))

# Creating the first plot, showing the mobile breadth
# over time with a linear regression line
p <- ggplot(data = mobile, aes(x = year, y = dim_breadth)) +
  geom_point(size = 1, alpha = 0.2, na.rm = TRUE, colour = "#2196F3") +
  xlab('Year') + ylab('Mobile Breadth') + ggtitle("Breadth in Time") +
  geom_abline(intercept = coef[1], slope = coef[2], colour = "#F44336") +
  my_theme
p

# Creating the second plot, showing the average mobile breadth per year
p <- ggplot(data = breadth_per_year, aes(x = year, y = mean_breadth)) +
  geom_col(fill="steelblue") +
  xlab('year') + ylab('Mobile breadth') +
  ggtitle("Average Breadth per Year") +
  my_theme
p

# Select year and dimension of thickness from
# the mobile data set, group them by year, 
# and calculate the mean thickness for each year
mobile %>%
  select(year, dim_thickness) %>%
  group_by(year) %>%
  summarise(mean_thick = mean(dim_thickness, na.rm = TRUE)) -> thick_per_year

# Use linear regression to calculate the coefficients
# for the relationship between thickness
# and year in the mobile data set
coef <- coef(lm(dim_thickness ~ year, data = mobile))
# Create a scatter plot to show the relationship
# between year and thickness in the mobile data set, 
# and add a linear regression line to show the trend over time
p <- ggplot(data = mobile, aes(x = year, y = dim_thickness)) + 
  geom_point(size = 1, alpha = 0.2, na.rm = TRUE, colour = "#2196F3") +
  xlab("Year") + ylab("Mobile thickness") + 
  ggtitle("Thickness in Time") +
  geom_abline(intercept = coef[1], slope = coef[2], colour = "#F44336") + 
  my_theme
p

# Create a bar plot to show the average thickness
# for each year in the mobile data set
p <- ggplot(data = thick_per_year, aes(x = year, y = mean_thick)) + 
  geom_col(fill = "steelblue") +
  xlab("Year") + ylab("Mobile thickness") +
  ggtitle("Average Thickness per Year") + 
  my_theme
p

# Group the data by sim number and LTE, and calculate mean price for each group
mobile_prices <- mobile %>% 
  group_by(sim_no, LTE) %>% 
  summarise(price = mean(price, na.rm = TRUE))

# Plot a bar chart comparing mean prices across sim numbers and LTE types
p <- ggplot(data = mobile_prices, aes(x = sim_no, y = price)) +
  geom_col(aes(fill = LTE, color = LTE), position = "dodge") +
  xlab("Sim Number") +
  ylab("Price") +
  my_theme
p

# Select data only for 2017 from the 'mobile' dataset
# and create a box plot with 'audio_jack' on the x-axis,
# 'dim_thickness' on the y-axis, and 'audio_jack' as the fill color
p <- ggplot(mobile[which(mobile$year==2017),],
            aes(x=audio_jack, y=dim_thickness, fill=audio_jack)) +
  geom_boxplot(na.rm = T) +
  xlab('Audio Jack') + ylab('Thickness') +
  ggtitle("Thickness vs Audio Jack") +
  my_theme + theme(legend.position="none")
p

# calculate PPI
mobile$ppi = sqrt(mobile$px_row^2 + mobile$px_col^2)/mobile$display_size

# create a histogram of PPI values
p <- ggplot(mobile, aes(x = ppi)) +
  geom_histogram(color = "black", fill = "#0072B2") +
  labs(title = "Histogram of PPI of Phones",
       x = "PPI",
       y = "Number of Phones") +
  theme(panel.grid.major = element_line(size = 0.2, color = "gray90"),
        panel.grid.minor = element_blank(),
        plot.title = element_text(size = 20, face = "bold"),
        axis.title = element_text(size = 10, color = "gray10"),
        axis.text = element_text(size = 8, color = "gray10")) + 
  theme_minimal()
p

# calculate the average PPI value for each year
mob_ppi = mobile %>%
  group_by(year) %>%
  summarise(ppi = mean(ppi,na.rm = T))

# create a line plot showing how average PPI changes over time
p <- ggplot(data = mob_ppi,aes(x = year,y = ppi)) +
  theme_minimal() + geom_line(color = "#0072B2", linewidth = 1.5, na.rm = T)
p

# display a table showing the phone with the highest PPI
mobile %>%
  arrange(-mobile$ppi) %>%
  select(company, device, price, year, announced) %>%
  head(1)

# Calculate the density of mobile phones
mobile$density = mobile$weight / (mobile$dim_length * mobile$dim_breadth * mobile$dim_thickness)

# Assign the den_vs_water column based on the calculated density
mobile$den_vs_water[mobile$density<10^-3] = 'Less Dense'
mobile$den_vs_water[mobile$density>10^-3] = 'More Dense'

# Create a bar plot using ggplot
p = ggplot(data = mobile %>% drop_na(den_vs_water),
           aes(den_vs_water), na.rm = T) +
  geom_bar(fill = "#0072B2",  na.rm = T) +
  ggtitle("Density of Phones Compared to Water") +
  my_theme +
  theme(axis.title = element_blank(),axis.text = element_text(size = 10)) 
p

# Display a table of the phones with less density than water
mobile %>%
  drop_na(den_vs_water) %>%
  filter(den_vs_water == 'Less Dense') %>%
  select(company, device, price, year, announced,
         dim_length, dim_breadth, dim_thickness, weight) %>%
  head()

# Create a scatter plot of mobile phone battery capacity (mAh) versus weight (g)
ggplot(data = mobile, aes(x = battery_mah, y = weight)) + 
  # Add individual points to the plot
  geom_point(size = 2, alpha = 0.8, na.rm = T, color = "#2196F3") + 
  # Add a linear regression line to the plot
  geom_smooth(method = "lm", se = FALSE, color = "#F44336") +
  # Add axis labels and a plot title
  xlab("Battery (mAh)") + ylab("Weight (g)") +
  ggtitle("Battery vs. Weight") +
  # Apply a custom theme to the plot
  my_theme

# Find correlation between battery capacity and weight of the phones
cor(mobile$battery_mah, mobile$weight, use="complete.obs")

# Filter the mobile dataset to include only
# Samsung flagship devices released between 2010 and 2017,
# then arrange them by year and decreasing price,
# and select the top device per year.
samsung_flagship <- mobile %>%
  filter(company %in% c("Samsung") & year %in% 2010:2017) %>%
  arrange(year, -price) %>%
  group_by(year) %>%
  slice_head(n = 1)

# Create a bar plot with year on the x-axis,
# price on the y-axis, and device name as the fill color.
p = ggplot(data = samsung_flagship,
           aes(x = year, y = price, fill = device)) +
  geom_col(alpha = 0.8, na.rm = T) +
  ggtitle("Top Samsung Flagship Devices by Year") +
  labs(subtitle = "Released between 2010 and 2017") +
  xlab('Year') + ylab('Price') + my_theme +
  scale_fill_brewer(palette = "Dark2")
p

# Compute the average RAM of mobile devices by year.
mob_ram <- mobile %>%
  group_by(year) %>%
  summarise(ram = mean(ram, na.rm = T))

# Create a bar plot with year on the x-axis and the average RAM on the y-axis.
p = ggplot(data = mob_ram, aes(x = year, y = ram)) +
  geom_col(na.rm = T, fill='steelblue') +
  labs(x = "Year", y = "Average RAM (GB)",
       title = "Average RAM by Year") +
  my_theme
p

# Compute the total number of pixels for each mobile device.
mobile$pixels = mobile$px_col * mobile$px_row

# Compute the coefficient of the linear regression model
# with battery capacity as the response and pixel count as the predictor.
coef = coef(lm(battery_mah ~ pixels, data = mobile))

# Create a scatter plot using ggplot2, with pixel
# count on the x-axis and battery capacity on the y-axis.
p = ggplot(data = mobile, aes(x = pixels, y = battery_mah)) +
  geom_point(size = 2, alpha = 0.4, na.rm = T, color = "#2196F3") + 
  geom_smooth(method = "lm", se = FALSE, color = "#F44336") +
  ylab("Battery (mAh)") + xlab("Number of Pixels") +
  ggtitle("Number of Pixels vs. Battery Capacity") + my_theme
p

# Calculate the average camera resolution (in pixels)
# for each year using the mobile dataset
mob_cam = mobile %>% 
  group_by(year) %>% 
  summarise(camera = mean(cam_px, na.rm = T))

# Create a bar plot using ggplot2 with year on the x-axis
# and camera resolution on the y-axis
p = ggplot(data = mob_cam, aes(x = year, y = camera)) +
  geom_col(na.rm = T, fill = 'steelblue') +
  labs(x = 'Year', y = 'Camera Resolution (Pixels)',
       title = 'Average Camera Resolution by Year') +
  my_theme
p
