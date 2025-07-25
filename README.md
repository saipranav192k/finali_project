# 🕵️ Criminal Case Management System

This project is a **Criminal Case Management System** designed using SQL to manage police records including cases, officers, suspects, and evidence. It also includes sample data, queries, views, and triggers for realistic use.

---

## 📁 Project Structure

| File           | Description                                                             |
| -------------- | ----------------------------------------------------------------------- |
| `Cases.csv`    | Contains all criminal cases with details like status, open/close dates. |
| `Officers.csv` | Information about officers including rank and department.               |
| `Suspects.csv` | Data of suspects linked to cases.                                       |
| `Evidence.csv` | Evidence collected for each case with timestamps.                       |

---

## 📌 Features

* Tracks solved and unsolved cases.
* Links suspects and evidence to specific cases.
* Maps officers to the evidence they collect.
* Automatically updates timestamps on evidence updates.
* Calculates officer workload via SQL view.

---

## 🧠 SQL Highlights

* ✅ `JOIN`, `GROUP BY`, `COUNT`, `ENUM`, `AUTO_INCREMENT`
* ✅ `FOREIGN KEY` constraints
* ✅ `ON UPDATE CURRENT_TIMESTAMP` logic
* ✅ View: `OfficerWorkload`
* ✅ Trigger: `trg_update_evidence_timestamp`

---

## 🗃️ How to Use

1. Import the `.csv` files into your MySQL/MariaDB environment.
2. Run the SQL script to recreate the database structure and insert sample data.
3. Use the provided SQL queries to explore the system.

---

## 🔧 Future Improvements

* Add user authentication for police officers.
* Create web interface using PHP or Python.
* Add case status timeline tracking.
* Implement role-based access control.




