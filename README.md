# 📡 Telecom Site Rollout Performance & Bottleneck Analysis

> Built an ETL pipeline and Power BI dashboard to track and identify bottlenecks across telecom site rollout lifecycles.

---

## 📌 Project Overview

This project analyzes the full lifecycle of telecom site rollout operations from IWO Permit Request through Survey, AFI, RTA, Implementation, and TA Sign-off. The goal is to identify where the pipeline slows down and whether we need to adjust timeline commitments, add manpower to certain areas or call out underperforming subcons, measure process efficiency against benchmarks, and surface actionable insights for operations teams.

The dataset contains **4000+ site records** spanning multiple batches and areas.

---

## 🎯 Business Problem

Telecom site rollouts involve multiple sequential processes across different teams and subcontractors. Delays in any stage cascade into project overruns. Key questions this project answers:

- Which process stage is the biggest bottleneck across all sites?
- How many sites are breaching benchmark duration thresholds?
- Which areas or subcontractors are underperforming?
- Are our benchmark timelines realistic, or are we overcommitting to deadlines we consistently can't meet?

---

## 🗂️ Project Structure

```
telecom-site-rollout-performance/
│
├── data/
│   └── sample_data.xlsx          # Anonymized sample of the cleaned dataset
│
├── power_query/
│   └── etl_pipeline.m            # M code from Power Query Advanced Editor
│
├── screenshots/
│   └── dashboard_overview.png    # Screenshot of your Power BI dashboard
│
└── README.md
```

---

## 🔧 Tools & Technologies

| Tool | Purpose |
|------|---------|
| **Power BI** | Dashboard and data visualization |
| **Power Query (M)** | ETL pipeline — data extraction, cleaning, and transformation |
| **Excel** | Source data format (weekly tracker uploads) |
| **DAX** | Calculated measures and KPIs |

---

## ⚙️ ETL Pipeline
The pipeline was designed to handle updated tracker uploads where:
- Reads the latest .xlsx file on the folder and automatically based on yyyy-mm-dd date format in the filename
- New rows are appended for newly added projects
- Previously blank fields get filled in from subsequent uploads without duplicating existing records
- Proper sheet referencing ensures only the correct tab is pulled, avoiding repetitive manual edits

### Key Transformation Steps
1. **Extract** - Automatically detects and loads only the latest .xlsx tracker from the folder based on the yyyy-mm-dd date in the filename ensuring the data is always fresh without manual file selection
2. **Transform** 
    - **Clean** - Standardize date formats, Standardize text casing and trim whitespace for consistent categorical values, handle nulls and Create unique keys and reference columns to support data model relationships in Power BI
    - **Compute** - Calculate phase durations (days between each milestone date)
    - **Flag** - Mark site tiers, sites that breach benchmark thresholds per process stage, flag invalid/inactive records
6. **Load** - Feed clean and structured table into Power BI data model

---

## 📊 Dashboard Features
A single-page interactive dashboard built in Power BI covering the full SLZ Region rollout performance.

- **Executive KPIs** - snapshot of overall project health including total projects, completion count and rate, ongoing sites, average project   duration, average monthly completion, and overall benchmark breach rate
- **Process Bottleneck Analysis** - combo and grouped bar charts comparing actual average durations against benchmarks per process stage, broken down by site tier (Feeder, Tailing, Main FOC) each tier has its own benchmark thresholds making the comparison tier aware
- **Benchmark Breach Rate** - horizontal bar chart ranking which process stages have the highest failure rate against their targets, color coded by severity
- **Completion Trend** - area chart tracking monthly completions from 2018 to 2022, revealing delivery peaks, slowdowns, and overall project pipeline health over time
- **Subcon & Manpower Overview** - project count by subcontractor and a headcount summary across design, implementation, admin, and RTA/ROW roles useful for correlating resource allocation with delivery performance
- **Dynamic Filtering** - year slicer and area checkbox slicer cross-filter all visuals simultaneously, enabling on-the-fly performance isolation by area or subcon without separate pages

---

## 📈 Key Findings
1. Which process stage is the biggest bottleneck?
- Implementation is the longest stage by average duration at 180.7 days, followed by RTA Securing at 130.8 days and Survey Duration at 110 days. However, when measured by breach rate, Survey Duration (72.1%), RTA Securing (71.1%), and RTA Submission (69.8%) are the most consistently failing stages meaning Implementation takes long partly by design, but RTA and Survey are where the pipeline breaks down most frequently relative to their benchmarks.
  
2. How many sites are breaching benchmark thresholds?
- The overall benchmark breach rate sits at 52.35% meaning more than half of all process stages across all sites are exceeding their target durations. Only TA Prep performs well with a 14.5% breach rate. Every other stage breaches at rates between 42% and 72%.
  
3. Which areas or subcontractors are underperforming?
- By average process duration, Marinduque (69.6 days) and Romblon (69.1 days) are the slowest areas. However, high-volume areas like Batangas (60.2 days across 246 projects) and Laguna (55.6 days across 281 projects) are more operationally significant given their scale. Inhouse teams carry the largest project load at 1,838 projects, making their performance critical to overall delivery.
  
4. Are benchmarks realistic or are we overcommitting?
- With 7 out of 10 process stages breaching at rates above 40%, the data suggests the current benchmark timelines may be too aggressive particularly for Survey Duration and RTA Securing, which breach at over 70%. This points to a need to either revisit benchmark commitments or investigate systemic causes such as resource constraints and permitting delays.

---

## 🧹 Data Quality Notes

- Date inconsistencies (negative durations, out-of-sequence dates) were identified and corrected during the cleaning phase
- Sample data provided in this repo is **anonymized** real site names, coordinates, and company references have been replaced with dummy values to protect confidentiality

---

## 💡 What I Learned

### Pipeline & Automation
Building an automated pipeline that refreshes the dashboard whenever a new tracker is saved to the folder taught me how small design decisions like enforcing a yyyy-mm-dd naming convention on uploaded files can make or break automation. Improper file naming that seems minor upfront becomes a real blocker when Power Query relies on it to detect the latest file.

### Data Modeling
Referencing sheets instead of duplicating them was a key architectural decision that kept the data model clean and maintainable any update to a source table propagates automatically without touching multiple copies. I also learned to think carefully about data types and null handling early, as inconsistent formats and unexpected nulls caused downstream calculation errors that were harder to trace the later they were caught.

### Power Query & M Code
Writing transformations directly in the Advanced Editor gave me a deeper understanding of how Power Query works under the hood rather than just relying on the UI steps. This made it easier to write reusable, readable logic and debug issues when the applied steps weren't behaving as expected.

### Power BI & DAX
Creating DAX measures for KPIs and using conditional formatting rules to drive color changes by performance thresholds showed me how much of a dashboard's storytelling happens at the measure level not just the visual level.

### Data Standards
Working through real inconsistencies in the source data reinforced why a standardized data framework matters from the start. Decisions made upstream by whoever fills in the tracker directly affect the reliability of every insight the dashboard produces.

