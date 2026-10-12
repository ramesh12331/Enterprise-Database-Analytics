# ============================================================
# ENTERPRISE DATABASE ANALYTICS PROJECT
# File: 01_generate_data.py
# Purpose: Generate synthetic database monitoring data
# ============================================================

import os
import numpy as np
import pandas as pd
from faker import Faker


# ============================================================
# 1. CREATE FAKER OBJECT
# ============================================================

fake = Faker()

# Set seed so that the same random data can be reproduced
np.random.seed(42)
Faker.seed(42)


# ============================================================
# 2. CREATE DATA DIRECTORY
# ============================================================

# Get the project folder
BASE_DIR = os.path.dirname(
    os.path.dirname(
        os.path.abspath(__file__)
    )
)

# Create the data folder path
DATA_DIR = os.path.join(
    BASE_DIR,
    "data"
)

# Create data folder if it does not exist
os.makedirs(DATA_DIR, exist_ok=True)


# ============================================================
# 3. DATABASE MASTER DATA
# ============================================================

# Number of databases we want to create
database_count = 15

# Possible database types
database_types = [
    "OLTP",
    "Reporting",
    "Analytics",
    "Payment",
    "Customer",
    "Internal"
]

# Possible risk levels
risk_levels = [
    "Low",
    "Medium",
    "High",
    "Critical"
]

# Possible environments
environments = [
    "Production",
    "Development",
    "Testing"
]

# Possible regions
regions = [
    "East US",
    "West US",
    "Central US",
    "North Europe",
    "South India"
]


# ============================================================
# 4. CREATE EMPTY LIST
# ============================================================

database_rows = []


# ============================================================
# 5. GENERATE 15 DATABASE RECORDS
# ============================================================

for database_id in range(1, database_count + 1):

    # Create database name
    database_name = f"DB-{database_id:03d}"

    # Random database type
    database_type = np.random.choice(database_types)

    # Random risk level
    risk_level = np.random.choice(
        risk_levels,
        p=[0.30, 0.35, 0.25, 0.10]
    )

    # Random environment
    environment = np.random.choice(
        environments,
        p=[0.70, 0.20, 0.10]
    )

    # Random region
    region = np.random.choice(regions)

    # Add one database record
    database_rows.append({
        "database_id": database_id,
        "database_name": database_name,
        "database_type": database_type,
        "risk_level": risk_level,
        "environment": environment,
        "region": region
    })


# ============================================================
# 6. CREATE PANDAS DATAFRAME
# ============================================================

dim_database = pd.DataFrame(database_rows)


# ============================================================
# 7. DISPLAY DATA
# ============================================================

print("\n========================================")
print("       DIM_DATABASE")
print("========================================")

print(dim_database)


# ============================================================
# 8. DISPLAY NUMBER OF ROWS AND COLUMNS
# ============================================================

print("\nShape:")
print(dim_database.shape)


# ============================================================
# 9. CREATE CSV FILE PATH
# ============================================================

database_file = os.path.join(
    DATA_DIR,
    "dim_database.csv"
)


# ============================================================
# 10. SAVE DATAFRAME AS CSV
# ============================================================

dim_database.to_csv(
    database_file,
    index=False
)


# ============================================================
# 11. SUCCESS MESSAGE
# ============================================================

print("\n========================================")
print("          SUCCESS")
print("========================================")

print("✅ Database CSV created successfully!")

print(f"📁 Location:")
print(database_file)


# ===================================
# ============================================================
# 12. APPLICATION MASTER DATA
# ============================================================

# Number of applications
application_count = 10


# ============================================================
# 13. APPLICATION INFORMATION
# ============================================================

application_names = [
    "E-Commerce App",
    "Payment API",
    "Customer Portal",
    "Order Management",
    "Inventory System",
    "Reporting Service",
    "Analytics Platform",
    "Employee Portal",
    "Notification Service",
    "Mobile Application"
]


application_types = [
    "Web Application",
    "API",
    "Internal Application",
    "Reporting",
    "Analytics",
    "Mobile"
]


business_units = [
    "Sales",
    "Finance",
    "Customer Service",
    "Operations",
    "IT",
    "Analytics"
]


# ============================================================
# 14. CREATE EMPTY LIST
# ============================================================

application_rows = []


# ============================================================
# 15. GENERATE APPLICATION RECORDS
# ============================================================

for application_id in range(1, application_count + 1):

    # Get application name
    application_name = application_names[
        application_id - 1
    ]

    # Random application type
    application_type = np.random.choice(
        application_types
    )

    # Random business unit
    business_unit = np.random.choice(
        business_units
    )

    # Random criticality
    criticality = np.random.choice(
        ["Low", "Medium", "High", "Critical"],
        p=[0.20, 0.35, 0.30, 0.15]
    )

    # Add application record
    application_rows.append({
        "application_id": application_id,
        "application_name": application_name,
        "application_type": application_type,
        "business_unit": business_unit,
        "criticality": criticality
    })


# ============================================================
# 16. CREATE DATAFRAME
# ============================================================

dim_application = pd.DataFrame(
    application_rows
)


# ============================================================
# 17. DISPLAY APPLICATION DATA
# ============================================================

print("\n========================================")
print("       DIM_APPLICATION")
print("========================================")

print(dim_application)

print("\nShape:")
print(dim_application.shape)


# ============================================================
# 18. SAVE APPLICATION CSV
# ============================================================

application_file = os.path.join(
    DATA_DIR,
    "dim_application.csv"
)

dim_application.to_csv(
    application_file,
    index=False
)


# ============================================================
# 19. SUCCESS MESSAGE
# ============================================================

print("\n========================================")
print("          SUCCESS")
print("========================================")

print("✅ Application CSV created successfully!")

print("📁 Location:")
print(application_file)

# ================================
# ============================================================
# 20. SLA MASTER DATA
# ============================================================

# SLA severity levels
sla_levels = [
    "Low",
    "Medium",
    "High",
    "Critical"
]


# ============================================================
# 21. SLA TARGET VALUES
# ============================================================

# These are simulated project targets.
# They are NOT official Microsoft SLA values.

sla_rules = {
    "Low": {
        "response_target_minutes": 240,
        "resolution_target_minutes": 1440,
        "availability_target_percent": 99.00
    },

    "Medium": {
        "response_target_minutes": 120,
        "resolution_target_minutes": 720,
        "availability_target_percent": 99.50
    },

    "High": {
        "response_target_minutes": 60,
        "resolution_target_minutes": 240,
        "availability_target_percent": 99.90
    },

    "Critical": {
        "response_target_minutes": 15,
        "resolution_target_minutes": 120,
        "availability_target_percent": 99.99
    }
}


# ============================================================
# 22. CREATE EMPTY LIST
# ============================================================

sla_rows = []


