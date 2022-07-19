--SQL Queries Used for preparing, cleaning, and processing data:

--1.)  Determine the time elapsed (in minutes) from start time and end time using the DATE_DIFF function. Repeat this process for every month of data (12), this will be known as 'trip duration'--
 
SELECT ride_id, rideable_type, started_at, ended_at, DATE_DIFF(ended_at,started_at,MINUTE) AS trip_duration, day_week, start_station_name, start_station_id, end_station_name, end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual
FROM `case-study-1x.new_bike_share_data.new_february_2022` ORDER BY trip_duration DESC

--2.) Combine all the months of data into one table using the UNION ALL function--
 
SELECT * FROM `case-study-1x.bike_share_data.april`
UNION ALL
SELECT * FROM `case-study-1x.bike_share_data.august`
UNION ALL
SELECT * FROM `case-study-1x.bike_share_data.december`
UNION ALL
SELECT * FROM `case-study-1x.bike_share_data.february`
UNION ALL
SELECT * FROM `case-study-1x.bike_share_data.january`
UNION ALL
SELECT * FROM `case-study-1x.bike_share_data.july`
UNION ALL
SELECT * FROM `case-study-1x.bike_share_data.june`
UNION ALL
SELECT * FROM `case-study-1x.bike_share_data.march`
UNION ALL
SELECT * FROM `case-study-1x.bike_share_data.may`
UNION ALL
SELECT * FROM `case-study-1x.bike_share_data.november`
UNION ALL
SELECT * FROM `case-study-1x.bike_share_data.october`
UNION ALL
SELECT * FROM `case-study-1x.bike_share_data.september`
 
 --3.) Determine if there are duplicate values in the ride_id column using COUNT(DISTINCT()) Function after joining all the tables together. The result is: 
4604143 distinct values in for ride_id and 4605595 rows total, meaning there are duplicate ride ids, which should not occur!--

