# 📊 Data Generation Rules

## 1. Project Purpose

This project uses synthetic database monitoring data to simulate a
real-world SQL Server / Azure SQL operations environment.

The generated data will be used for:

- Python data analysis
- SQL analysis
- Power BI dashboards
- DAX calculations
- Performance analysis
- Reliability analysis
- Capacity planning
- Cost analysis

The data is synthetic and does not contain confidential company data.

---

# 2. Data Source Strategy

The project is based on common SQL Server and Azure SQL monitoring
concepts.

The synthetic dataset will simulate information such as:

- CPU utilization
- Memory utilization
- Query duration
- Query execution count
- Transaction volume
- Transaction failures
- Incidents
- Downtime
- Storage utilization
- Storage growth
- Infrastructure cost
- SLA targets

---

# 3. Data Model

The project will contain the following tables:

## Dimension Tables

1. dim_database
2. dim_application
3. dim_sla

## Fact Tables

4. fact_performance_metrics
5. fact_query_performance
6. fact_incidents
7. fact_transactions
8. fact_storage
9. fact_cost

A future date dimension will also be added:

10. dim_date

---

# 4. Table Grain

## dim_database

Grain:

One row represents one database.

Target rows:

15 databases

---

## dim_application

Grain:

One row represents one application.

Target rows:

10 applications

---

## fact_performance_metrics

Grain:

One row represents one database performance measurement
at a specific timestamp.

Target rows:

Approximately 50,000

Main metrics:

- CPU utilization
- Memory utilization
- Disk I/O
- Connections
- Transactions per second
- Deadlocks
- Errors

---

## fact_query_performance

Grain:

One row represents one query performance record.

Target rows:

Approximately 10,000

Main metrics:

- Query duration
- CPU time
- Execution count
- Logical reads
- Logical writes
- Rows affected

---

## fact_incidents

Grain:

One row represents one database incident.

Target rows:

Approximately 1,000

Main information:

- Incident type
- Severity
- Start time
- End time
- Downtime
- Root cause
- Resolution time

---

## fact_transactions

Grain:

One row represents one transaction record.

Target rows:

Approximately 50,000

Main information:

- Application
- Database
- Transaction type
- Transaction status
- Duration
- Error category

---

## fact_storage

Grain:

One row represents one database storage measurement
for a specific date.

Target rows:

Approximately 2,700

Main metrics:

- Allocated storage
- Used storage
- Free storage
- Storage utilization
- Growth rate

---

## fact_cost

Grain:

One row represents one database cost record
for one month.

Target rows:

Approximately 90

Main metrics:

- Compute cost
- Storage cost
- Backup cost
- Total cost
- Transaction count
- Cost per transaction

---

## dim_sla

Grain:

One row represents one SLA severity level.

Target rows:

4

Severity levels:

- Critical
- High
- Medium
- Low

---

# 5. Database Categories

The synthetic environment will contain different database types.

Example categories:

- OLTP
- Reporting
- Analytics
- Payment
- Customer
- Internal

Different database types will have different workloads.

---

# 6. Database Risk Levels

Each database will have a risk profile.

Possible values:

- Low
- Medium
- High
- Critical

Risk level will influence:

- CPU usage
- Query latency
- Transaction failures
- Incident frequency
- Storage growth
- Downtime
- Cost

---

# 7. CPU Generation Rules

CPU utilization will be generated between:

0% and 100%

Normal databases:

20% - 65%

Busy databases:

60% - 85%

High-risk databases:

75% - 95%

Critical periods:

90% - 100%

High CPU should not happen continuously.

Some periods should contain temporary spikes.

---

# 8. Memory Generation Rules

Memory utilization will be generated between:

0% and 100%.

Normal:

30% - 65%

Busy:

60% - 80%

High-risk:

75% - 95%

Critical:

90% - 100%

Memory pressure should sometimes occur together
with high CPU.

---

# 9. Query Performance Rules

Query duration will be measured in milliseconds.

Normal queries:

50 - 500 ms

Medium queries:

500 - 2,000 ms

Slow queries:

2,000 - 10,000 ms

Very slow queries:

10,000+ ms

High CPU databases should have a higher probability
of slow queries.

---

# 10. Query Execution Rules

Execution count should depend on workload.

Low workload:

1 - 50 executions

Medium workload:

50 - 500 executions

High workload:

500 - 5,000 executions

Some frequently executed queries should have
low duration but high total CPU impact.

---

# 11. Transaction Rules

Transactions can have two statuses:

- Success
- Failed

Normal databases:

Failure rate approximately 1% - 3%

Busy databases:

Failure rate approximately 3% - 7%

High-risk databases:

Failure rate approximately 5% - 12%

Critical periods:

Failure rate can exceed 10%

Failures should increase when:

- CPU is high
- Query duration is high
- Deadlocks increase
- Database incidents occur

---

# 12. Transaction Error Categories

Failed transactions can have categories such as:

- Timeout
- Deadlock
- Connection Error
- Constraint Error
- Resource Limit
- Unknown Error

