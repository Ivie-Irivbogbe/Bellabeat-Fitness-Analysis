# ================================================
# Load Necessary Libraries
# ================================================
library(dplyr)
library(lubridate)
library(ggplot2)
library(tidyr)
library(cluster)
library(reshape2)
library(factoextra)

# ================================================
# Data Loading and Merging
# ================================================
# Month 1
daily_activity_m1 <- read.csv("/Users/ivieirivbogbe/Downloads/CASE STUDY/BellaBeat/Fitabase Data 3.12.16-4.11.16/dailyActivity_merged.csv")
heartrate_m1 <- read.csv("/Users/ivieirivbogbe/Downloads/CASE STUDY/BellaBeat/Fitabase Data 3.12.16-4.11.16/heartrate_seconds_merged.csv")
hourly_calories_m1 <- read.csv("/Users/ivieirivbogbe/Downloads/CASE STUDY/BellaBeat/Fitabase Data 3.12.16-4.11.16/hourlyCalories_merged.csv")
hourly_intensities_m1 <- read.csv("/Users/ivieirivbogbe/Downloads/CASE STUDY/BellaBeat/Fitabase Data 3.12.16-4.11.16/hourlyIntensities_merged.csv")
minute_sleep_m1 <- read.csv("/Users/ivieirivbogbe/Downloads/CASE STUDY/BellaBeat/Fitabase Data 3.12.16-4.11.16/minuteSleep_merged.csv")
weight_log_m1 <- read.csv("/Users/ivieirivbogbe/Downloads/CASE STUDY/BellaBeat/Fitabase Data 3.12.16-4.11.16/weightLogInfo_merged.csv")

# Month 2
daily_activity_m2 <- read.csv("/Users/ivieirivbogbe/Downloads/CASE STUDY/BellaBeat/Fitabase Data 4.12.16-5.12.16/dailyActivity_merged.csv")
heartrate_m2 <- read.csv("/Users/ivieirivbogbe/Downloads/CASE STUDY/BellaBeat/Fitabase Data 4.12.16-5.12.16/heartrate_seconds_merged.csv")
hourly_calories_m2 <- read.csv("/Users/ivieirivbogbe/Downloads/CASE STUDY/BellaBeat/Fitabase Data 4.12.16-5.12.16/hourlyCalories_merged.csv")
hourly_intensities_m2 <- read.csv("/Users/ivieirivbogbe/Downloads/CASE STUDY/BellaBeat/Fitabase Data 4.12.16-5.12.16/hourlyIntensities_merged.csv")
minute_sleep_m2 <- read.csv("/Users/ivieirivbogbe/Downloads/CASE STUDY/BellaBeat/Fitabase Data 4.12.16-5.12.16/minuteSleep_merged.csv")
weight_log_m2 <- read.csv("/Users/ivieirivbogbe/Downloads/CASE STUDY/BellaBeat/Fitabase Data 4.12.16-5.12.16/weightLogInfo_merged.csv")

# ================================================
# Data Preprocessing and Feature Engineering
# ================================================
# Concatenate datasets from both months
daily_activity <- bind_rows(daily_activity_m1, daily_activity_m2)
heartrate <- bind_rows(heartrate_m1, heartrate_m2)
hourly_calories <- bind_rows(hourly_calories_m1, hourly_calories_m2)
hourly_intensities <- bind_rows(hourly_intensities_m1, hourly_intensities_m2)
minute_sleep <- bind_rows(minute_sleep_m1, minute_sleep_m2)
weight_log <- bind_rows(weight_log_m1, weight_log_m2)

# Convert date and time columns as necessary for merging
daily_activity$ActivityDate <- as.Date(daily_activity$ActivityDate, format = "%m/%d/%Y")
hourly_steps$Hour <- hour(as.POSIXct(hourly_steps$ActivityHour, format = "%m/%d/%Y %I:%M:%S %p"))
minute_sleep$DateOnly <- as.Date(minute_sleep$date, format = "%m/%d/%Y")
hourly_calories$ActivityDate <- as.Date(hourly_calories$ActivityHour)

