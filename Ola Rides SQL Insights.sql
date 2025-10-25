-- Load and Prepare Data
USE OLA;
SELECT * FROM OLA_RIDES;
SET SQL_SAFE_UPDATES=0;

-- Round Numeric Columns
UPDATE OLA_RIDES SET `Avg VTAT` = ROUND(`Avg VTAT`);
UPDATE OLA_RIDES SET 
    `Avg CTAT` = ROUND(`Avg CTAT`),
    `Booking Value` = ROUND(`Booking Value`),
    `Ride Distance` = ROUND(`Ride Distance`),
    `Driver Ratings` = ROUND(`Driver Ratings`),
    `Customer Rating` = ROUND(`Customer Rating`);

-- Format Date Column
UPDATE OLA_RIDES
SET Date = DATE_FORMAT(STR_TO_DATE(Date, '%d/%m/%Y'), '%Y-%m-%d');

-- Vehicle Type Distribution
SELECT `Vehicle Type`, COUNT(`Customer ID`) AS `NO OF VEHICLES`
FROM OLA_RIDES
GROUP BY `Vehicle Type`
ORDER BY 2 DESC;
/*
Prime Plus  7252
Bike    7223
Prime Sedan 7179
Prime SUV   7140
Auto    7098
eBike   7097
Mini    7010
*/

-- Top 5 Dates with Most Successful Rides
SELECT DATE, COUNT(`Booking Status`) AS 'NO OF SUCCESSFULL RIDES'
FROM OLA_RIDES
WHERE `Booking Status` = 'Success'
GROUP BY Date ORDER BY 2 DESC LIMIT 5;
/*
2024-01-12  1178
2024-01-11  1167
2024-01-30  1148
2024-01-14  1148
2024-01-18  1147
*/

-- Total Number of Customers
SELECT COUNT(`Customer ID`) AS `TOTAL CUSTOMER` FROM OLA_RIDES;
/*
49999
*/

-- Booking Status Summary
SELECT `Booking Status`, COUNT(`Booking Status`) AS `BOOKING STATUS`
FROM OLA_RIDES
GROUP BY 1;
/*
Success 33484
Cancelled by Driver 9610
Incomplete  3106
Cancelled by Customer   3799
*/

-- Most Profitable Time Slot
SELECT TIME, SUM(`Booking Value`) AS `PROFIT`
FROM OLA_RIDES
WHERE `Booking Status` = 'Success'
GROUP BY TIME
ORDER BY 2 DESC
LIMIT 1;
/*
12:00:00    1503082
*/

-- Total Cancelled by Customer
SELECT COUNT(`Cancelled  by Customer`) AS `NO OF CANCELLED CUSTOMER`
FROM OLA_RIDES
WHERE `Cancelled  by Customer` > 0;
/*3799*/

-- Most Common Booking Status (Top 1)
SELECT `Booking Status`, COUNT(`Booking Status`) AS 'BOOKING STATUS'
FROM OLA_RIDES
GROUP BY 1 LIMIT 1;
/*Success   33484*/

-- Top 5 Pickup Locations
SELECT `Pickup Location`, COUNT(`Pickup Location`) AS `Pickup_Count`
FROM OLA_RIDES
GROUP BY `Pickup Location`
ORDER BY 2 DESC
LIMIT 5;
/*
Area-39 1100
Area-4  1057
Area-8  1049
Area-29 1045
Area-9  1040
*/

-- Top 5 Drop Locations
SELECT `Drop Location`, COUNT(`Drop Location`) AS `DROP_Count`
FROM OLA_RIDES
GROUP BY `Drop Location`
ORDER BY 2 DESC
LIMIT 5;
/*
Area-39 1058
Area-8  1052
Area-21 1049
Area-34 1042
Area-27 1041
*/

-- VTAT Extremes (Max and Min)
SELECT MAX(`Avg VTAT`) AS `MAXIMUM AND MINIMUM WAITING TIME VEHICLE`
FROM OLA_RIDES 
UNION 
SELECT MIN(`Avg VTAT`) FROM OLA_RIDES;
/*
20
1
*/

-- CTAT Extremes (Max and Min)
SELECT MAX(`Avg CTAT`) AS `MAX AND MINWAITING TIME BY CUSTOMER`
FROM OLA_RIDES 
UNION 
SELECT MIN(`Avg CTAT`) FROM OLA_RIDES;
/*
30
1
*/

-- Drop Locations with Max VTAT
SELECT `Drop Location`, `Avg VTAT`
FROM OLA_RIDES
WHERE `Avg VTAT` = (SELECT MAX(`Avg VTAT`) FROM OLA_RIDES);
/*
Area-26 20
Area-4  20
Area-48 20
Area-35 20
Area-33 20
Area-30 20
Area-34 20
Area-13 20
Area-14 20
Area-49 20
*/

-- Reasons for Customer Cancellations
SELECT `Reason for Cancelling by Customer`, COUNT(`Customer ID`) AS `Cancel_Count`
FROM OLA_RIDES
WHERE `Reason for Cancelling by Customer` != 'Not Cancelled by Customer'
GROUP BY `Reason for Cancelling by Customer`;
/*
Wrong Address   720
Driver asked to cancel  738
AC is not working   792
Driver is not moving towards pickup location    793
Change of plans 756
*/

-- Reasons for Driver Cancellations
SELECT `Reason for Cancelling by Driver`, COUNT(`Customer ID`) AS `Cancel_Count`
FROM OLA_RIDES
WHERE `Reason for Cancelling by Driver` != 'Not Cancelled by Driver'
GROUP BY `Reason for Cancelling by Driver`;
/*
The customer was coughing/sick  2283
Personal & Car related issues   2413
Customer related issue  2402
More than permitted people in there 2512
*/

-- View Full Dataset
SELECT * FROM OLA_RIDES;

-- Total Incomplete Rides
SELECT SUM(`Incomplete Rides`) AS `NO OF INCOMPLETED` FROM OLA_RIDES;
/*
3106
*/

-- Payment Method Usage Count
SELECT `Payment Method`, COUNT(`Booking ID`) AS `Payment_Count`
FROM OLA_RIDES
WHERE `Payment Method` != 'Not Applicable'
GROUP BY `Payment Method`
ORDER BY 2 DESC;
/*
Cash    8552
UPI 8428
Card    8280
Wallet  8224
*/

-- Top Customers by Ride Count
SELECT `Customer ID`, COUNT(`Customer ID`) AS `NO OF RIDE BY CUSTOMER`
FROM OLA_RIDES
GROUP BY `Customer ID`
ORDER BY 2 DESC;
/*
369403  3
476504  3
844154  3
426604  3
579247  3
299613  3
583885  3
580524  3
458084  3
517003  3
*/

-- Maximum Ride Distance
SELECT `Ride Distance` AS `MAX RIDE DISTANCE`
FROM OLA_RIDES
ORDER BY `Ride Distance` DESC
LIMIT 1;
/*50*/

-- View Full Dataset Again
SELECT * FROM OLA_RIDES;

-- Total Revenue by Payment Method
SELECT `Payment Method`, SUM(`Booking Value`) AS `Total_Revenue`
FROM OLA_RIDES
WHERE `Payment Method` != 'Not Applicable'
GROUP BY `Payment Method`
ORDER BY 2 DESC;
/*
Cash    8768215
UPI 8612239
Wallet  8508588
Card    8377625
*/