Timeout should be more common during high query latency.

Deadlock errors should be associated with deadlock events.

Connection errors should be associated with availability
or connectivity problems.

---

# 13. Incident Generation Rules

Incidents should be generated based on system health.

Possible incident types:

- High CPU
- High Memory
- Slow Query
- Deadlock
- Transaction Failure
- Storage Capacity
- Connection Failure
- Database Unavailable

Incident probability should increase when
performance metrics cross unhealthy thresholds.

---

# 14. Incident Severity

Severity levels:

## Critical

Major production impact.

Examples:

- Database unavailable
- Very high transaction failure
- Severe storage capacity issue

## High

Significant performance degradation.

Examples:

- High CPU
- Large number of slow queries
- High transaction failures

## Medium

Performance issue requiring investigation.

Examples:

- Increasing latency
- Moderate CPU pressure
- Storage growth

## Low

Minor issue.

Examples:

- Temporary CPU spike
- Small number of failed transactions

---

# 15. Downtime Rules

Downtime should be measured in minutes.

Low severity:

1 - 15 minutes

Medium:

10 - 60 minutes

High:

30 - 180 minutes

Critical:

60 - 360 minutes

Critical incidents should generally have
higher downtime than low-severity incidents.

---

# 16. Storage Rules

Storage will increase over time.

Each database will have:

- Allocated storage
- Used storage
- Free storage
- Utilization percentage

Formula:

Storage Utilization =
Used Storage / Allocated Storage * 100

Example:

Allocated Storage = 500 GB

Used Storage = 400 GB

Utilization =

400 / 500 * 100

= 80%

---

# 17. Storage Risk Rules

Normal:

0% - 70%

Warning:

70% - 85%

High Risk:

85% - 95%

Critical:

95%+

Databases with high storage growth should eventually
approach capacity limits.

---

# 18. Cost Rules

Monthly cost will depend on:

- Compute usage
- Storage
- Backup
- Workload

Formula:

Total Cost =
Compute Cost + Storage Cost + Backup Cost

Cost per transaction:

Cost Per Transaction =
Total Cost / Transaction Count

High workload databases should generally have
higher compute costs.

---

# 19. Relationship Between Metrics

The synthetic data must contain realistic relationships.

The important relationship is:

High CPU
    ↓
Higher Query Duration
    ↓
Transaction Failures
    ↓
Incidents
    ↓
Downtime
    ↓
SLA Risk

Another relationship:

Storage Growth
    ↓
Higher Storage Utilization
    ↓
Capacity Risk
    ↓
Storage Incident

Another relationship:

Higher Workload
    ↓
Higher Resource Usage
    ↓
Higher Compute Cost

These relationships are important for Power BI analysis.

---

# 20. Peak Hour Rules

Some systems should have higher workload
during specific hours.

Example:

Morning:

09:00 - 11:00

Lunch:

13:00 - 14:00

Evening:

18:00 - 21:00

Peak periods should have:

- More transactions
- Higher CPU
- Higher query execution
- Higher query duration
- More failures

---

# 21. Weekend Rules

Weekend workload should generally be lower
for business applications.

However, some databases such as:

- Reporting
- Analytics
- Backup systems

may have higher weekend activity.

This will make the dataset more realistic.

---

# 22. Anomaly Rules

Some abnormal events should intentionally
be inserted into the dataset.

Examples:

- Sudden CPU spike
- Sudden transaction failure increase
- Unusual query duration
- Storage utilization spike
- Deadlock spike
- Sudden downtime

These anomalies will later be detected using Python.

---

# 23. Data Quality Rules

The generated dataset should contain realistic
data quality challenges.

Examples:

- Missing values
- Duplicate records
- Outliers
- Invalid values
- Unexpected categories

These issues will be handled later in:

Python + Pandas

---

# 24. Data Validation Rules

Before loading the data into SQL:

Check:

- Duplicate IDs
- Null values
- Invalid dates
- Invalid foreign keys
- Negative values
- CPU > 100
- Memory > 100
- Storage utilization > 100
- Negative cost
- Negative transaction duration

---

# 25. Target Dataset Size

| Table | Target Rows |
|------|-------------:|
| dim_database | 15 |
| dim_application | 10 |
| fact_performance_metrics | ~50,000 |
| fact_query_performance | ~10,000 |
| fact_incidents | ~1,000 |
| fact_transactions | ~50,000 |
| fact_storage | ~2,700 |
| fact_cost | ~90 |
| dim_sla | 4 |

---

# 26. Technology

Data generation will use:

- Python
- Pandas
- NumPy
- Faker

Data files will initially be saved as:

CSV

Later they will be loaded into:

PostgreSQL / SQL Server-compatible analytical structures

and connected to:

Power BI

---

# 27. Important Project Rule

This is a synthetic portfolio project.

No confidential company information,
production credentials, customer information,
or real company monitoring logs will be used.

All business findings must clearly state
that the dataset is simulated.