# ================================================
# 1. Activity Patterns - Average Daily Steps
# ================================================

# Calculate average daily steps
avg_daily_steps <- daily_activity %>%
  group_by(ActivityDate) %>%
  summarize(avg_steps = round(mean(TotalSteps, na.rm = TRUE), 2))

# Display full list of average daily steps
print(avg_daily_steps, n = Inf)

# Plot: Average Daily Steps Over Time
ggplot(avg_daily_steps, aes(x = ActivityDate, y = avg_steps)) +
  geom_line(color = "#174D51", size = 1) +
  geom_point(color = "#D48931", size = 2) +
  labs(title = "Average Daily Steps Over Time", x = "Date", y = "Average Steps") +
  theme_minimal()

# =================================================
# 2. Heart Rate Trends - Average Heart Rate by Hour
# =================================================

# Ensure the Time column is in POSIXct format to extract hour
heartrate$Time <- as.POSIXct(heartrate$Time, format = "%m/%d/%Y %I:%M:%S %p")

# Extract hour from Time column
heartrate$Hour <- hour(heartrate$Time)

# Calculate average heart rate by hour
avg_hourly_hr <- heartrate %>%
  group_by(Hour) %>%
  summarize(avg_heartrate = round(mean(Value, na.rm = TRUE), 2))

# Display the full list of average heart rate by hour
print("Average Heart Rate by Hour:")
print(avg_hourly_hr, n = Inf)

# Plot average heart rate by hour and include data point labels
ggplot(avg_hourly_hr, aes(x = Hour, y = avg_heartrate)) +
  geom_line(color = "#D48931", size = 1) +         # Line for average heart rate
  geom_point(color = "#174D51", size = 3) +        # Points on the line
  geom_text(aes(label = avg_heartrate),            # Display rounded heart rate values
            vjust = -0.5, color = "black", size = 3) + 
  labs(title = "Average Heart Rate by Hour", 
       x = "Hour of Day", 
       y = "Average Heart Rate (bpm)") +
  theme_minimal()

# ================================================
# 3. Time of Day - Morning and Evening Activity
# ================================================

# Extract hour from hourly data
hourly_steps$Hour <- hour(as.POSIXct(hourly_steps$ActivityHour, format = "%m/%d/%Y %I:%M:%S %p"))

# Calculate average steps by hour
avg_hourly_steps <- hourly_steps %>%
  group_by(Hour) %>%
  summarize(avg_steps = round(mean(StepTotal, na.rm = TRUE), 2))

# Identify peak hours for morning and evening
peak_hours <- avg_hourly_steps %>%
  filter(Hour %in% c(6, 7, 8, 9, 18, 19, 20, 21))

# Plot: Peak Activity in Morning and Evening
ggplot(avg_hourly_steps, aes(x = Hour, y = avg_steps)) +
  geom_line(color = "#0C2521", size = 1) +
  geom_point(data = peak_hours, aes(x = Hour, y = avg_steps), color = "#D48931", size = 3) +
  geom_text(data = peak_hours, aes(x = Hour, y = avg_steps, label = round(avg_steps, 2)), 
            vjust = -0.5, color = "#174D51") +
  labs(title = "Activity Peaks in Morning and Evening", x = "Hour of Day", y = "Average Steps") +
  theme_minimal()

# ================================================
# 4. Weekdays vs. Weekends - Sleep Patterns
# ================================================

# Convert the 'date' column to Date format (assuming 'date' is in the correct format)
minute_sleep$date <- as.Date(minute_sleep$date, format = "%m/%d/%Y")

# Classify as Weekday or Weekend using the 'weekdays' function
minute_sleep$DayType <- ifelse(weekdays(minute_sleep$date) %in% c("Saturday", "Sunday"), "Weekend", "Weekday")