SELECT COUNT(DISTINCT(ride_id)) FROM `case-study-1x.new_bike_share_data1.all_data_no_nulls
 
 --In order to clean the data of missing values for blank station names for part of the analysis, I used the DELETE FROM function on NULL fields for station names--

DELETE FROM `case-study-1x.bike_share_data.all_months_no_nulls` WHERE start_station_name IS NULL OR end_station_name IS NULL
 
--I also deleted trips with trip durations that were equal to "0", as those were most likely invalid entries in my opinion and didn't completely make sense to me--

DELETE FROM `case-study-1x.bike_share_data.all_months_1` WHERE trip_duration_minutes = 0
 
--5.) Determine the max and min values for trip_duration_minutes column by using MIN() and MAX() functions for data validation--

SELECT MIN(trip_duration_minutes) FROM `case-study-1x.bike_share_data.all_months_1`
 
SELECT MAX(trip_duration_minutes) FROM `case-study-1x.bike_share_data.all_months_1`
 
 --4.) Realize there are negative values when running the MIN() function on trip_duration_minutes column so I convert all the negative values in trip_duration_minutes to absolute values using the ABS() Function:
Run a query to convert all trip duration values to absolute values to remove negative numbers in the all_data1 table--

SELECT ride_id, rideable_type, started_at, ended_at, month, time_24hr, ABS(trip_duration) AS trip_duration_minutes, day_week, start_station_name, start_station_id, end_station_name, end_station_id, start_lat, start_lng, end_lat, end_lng, member_casual
FROM `case-study-1x.bike_share_data.all_months`

--To check to see if the data is valid and clean I check the min and max of all number fields to spot errors or inconsistent data--

SELECT MIN(start_lat), MAX(start_lat), MIN(start_lng), MAX(start_lng), MIN(end_lat), MAX(end_lat), MIN(end_lng), MAX(end_lng) FROM `case-study-1x.bike_share_data.all_months_1`
 
--None were found now--

--Data and visualizations I shared and SQL queries used for each:

--Breakdown of % of casual bike riders vs % of member bike riders from total of ride id’s--

SELECT member_casual,COUNT(member_casual) AS Total_riders
FROM `case-study-1x.bike_share_data.all_months_1`
WHERE rideable_type <> "docked_bike"
GROUP BY member_casual
ORDER BY total_riders DESC
LIMIT 2
 
--Most popular days to ride (mode) for casual and member bike riders--

SELECT member_casual,day_week, COUNT(day_week) AS Popular_Days
FROM `case-study-1x.bike_share_data.all_months_1`
WHERE member_casual = "member" AND rideable_type <> "docked_bike"
GROUP BY member_casual, day_week
ORDER BY Popular_Days DESC
LIMIT 7

SELECT member_casual,day_week, COUNT(day_week) AS Popular_Days
FROM `case-study-1x.bike_share_data.all_months_1`
WHERE member_casual = "casual" AND rideable_type <> "docked_bike"
GROUP BY member_casual, day_week
ORDER BY Popular_Days DESC
LIMIT 7

--Most popular times of day to ride for casual and member bike riders--

SELECT member_casual,time_24hr, COUNT(time_24hr) AS popular_times
FROM `case-study-1x.bike_share_data.all_months_1`
WHERE member_casual = "member" AND rideable_type <> "docked_bike"
GROUP BY member_casual, time_24hr
ORDER BY popular_times DESC
LIMIT 24

--Average trip duration for casual riders vs member bike riders--

SELECT member_casual
, ROUND(AVG(trip_duration_minutes)) AS Duration
FROM `case-study-1x.bike_share_data.all_months_1`
WHERE rideable_type <> 'docked_bike'
GROUP BY
member_casual
ORDER BY
Duration DESC
LIMIT 10

--Number of trips greater than 30 minutes for casual riders vs member bike riders--
 
SELECT member_casual, COUNT(member_casual) AS rides_more_than_30min
FROM  `case-study-1x.bike_share_data.all_months_1`
WHERE trip_duration_minutes >= 30
GROUP BY member_casual

--Top 30 most popular routes for casual riders vs member bike riders--

SELECT member_casual
, CONCAT(start_station_name, " to " , end_station_name) AS route
, COUNT(*) as num_of_trips
, ROUND(AVG(trip_duration_minutes)) AS Duration
FROM `case-study-1x.bike_share_data.all_months_no_nulls`
WHERE rideable_type <> 'docked_bike'
GROUP BY
Start_station_name, end_station_name, member_casual
ORDER BY
num_of_trips DESC
LIMIT 30

--Top 10 most popular routes for casual riders vs member bike riders--

SELECT member_casual
, CONCAT(start_station_name, " to " , end_station_name) AS route
, COUNT(*) as num_of_trips
, ROUND(AVG(trip_duration_minutes)) AS Duration
FROM `case-study-1x.bike_share_data.all_months_no_nulls`
WHERE member_casual = "casual" AND rideable_type <> 'docked_bike'
GROUP BY
Start_station_name, end_station_name, member_casual
ORDER BY
num_of_trips DESC
LIMIT 10

SELECT member_casual
, CONCAT(start_station_name, " to " , end_station_name) AS route
, COUNT(*) as num_of_trips
, ROUND(AVG(trip_duration_minutes)) AS Duration
FROM `case-study-1x.bike_share_data.all_months_no_nulls`
WHERE member_casual = "member" AND rideable_type <> 'docked_bike'
GROUP BY
Start_station_name, end_station_name, member_casual
ORDER BY
num_of_trips DESC
LIMIT 10

--Most common bike used by the two groups of riders (member/casual): classic or electric bike--

SELECT member_casual,rideable_type, COUNT(rideable_type) AS Popular_bikes
FROM `case-study-1x.bike_share_data.all_months_1`
WHERE rideable_type <> "docked_bike"
GROUP BY member_casual, rideable_type
ORDER BY Popular_bikes DESC
LIMIT 4

--9.) Months with the most / least riders between members and casuals--

SELECT member_casual,month, COUNT(month) AS popular_months
FROM `case-study-1x.bike_share_data.all_months_1`
WHERE member_casual = "casual" AND rideable_type <> "docked_bike"
GROUP BY member_casual, month
ORDER BY popular_months DESC
 
SELECT member_casual,month, COUNT(month) AS popular_months
FROM `case-study-1x.bike_share_data.all_months_1`
WHERE member_casual = "member" AND rideable_type <> "docked_bike"
GROUP BY member_casual, month
ORDER BY popular_months DESC
 
SELECT member_casual,month, COUNT(month) AS popular_months
FROM `case-study-1x.bike_share_data.all_months_1`
WHERE rideable_type <> "docked_bike"
GROUP BY member_casual, month
ORDER BY popular_months
 
--8.) Average Trip Duration between Classic and Electric Bikes--

SELECT rideable_type
, ROUND(AVG(trip_duration_minutes)) AS Duration
FROM `case-study-1x.bike_share_data.all_months_1`
WHERE rideable_type <> 'docked_bike'
GROUP BY
rideable_type
ORDER BY
Duration DESC
