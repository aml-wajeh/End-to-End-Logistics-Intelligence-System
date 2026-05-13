-- Create Database:
 CREATE DATABASE LogisticT
 USE LogisticT

--Creating Tables
-- Dropping table [Customers]
DROP TABLE IF EXISTS Customers;
--3 Creating table to store information about customers
CREATE TABLE Customers (
    CustomerID VARCHAR(30) PRIMARY KEY,            
    Name VARCHAR(100),                              
	Address VARCHAR(255),                           
    State VARCHAR(50),                            
    ContactNumber_C VARCHAR(20) Null CHECK (ISNUMERIC(ContactNumber_c) = 1)   
);

BULK INSERT Customers
FROM 'D:\Lms\Data minig\project\New folder (2)\New folder\Customers.csv'
WITH (
    FIELDTERMINATOR = ',',     
    ROWTERMINATOR = '0x0a',    
    FIRSTROW = 2              
);

-- Dropping table [O_Hubs]
DROP TABLE IF EXISTS O_Hubs;
--1 Creating table to store information about hubs
CREATE TABLE O_Hubs (
    HubID VARCHAR(100) PRIMARY KEY,                     
	Location VARCHAR(100),                      
    State VARCHAR(50),                            
	Capacity INT,                     
    ContactNumber_H VARCHAR(20)                   
);

BULK INSERT O_Hubs
FROM 'D:\Lms\Data minig\project\New folder (2)\New folder\O_HUB.txt'
WITH (
    FIELDTERMINATOR = '\t',   
    ROWTERMINATOR = '\n',     
    FIRSTROW = 2,             
    KEEPNULLS,                
    CODEPAGE = '65001'        
);

select * from O_Hubs

DROP TABLE IF EXISTS D_Hubs;
--1 Creating table to store information about hubs
CREATE TABLE D_Hubs (
    HubID VARCHAR(100) PRIMARY KEY,                         
	Location VARCHAR(100),                          
    State VARCHAR(50),                             
	Capacity INT CHECK (Capacity >= 0),                 
    ContactNumber_H VARCHAR(20)                   
);

BULK INSERT D_Hubs
FROM 'D:\Lms\Data minig\project\New folder (2)\New folder\D_HUB.txt'
WITH (
    FIELDTERMINATOR = '\t',   
    ROWTERMINATOR = '\n',     
    FIRSTROW = 2,             
    KEEPNULLS,                
    CODEPAGE = '65001'        
);


-- Dropping table [Vehicles]
DROP TABLE IF EXISTS Vehicles;
-- 4 Creating table to store information about Vehicles
CREATE TABLE Vehicles (
    VehicleNumber VARCHAR(30) PRIMARY KEY,     
    VehicleType VARCHAR(50),               
    FuelType VARCHAR(20) CHECK (FuelType IN ('Petrol', 'Diesel', 'Electric', 'Gas'))             

);

BULK INSERT Vehicles
FROM 'D:\Lms\Data minig\project\New folder (2)\New folder\vehicle.csv'
WITH (
    FIELDTERMINATOR = ',',     
    ROWTERMINATOR = '0x0a',    
    FIRSTROW = 2              
);

-- Dropping table [Routes]
DROP TABLE IF EXISTS Routes;
-- 6 Creating table to store information about routes
CREATE TABLE Routes (
    RouteID INT IDENTITY(1,1) PRIMARY KEY,                    
    DeparturePoint VARCHAR(100) NOT NULL,                   
    DestinationPoint VARCHAR(100) NOT NULL,                  
    Mode VARCHAR(30) CHECK (Mode IN ('Market', 'Regular')),  
    EDA DATETIME2,                                        
    Distance_KM REAL CHECK (Distance_KM > 0)                
);

BULK INSERT Routes
FROM 'D:\Lms\Data minig\project\New folder (2)\New folder\Routes.txt'
WITH (
    FIELDTERMINATOR = '\t',   
    ROWTERMINATOR = '\n',     
    FIRSTROW = 2,             
    KEEPNULLS,                
    CODEPAGE = '65001'        
);