# ============================================================
# 23. GENERATE SLA RECORDS
# ============================================================

for sla_id, severity in enumerate(
    sla_levels,
    start=1
):

    # Get SLA rules for current severity
    rules = sla_rules[severity]

    # Create one SLA record
    sla_rows.append({
        "sla_id": sla_id,
        "severity": severity,
        "response_target_minutes": rules[
            "response_target_minutes"
        ],
        "resolution_target_minutes": rules[
            "resolution_target_minutes"
        ],
        "availability_target_percent": rules[
            "availability_target_percent"
        ]
    })


# ============================================================
# 24. CREATE DATAFRAME
# ============================================================

dim_sla = pd.DataFrame(sla_rows)


# ============================================================
# 25. DISPLAY SLA DATA
# ============================================================

print("\n========================================")
print("             DIM_SLA")
print("========================================")

print(dim_sla)

print("\nShape:")
print(dim_sla.shape)


# ============================================================
# 26. SAVE SLA CSV
# ============================================================

sla_file = os.path.join(
    DATA_DIR,
    "dim_sla.csv"
)

dim_sla.to_csv(
    sla_file,
    index=False
)


# ============================================================
# 27. SUCCESS MESSAGE
# ============================================================

print("\n========================================")
print("              SUCCESS")
print("========================================")

print("✅ SLA CSV created successfully!")

print("📁 Location:")
print(sla_file)

# ========================================
# ============================================================
# 28. PERFORMANCE METRICS DATA
# ============================================================

# Number of performance records
performance_rows_count = 50000


# ============================================================
# 29. CREATE DATE/TIME RANGE
# ============================================================

# Generate timestamps every 5 minutes.
# Approximately 50,000 records will be created.

timestamps = pd.date_range(
    start="2026-01-01",
    periods=performance_rows_count,
    freq="5min"
)


# ============================================================
# 30. CREATE DATABASE IDs
# ============================================================

# Randomly assign each performance record
# to one of our 15 databases.

performance_database_ids = np.random.choice(
    dim_database["database_id"],
    size=performance_rows_count
)


# ============================================================
# 31. CREATE BASE DATAFRAME
# ============================================================

fact_performance_metrics = pd.DataFrame({
    "metric_id": range(
        1,
        performance_rows_count + 1
    ),

    "database_id": performance_database_ids,

    "timestamp": timestamps
})


# ============================================================
# 32. ADD HOUR INFORMATION
# ============================================================

fact_performance_metrics["hour"] = (
    fact_performance_metrics["timestamp"]
    .dt.hour
)


# ============================================================
# 33. PEAK HOUR FLAG
# ============================================================

# Peak business hours:
# 09:00 - 11:00
# 13:00 - 14:00
# 18:00 - 21:00

fact_performance_metrics["is_peak_hour"] = (
    fact_performance_metrics["hour"].isin([
        9, 10,
        13,
        18, 19, 20
    ])
)


# ============================================================
# 34. GENERATE BASE CPU
# ============================================================

# Start with normal CPU usage.

base_cpu = np.random.normal(
    loc=50,
    scale=15,
    size=performance_rows_count
)


# Add additional CPU during peak hours.

base_cpu += np.where(
    fact_performance_metrics["is_peak_hour"],
    15,
    0
)


# Keep CPU between 5% and 100%.

cpu_percent = np.clip(
    base_cpu,
    5,
    100
)


# ============================================================
# 35. GENERATE MEMORY UTILIZATION
# ============================================================

# Memory is somewhat related to CPU.

memory_percent = (
    cpu_percent * 0.65
    + np.random.normal(
        loc=25,
        scale=8,
        size=performance_rows_count
    )
)


# Keep memory between 10% and 100%.

memory_percent = np.clip(
    memory_percent,
    10,
    100
)


# ============================================================
# 36. GENERATE DISK I/O
# ============================================================

disk_io_percent = (
    cpu_percent * 0.55
    + np.random.normal(
        loc=15,
        scale=10,
        size=performance_rows_count
    )
)


disk_io_percent = np.clip(
    disk_io_percent,
    5,
    100
)


# ============================================================
# 37. GENERATE CONNECTIONS
# ============================================================

base_connections = np.random.normal(
    loc=120,
    scale=35,
    size=performance_rows_count
)


# More connections during peak hours.

base_connections += np.where(
    fact_performance_metrics["is_peak_hour"],
    80,
    0
)


connections = np.clip(
    base_connections,
    10,
    500
).astype(int)


# ============================================================
# 38. GENERATE TRANSACTIONS PER SECOND
# ============================================================

base_transactions = np.random.normal(
    loc=500,
    scale=150,
    size=performance_rows_count
)


# Higher workload during peak hours.

base_transactions += np.where(
    fact_performance_metrics["is_peak_hour"],
    300,
    0
)


transactions_per_second = np.clip(
    base_transactions,
    20,
    2000
).round(2)


# ============================================================
# 39. GENERATE DEADLOCKS
# ============================================================

# Deadlocks become more likely when CPU and workload
# increase.

deadlock_probability = (
    cpu_percent / 10000
)

deadlocks = np.random.binomial(
    n=3,
    p=np.clip(
        deadlock_probability,
        0.001,
        0.30
    )
)


# ============================================================
# 40. GENERATE ERRORS
# ============================================================

# Errors increase with CPU pressure.

error_rate = (
    0.5
    + (cpu_percent / 20)
)

errors = np.random.poisson(
    lam=error_rate
)


# ============================================================
# 41. ADD PERFORMANCE COLUMNS
# ============================================================

fact_performance_metrics["cpu_percent"] = (
    cpu_percent.round(2)
)

fact_performance_metrics["memory_percent"] = (
    memory_percent.round(2)
)

fact_performance_metrics["disk_io_percent"] = (
    disk_io_percent.round(2)
)

fact_performance_metrics["connections"] = (
    connections
)

fact_performance_metrics["transactions_per_second"] = (
    transactions_per_second
)

fact_performance_metrics["deadlocks"] = (
    deadlocks
)

fact_performance_metrics["errors"] = (
    errors
)


# ============================================================
# 42. REMOVE TEMPORARY COLUMN
# ============================================================

fact_performance_metrics.drop(
    columns=["hour"],
    inplace=True
)


# ============================================================
# 43. DISPLAY PERFORMANCE DATA
# ============================================================

print("\n========================================")
print("   FACT_PERFORMANCE_METRICS")
print("========================================")

print(
    fact_performance_metrics.head(10)
)

print("\nShape:")
print(
    fact_performance_metrics.shape
)


# ============================================================
# 44. DISPLAY SUMMARY
# ============================================================

print("\nCPU Summary:")

print(
    fact_performance_metrics[
        "cpu_percent"
    ].describe()
)


print("\nMemory Summary:")