# Check if the conversion worked and DayType is properly classified
print("Unique DayType values:")
print(unique(minute_sleep$DayType))

# Calculate the average sleep duration by DayType
avg_sleep_day <- minute_sleep %>%
  group_by(DayType) %>%
  summarize(avg_sleep = round(mean(value, na.rm = TRUE), 2))

# Print the average sleep duration for Weekday and Weekend
print("Average Sleep by Day Type:")
print(avg_sleep_day, n = Inf)

# Plot average sleep by day type
ggplot(avg_sleep_day, aes(x = DayType, y = avg_sleep, fill = DayType)) +
  geom_bar(stat = "identity", color = "black", width = 0.6) +
  geom_text(aes(label = avg_sleep), vjust = -0.3, size = 5, color = "black") +
  labs(title = "Average Sleep Duration on Weekdays vs Weekends", x = "Day Type", y = "Average Sleep (Minutes)") +
  theme_minimal() +
  scale_fill_manual(values = c("Weekday" = "#174D51", "Weekend" = "#D48931")) +
  theme(legend.position = "none")

# ============================================================
# 5. Monthly Average Steps, Sleep, Resting Heart Rate Analysis
# ============================================================
# Monthly Average Steps
daily_activity$Month <- factor(month(daily_activity$ActivityDate), 
                               levels = 1:12, 
                               labels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))

monthly_steps <- daily_activity %>%
  group_by(Month) %>%
  summarize(avg_steps = round(mean(TotalSteps, na.rm = TRUE), 2))

# Plot the results
ggplot(monthly_steps, aes(x = Month, y = avg_steps, fill = Month)) +
  geom_bar(stat = "identity", color = "black", width = 0.6) +
  geom_text(aes(label = avg_steps), vjust = -0.3, color = "black", size = 5) +
  labs(title = "Average Daily Steps by Month", x = "Month", y = "Average Steps") +
  theme_minimal() +
  scale_fill_manual(values = c("Mar" = "#174D51", "Apr" = "#0C2521", "May" = "#D48931")) +
  theme(legend.position = "none")

# Monthly Average Sleep Duration
minute_sleep$Month <- factor(month(minute_sleep$DateOnly),
                             levels = 1:12,
                             labels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))

monthly_sleep <- minute_sleep %>%
  group_by(Month) %>%
  summarize(avg_sleep = round(mean(value, na.rm = TRUE), 2))

# Plot the results
ggplot(monthly_sleep, aes(x = Month, y = avg_sleep, fill = Month)) +
  geom_bar(stat = "identity", color = "black", width = 0.6) +
  geom_text(aes(label = avg_sleep), vjust = -0.3, color = "black", size = 5) +
  labs(title = "Average Sleep Duration by Month", x = "Month", y = "Average Sleep (Minutes)") +
  theme_minimal() +
  scale_fill_manual(values = c("Mar" = "#174D51", "Apr" = "#0C2521", "May" = "#D48931")) +
  theme(legend.position = "none")

# Monthly Average Resting Heart Rate
heartrate$Month <- factor(month(heartrate$Time),
                          levels = 1:12,
                          labels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))

monthly_hr <- heartrate %>%
  filter(hour(Time) %in% 0:5) %>% # Resting heart rate (midnight to 5 AM)
  group_by(Month) %>%
  summarize(avg_resting_hr = round(mean(Value, na.rm = TRUE), 2))

# Plot the results
ggplot(monthly_hr, aes(x = Month, y = avg_resting_hr, fill = Month)) +
  geom_bar(stat = "identity", color = "black", width = 0.6) +
  geom_text(aes(label = avg_resting_hr), vjust = -0.3, color = "black", size = 5) +
  labs(title = "Average Resting Heart Rate by Month", x = "Month", y = "Average Resting Heart Rate (bpm)") +
  theme_minimal() +
  scale_fill_manual(values = c("Mar" = "#174D51", "Apr" = "#0C2521", "May" = "#D48931")) +
  theme(legend.position = "none")

