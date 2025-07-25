-- Clean up if re-running
DROP TRIGGER IF EXISTS trg_update_evidence_timestamp;
DROP VIEW IF EXISTS OfficerWorkload;
DROP TABLE IF EXISTS Evidence;
DROP TABLE IF EXISTS Suspects;
DROP TABLE IF EXISTS Officers;
DROP TABLE IF EXISTS Cases;

-- Step 1: Create main tables

CREATE TABLE Cases (
    CaseID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Status ENUM('Solved', 'Unsolved') NOT NULL,
    OpenDate DATE NOT NULL,
    CloseDate DATE
);
-- Option 1 (Recommended): Rename column
CREATE TABLE Officers (
    OfficerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    OfficerRank VARCHAR(50),   -- Fixed name
    Department VARCHAR(50)
);




CREATE TABLE Suspects (
    SuspectID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Age INT,
    Gender ENUM('Male', 'Female', 'Other'),
    CaseID INT,
    FOREIGN KEY (CaseID) REFERENCES Cases(CaseID)
);

CREATE TABLE Evidence (
    EvidenceID INT AUTO_INCREMENT PRIMARY KEY,
    Description TEXT NOT NULL,
    CaseID INT,
    CollectedBy INT,
    CollectedDate DATE,
    LastUpdated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (CaseID) REFERENCES Cases(CaseID),
    FOREIGN KEY (CollectedBy) REFERENCES Officers(OfficerID)
);


-- Step 2: Indexes
CREATE INDEX idx_case_status ON Cases(Status);
CREATE INDEX idx_suspect_name ON Suspects(Name);

-- Step 3: Sample Data

-- Officers
-- Using OfficerRank (if renamed)
INSERT INTO Officers (Name, OfficerRank, Department) VALUES
('Ravi Singh', 'Inspector', 'Homicide'),
('Meena Reddy', 'Sub-Inspector', 'Cyber Crime'),
('Akash Kumar', 'Inspector', 'Narcotics');

-- Cases
INSERT INTO Cases (Title, Status, OpenDate, CloseDate) VALUES
('ATM Robbery', 'Solved', '2023-01-05', '2023-01-15'),
('Drug Racket', 'Unsolved', '2023-02-10', NULL),
('Online Fraud', 'Solved', '2023-03-01', '2023-03-25');

-- Suspects
INSERT INTO Suspects (Name, Age, Gender, CaseID) VALUES
('Rahul Das', 32, 'Male', 1),
('Sneha Kapoor', 27, 'Female', 2),
('Vijay Patil', 45, 'Male', 3);

-- Evidence
INSERT INTO Evidence (Description, CaseID, CollectedBy, CollectedDate) VALUES
('CCTV footage', 1, 1, '2023-01-06'),
('Seized drugs', 2, 3, '2023-02-11'),
('Fake ID', 3, 2, '2023-03-02');

-- Step 4: Query - Count Solved/Unsolved Cases
SELECT Status, COUNT(*) AS Total
FROM Cases
GROUP BY Status;

-- Step 5: View - Officer Workload
CREATE VIEW OfficerWorkload AS
SELECT O.OfficerID, O.Name AS OfficerName, COUNT(E.EvidenceID) AS TotalEvidence
FROM Officers O
LEFT JOIN Evidence E ON O.OfficerID = E.CollectedBy
GROUP BY O.OfficerID;

-- View it
SELECT * FROM OfficerWorkload;

-- Step 6: Trigger - Auto update evidence timestamp (Already handled using ON UPDATE CURRENT_TIMESTAMP)

-- Optional custom function-like trigger (if needed separately)
DELIMITER //
CREATE TRIGGER trg_update_evidence_timestamp
BEFORE UPDATE ON Evidence
FOR EACH ROW
BEGIN
   SET NEW.LastUpdated = CURRENT_TIMESTAMP;
END;
//
DELIMITER ;

-- Step 7: Summary Query - Case summary
SELECT 
    C.CaseID,
    C.Title,
    COUNT(DISTINCT S.SuspectID) AS TotalSuspects,
    COUNT(DISTINCT E.EvidenceID) AS TotalEvidence
FROM Cases C
LEFT JOIN Suspects S ON C.CaseID = S.CaseID
LEFT JOIN Evidence E ON C.CaseID = E.CaseID
GROUP BY C.CaseID, C.Title;