print(
    fact_performance_metrics[
        "memory_percent"
    ].describe()
)


# ============================================================
# 45. SAVE PERFORMANCE CSV
# ============================================================

performance_file = os.path.join(
    DATA_DIR,
    "fact_performance_metrics.csv"
)


fact_performance_metrics.to_csv(
    performance_file,
    index=False
)


# ============================================================
# 46. SUCCESS MESSAGE
# ============================================================

print("\n========================================")
print("              SUCCESS")
print("========================================")

print(
    "✅ Performance metrics CSV created successfully!"
)

print("📁 Location:")

print(performance_file)

# =====================================


# ============================================================
# 47. QUERY PERFORMANCE DATA
# ============================================================

# Number of query performance records
query_rows_count = 10000


# ============================================================
# 48. CREATE QUERY TIMESTAMPS
# ============================================================

query_timestamps = pd.to_datetime(
    np.random.choice(
        fact_performance_metrics["timestamp"],
        size=query_rows_count
    )
)


# ============================================================
# 49. ASSIGN DATABASE IDs
# ============================================================

query_database_ids = np.random.choice(
    dim_database["database_id"],
    size=query_rows_count
)


# ============================================================
# 50. CREATE BASE QUERY DATAFRAME
# ============================================================

fact_query_performance = pd.DataFrame({

    "query_id": range(
        1,
        query_rows_count + 1
    ),

    "database_id": query_database_ids,

    "timestamp": query_timestamps
})


# ============================================================
# 51. GENERATE QUERY TYPES
# ============================================================

query_types = [
    "SELECT",
    "INSERT",
    "UPDATE",
    "DELETE"
]

fact_query_performance["query_type"] = np.random.choice(
    query_types,
    size=query_rows_count,
    p=[0.65, 0.15, 0.12, 0.08]
)


# ============================================================
# 52. GENERATE QUERY CATEGORIES
# ============================================================

query_categories = [
    "Customer",
    "Order",
    "Payment",
    "Inventory",
    "Reporting",
    "Analytics",
    "Authentication"
]

fact_query_performance["query_category"] = np.random.choice(
    query_categories,
    size=query_rows_count
)


# ============================================================
# 53. GET CPU FOR QUERY TIMESTAMP
# ============================================================

# Match query records with performance metrics
# using database_id and timestamp.

performance_lookup = (
    fact_performance_metrics[
        [
            "database_id",
            "timestamp",
            "cpu_percent"
        ]
    ]
    .drop_duplicates(
        subset=["database_id", "timestamp"]
    )
)


fact_query_performance = fact_query_performance.merge(
    performance_lookup,
    on=["database_id", "timestamp"],
    how="left"
)


# ============================================================
# 54. HANDLE MISSING CPU VALUES
# ============================================================

# Some query timestamps may not exactly match
# a performance timestamp.
#
# Therefore, some CPU values may be missing.
#
# IMPORTANT:
# We do NOT use:
#
# .fillna(np.random.normal(...))
#
# because np.random.normal() returns a NumPy array.
#
# Instead, we:
# 1. Find missing CPU values.
# 2. Count them.
# 3. Generate exactly that many random values.
# 4. Assign them to the missing rows.


# Find missing CPU values

missing_cpu_mask = (
    fact_query_performance["cpu_percent"].isna()
)


# Count missing CPU values

missing_cpu_count = (
    missing_cpu_mask.sum()
)


# Generate random CPU values only when
# missing values exist.

if missing_cpu_count > 0:

    random_cpu_values = np.random.normal(
        50,
        15,
        missing_cpu_count
    )

    # Assign random CPU values
    # only to missing rows.

    fact_query_performance.loc[
        missing_cpu_mask,
        "cpu_percent"
    ] = random_cpu_values


# Keep CPU values between 5% and 100%

fact_query_performance["cpu_percent"] = np.clip(
    fact_query_performance["cpu_percent"],
    5,
    100
)


# ============================================================
# 55. GENERATE EXECUTION COUNT
# ============================================================

execution_count = np.random.lognormal(
    mean=4,
    sigma=1,
    size=query_rows_count
)


execution_count = np.clip(
    execution_count,
    1,
    5000
).astype(int)


fact_query_performance["execution_count"] = (
    execution_count
)


# ============================================================
# 56. GENERATE QUERY DURATION
# ============================================================

# Base query duration

base_duration = np.random.lognormal(
    mean=5.2,
    sigma=0.8,
    size=query_rows_count
)


# High CPU increases query duration

cpu_effect = (
    fact_query_performance["cpu_percent"]
    * 8
)


avg_duration = (
    base_duration
    + cpu_effect
)


# Keep values realistic

avg_duration = np.clip(
    avg_duration,
    20,
    15000
)


fact_query_performance["avg_duration_ms"] = (
    avg_duration.round(2)
)


# ============================================================
# 57. GENERATE CPU TIME
# ============================================================

cpu_time = (
    fact_query_performance["avg_duration_ms"]
    * np.random.uniform(
        0.30,
        0.85,
        query_rows_count
    )
)


fact_query_performance["cpu_time_ms"] = (
    cpu_time.round(2)
)


# ============================================================
# 58. GENERATE LOGICAL READS
# ============================================================

logical_reads = (
    fact_query_performance["avg_duration_ms"]
    * np.random.uniform(
        2,
        15,
        query_rows_count
    )
)


fact_query_performance["logical_reads"] = (
    logical_reads.round(0).astype(int)
)


# ============================================================
# 59. GENERATE LOGICAL WRITES
# ============================================================

logical_writes = (
    fact_query_performance["avg_duration_ms"]
    * np.random.uniform(
        0.1,
        2,
        query_rows_count
    )
)


fact_query_performance["logical_writes"] = (
    logical_writes.round(0).astype(int)
)


# ============================================================
# 60. GENERATE ROWS AFFECTED
# ============================================================

rows_affected = np.random.lognormal(
    mean=3,
    sigma=1.2,
    size=query_rows_count
)


rows_affected = np.clip(
    rows_affected,
    1,
    100000
)


fact_query_performance["rows_affected"] = (
    rows_affected.round(0).astype(int)
)


# ============================================================
# 61. GENERATE WAIT TIME
# ============================================================

wait_time = (
    fact_query_performance["avg_duration_ms"]
    - fact_query_performance["cpu_time_ms"]
)


wait_time = np.maximum(
    wait_time,
    0
)


fact_query_performance["wait_time_ms"] = (
    wait_time.round(2)
)


# ============================================================
# 62. CLASSIFY QUERY PERFORMANCE
# ============================================================

fact_query_performance["performance_status"] = np.select(

    [
        fact_query_performance["avg_duration_ms"] < 500,

        fact_query_performance["avg_duration_ms"] < 2000,

        fact_query_performance["avg_duration_ms"] < 10000
    ],

    [
        "Normal",
        "Slow",
        "Very Slow"
    ],

    default="Critical"
)