-- Dropping table [Sellers]
DROP TABLE IF EXISTS Sellers;
-- 2 Creating table to store information about sellers
CREATE TABLE Sellers (
    SellerID VARCHAR(30) PRIMARY KEY,                         
    Name VARCHAR(100),                              
	Address VARCHAR(255),                           
    State VARCHAR(50),                             
    ContactNumber_S VARCHAR(20) CHECK (ISNUMERIC(ContactNumber_S) = 1)   
);

BULK INSERT Sellers
FROM 'D:\Lms\Data minig\project\New folder (2)\New folder\Sellers.csv'
WITH (
    FIELDTERMINATOR = ',',     
    ROWTERMINATOR = '0x0a',    
    FIRSTROW = 2              
);

-- Dropping table [DeliveryPersons]
DROP TABLE IF EXISTS DeliveryPersons;
-- 5 Creating table to store information about delivery persons
CREATE TABLE DeliveryPersons(
    DeliveryPersonID INT IDENTITY(1,1),                
    Name VARCHAR(100) PRIMARY KEY,                               
    ContactNumber VARCHAR(20),                       

);

BULK INSERT DeliveryPersons
FROM 'D:\Lms\Data minig\project\New folder (2)\New folder\DeliveryPersons.csv'
WITH (
    FIELDTERMINATOR = ',',     
    ROWTERMINATOR = '0x0a',    
    FIRSTROW = 2              
);


-- Dropping table [Parcels]
DROP TABLE IF EXISTS Parcels;

