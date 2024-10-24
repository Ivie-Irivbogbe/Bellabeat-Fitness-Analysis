# Fitness Data Analysis for Bellabeat Marketing Strategy

This repository contains an analysis of fitness tracking data aimed at informing Bellabeat's marketing strategy. The project explores user behavior related to daily activity, sleep patterns, heart rate, and intensity levels to provide actionable insights for Bellabeat’s product development and user engagement strategies.

## Table of Contents
- [Project Overview](#project-overview)
- [Data Sources](#data-sources)
- [Analysis](#analysis)
- [Installation](#installation)
- [Usage](#usage)
- [Data Access](#data-access)
- [Contributors](#contributors)
- [License](#license)

## Project Overview
The primary objective of this project is to analyze fitness data to:
- Identify trends in user behavior using fitness devices.
- Provide recommendations for improving Bellabeat’s product offerings.
- Suggest marketing strategies based on user engagement patterns.

The analysis leverages publicly available data from Fitbit users, and the insights are intended to help Bellabeat better align its product features and marketing efforts with the real-world usage of fitness tracking devices.

## Data Sources
The data used in this analysis comes from a publicly available Fitbit dataset provided by Kaggle. It includes:
- **Daily and hourly activity data**: Step counts, calories burned, and intensity levels across different times of the day.
- **Sleep data**: Minute-level sleep duration and quality data, including differences between weekdays and weekends.
- **Heart rate data**: Continuous readings provide insights into resting and active heart rate patterns.
- **Weight logs**: Data on user weight, providing additional context on fitness progress and health metrics.

[Data Access]((https://drive.google.com/drive/folders/1Ay2kj0EuAuXeg_oHEIAPHzSag2UhF7Rd?usp=drive_link))

## Analysis
The analysis focuses on several key behavioral patterns:

### Daily and Hourly Activity Patterns
- **Average Daily Steps**: The data shows significant variability in step counts, with some users walking fewer than 500 steps and others exceeding 10,000 steps daily.
- **Hourly Activity Peaks**: Peaks in activity are observed between 7-9 AM and 6-8 PM, likely coinciding with commuting and post-work exercise routines.

### Heart Rate Trends
- **Heart Rate by Hour**: Users’ heart rates fluctuate throughout the day, peaking during evening exercise hours and dipping during periods of rest. Resting heart rates average around 61.9 bpm, while peak active heart rates reach 86.2 bpm.

### Sleep Patterns
- **Weekend vs. Weekday Sleep**: Users tend to sleep slightly more on weekends (1.1 hours on average) than on weekdays (1.08 hours), indicating a natural recovery pattern.

### User Segmentation
Two types of segmentation were performed to understand user behavior better:
1. **Step-Based Segmentation**: Users were segmented based on their average daily steps into High Activity (10,000+ steps), Moderate Activity (5,000-9,999 steps), and Low Activity (fewer than 5,000 steps) categories.
2. **K-means Clustering**: A more holistic clustering approach that segments users based on multiple metrics such as activity, sleep, and heart rate. Three distinct clusters were identified:
    - **Cluster 1 (Low-to-Moderate Activity)**: These users would benefit from motivational tools and fitness challenges.
    - **Cluster 2 (Moderate Activity)**: Users are consistently active and could be engaged with more challenging programs.
    - **Cluster 3 (Highly Active)**: These users show high activity across all metrics and would respond well to advanced features.

### Correlation Analysis
A correlation analysis was performed to explore relationships between key metrics:
- **Steps vs. Sleep Duration**: A weak negative correlation (-0.08) suggests that higher activity does not significantly improve sleep duration.
- **Heart Rate vs. Sleep Duration**: A weak correlation (-0.2) indicates that users with higher resting heart rates tend to sleep less, though the effect is minor.

The correlation analysis suggests that factors beyond steps and heart rate, such as stress or environmental conditions, may play a more significant role in sleep quality.

## Installation
To replicate the analysis, follow these steps:

1. Clone the repository:
   ```bash
   https://github.com/Ivie-Irivbogbe/Bellabeat-Fitness-Analysis
2. Install the required dependencies:
```bash
    pip install -r requirements.txt