# ============================================================
# 63. REMOVE TEMPORARY CPU COLUMN
# ============================================================

fact_query_performance.drop(
    columns=["cpu_percent"],
    inplace=True
)


# ============================================================
# 64. SORT DATA
# ============================================================

fact_query_performance.sort_values(
    by="timestamp",
    inplace=True
)


# ============================================================
# 65. RESET INDEX
# ============================================================

fact_query_performance.reset_index(
    drop=True,
    inplace=True
)


# ============================================================
# 66. DISPLAY QUERY DATA
# ============================================================

print("\n========================================")
print("      FACT_QUERY_PERFORMANCE")
print("========================================")

print(
    fact_query_performance.head(10)
)


print("\nShape:")

print(
    fact_query_performance.shape
)


# ============================================================
# 67. PERFORMANCE STATUS SUMMARY
# ============================================================

print("\nPerformance Status:")

print(
    fact_query_performance[
        "performance_status"
    ].value_counts()
)


# ============================================================
# 68. QUERY DURATION SUMMARY
# ============================================================

print("\nQuery Duration Summary:")

print(
    fact_query_performance[
        "avg_duration_ms"
    ].describe()
)


# ============================================================
# 69. SAVE QUERY PERFORMANCE CSV
# ============================================================

query_file = os.path.join(
    DATA_DIR,
    "fact_query_performance.csv"
)


fact_query_performance.to_csv(
    query_file,
    index=False
)


# ============================================================
# 70. SUCCESS MESSAGE
# ============================================================

print("\n========================================")
print("              SUCCESS")
print("========================================")

print(
    "✅ Query performance CSV created successfully!"
)

print("📁 Location:")

print(query_file)

# =================================
# ============================================================
# 71. TRANSACTION DATA
# ============================================================

# Number of transaction records

transaction_rows_count = 50000


# ============================================================
# 72. CREATE TRANSACTION TIMESTAMPS
# ============================================================

# Use timestamps from performance metrics.
#
# This helps us create relationships between:
#
# Performance
#      ↓
# Transactions
#
# For example:
# High CPU → More transaction failures


transaction_sample_indices = np.random.choice(
    len(fact_performance_metrics),
    size=transaction_rows_count
)


transaction_performance = (
    fact_performance_metrics.iloc[
        transaction_sample_indices
    ]
    .reset_index(drop=True)
)


# ============================================================
# 73. ASSIGN DATABASE IDs
# ============================================================

transaction_database_ids = (
    transaction_performance[
        "database_id"
    ]
    .to_numpy()
)


# ============================================================
# 74. ASSIGN APPLICATION IDs
# ============================================================

transaction_application_ids = np.random.choice(
    dim_application["application_id"],
    size=transaction_rows_count
)


# ============================================================
# 75. GET TRANSACTION TIMESTAMPS
# ============================================================

transaction_timestamps = (
    transaction_performance[
        "timestamp"
    ]
    .to_numpy()
)


# ============================================================
# 76. GET PERFORMANCE INFORMATION
# ============================================================

# CPU

transaction_cpu = (
    transaction_performance[
        "cpu_percent"
    ]
    .to_numpy()
)


# Deadlocks

transaction_deadlocks = (
    transaction_performance[
        "deadlocks"
    ]
    .to_numpy()
)


# Peak hour

transaction_peak = (
    transaction_performance[
        "is_peak_hour"
    ]
    .to_numpy()
)


# ============================================================
# 77. CREATE BASE TRANSACTION DATAFRAME
# ============================================================

fact_transactions = pd.DataFrame({

    "transaction_id": range(
        1,
        transaction_rows_count + 1
    ),

    "database_id": transaction_database_ids,

    "application_id": transaction_application_ids,

    "timestamp": transaction_timestamps
})


# ============================================================
# 78. GENERATE TRANSACTION TYPES
# ============================================================

transaction_types = [
    "SELECT",
    "INSERT",
    "UPDATE",
    "DELETE",
    "PAYMENT",
    "ORDER",
    "LOGIN"
]


fact_transactions["transaction_type"] = np.random.choice(

    transaction_types,

    size=transaction_rows_count,

    p=[
        0.25,   # SELECT
        0.15,   # INSERT
        0.12,   # UPDATE
        0.08,   # DELETE
        0.12,   # PAYMENT
        0.18,   # ORDER
        0.10    # LOGIN
    ]
)


# ============================================================
# 79. CALCULATE FAILURE PROBABILITY
# ============================================================

# Base failure probability

failure_probability = np.full(
    transaction_rows_count,
    0.01
)


# ------------------------------------------------------------
# High CPU increases failure probability
# ------------------------------------------------------------

failure_probability += (
    np.maximum(
        transaction_cpu - 70,
        0
    )
    * 0.002
)


# ------------------------------------------------------------
# Deadlocks increase failure probability
# ------------------------------------------------------------

failure_probability += (
    (transaction_deadlocks > 0)
    .astype(float)
    * 0.03
)


# ------------------------------------------------------------
# Peak hours slightly increase failure probability
# ------------------------------------------------------------

failure_probability += (
    transaction_peak.astype(float)
    * 0.005
)


# ------------------------------------------------------------
# Keep probability within 1% - 20%
# ------------------------------------------------------------

failure_probability = np.clip(
    failure_probability,
    0.01,
    0.20
)


# ============================================================
# 80. GENERATE TRANSACTION STATUS
# ============================================================

random_values = np.random.random(
    transaction_rows_count
)


transaction_failed = (
    random_values < failure_probability
)


fact_transactions["status"] = np.where(
    transaction_failed,
    "Failed",
    "Success"
)


# ============================================================
# 81. GENERATE TRANSACTION DURATION
# ============================================================

# Base transaction duration

transaction_duration = np.random.lognormal(
    mean=4.5,
    sigma=0.7,
    size=transaction_rows_count
)


# ------------------------------------------------------------
# CPU effect
# ------------------------------------------------------------

transaction_duration += (
    transaction_cpu * 5
)


# ------------------------------------------------------------
# Deadlock effect
# ------------------------------------------------------------

transaction_duration += (
    transaction_deadlocks * 100
)


# ------------------------------------------------------------
# Peak hour effect
# ------------------------------------------------------------

transaction_duration += (
    transaction_peak.astype(float)
    *
    np.random.uniform(
        20,
        100,
        transaction_rows_count
    )
)


# ------------------------------------------------------------
# Keep duration realistic
# ------------------------------------------------------------

transaction_duration = np.clip(
    transaction_duration,
    10,
    30000
)


fact_transactions["duration_ms"] = (
    transaction_duration.round(2)
)


