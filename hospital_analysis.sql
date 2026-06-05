CREATE DATABASE hospital_analysis;
USE hospital_analysis;

CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    patient_name VARCHAR(100),
    gender VARCHAR(10),
    age INT,
    city VARCHAR(50),
    admission_date DATE
);

CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY,
    doctor_name VARCHAR(100),
    specialization VARCHAR(50)
);

CREATE TABLE admissions (
    admission_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    disease VARCHAR(100),
    admission_date DATE,
    discharge_date DATE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

CREATE TABLE treatments (
    treatment_id INT PRIMARY KEY,
    admission_id INT,
    treatment_name VARCHAR(100),
    cost DECIMAL(10,2),
    FOREIGN KEY (admission_id) REFERENCES admissions(admission_id)
);

INSERT INTO patients VALUES
(1, 'Ali Khan', 'Male', 35, 'Multan', '2024-06-01'),
(2, 'Sara Ahmed', 'Female', 28, 'Lahore', '2024-06-03'),
(3, 'Usman Ali', 'Male', 50, 'Karachi', '2024-06-05');

INSERT INTO doctors VALUES
(1, 'Dr. Ahmed', 'Cardiology'),
(2, 'Dr. Sara', 'Neurology'),
(3, 'Dr. Imran', 'General');

INSERT INTO admissions VALUES
(101, 1, 1, 'Heart Attack', '2024-06-01', '2024-06-10'),
(102, 2, 2, 'Migraine', '2024-06-03', '2024-06-07'),
(103, 3, 3, 'Diabetes', '2024-06-05', '2024-06-15');

INSERT INTO treatments VALUES
(1, 101, 'Angiography', 50000),
(2, 101, 'Medication', 10000),
(3, 102, 'MRI Scan', 20000),
(4, 103, 'Insulin Therapy', 15000);

/* total hospital revenue */
SELECT 
    SUM(cost) AS total_revenue
FROM treatments;

/* most common disease */
SELECT 
    disease,
    COUNT(*) AS cases
FROM admissions
GROUP BY disease
ORDER BY cases DESC;

/* top doctors by number of patients */
SELECT 
    d.doctor_name,
    COUNT(a.patient_id) AS total_patients
FROM doctors d
JOIN admissions a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_name
ORDER BY total_patients DESC;

/* Average treatment cost per disease */
SELECT 
    a.disease,
    AVG(t.cost) AS avg_cost
FROM admissions a
JOIN treatments t ON a.admission_id = t.admission_id
GROUP BY a.disease;

/* patients with longest stay */
SELECT 
    p.patient_name,
    DATEDIFF(a.discharge_date, a.admission_date) AS stay_days
FROM patients p
JOIN admissions a ON p.patient_id = a.patient_id
ORDER BY stay_days DESC;

/* revenue by doctor */
SELECT 
    d.doctor_name,
    SUM(t.cost) AS total_revenue
FROM doctors d
JOIN admissions a ON d.doctor_id = a.doctor_id
JOIN treatments t ON a.admission_id = t.admission_id
GROUP BY d.doctor_name;

/*city wise patient count*/
SELECT 
    city,
    COUNT(*) AS total_patients
FROM patients
GROUP BY city;