-- 7 Creating table for data regarding the parcels ordered
CREATE TABLE Parcels (
    TrackingNumber VARCHAR(30) PRIMARY KEY,                    
    CustomerID VARCHAR(30) NOT NULL,                                                  
	ShippingFee DECIMAL(10, 2) CHECK (ShippingFee >= 0),
	BookingDate DATETIME2 NOT NULL DEFAULT GETDATE(),    
	PromisedDate DATETIME2,
    DeliveryDate DATETIME2,                      
    Status VARCHAR(20) NOT NULL DEFAULT 'Pending' 
        CHECK ([Status] IN ('Delayed', 'OnTime', 'Early', 'Failed', 'Pending')), 
	WeatherCondition  VARCHAR(50),

    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

BULK INSERT Parcels
FROM 'D:\Lms\Data minig\project\New folder (2)\New folder\Parcels.csv'
WITH (
    FIELDTERMINATOR = ',',     
    ROWTERMINATOR = '0x0a',    
    FIRSTROW = 2              
);

--Dropping table [Parcels_Details]
DROP TABLE IF EXISTS Parcels_Details;
-- 7 Creating table for data regarding the parcels ordered
CREATE TABLE Parcels_Details (
    ParcelID INT IDENTITY(1,1) PRIMARY KEY,
	TrackingNumber VARCHAR(30),
    SellerID VARCHAR(30) NOT NULL,                         
	Material_Type VARCHAR(100),                     
	Status VARCHAR(20) NOT NULL DEFAULT 'Pending' 
        CHECK ([Status] IN ('Delayed', 'OnTime', 'Early', 'Failed', 'Pending')), 
	SourceHubID VARCHAR(100),                      
    DestinationHubID VARCHAR(100),                 
    DeliveryName VARCHAR(100),
	VehicleID VARCHAR(30),
	RouteID INT,
	Failure_Reason VARCHAR(255) Null,

	FOREIGN KEY (RouteID) REFERENCES Routes(RouteID),
	FOREIGN KEY (TrackingNumber) REFERENCES Parcels(TrackingNumber),
	FOREIGN KEY (SellerID) REFERENCES Sellers(SellerID),
    FOREIGN KEY (SourceHubID) REFERENCES O_Hubs(HubID),
    FOREIGN KEY (DestinationHubID) REFERENCES D_Hubs(HubID),
	FOREIGN KEY (DeliveryName) REFERENCES DeliveryPersons(Name),
	FOREIGN KEY (VehicleID) REFERENCES Vehicles(VehicleNumber),
);

BULK INSERT Parcels_Details
FROM 'D:\Lms\Data minig\project\New folder (2)\New folder\Parcels_ID.CSV'
WITH (
    FIELDTERMINATOR = ',',     
    ROWTERMINATOR = '0x0a',    
    FIRSTROW = 2              
);

select * from Parcels_Details

-- Dropping table [Shipment_Logs]
DROP TABLE IF EXISTS Shipment_Logs;
-- 8 Creating table to store information about chronological tracking events
CREATE TABLE Shipment_Logs (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    TrackingNumber VARCHAR(30) NOT NULL,                   
    Shipmet_Start_Date DATETIME2,                
	DeliveryDate DATETIME2,                     
	Log_Timestamp DATETIME2,                     
    Start_Point VARCHAR(100),                      
	Current_Location VARCHAR(300),                    
	Destination VARCHAR(100),                      
	Log_Description VARCHAR(100) Null,                  
	Original_GPS VARCHAR(100),   
	Destination_GPS VARCHAR(100),
    GpsProvider VARCHAR(230)
    
    FOREIGN KEY (TrackingNumber) REFERENCES Parcels(TrackingNumber),
);

BULK INSERT Shipment_Logs
FROM 'D:\Lms\Data minig\project\New folder (2)\New folder\Shipment_Logs.txt'
WITH (
    FIELDTERMINATOR = '\t',   
    ROWTERMINATOR = '\n',     
    FIRSTROW = 2,             
    KEEPNULLS,                
    CODEPAGE = '65001'        
);

-- Dropping table [Revenue]
DROP TABLE IF EXISTS Revenue;
-- 5 Creating table to store information about Revenue
CREATE TABLE Revenue(
    BillID INT IDENTITY(1,1)PRIMARY KEY,   -
	TrackingNumber VARCHAR(30) NOT NULL,                    
	VehicleID VARCHAR(30),     
    Maintenance DECIMAL(10, 2),

	FOREIGN KEY (TrackingNumber) REFERENCES Parcels(TrackingNumber),
	FOREIGN KEY (VehicleID) REFERENCES Vehicles(VehicleNumber)
);

BULK INSERT Revenue
FROM 'D:\Lms\Data minig\project\New folder (2)\New folder\Revenue.csv'
WITH (
    FIELDTERMINATOR = ',',     
    ROWTERMINATOR = '0x0a',    
    FIRSTROW = 2              
);


---1 Shipment Master View
go
CREATE VIEW vw_ShipmentMaster AS
SELECT 
    pd.ParcelID AS ShipmentID,
    pd.TrackingNumber,
    s.Name AS SenderName,          
    c.Name AS ReceiverName,        
    oh.Location AS OriginHub,
    dh.Location AS DestinationHub,
    p.BookingDate AS CreatedDate,
    pd.Status AS CurrentStatus
FROM 
Parcels_Details pd
JOIN Parcels p ON pd.TrackingNumber = p.TrackingNumber
JOIN Sellers s ON pd.SellerID = s.SellerID
JOIN Customers c ON p.CustomerID = c.CustomerID
JOIN D_Hubs dh ON pd.DestinationHubID = dh.HubID
JOIN O_Hubs oh ON pd.SourceHubID = oh.HubID;

GO
drop view vw_ShipmentMaster

SELECT TOP 50 * FROM vw_ShipmentMaster
ORDER BY CreatedDate DESC;

---comments
---Operational Efficiency: All shipments are marked "Early," indicating a highly punctual and efficient logistics process.
---Localized Logistics: Many shipments share the same Origin and Destination (Kanchipuram), pointing to high-volume internal transfers within the same industrial complex.


--2 Latest Tracking Status per Shipment
SELECT 
    pd.TrackingNumber,
    p.DeliveryDate AS LatestEventTime,  
    'Delivered' AS LatestStatus,
    dh.Location AS LatestHubName,
	p.Status AS Condition
FROM 
    Parcels_Details pd
	JOIN D_Hubs dh ON pd.DestinationHubID = dh.HubID
    JOIN Parcels p ON pd.TrackingNumber = p.TrackingNumber
JOIN (
    SELECT TrackingNumber, MAX(DeliveryDate) AS MaxDate
    FROM Parcels
    GROUP BY TrackingNumber
) AS LatestRecords ON pd.TrackingNumber = LatestRecords.TrackingNumber 
                  AND p.DeliveryDate = LatestRecords.MaxDate


--OR
SELECT 
    TrackingNumber, 
    LatestEventTime, 
    LatestStatus, 
    LatestHubName,
	Condition
FROM (
    SELECT 
        pd.TrackingNumber,
    p.DeliveryDate AS LatestEventTime,  
    'Delivered' AS LatestStatus,
    dh.Location AS LatestHubName,
	p.Status AS Condition,
        ROW_NUMBER() OVER (PARTITION BY pd.TrackingNumber ORDER BY p.DeliveryDate DESC) as RN
    FROM 
        Parcels_Details pd
JOIN D_Hubs dh ON pd.DestinationHubID = dh.HubID
JOIN Parcels p ON pd.TrackingNumber = p.TrackingNumber
) AS RankedEvents
WHERE RN = 1; 

---comments
--Operational Bottleneck: A high frequency of "Delay" conditions is linked to the "Devalapura, Mysore" hub, indicating a specific localized logistics issue.


--3 Tracking Timeline View (Full History)
CREATE VIEW vw_ShipmentTimeline AS
-- 1. Booking event (from Parcels)
SELECT
    p.TrackingNumber,
    p.BookingDate AS EventTime,
    oh.Location AS HubName,
    'Booked' AS Status,
    'Registered at ' + ISNULL(oh.Location, 'Unknown') +' from Seller ' 
     + pd.SellerID AS EventDescription
FROM Parcels p
JOIN Parcels_Details pd ON p.TrackingNumber = pd.TrackingNumber
JOIN O_Hubs oh ON pd.SourceHubID = oh.HubID

UNION ALL

-- 2. In-transit updates (from Shipment_Logs)
SELECT
    sl.TrackingNumber,
    sl.Log_Timestamp AS EventTime,
    sl.Current_Location AS HubName,
    'In-Transit' AS Status,
    'In-transit update at ' + ISNULL(sl.Current_Location, 'Unknown location')
      + ' - ' + ISNULL(sl.GpsProvider, '') AS EventDescription
FROM Shipment_Logs sl

UNION ALL

-- 3. Final delivery / status (from Parcels_Details)
SELECT
    pd.TrackingNumber,
    p.DeliveryDate AS EventTime,
    dh.Location AS HubName,
    pd.Status AS Status,
    'Final status: ' + pd.Status
      + ' at ' + ISNULL(dh.Location, 'Destination') AS EventDescription
FROM Parcels_Details pd
JOIN Parcels p ON pd.TrackingNumber = p.TrackingNumber
JOIN D_Hubs dh ON pd.DestinationHubID = dh.HubID
WHERE p.DeliveryDate IS NOT NULL;
GO


-- Example usage
SELECT  *
FROM vw_ShipmentTimeline
WHERE TrackingNumber = 'MVCV0000927/082021' 
ORDER BY EventTime ASC;


--4 Hub Throughput by Day
DECLARE @StartDate DATE = '2020-08-01';
DECLARE @EndDate DATE = '2020-08-31';

WITH HubList AS (
    SELECT HubID FROM O_Hubs
    UNION
    SELECT HubID FROM D_Hubs
),
Departures AS (
    SELECT pd.SourceHubID AS HubID, CAST(p.BookingDate AS DATE) AS EventDate, COUNT(*) AS DepartedCount
    FROM Parcels p
    JOIN Parcels_Details pd ON p.TrackingNumber = pd.TrackingNumber
    GROUP BY pd.SourceHubID, CAST(p.BookingDate AS DATE)
),
Arrivals AS (
    SELECT pd.DestinationHubID AS HubID, CAST(p.DeliveryDate AS DATE) AS EventDate, COUNT(*) AS ArrivedCount
    FROM Parcels p
    JOIN Parcels_Details pd ON p.TrackingNumber = pd.TrackingNumber
    GROUP BY pd.DestinationHubID, CAST(p.DeliveryDate AS DATE)
)
SELECT 
    h.HubID, 
    COALESCE(d.EventDate, a.EventDate) AS [Date],
    ISNULL(a.ArrivedCount, 0) AS ShipmentsArrivedCount,
    ISNULL(d.DepartedCount, 0) AS ShipmentsDepartedCount,
    (ISNULL(a.ArrivedCount, 0) + ISNULL(d.DepartedCount, 0)) AS TotalCount
FROM HubList h
LEFT JOIN Departures d ON h.HubID = d.HubID
LEFT JOIN Arrivals a ON h.HubID = a.HubID AND a.EventDate = COALESCE(d.EventDate, a.EventDate)
WHERE COALESCE(d.EventDate, a.EventDate) BETWEEN @StartDate AND @EndDate
ORDER BY [Date], h.HubID;

---or
DECLARE @StartDate DATE = '2020-08-01';
DECLARE @EndDate DATE = '2020-08-31';

WITH HubList AS (
    SELECT HubID FROM O_Hubs
    UNION
    SELECT HubID FROM D_Hubs
),
Departures AS (
    SELECT pd.SourceHubID AS HubID, COUNT(*) AS DepartedCount
    FROM Parcels p
    JOIN Parcels_Details pd ON p.TrackingNumber = pd.TrackingNumber
    WHERE CAST(p.BookingDate AS DATE) BETWEEN @StartDate AND @EndDate 
    GROUP BY pd.SourceHubID
),
Arrivals AS (
    SELECT pd.DestinationHubID AS HubID, COUNT(*) AS ArrivedCount
    FROM Parcels p
    JOIN Parcels_Details pd ON p.TrackingNumber = pd.TrackingNumber
    WHERE CAST(p.DeliveryDate AS DATE) BETWEEN @StartDate AND @EndDate
    GROUP BY pd.DestinationHubID
)
SELECT 
    h.HubID, 
    ISNULL(a.ArrivedCount, 0) AS TotalArrived,
    ISNULL(d.DepartedCount, 0) AS TotalDeparted,
    (ISNULL(a.ArrivedCount, 0) + ISNULL(d.DepartedCount, 0)) AS GrandTotal
FROM HubList h
LEFT JOIN Departures d ON h.HubID = d.HubID
LEFT JOIN Arrivals a ON h.HubID = a.HubID;




--5 Delivery Success Rate by Courier
---for driver
SELECT 
    pd.DeliveryName AS CourierName, 
    COUNT(p.TrackingNumber) AS TotalAttempts,
    SUM(CASE WHEN p.Status = 'Early' THEN 1 ELSE 0 END) AS SuccessfulDeliveries,
    SUM(CASE WHEN p.Status = 'Delay' THEN 1 ELSE 0 END) AS FailedAttempts,
    FORMAT(
        (CAST(SUM(CASE WHEN p.Status = 'Early' THEN 1 ELSE 0 END) AS FLOAT) / 
         NULLIF(COUNT(p.TrackingNumber), 0)) * 100, 
        'N2'
    ) + '%' AS SuccessRate
FROM Parcels p
JOIN Parcels_Details pd ON p.TrackingNumber = pd.TrackingNumber 

WHERE p.DeliveryDate BETWEEN '2020-08-01' AND '2020-11-01' 

GROUP BY pd.DeliveryName
ORDER BY SuccessRate DESC;


---for hub
SELECT 
    h.Location AS HubName, 
    COUNT(p.TrackingNumber) AS TotalAttempts,
    
    SUM(CASE WHEN UPPER(p.Status) LIKE '%EARLY%' THEN 1 ELSE 0 END) AS SuccessfulDeliveries,
    
    SUM(CASE WHEN UPPER(p.Status) LIKE '%DELAY%' THEN 1 ELSE 0 END) AS FailedAttempts,
    
    FORMAT(
        (SUM(CASE WHEN UPPER(p.Status) LIKE '%EARLY%' THEN 1 ELSE 0 END) * 100.0) / 
         NULLIF(COUNT(p.TrackingNumber), 0), 
        'N2'
    ) + '%' AS SuccessRate
FROM Parcels p
JOIN Parcels_Details pd ON p.TrackingNumber = pd.TrackingNumber 
JOIN D_Hubs h ON pd.DestinationHubID = h.HubID

WHERE p.DeliveryDate BETWEEN '2020-08-01' AND '2020-11-01' 

GROUP BY h.Location 
ORDER BY SuccessRate DESC;


---6 Delivery Attempts Analysis (Reason Codes)
---percentage of delay
SELECT
    COUNT(*) AS Total_Shipments,
    SUM(CASE WHEN p.Status = 'Delay' THEN 1 ELSE 0 END) AS Delayed_Count,
    ROUND(100.0 * 
          SUM(CASE WHEN p.Status = 'Delay' THEN 1 ELSE 0 END) 
          / NULLIF(COUNT(*), 0), 2) AS Overall_Delay_Percentage
FROM Parcels p
INNER JOIN Parcels_Details pd 
    ON p.TrackingNumber = pd.TrackingNumber
WHERE p.Status IN ('Delay', 'OnTime', 'Early');


---delay because of distance
  SELECT
    CASE 
        WHEN r.Distance_KM <= 150 THEN '≤150 km'
        WHEN r.Distance_KM <= 300 THEN '151–300 km'
        ELSE '>300 km'
    END AS Range,
    COUNT(*) AS Trips,
    SUM(CASE WHEN pd.Status = 'Delay' THEN 1 ELSE 0 END) AS Delayed,
    ROUND(100.0 * SUM(CASE WHEN pd.Status = 'Delay' THEN 1.0 ELSE 0 END) / COUNT(*), 1) AS Delay_pct
FROM Parcels_Details pd
JOIN Routes r ON pd.RouteID = r.RouteID
WHERE pd.Status IN ('Delay', 'OnTime', 'Early')
  AND r.Distance_KM > 0
GROUP BY 
    CASE 
        WHEN r.Distance_KM <= 150 THEN '≤150 km'
        WHEN r.Distance_KM <= 300 THEN '151–300 km'
        ELSE '>300 km'
    END
ORDER BY MIN(r.Distance_KM);


---delay because of mode
  SELECT
    r.Mode AS Shipment_Type,
    COUNT(*) AS Total_Trips,
    SUM(CASE WHEN p.Status = 'Delay' THEN 1 ELSE 0 END) AS Delayed_Trips,
    ROUND(100.0 * 
          SUM(CASE WHEN p.Status = 'Delay' THEN 1 ELSE 0 END) 
          / NULLIF(COUNT(*), 0), 1) AS Delay_Percentage
FROM Parcels p
INNER JOIN Parcels_Details pd ON p.TrackingNumber = pd.TrackingNumber
INNER JOIN Routes r ON pd.RouteID = r.RouteID
WHERE p.Status IN ('Delay', 'OnTime', 'Early')
  AND r.Mode IN ('Market', 'Regular')
GROUP BY r.Mode
ORDER BY Delay_Percentage DESC;


---delay beacause of weather
  SELECT 
    'Bad weather' AS Factor,
    COUNT(*) AS Total_Trips,
    SUM(CASE WHEN p.Status = 'Delay' THEN 1 ELSE 0 END) AS Delayed_Trips,
    ROUND(100.0 * 
          SUM(CASE WHEN p.Status = 'Delay' THEN 1 ELSE 0 END) 
          / NULLIF(COUNT(*), 0), 1) AS Delay_Percentage
FROM Parcels p
INNER JOIN Parcels_Details pd ON p.TrackingNumber = pd.TrackingNumber
WHERE p.WeatherCondition IN ('cloudy', 'Mist', 'Patchy rain possible', 'Overcast', 'Patchy rain', 'cloudy ,')
  AND p.Status IN ('Delay', 'OnTime', 'Early');
  
----delay because of vehicle type
  SELECT
    CASE 
        WHEN v.VehicleType LIKE '%Tata Ace%' 
          OR v.VehicleType LIKE '%1 MT%' 
          OR v.VehicleType LIKE '%Ace%' 
            THEN 'Small (~1 ton)'

        WHEN v.VehicleType LIKE '%7MT%' 
          OR v.VehicleType LIKE '%8 MT%' 
          OR v.VehicleType LIKE '%Single-Axle%' 
            THEN 'Medium light (7–8 ton)'

        ELSE 'Large / Heavy / Other'
    END AS Vehicle_Size_Group,

    COUNT(*) AS Total_Trips,
    SUM(CASE WHEN p.Status = 'Delay' THEN 1 ELSE 0 END) AS Delayed_Trips,
    ROUND(100.0 * 
          SUM(CASE WHEN p.Status = 'Delay' THEN 1 ELSE 0 END) 
          / NULLIF(COUNT(*), 0), 1) AS Delay_Percentage

FROM Parcels p
INNER JOIN Parcels_Details pd ON p.TrackingNumber = pd.TrackingNumber
INNER JOIN Vehicles v ON pd.VehicleID = v.VehicleNumber

WHERE p.Status IN ('Delay', 'OnTime', 'Early')

GROUP BY 
    CASE 
        WHEN v.VehicleType LIKE '%Tata Ace%' 
          OR v.VehicleType LIKE '%1 MT%' 
          OR v.VehicleType LIKE '%Ace%' 
            THEN 'Small (~1 ton)'

        WHEN v.VehicleType LIKE '%7MT%' 
          OR v.VehicleType LIKE '%8 MT%' 
          OR v.VehicleType LIKE '%Single-Axle%' 
            THEN 'Medium light (7–8 ton)'

        ELSE 'Large / Heavy / Other'
    END

ORDER BY Delay_Percentage DESC;


-----
WITH DelayFactors AS (
    SELECT 
        p.TrackingNumber,
        p.Status,
        pd.DestinationHubID,
        CASE WHEN r.Distance_KM > 300 THEN 'Long Distance (>300km)' ELSE NULL END AS DistFactor,
        CASE WHEN r.Mode = 'Market' THEN 'Market Mode' ELSE NULL END AS ModeFactor,
        CASE WHEN p.WeatherCondition IN ('cloudy', 'Mist', 'Patchy rain', 'Overcast') THEN 'Bad Weather' ELSE NULL END AS WeatherFactor,
        CASE WHEN v.VehicleType LIKE '%Tata Ace%' OR v.VehicleType LIKE '%1 MT%' THEN 'Small Vehicle' ELSE NULL END AS VehicleFactor
    FROM Parcels p
    JOIN Parcels_Details pd ON p.TrackingNumber = pd.TrackingNumber
    JOIN Routes r ON pd.RouteID = r.RouteID
    LEFT JOIN Vehicles v ON pd.VehicleID = v.VehicleNumber
    WHERE p.Status = 'Delay'
),
UnpivotedFactors AS (
    SELECT TrackingNumber, DestinationHubID, FactorName
    FROM DelayFactors
    CROSS APPLY (VALUES (DistFactor), (ModeFactor), (WeatherFactor), (VehicleFactor)) AS v(FactorName)
    WHERE FactorName IS NOT NULL
),
TopFactor AS (
    SELECT TOP 1 FactorName, COUNT(*) AS TotalCount
    FROM UnpivotedFactors
    GROUP BY FactorName
    ORDER BY TotalCount DESC
)
SELECT 
    tf.FactorName AS [Top_Delay_Cause],
    h.Location AS [City_Name],
    COUNT(uf.TrackingNumber) AS [Delay_Occurrences_In_City]
FROM UnpivotedFactors uf
JOIN TopFactor tf ON uf.FactorName = tf.FactorName
JOIN D_Hubs h ON uf.DestinationHubID = h.HubID
GROUP BY tf.FactorName, h.Location
ORDER BY [Delay_Occurrences_In_City] DESC;


---7 Late Delivery Report (SLA Breach)
SELECT 
    p.TrackingNumber,
    pd.SourceHubID AS OriginHub,
    pd.DestinationHubID AS DestinationHub,
    p.PromisedDate,
    p.DeliveryDate AS ActualDate,
    DATEDIFF(DAY, p.PromisedDate, p.DeliveryDate) AS DaysLate
FROM Parcels p
JOIN Parcels_Details pd ON p.TrackingNumber = pd.TrackingNumber
WHERE p.DeliveryDate > p.PromisedDate;

SELECT 
    pd.DestinationHubID,
    COUNT(*) AS TotalShipments,
    SUM(CASE WHEN p.DeliveryDate > p.PromisedDate THEN 1 ELSE 0 END) AS LateCount,
    CAST(
        SUM(CASE WHEN p.DeliveryDate > p.PromisedDate THEN 1.0 ELSE 0 END) / COUNT(*) * 100 
    AS DECIMAL(10,2)) AS LateRate
FROM Parcels p
JOIN Parcels_Details pd ON p.TrackingNumber = pd.TrackingNumber
GROUP BY pd.DestinationHubID
ORDER BY LateRate DESC; 

---8 Stuck Shipments (No Movement)
WITH LastMovement AS (
    SELECT 
        TrackingNumber, 
        Log_Timestamp AS LastEventTime, 
        Current_Location,
        ROW_NUMBER() OVER (PARTITION BY TrackingNumber ORDER BY Log_Timestamp DESC) AS RowNum
    FROM Shipment_Logs
)
SELECT 
    p.TrackingNumber, 
    p.Status AS CurrentStatus, 
    lm.LastEventTime, 
    lm.Current_Location AS LastHub 
FROM Parcels p
JOIN LastMovement lm ON p.TrackingNumber = lm.TrackingNumber
WHERE lm.RowNum = 1 
  AND p.Status NOT IN ('Delivered', 'Cancelled')
  AND lm.LastEventTime < DATEADD(HOUR, -48, GETDATE()) 
ORDER BY lm.LastEventTime ASC;


---9 Proof of Delivery (POD) Validation View
CREATE VIEW vw_PODValidation AS
WITH LatestStatus AS (
    SELECT 
        TrackingNumber, 
        GpsProvider,
        Log_Timestamp,
        ROW_NUMBER() OVER (PARTITION BY TrackingNumber ORDER BY Log_Timestamp DESC) AS RowNum
    FROM Shipment_Logs
)
SELECT 
    p.TrackingNumber,
    p.DeliveryDate AS DeliveredDate,
    CASE 
        WHEN ls.GpsProvider IS NOT NULL THEN 'Yes' 
        ELSE 'No' 
    END AS PODExists,
    ISNULL(ls.GpsProvider, 'Missing') AS PODType
FROM Parcels p
LEFT JOIN LatestStatus ls ON p.TrackingNumber = ls.TrackingNumber AND ls.RowNum = 1
WHERE p.Status = 'Delay' OR p.Status = 'Early'; 

SELECT * FROM vw_PODValidation
drop view vw_PODValidation

---or
SELECT 
    p.TrackingNumber,
    p.DeliveryDate AS DeliveredDate,
    CASE 
        WHEN ls.GpsProvider IS NOT NULL THEN 'Yes' 
        ELSE 'No' 
    END AS PODExists,
    ISNULL(ls.GpsProvider, 'Missing') AS PODType
FROM Parcels p
LEFT JOIN (
    SELECT 
        TrackingNumber, 
        GpsProvider,
        ROW_NUMBER() OVER (PARTITION BY TrackingNumber ORDER BY Log_Timestamp DESC) AS RowNum
    FROM Shipment_Logs
) AS ls ON p.TrackingNumber = ls.TrackingNumber AND ls.RowNum = 1

WHERE p.Status = 'Delay' OR p.Status = 'Early';



---10 Billing & Revenue by Hub (Optional if you have payment table)
CREATE VIEW vw_HubRevenueMonthly AS
SELECT
    FORMAT(p.BookingDate, 'yyyy-MM') AS YearMonth,
	pd.SourceHubID AS Hub,
    COUNT(p.TrackingNumber) AS TotalShipments,
    SUM(p.ShippingFee) AS TotalShippingFees,
    SUM(r.Maintenance) AS TotalCosts,
    SUM(p.ShippingFee - r.Maintenance) AS NetProfit,
    AVG(p.ShippingFee - r.Maintenance) AS AvgProfitPerShipment

FROM Parcels p
JOIN Parcels_Details pd ON p.TrackingNumber = pd.TrackingNumber
JOIN Revenue r ON p.TrackingNumber = r.TrackingNumber
GROUP BY 
    FORMAT(p.BookingDate, 'yyyy-MM'), 
    pd.SourceHubID;
GO

SELECT 
    YearMonth, 
    Hub, 
    TotalShipments, 
    CAST(TotalShippingFees AS DECIMAL(10,2)) AS TotalShippingFees,
    CAST(TotalCosts AS DECIMAL(10,2)) AS TotalCosts,
    CAST(NetProfit AS DECIMAL(10,2)) AS NetProfit,
    CAST(AvgProfitPerShipment AS DECIMAL(10,2)) AS AvgProfitPerShipment
FROM vw_HubRevenueMonthly
ORDER BY YearMonth DESC, NetProfit DESC;

drop view vw_HubRevenueMonthly