# ============================================================
# 82. GENERATE ERROR CATEGORY
# ============================================================

# Default value for successful transactions

error_categories = np.full(
    transaction_rows_count,
    "None",
    dtype=object
)


# ============================================================
# 83. CREATE FAILURE MASK
# ============================================================

failed_mask = (
    fact_transactions["status"]
    == "Failed"
)


# ============================================================
# 84. DEADLOCK FAILURES
# ============================================================

deadlock_mask = (
    failed_mask
    &
    (transaction_deadlocks > 0)
)


error_categories[
    deadlock_mask
] = "Deadlock"


# ============================================================
# 85. TIMEOUT FAILURES
# ============================================================

timeout_mask = (
    failed_mask
    &
    (~deadlock_mask)
    &
    (transaction_duration > 5000)
)


error_categories[
    timeout_mask
] = "Timeout"


# ============================================================
# 86. RESOURCE LIMIT FAILURES
# ============================================================

resource_mask = (
    failed_mask
    &
    (~deadlock_mask)
    &
    (~timeout_mask)
    &
    (transaction_cpu > 85)
)


error_categories[
    resource_mask
] = "Resource Limit"


# ============================================================
# 87. OTHER FAILURE CATEGORIES
# ============================================================

remaining_failure_mask = (
    failed_mask
    &
    (~deadlock_mask)
    &
    (~timeout_mask)
    &
    (~resource_mask)
)


remaining_failure_count = (
    remaining_failure_mask.sum()
)


if remaining_failure_count > 0:

    error_categories[
        remaining_failure_mask
    ] = np.random.choice(

        [
            "Connection Error",
            "Constraint Error",
            "Unknown Error"
        ],

        size=remaining_failure_count,

        p=[
            0.45,
            0.35,
            0.20
        ]
    )


# ============================================================
# 88. ADD ERROR CATEGORY
# ============================================================

fact_transactions["error_category"] = (
    error_categories
)


# ============================================================
# 89. SORT TRANSACTIONS
# ============================================================

fact_transactions.sort_values(
    by="timestamp",
    inplace=True
)


# ============================================================
# 90. RESET INDEX
# ============================================================

fact_transactions.reset_index(
    drop=True,
    inplace=True
)


# ============================================================
# 91. DISPLAY TRANSACTION DATA
# ============================================================

print("\n========================================")
print("          FACT_TRANSACTIONS")
print("========================================")


print(
    fact_transactions.head(10)
)


# ============================================================
# 92. DISPLAY SHAPE
# ============================================================

print("\nShape:")

print(
    fact_transactions.shape
)


# ============================================================
# 93. TRANSACTION STATUS SUMMARY
# ============================================================

print("\nTransaction Status:")

print(
    fact_transactions[
        "status"
    ].value_counts()
)


# ============================================================
# 94. TRANSACTION ERROR SUMMARY
# ============================================================

print("\nError Category:")

print(
    fact_transactions[
        "error_category"
    ].value_counts()
)


# ============================================================
# 95. TRANSACTION DURATION SUMMARY
# ============================================================

print("\nTransaction Duration Summary:")

print(
    fact_transactions[
        "duration_ms"
    ].describe()
)


# ============================================================
# 96. TRANSACTION FAILURE RATE
# ============================================================

total_transactions = len(
    fact_transactions
)


failed_transactions = (
    fact_transactions[
        "status"
    ]
    .eq("Failed")
    .sum()
)


failure_rate = (
    failed_transactions
    /
    total_transactions
    * 100
)


print("\nTransaction Failure Rate:")

print(
    round(
        failure_rate,
        2
    ),
    "%"
)


# ============================================================
# 97. SAVE TRANSACTION CSV
# ============================================================

transaction_file = os.path.join(
    DATA_DIR,
    "fact_transactions.csv"
)


fact_transactions.to_csv(
    transaction_file,
    index=False
)


# ============================================================
# 98. SUCCESS MESSAGE
# ============================================================

print("\n========================================")
print("              SUCCESS")
print("========================================")


print(
    "✅ Transaction CSV created successfully!"
)


print("📁 Location:")


print(
    transaction_file
)

# ================================
# ============================================================
# 99. INCIDENT DATA
# ============================================================

# Number of incident records

incident_rows_count = 1000


# ============================================================
# 100. SELECT PERFORMANCE RECORDS
# ============================================================

# Use performance records as the source for
# incident database and timestamp information.
#
# This creates a relationship between:
#
# Database Performance
#        ↓
# Incidents


incident_sample_indices = np.random.choice(
    len(fact_performance_metrics),
    size=incident_rows_count
)


incident_performance = (
    fact_performance_metrics.iloc[
        incident_sample_indices
    ]
    .reset_index(drop=True)
)


# ============================================================
# 101. ASSIGN DATABASE IDs
# ============================================================

incident_database_ids = (
    incident_performance[
        "database_id"
    ]
    .to_numpy()
)


# ============================================================
# 102. ASSIGN INCIDENT TIMESTAMPS
# ============================================================

incident_timestamps = (
    incident_performance[
        "timestamp"
    ]
    .to_numpy()
)


# ============================================================
# 103. CREATE BASE INCIDENT DATAFRAME
# ============================================================

fact_incidents = pd.DataFrame({

    "incident_id": range(
        1,
        incident_rows_count + 1
    ),

    "database_id": incident_database_ids,

    "timestamp": incident_timestamps
})


# ============================================================
# 104. GENERATE INCIDENT CATEGORIES
# ============================================================

incident_categories = [
    "Performance",
    "Transaction Failure",
    "Deadlock",
    "Storage",
    "Connectivity",
    "Backup",
    "Availability"
]


fact_incidents["incident_category"] = np.random.choice(

    incident_categories,

    size=incident_rows_count,

    p=[
        0.25,   # Performance
        0.25,   # Transaction Failure
        0.10,   # Deadlock
        0.10,   # Storage
        0.10,   # Connectivity
        0.08,   # Backup
        0.12    # Availability
    ]
)


# ============================================================
# 105. GENERATE INCIDENT SEVERITY
# ============================================================

incident_severity = np.random.choice(

    [
        "Low",
        "Medium",
        "High",
        "Critical"
    ],

    size=incident_rows_count,

    p=[
        0.35,
        0.40,
        0.20,
        0.05
    ]
)


fact_incidents["severity"] = (
    incident_severity
)


# ============================================================
# 106. GENERATE INCIDENT STATUS
# ============================================================

incident_status = np.random.choice(

    [
        "Resolved",
        "Open",
        "In Progress"
    ],

    size=incident_rows_count,

    p=[
        0.80,
        0.08,
        0.12
    ]
)


fact_incidents["status"] = (
    incident_status
)


# ============================================================
# 107. GENERATE DOWNTIME
# ============================================================

# Generate downtime in minutes.