# ================================================
# 6. User Segmentation Based on Activity and Sleep
# ================================================

# Segment users based on daily steps
activity_levels <- daily_activity %>%
  group_by(Id) %>%
  summarize(avg_daily_steps = round(mean(TotalSteps, na.rm = TRUE), 2)) %>%
  mutate(activity_segment = case_when(
    avg_daily_steps >= 10000 ~ "High Activity",
    avg_daily_steps >= 5000 ~ "Moderate Activity",  # Remove redundant condition
    TRUE ~ "Low Activity"
  ))

# Plot: Segmentation Based on Activity Level
activity_segment_counts <- activity_levels %>%
  group_by(activity_segment) %>%
  summarize(user_count = n())

ggplot(activity_segment_counts, aes(x = activity_segment, y = user_count, fill = activity_segment)) +
  geom_bar(stat = "identity", color = "#0C2521", width = 0.7) +
  geom_text(aes(label = user_count), vjust = -0.3, color = "black", size = 4) +
  labs(title = "User Segmentation Based on Activity Level", x = "Activity Segment", y = "User Count") +
  scale_fill_manual(values = c("High Activity" = "#D48931", "Moderate Activity" = "#174D51", "Low Activity" = "#6F1C00")) +
  theme(axis.text.x = element_text(angle = 0, vjust = 0.5, hjust = 0.5))

colnames(daily_activity)

# Convert all columns except the Id and ActivityDate columns to numeric for clustering
segmentation_data_numeric <- daily_activity %>%
  select(-Id, -ActivityDate, -Month) %>%
  mutate(across(everything(), as.numeric))  # Ensure all columns are numeric

# Apply K-means clustering with 3 clusters
set.seed(42)
kmeans_result <- kmeans(segmentation_data_numeric, centers = 3)

# Add the cluster assignment to the original segmentation data
segmentation_data <- daily_activity %>%
  mutate(cluster = factor(kmeans_result$cluster))

# Visualize the clustering result using fviz_cluster
fviz_cluster(kmeans_result, data = segmentation_data_numeric,
             geom = "point", ellipse.type = "convex",
             ggtheme = theme_minimal(),
             main = "User Segmentation Based on Combined Metrics")

# ================================================
# 7. Intensity Analysis
# ================================================

# Convert the 'ActivityHour' column to POSIXct format
hourly_intensities$ActivityHour <- as.POSIXct(hourly_intensities$ActivityHour, format = "%m/%d/%Y %I:%M:%S %p")

# Extract the hour and calculate the average intensity by hour
avg_intensity_hour <- hourly_intensities %>%
  mutate(Hour = hour(ActivityHour)) %>%
  group_by(Hour) %>%
  summarize(avg_intensity = round(mean(TotalIntensity, na.rm = TRUE), 2))

# Display the results
print(avg_intensity_hour, n = Inf)

# Plot: Average Intensity by Hour
ggplot(avg_intensity_hour, aes(x = Hour, y = avg_intensity)) +
  geom_line(color = "#174D51", size = 1.2) +
  geom_point(color = "#0C2521", size = 2) +
  geom_text(aes(label = avg_intensity), vjust = -0.5, color = "#D48931", size = 3) +
  labs(title = "Average Intensity by Hour", x = "Hour of Day", y = "Average Intensity") +
  theme_minimal()

# High-Intensity Workouts Across the Months
high_intensity <- hourly_intensities %>%
  filter(TotalIntensity >= 8) %>%
  mutate(Month = month(ActivityHour)) %>%
  group_by(Month) %>%
  summarize(high_intensity_sessions = n(), .groups = 'drop')