downtime_minutes = np.random.lognormal(

    mean=2,

    sigma=1,

    size=incident_rows_count
)


# Keep downtime within realistic limits.

downtime_minutes = np.clip(

    downtime_minutes,

    1,

    720
)


fact_incidents["downtime_minutes"] = (
    downtime_minutes.round(2)
)


# ============================================================
# 108. GENERATE RESOLUTION TIME
# ============================================================

# Resolution time should normally be greater than
# downtime.

resolution_time_minutes = (

    downtime_minutes

    +

    np.random.uniform(
        5,
        120,
        incident_rows_count
    )
)


# Keep values within 24 hours.

resolution_time_minutes = np.clip(

    resolution_time_minutes,

    1,

    1440
)


fact_incidents["resolution_time_minutes"] = (
    resolution_time_minutes.round(2)
)


# ============================================================
# 109. SORT INCIDENT DATA
# ============================================================

fact_incidents.sort_values(

    by="timestamp",

    inplace=True
)


# ============================================================
# 110. RESET INDEX
# ============================================================

fact_incidents.reset_index(

    drop=True,

    inplace=True
)


# ============================================================
# 111. DISPLAY INCIDENT DATA
# ============================================================

print("\n========================================")
print("            FACT_INCIDENTS")
print("========================================")


print(
    fact_incidents.head(10)
)


# ============================================================
# 112. DISPLAY SHAPE
# ============================================================

print("\nShape:")


print(
    fact_incidents.shape
)


# ============================================================
# 113. INCIDENT CATEGORY SUMMARY
# ============================================================

print("\nIncident Category:")


print(
    fact_incidents[
        "incident_category"
    ].value_counts()
)


# ============================================================
# 114. INCIDENT SEVERITY SUMMARY
# ============================================================

print("\nIncident Severity:")


print(
    fact_incidents[
        "severity"
    ].value_counts()
)


# ============================================================
# 115. INCIDENT STATUS SUMMARY
# ============================================================

print("\nIncident Status:")


print(
    fact_incidents[
        "status"
    ].value_counts()
)


# ============================================================
# 116. DOWNTIME SUMMARY
# ============================================================

print("\nDowntime Summary:")


print(
    fact_incidents[
        "downtime_minutes"
    ].describe()
)


# ============================================================
# 117. RESOLUTION TIME SUMMARY
# ============================================================

print("\nResolution Time Summary:")


print(
    fact_incidents[
        "resolution_time_minutes"
    ].describe()
)


# ============================================================
# 118. CALCULATE MTTR
# ============================================================

# MTTR = Mean Time To Resolution
#
# Formula:
#
# MTTR = Average Resolution Time


mttr = fact_incidents[
    "resolution_time_minutes"
].mean()


print("\nMTTR:")


print(
    round(
        mttr,
        2
    ),
    "minutes"
)


# ============================================================
# 119. SAVE INCIDENT CSV
# ============================================================

incident_file = os.path.join(

    DATA_DIR,

    "fact_incidents.csv"
)


fact_incidents.to_csv(

    incident_file,

    index=False
)


# ============================================================
# 120. SUCCESS MESSAGE
# ============================================================

print("\n========================================")
print("              SUCCESS")
print("========================================")


print(
    "✅ Incident CSV created successfully!"
)


print("📁 Location:")


print(
    incident_file
)

# ==================================================================
# ============================================================
# TASK 4H — GENERATE FACT_STORAGE
# ============================================================

print("\n" + "=" * 60)
print("TASK 4H — GENERATING FACT_STORAGE")
print("=" * 60)


# ------------------------------------------------------------
# 121. Generate daily storage dates
# ------------------------------------------------------------

storage_dates = pd.date_range(
    start="2026-01-01",
    periods=180,
    freq="D"
)


# ------------------------------------------------------------
# 122. Create one row for every database and every date
# ------------------------------------------------------------

storage_base = pd.MultiIndex.from_product(
    [
        dim_database["database_id"],
        storage_dates
    ],
    names=[
        "database_id",
        "date"
    ]
).to_frame(index=False)


# ------------------------------------------------------------
# 123. Number of rows
# ------------------------------------------------------------

storage_rows_count = len(storage_base)

print("Storage rows:", storage_rows_count)


# ------------------------------------------------------------
# 124. Create storage ID
# ------------------------------------------------------------

storage_base["storage_id"] = (
    np.arange(1, storage_rows_count + 1)
    + 800000
)


# ------------------------------------------------------------
# 125. Generate base allocated capacity
# ------------------------------------------------------------

database_capacity = (
    dim_database[
        [
            "database_id"
        ]
    ]
    .copy()
)


database_capacity["allocated_gb"] = np.random.uniform(
    250,
    2000,
    len(database_capacity)
)


# ------------------------------------------------------------
# 126. Merge capacity into storage data
# ------------------------------------------------------------

fact_storage = storage_base.merge(
    database_capacity,
    on="database_id",
    how="left"
)


# ------------------------------------------------------------
# 127. Calculate days since project start
# ------------------------------------------------------------

fact_storage["days_since_start"] = (
    fact_storage["date"]
    - pd.Timestamp("2026-01-01")
).dt.days


# ------------------------------------------------------------
# 128. Generate initial storage usage
# ------------------------------------------------------------

initial_usage_percent = np.random.uniform(
    0.35,
    0.70,
    len(fact_storage)
)


# ------------------------------------------------------------
# 129. Generate storage growth
# ------------------------------------------------------------

daily_growth = np.random.uniform(
    0.02,
    0.20,
    len(fact_storage)
)


# ------------------------------------------------------------
# 130. Calculate used storage
# ------------------------------------------------------------

fact_storage["used_gb"] = (
    fact_storage["allocated_gb"]
    * initial_usage_percent
    + (
        fact_storage["days_since_start"]
        * daily_growth
    )
)


# ------------------------------------------------------------
# 131. Add some high-growth databases
# ------------------------------------------------------------

high_growth_mask = (
    fact_storage["database_id"] % 5 == 0
)


fact_storage.loc[
    high_growth_mask,
    "used_gb"
] = (
    fact_storage.loc[
        high_growth_mask,
        "used_gb"
    ]
    + (
        fact_storage.loc[
            high_growth_mask,
            "days_since_start"
        ]
        * 0.50
    )
)


# ------------------------------------------------------------
# 132. Prevent used storage from exceeding capacity
# ------------------------------------------------------------

fact_storage["used_gb"] = np.minimum(
    fact_storage["used_gb"],
    fact_storage["allocated_gb"] * 0.98
)


# ------------------------------------------------------------
# 133. Calculate free storage
# ------------------------------------------------------------

fact_storage["free_gb"] = (
    fact_storage["allocated_gb"]
    - fact_storage["used_gb"]
)


# ------------------------------------------------------------
# 134. Round storage values
# ------------------------------------------------------------

fact_storage["allocated_gb"] = (
    fact_storage["allocated_gb"]
    .round(2)
)

fact_storage["used_gb"] = (
    fact_storage["used_gb"]
    .round(2)
)

fact_storage["free_gb"] = (
    fact_storage["free_gb"]
    .round(2)
)


# ------------------------------------------------------------
# 135. Select final columns
# ------------------------------------------------------------

fact_storage = fact_storage[
    [
        "storage_id",
        "database_id",
        "date",
        "used_gb",
        "allocated_gb",
        "free_gb"
    ]
]


# ------------------------------------------------------------
# 136. Sort data
# ------------------------------------------------------------

fact_storage = fact_storage.sort_values(
    [
        "database_id",
        "date"
    ]
).reset_index(drop=True)


# ------------------------------------------------------------
# 137. Check shape
# ------------------------------------------------------------

print(
    "fact_storage shape:",
    fact_storage.shape
)


# ------------------------------------------------------------
# 138. Display first 10 rows
# ------------------------------------------------------------

print("\nFirst 10 rows:")

print(
    fact_storage.head(10)
)


# ------------------------------------------------------------
# 139. Check minimum values
# ------------------------------------------------------------

print("\nMinimum values:")

print(
    fact_storage[
        [
            "used_gb",
            "allocated_gb",
            "free_gb"
        ]
    ].min()
)


# ------------------------------------------------------------
# 140. Validate used <= allocated
# ------------------------------------------------------------

invalid_storage = (
    fact_storage["used_gb"]
    > fact_storage["allocated_gb"]
)


print(
    "\nInvalid used > allocated rows:",
    invalid_storage.sum()
)


# ------------------------------------------------------------
# 141. Validate free storage
# ------------------------------------------------------------

free_validation = np.isclose(
    fact_storage["free_gb"],
    fact_storage["allocated_gb"]
    - fact_storage["used_gb"],
    atol=0.01
)


print(
    "Invalid free_gb rows:",
    (~free_validation).sum()
)


# ------------------------------------------------------------
# 142. Save CSV
# ------------------------------------------------------------

storage_output_path = os.path.join(
    DATA_DIR,
    "fact_storage.csv"
)


fact_storage.to_csv(
    storage_output_path,
    index=False
)


# ------------------------------------------------------------
# 143. Final message
# ------------------------------------------------------------

print(
    "\n✅ fact_storage.csv created successfully!"
)

print(
    "Saved to:",
    storage_output_path
)

# =================================================
# ============================================================
# TASK 4I — GENERATE FACT_COST
# ============================================================

print("\n" + "=" * 60)
print("TASK 4I — GENERATING FACT_COST")
print("=" * 60)


# ------------------------------------------------------------
# 144. Create monthly dates
# ------------------------------------------------------------

cost_months = pd.date_range(
    start="2026-01-01",
    periods=6,
    freq="MS"
)


# ------------------------------------------------------------
# 145. Create one row per database per month
# ------------------------------------------------------------

cost_base = pd.MultiIndex.from_product(
    [
        dim_database["database_id"],
        cost_months
    ],
    names=[
        "database_id",
        "month"
    ]
).to_frame(index=False)


# ------------------------------------------------------------
# 146. Number of rows
# ------------------------------------------------------------

cost_rows_count = len(cost_base)

print(
    "Cost rows:",
    cost_rows_count
)


# ------------------------------------------------------------
# 147. Create cost ID
# ------------------------------------------------------------

cost_base["cost_id"] = (
    np.arange(
        1,
        cost_rows_count + 1
    )
    + 900000
)


# ------------------------------------------------------------
# 148. Generate compute cost
# ------------------------------------------------------------

cost_base["compute_cost"] = np.random.uniform(
    500,
    5000,
    cost_rows_count
)


# ------------------------------------------------------------
# 149. Generate storage cost
# ------------------------------------------------------------

cost_base["storage_cost"] = np.random.uniform(
    100,
    1500,
    cost_rows_count
)


# ------------------------------------------------------------
# 150. Generate backup cost
# ------------------------------------------------------------

cost_base["backup_cost"] = np.random.uniform(
    50,
    500,
    cost_rows_count
)


# ------------------------------------------------------------
# 151. Generate transaction count
# ------------------------------------------------------------

cost_base["transaction_count"] = np.random.lognormal(
    mean=13,
    sigma=0.8,
    size=cost_rows_count
)


# ------------------------------------------------------------
# 152. Convert transaction count to integer
# ------------------------------------------------------------

cost_base["transaction_count"] = (
    cost_base["transaction_count"]
    .clip(10000, 10000000)
    .round()
    .astype("int64")
)


# ------------------------------------------------------------
# 153. Calculate total cost
# ------------------------------------------------------------

cost_base["total_cost"] = (
    cost_base["compute_cost"]
    + cost_base["storage_cost"]
    + cost_base["backup_cost"]
)


# ------------------------------------------------------------
# 154. Round cost columns
# ------------------------------------------------------------

cost_columns = [
    "compute_cost",
    "storage_cost",
    "backup_cost",
    "total_cost"
]


for column in cost_columns:

    cost_base[column] = (
        cost_base[column]
        .round(2)
    )


# ------------------------------------------------------------
# 155. Select final columns
# ------------------------------------------------------------

fact_cost = cost_base[
    [
        "cost_id",
        "database_id",
        "month",
        "compute_cost",
        "storage_cost",
        "backup_cost",
        "total_cost",
        "transaction_count"
    ]
]


# ------------------------------------------------------------
# 156. Sort data
# ------------------------------------------------------------

fact_cost = fact_cost.sort_values(
    [
        "database_id",
        "month"
    ]
).reset_index(drop=True)


# ------------------------------------------------------------
# 157. Display shape
# ------------------------------------------------------------

print(
    "\nfact_cost shape:",
    fact_cost.shape
)


# ------------------------------------------------------------
# 158. Display first 10 rows
# ------------------------------------------------------------

print("\nFirst 10 rows:")

print(
    fact_cost.head(10)
)


# ------------------------------------------------------------
# 159. Validate total cost
# ------------------------------------------------------------

expected_total_cost = (
    fact_cost["compute_cost"]
    + fact_cost["storage_cost"]
    + fact_cost["backup_cost"]
)


total_cost_validation = np.isclose(
    fact_cost["total_cost"],
    expected_total_cost,
    atol=0.01
)


print(
    "\nInvalid total_cost rows:",
    (~total_cost_validation).sum()
)


# ------------------------------------------------------------
# 160. Validate transaction count
# ------------------------------------------------------------

invalid_transactions = (
    fact_cost["transaction_count"] <= 0
)


print(
    "Invalid transaction count rows:",
    invalid_transactions.sum()
)