ggplot(high_intensity, aes(x = as.factor(Month), y = high_intensity_sessions, fill = as.factor(Month))) +
  geom_bar(stat = "identity", color = "#0C2521", width = 0.6) +
  geom_text(aes(label = high_intensity_sessions), vjust = -0.3, color = "black", size = 4) +
  scale_fill_manual(values = c("#6F1C00", "#D48931", "#174D51")) +
  labs(title = "High-Intensity Sessions by Month", x = "Month", y = "Number of High-Intensity Sessions", fill = "Month") +
  theme_minimal()

# ================================================
# 8. Correlation Analysis - Predictive Modeling
# ================================================

# Correlation between steps, sleep, and heart rate
sleep_model <- lm(avg_sleep ~ avg_steps + avg_hr, data = regression_data)

# Display model summary
print(summary(sleep_model))

# Plot: Predicted vs Actual Sleep
regression_data$predicted_sleep <- predict(sleep_model, regression_data)
ggplot(regression_data, aes(x = avg_sleep, y = predicted_sleep)) +
  geom_point(color = "#0C2521") +
  geom_smooth(method = "lm", color = "#D48931") +
  labs(title = "Predicted vs Actual Sleep Quality", x = "Actual Sleep (Minutes)", y = "Predicted Sleep (Minutes)") +
  theme_minimal()

# Correlation Heatmap

# Prepare data for correlation analysis
correlation_data <- daily_activity %>%
  left_join(minute_sleep %>% group_by(Id) %>% summarize(avg_sleep = mean(value, na.rm = TRUE)), by = "Id") %>%
  left_join(heartrate %>% group_by(Id) %>% summarize(avg_hr = mean(Value, na.rm = TRUE)), by = "Id") %>%
  group_by(Id) %>%
  summarize(
    avg_steps = mean(TotalSteps, na.rm = TRUE),
    avg_sleep = mean(avg_sleep, na.rm = TRUE),
    avg_hr = mean(avg_hr, na.rm = TRUE)
  ) %>%
  na.omit()

# Compute the correlation matrix
cor_matrix <- round(cor(correlation_data[, -1]), 2)  # Remove 'Id' column before calculating correlation

# Melt the correlation matrix for visualization
melted_cor_matrix <- melt(cor_matrix)

# Heatmap using ggplot2 with labels inside the tiles
ggplot(data = melted_cor_matrix, aes(Var1, Var2, fill = value)) +
  geom_tile(color = "white") +
  geom_text(aes(label = value), size = 5, color = "black") +  # Add correlation values as labels inside the tiles
  scale_fill_gradient2(low = "#174D51", high = "#D48931", mid = "white", midpoint = 0, limit = c(-1, 1), space = "Lab", name = "Correlation") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, size = 12, hjust = 1)) +
  labs(title = "Correlation Heatmap: Steps, Sleep, Heart Rate", x = "Variables", y = "Variables") +
  coord_fixed()

# ================================================
# 9. Goal Achievement Analysis
# ================================================

# Calculate custom goals for each user as 110% of their average steps
custom_goals <- daily_activity %>%
  group_by(Id) %>%
  summarize(custom_goal = round(mean(TotalSteps, na.rm = TRUE) * 1.1), .groups = 'drop')

# Calculate goal achievement rate for each user
goal_achievement <- daily_activity %>%
  left_join(custom_goals, by = "Id") %>%
  mutate(goal_met = ifelse(TotalSteps >= custom_goal, 1, 0)) %>%
  group_by(Id) %>%
  summarize(goal_achievement_rate = round(mean(goal_met, na.rm = TRUE) * 100, 2), .groups = 'drop')

# Plot the goal achievement rate for each user
ggplot(goal_achievement, aes(x = factor(Id), y = goal_achievement_rate)) +
  geom_bar(stat = "identity", fill = "#D48931", color = "#0C2521", width = 0.7) +
  geom_text(aes(label = paste0(goal_achievement_rate, "%")), vjust = -0.3, size = 3) +
  labs(
    title = "Custom Goal Achievement Rate per User",
    x = "User ID",
    y = "Goal Achievement Rate (%)"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