# ------------------------------------------------------------
# 161. Calculate cost per transaction
# ------------------------------------------------------------

cost_per_transaction = (
    fact_cost["total_cost"]
    / fact_cost["transaction_count"]
)


print(
    "\nAverage cost per transaction:",
    round(
        cost_per_transaction.mean(),
        6
    )
)


# ------------------------------------------------------------
# 162. Save CSV
# ------------------------------------------------------------

cost_output_path = os.path.join(
    DATA_DIR,
    "fact_cost.csv"
)


fact_cost.to_csv(
    cost_output_path,
    index=False
)


# ------------------------------------------------------------
# 163. Final message
# ------------------------------------------------------------

print(
    "\n✅ fact_cost.csv created successfully!"
)

print(
    "Saved to:",
    cost_output_path
)

# ============================
# ============================================================
# TASK 4J — FINAL DATA VALIDATION
# ============================================================

print("\n" + "=" * 60)
print("TASK 4J — FINAL DATA VALIDATION")
print("=" * 60)


# ------------------------------------------------------------
# 164. Check all generated DataFrames
# ------------------------------------------------------------

datasets = {
    "dim_database": dim_database,
    "dim_application": dim_application,
    "dim_sla": dim_sla,
    "fact_performance_metrics": fact_performance_metrics,
    "fact_query_performance": fact_query_performance,
    "fact_transactions": fact_transactions,
    "fact_incidents": fact_incidents,
    "fact_storage": fact_storage,
    "fact_cost": fact_cost
}


# ------------------------------------------------------------
# 165. Display dataset shapes
# ------------------------------------------------------------

print("\n📊 DATASET SUMMARY")
print("-" * 60)

for name, dataframe in datasets.items():

    print(
        f"{name:<30} {dataframe.shape}"
    )


# ------------------------------------------------------------
# 166. Check missing values
# ------------------------------------------------------------

print("\n🔍 MISSING VALUE CHECK")
print("-" * 60)

for name, dataframe in datasets.items():

    missing_values = (
        dataframe.isnull()
        .sum()
        .sum()
    )

    print(
        f"{name:<30} {missing_values}"
    )


# ------------------------------------------------------------
# 167. Check duplicate rows
# ------------------------------------------------------------

print("\n🔁 DUPLICATE ROW CHECK")
print("-" * 60)

for name, dataframe in datasets.items():

    duplicate_count = (
        dataframe.duplicated()
        .sum()
    )

    print(
        f"{name:<30} {duplicate_count}"
    )


# ------------------------------------------------------------
# 168. Check database foreign keys
# ------------------------------------------------------------

valid_database_ids = set(
    dim_database["database_id"]
)


print("\n🔗 DATABASE FOREIGN KEY CHECK")
print("-" * 60)


database_fact_tables = [
    fact_performance_metrics,
    fact_query_performance,
    fact_transactions,
    fact_incidents,
    fact_storage,
    fact_cost
]


for dataframe in database_fact_tables:

    invalid_ids = (
        ~dataframe["database_id"]
        .isin(valid_database_ids)
    ).sum()

    print(
        f"Invalid database IDs: {invalid_ids}"
    )


# ------------------------------------------------------------
# 169. Check application foreign keys
# ------------------------------------------------------------

valid_application_ids = set(
    dim_application["application_id"]
)


invalid_application_ids = (
    ~fact_transactions["application_id"]
    .isin(valid_application_ids)
).sum()


print(
    "\nInvalid application IDs:",
    invalid_application_ids
)


# ------------------------------------------------------------
# 170. Check storage rules
# ------------------------------------------------------------

invalid_storage = (
    fact_storage["used_gb"]
    > fact_storage["allocated_gb"]
).sum()


print(
    "Invalid storage rows:",
    invalid_storage
)


# ------------------------------------------------------------
# 171. Check free storage calculation
# ------------------------------------------------------------

expected_free = (
    fact_storage["allocated_gb"]
    - fact_storage["used_gb"]
)


invalid_free = (
    ~np.isclose(
        fact_storage["free_gb"],
        expected_free,
        atol=0.01
    )
).sum()


print(
    "Invalid free_gb rows:",
    invalid_free
)


# ------------------------------------------------------------
# 172. Check cost calculation
# ------------------------------------------------------------

expected_total = (
    fact_cost["compute_cost"]
    + fact_cost["storage_cost"]
    + fact_cost["backup_cost"]
)


invalid_total_cost = (
    ~np.isclose(
        fact_cost["total_cost"],
        expected_total,
        atol=0.01
    )
).sum()


print(
    "Invalid total_cost rows:",
    invalid_total_cost
)


# ------------------------------------------------------------
# 173. Check negative numeric values
# ------------------------------------------------------------

print("\n🔢 NEGATIVE VALUE CHECK")
print("-" * 60)

numeric_columns_to_check = {
    "fact_performance_metrics": [
        "cpu_percent",
        "memory_percent",
        "disk_io_percent",
        "connections",
        "transactions_per_second",
        "deadlocks",
        "errors"
    ],

    "fact_transactions": [
        "duration_ms"
    ],

    "fact_incidents": [
        "downtime_minutes",
        "resolution_time_minutes"
    ],

    "fact_storage": [
        "used_gb",
        "allocated_gb",
        "free_gb"
    ],

    "fact_cost": [
        "compute_cost",
        "storage_cost",
        "backup_cost",
        "total_cost",
        "transaction_count"
    ]
}


for dataset_name, columns in numeric_columns_to_check.items():

    dataframe = datasets[dataset_name]

    negative_count = 0

    for column in columns:

        if column in dataframe.columns:

            negative_count += (
                dataframe[column] < 0
            ).sum()

    print(
        f"{dataset_name:<30} {negative_count}"
    )


# ------------------------------------------------------------
# 174. Transaction status validation
# ------------------------------------------------------------

valid_transaction_status = {
    "Success",
    "Failed"
}


invalid_transaction_status = (
    ~fact_transactions["status"]
    .isin(valid_transaction_status)
).sum()


print(
    "\nInvalid transaction status:",
    invalid_transaction_status
)


# ------------------------------------------------------------
# 175. Incident severity validation
# ------------------------------------------------------------

valid_severity = {
    "Low",
    "Medium",
    "High",
    "Critical"
}


invalid_incident_severity = (
    ~fact_incidents["severity"]
    .isin(valid_severity)
).sum()


print(
    "Invalid incident severity:",
    invalid_incident_severity
)


# ------------------------------------------------------------
# 176. Final validation message
# ------------------------------------------------------------

print("\n" + "=" * 60)
print("FINAL VALIDATION COMPLETED")
print("=" * 60)

print(
    """
✅ Data generation completed.

Next phase:
SQL Database Setup
"""
)