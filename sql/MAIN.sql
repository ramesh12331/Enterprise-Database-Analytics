SELECT current_database();

-- ============================================================
-- TASK 5B — CREATE DIM_DATABASE
-- ============================================================

CREATE TABLE dim_database
(
    database_id INTEGER PRIMARY KEY,
    database_name VARCHAR(100) NOT NULL,
    database_type VARCHAR(50) NOT NULL,
    risk_level VARCHAR(20) NOT NULL,
    environment VARCHAR(30) NOT NULL,
    region VARCHAR(50) NOT NULL
);

SELECT *
FROM dim_database
ORDER BY database_id;

SELECT COUNT(*) AS database_count
FROM dim_database;

-- ============================================================
-- TASK 5D — CREATE DIM_APPLICATION
-- ============================================================

CREATE TABLE dim_application
(
    application_id INTEGER PRIMARY KEY,
    application_name VARCHAR(100) NOT NULL,
    application_type VARCHAR(50) NOT NULL,
    business_unit VARCHAR(50) NOT NULL,
    criticality VARCHAR(20) NOT NULL
);

SELECT *
FROM dim_application;

SELECT *
FROM dim_application
ORDER BY application_id;

SELECT COUNT(*) AS application_count
FROM dim_application;

-- ============================================================
-- TASK 5E — CREATE DIM_SLA
-- ============================================================

CREATE TABLE dim_sla
(
    sla_id INTEGER PRIMARY KEY,
    sla_name VARCHAR(50) NOT NULL,
    response_time_minutes INTEGER NOT NULL,
    resolution_time_minutes INTEGER NOT NULL,
    availability_target DECIMAL(5,2) NOT NULL
);

SELECT *
FROM dim_sla;

DROP TABLE IF EXISTS dim_sla;

CREATE TABLE dim_sla
(
    sla_id INTEGER PRIMARY KEY,
    severity VARCHAR(20) NOT NULL,
    response_target_minutes INTEGER NOT NULL,
    resolution_target_minutes INTEGER NOT NULL,
    availability_target_percent DECIMAL(5,2) NOT NULL
);

SELECT *
FROM dim_sla
ORDER BY sla_id;

SELECT COUNT(*) AS sla_count
FROM dim_sla;

CREATE TABLE fact_performance_metrics
(
    metric_id BIGINT PRIMARY KEY,

    database_id INTEGER NOT NULL,

    timestamp TIMESTAMP NOT NULL,

    is_peak_hour BOOLEAN NOT NULL,

    cpu_percent DECIMAL(5,2) NOT NULL,

    memory_percent DECIMAL(5,2) NOT NULL,

    disk_io_percent DECIMAL(5,2) NOT NULL,

    connections INTEGER NOT NULL,

    transactions_per_second DECIMAL(12,2) NOT NULL,

    deadlocks INTEGER NOT NULL,

    errors INTEGER NOT NULL
);

SELECT *
FROM fact_performance_metrics;

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'fact_performance_metrics'
ORDER BY ordinal_position;

SELECT COUNT(*)
FROM fact_performance_metrics;

SELECT *
FROM fact_performance_metrics
LIMIT 10;

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(metric_id) AS missing_metric_id,
    COUNT(*) - COUNT(database_id) AS missing_database_id,
    COUNT(*) - COUNT(timestamp) AS missing_timestamp,
    COUNT(*) - COUNT(cpu_percent) AS missing_cpu
FROM fact_performance_metrics;

SELECT
    MIN(cpu_percent) AS min_cpu,
    MAX(cpu_percent) AS max_cpu,
    AVG(cpu_percent) AS avg_cpu
FROM fact_performance_metrics;

SELECT
    MIN(database_id) AS min_database_id,
    MAX(database_id) AS max_database_id
FROM fact_performance_metrics;

ALTER TABLE fact_performance_metrics
ADD CONSTRAINT fk_performance_database
FOREIGN KEY (database_id)
REFERENCES dim_database(database_id);

SELECT
    COUNT(*) AS total_metrics,
    COUNT(DISTINCT database_id) AS databases,
    MIN(timestamp) AS first_timestamp,
    MAX(timestamp) AS last_timestamp
FROM fact_performance_metrics;

DROP TABLE IF EXISTS fact_query_performance;

CREATE TABLE fact_query_performance
(
    query_id BIGINT PRIMARY KEY,

    database_id INTEGER NOT NULL,

    timestamp TIMESTAMP NOT NULL,

    query_type VARCHAR(20) NOT NULL,

    query_category VARCHAR(50) NOT NULL,

    execution_count INTEGER NOT NULL,

    avg_duration_ms DECIMAL(12,2) NOT NULL,

    cpu_time_ms DECIMAL(12,2) NOT NULL,

    logical_reads DECIMAL(12,2) NOT NULL,

    logical_writes DECIMAL(12,2) NOT NULL,

    rows_affected INTEGER NOT NULL,

    wait_time_ms DECIMAL(12,2) NOT NULL,

    performance_status VARCHAR(20) NOT NULL
);

ALTER TABLE fact_query_performance
ADD CONSTRAINT fk_query_database
FOREIGN KEY (database_id)
REFERENCES dim_database(database_id);

SELECT COUNT(*)
FROM fact_query_performance;

CREATE TABLE fact_transactions
(
    transaction_id BIGINT PRIMARY KEY,

    database_id INTEGER NOT NULL,

    application_id INTEGER NOT NULL,

    timestamp TIMESTAMP NOT NULL,

    transaction_type VARCHAR(30) NOT NULL,

    status VARCHAR(20) NOT NULL,

    duration_ms DECIMAL(12,2) NOT NULL,

    error_category VARCHAR(50)
);

ALTER TABLE fact_transactions
ADD CONSTRAINT fk_transaction_database
FOREIGN KEY (database_id)
REFERENCES dim_database(database_id);

ALTER TABLE fact_transactions
ADD CONSTRAINT fk_transaction_application
FOREIGN KEY (application_id)
REFERENCES dim_application(application_id);

SELECT COUNT(*) AS total_transactions
FROM fact_transactions;

SELECT *
FROM fact_transactions
LIMIT 10;

SELECT
    status,
    COUNT(*) AS transaction_count
FROM fact_transactions
GROUP BY status
ORDER BY transaction_count DESC;

SELECT
    COUNT(*) AS total_transactions,

    COUNT(*) FILTER (
        WHERE status = 'Failed'
    ) AS failed_transactions,

    ROUND(
        100.0 *
        COUNT(*) FILTER (
            WHERE status = 'Failed'
        ) / COUNT(*),
        2
    ) AS failure_rate_percent

FROM fact_transactions;

SELECT
    error_category,
    COUNT(*) AS failure_count
FROM fact_transactions
WHERE status = 'Failed'
GROUP BY error_category
ORDER BY failure_count DESC;

SELECT
    transaction_id,
    database_id,
    application_id,
    transaction_type,
    duration_ms,
    status,
    error_category
FROM fact_transactions
ORDER BY duration_ms DESC
LIMIT 20;

SELECT
    transaction_type,

    COUNT(*) AS total_transactions,

    COUNT(*) FILTER (
        WHERE status = 'Failed'
    ) AS failed_transactions,

    ROUND(
        100.0 *
        COUNT(*) FILTER (
            WHERE status = 'Failed'
        ) / COUNT(*),
        2
    ) AS failure_rate_percent

FROM fact_transactions

GROUP BY transaction_type

ORDER BY failure_rate_percent DESC;

SELECT
    database_id,

    COUNT(*) AS total_transactions,

    COUNT(*) FILTER (
        WHERE status = 'Failed'
    ) AS failed_transactions,

    ROUND(
        100.0 *
        COUNT(*) FILTER (
            WHERE status = 'Failed'
        ) / COUNT(*),
        2
    ) AS failure_rate_percent

FROM fact_transactions

GROUP BY database_id

ORDER BY failure_rate_percent DESC;

SELECT
    COUNT(*) AS total_rows,

    COUNT(*) - COUNT(transaction_id)
        AS missing_transaction_id,

    COUNT(*) - COUNT(database_id)
        AS missing_database_id,

    COUNT(*) - COUNT(application_id)
        AS missing_application_id,

    COUNT(*) - COUNT(status)
        AS missing_status,

    COUNT(*) - COUNT(duration_ms)
        AS missing_duration

FROM fact_transactions;

SELECT DISTINCT status
FROM fact_transactions;

SELECT
    COUNT(DISTINCT database_id) AS database_count
FROM fact_transactions;

SELECT
    COUNT(DISTINCT application_id) AS application_count
FROM fact_transactions;

CREATE TABLE fact_incidents
(
    incident_id BIGINT PRIMARY KEY,

    database_id INTEGER NOT NULL,

    timestamp TIMESTAMP NOT NULL,

    incident_category VARCHAR(50) NOT NULL,

    severity VARCHAR(20) NOT NULL,

    status VARCHAR(20) NOT NULL,

    downtime_minutes DECIMAL(12,2) NOT NULL,

    resolution_time_minutes DECIMAL(12,2) NOT NULL
);

ALTER TABLE fact_incidents
ADD CONSTRAINT fk_incident_database
FOREIGN KEY (database_id)
REFERENCES dim_database(database_id);

SELECT COUNT(*) AS total_incidents
FROM fact_incidents;

SELECT *
FROM fact_incidents
LIMIT 10;

SELECT
    severity,
    COUNT(*) AS incident_count
FROM fact_incidents
GROUP BY severity
ORDER BY incident_count DESC;

SELECT
    incident_category,
    COUNT(*) AS incident_count
FROM fact_incidents
GROUP BY incident_category
ORDER BY incident_count DESC;

SELECT
    ROUND(
        AVG(resolution_time_minutes),
        2
    ) AS mttr_minutes
FROM fact_incidents;

SELECT
    severity,

    COUNT(*) AS incident_count,

    ROUND(
        AVG(resolution_time_minutes),
        2
    ) AS avg_resolution_minutes

FROM fact_incidents

GROUP BY severity

ORDER BY avg_resolution_minutes DESC;

SELECT
    incident_category,

    COUNT(*) AS incident_count,

    ROUND(
        SUM(downtime_minutes),
        2
    ) AS total_downtime_minutes,

    ROUND(
        AVG(downtime_minutes),
        2
    ) AS avg_downtime_minutes

FROM fact_incidents

GROUP BY incident_category

ORDER BY total_downtime_minutes DESC;

SELECT
    database_id,

    COUNT(*) AS incident_count,

    ROUND(
        SUM(downtime_minutes),
        2
    ) AS total_downtime_minutes,

    ROUND(
        AVG(resolution_time_minutes),
        2
    ) AS avg_resolution_minutes

FROM fact_incidents

GROUP BY database_id

ORDER BY total_downtime_minutes DESC;

SELECT
    status,
    COUNT(*) AS incident_count
FROM fact_incidents
GROUP BY status
ORDER BY incident_count DESC;

SELECT
    COUNT(*) AS total_rows,

    COUNT(*) - COUNT(incident_id)
        AS missing_incident_id,

    COUNT(*) - COUNT(database_id)
        AS missing_database_id,

    COUNT(*) - COUNT(timestamp)
        AS missing_timestamp,

    COUNT(*) - COUNT(severity)
        AS missing_severity,

    COUNT(*) - COUNT(downtime_minutes)
        AS missing_downtime,

    COUNT(*) - COUNT(resolution_time_minutes)
        AS missing_resolution

FROM fact_incidents;

SELECT
    COUNT(*) AS total_incidents,
    COUNT(DISTINCT database_id) AS databases,
    COUNT(DISTINCT incident_category) AS categories,
    COUNT(DISTINCT severity) AS severity_levels,
    ROUND(SUM(downtime_minutes), 2) AS total_downtime,
    ROUND(AVG(resolution_time_minutes), 2) AS overall_mttr
FROM fact_incidents;

CREATE TABLE fact_storage
(
    storage_id BIGINT PRIMARY KEY,

    database_id INTEGER NOT NULL,

    date DATE NOT NULL,

    used_gb DECIMAL(12,2) NOT NULL,

    allocated_gb DECIMAL(12,2) NOT NULL,

    free_gb DECIMAL(12,2) NOT NULL
);

ALTER TABLE fact_storage
ADD CONSTRAINT fk_storage_database
FOREIGN KEY (database_id)
REFERENCES dim_database(database_id);

SELECT COUNT(*) AS total_storage_records
FROM fact_storage;

SELECT *
FROM fact_storage
LIMIT 10;

SELECT
    database_id,
    date,
    used_gb,
    allocated_gb,
    free_gb,

    ROUND(
        (used_gb / NULLIF(allocated_gb, 0)) * 100,
        2
    ) AS storage_utilization_percent

FROM fact_storage

ORDER BY storage_utilization_percent DESC
LIMIT 20;

SELECT
    database_id,
    date,
    used_gb,
    allocated_gb,
    free_gb,

    ROUND(
        (used_gb / NULLIF(allocated_gb, 0)) * 100,
        2
    ) AS utilization_percent

FROM fact_storage

WHERE
    (used_gb / NULLIF(allocated_gb, 0)) * 100 >= 80

ORDER BY utilization_percent DESC;

SELECT MAX(date)
FROM fact_storage;

SELECT
    database_id,
    date,
    used_gb,
    allocated_gb,
    free_gb,

    ROUND(
        (used_gb / NULLIF(allocated_gb, 0)) * 100,
        2
    ) AS utilization_percent

FROM fact_storage

WHERE date = (
    SELECT MAX(date)
    FROM fact_storage
)

ORDER BY utilization_percent DESC;

--======================================
WITH storage_start AS
(
    SELECT DISTINCT ON (database_id)
        database_id,
        used_gb AS starting_used_gb
    FROM fact_storage
    ORDER BY database_id, date
),

storage_end AS
(
    SELECT DISTINCT ON (database_id)
        database_id,
        used_gb AS ending_used_gb
    FROM fact_storage
    ORDER BY database_id, date DESC
)

SELECT
    s.database_id,
    ROUND(s.starting_used_gb, 2) AS starting_used_gb,
    ROUND(e.ending_used_gb, 2) AS ending_used_gb,

    ROUND(
        e.ending_used_gb - s.starting_used_gb,
        2
    ) AS storage_growth_gb

FROM storage_start s

JOIN storage_end e
    ON s.database_id = e.database_id

ORDER BY storage_growth_gb DESC;

--===================================
SELECT
    database_id,
    date,
    used_gb,
    allocated_gb,
    free_gb

FROM fact_storage

WHERE free_gb < 200

ORDER BY free_gb ASC;

--========================================
SELECT COUNT(*) AS invalid_storage_rows
FROM fact_storage
WHERE used_gb > allocated_gb;

SELECT COUNT(*) AS invalid_free_gb
FROM fact_storage
WHERE ABS(
    free_gb - (allocated_gb - used_gb)
) > 0.01;

SELECT
    COUNT(DISTINCT database_id) AS database_count,
    MIN(date) AS first_date,
    MAX(date) AS last_date,
    COUNT(*) AS total_records
FROM fact_storage;

CREATE TABLE fact_cost
(
    cost_id BIGINT PRIMARY KEY,

    database_id INTEGER NOT NULL,

    month DATE NOT NULL,

    compute_cost DECIMAL(12,2) NOT NULL,

    storage_cost DECIMAL(12,2) NOT NULL,

    backup_cost DECIMAL(12,2) NOT NULL,

    total_cost DECIMAL(12,2) NOT NULL,

    transaction_count BIGINT NOT NULL
);

ALTER TABLE fact_cost
ADD CONSTRAINT fk_cost_database
FOREIGN KEY (database_id)
REFERENCES dim_database(database_id);

SELECT COUNT(*) AS total_cost_records
FROM fact_cost;

SELECT *
FROM fact_cost
LIMIT 10;

SELECT
    COUNT(*) AS invalid_total_cost
FROM fact_cost
WHERE ABS(
    total_cost
    - (
        compute_cost
        + storage_cost
        + backup_cost
      )
) > 0.01;

SELECT
    database_id,
    month,
    total_cost,
    transaction_count,

    ROUND(
        total_cost / NULLIF(transaction_count, 0),
        4
    ) AS cost_per_transaction

FROM fact_cost

ORDER BY cost_per_transaction DESC;


SELECT
    month,

    ROUND(
        SUM(compute_cost),
        2
    ) AS total_compute_cost,

    ROUND(
        SUM(storage_cost),
        2
    ) AS total_storage_cost,

    ROUND(
        SUM(backup_cost),
        2
    ) AS total_backup_cost,

    ROUND(
        SUM(total_cost),
        2
    ) AS total_cost

FROM fact_cost

GROUP BY month

ORDER BY month;

SELECT
    database_id,

    ROUND(
        SUM(compute_cost),
        2
    ) AS compute_cost,

    ROUND(
        SUM(storage_cost),
        2
    ) AS storage_cost,

    ROUND(
        SUM(backup_cost),
        2
    ) AS backup_cost,

    ROUND(
        SUM(total_cost),
        2
    ) AS total_cost

FROM fact_cost

GROUP BY database_id

ORDER BY total_cost DESC;


SELECT
    database_id,

    ROUND(
        SUM(total_cost),
        2
    ) AS total_cost,

    SUM(transaction_count) AS total_transactions,

    ROUND(
        SUM(total_cost)
        / NULLIF(SUM(transaction_count), 0),
        4
    ) AS cost_per_transaction

FROM fact_cost

GROUP BY database_id

ORDER BY cost_per_transaction DESC;


SELECT
    month,
    ROUND(
        SUM(total_cost),
        2
    ) AS total_cost,

    LAG(
        SUM(total_cost)
    ) OVER (
        ORDER BY month
    ) AS previous_month_cost

FROM fact_cost

GROUP BY month

ORDER BY month;


SELECT
    month,
    total_cost,
    previous_month_cost,

    ROUND(
        (
            (total_cost - previous_month_cost)
            / NULLIF(previous_month_cost, 0)
        ) * 100,
        2
    ) AS cost_growth_percent

FROM
(
    SELECT
        month,

        SUM(total_cost) AS total_cost,

        LAG(
            SUM(total_cost)
        ) OVER (
            ORDER BY month
        ) AS previous_month_cost

    FROM fact_cost

    GROUP BY month
) x

ORDER BY month;


SELECT
    COUNT(*) AS total_rows,

    COUNT(*) - COUNT(cost_id)
        AS missing_cost_id,

    COUNT(*) - COUNT(database_id)
        AS missing_database_id,

    COUNT(*) - COUNT(month)
        AS missing_month,

    COUNT(*) - COUNT(total_cost)
        AS missing_total_cost,

    COUNT(*) - COUNT(transaction_count)
        AS missing_transaction_count

FROM fact_cost;

SELECT COUNT(*) AS invalid_cost_rows
FROM fact_cost
WHERE
    compute_cost < 0
    OR storage_cost < 0
    OR backup_cost < 0
    OR total_cost < 0
    OR transaction_count < 0;


SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT database_id) AS databases,
    COUNT(DISTINCT month) AS months,

    ROUND(
        SUM(total_cost),
        2
    ) AS overall_cost,

    SUM(transaction_count) AS overall_transactions

FROM fact_cost;


--==========================================================
SELECT 'dim_database' AS table_name, COUNT(*) AS row_count
FROM dim_database

UNION ALL

SELECT 'dim_application', COUNT(*)
FROM dim_application

UNION ALL

SELECT 'dim_sla', COUNT(*)
FROM dim_sla

UNION ALL

SELECT 'fact_performance_metrics', COUNT(*)
FROM fact_performance_metrics

UNION ALL

SELECT 'fact_query_performance', COUNT(*)
FROM fact_query_performance

UNION ALL

SELECT 'fact_transactions', COUNT(*)
FROM fact_transactions

UNION ALL

SELECT 'fact_incidents', COUNT(*)
FROM fact_incidents

UNION ALL

SELECT 'fact_storage', COUNT(*)
FROM fact_storage

UNION ALL

SELECT 'fact_cost', COUNT(*)
FROM fact_cost

ORDER BY table_name;

--=============================================
SELECT
    database_id,
    COUNT(*) AS duplicate_count
FROM dim_database
GROUP BY database_id
HAVING COUNT(*) > 1;

SELECT
    application_id,
    COUNT(*) AS duplicate_count
FROM dim_application
GROUP BY application_id
HAVING COUNT(*) > 1;

SELECT
    transaction_id,
    COUNT(*) AS duplicate_count
FROM fact_transactions
GROUP BY transaction_id
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS invalid_database_ids
FROM fact_performance_metrics f
LEFT JOIN dim_database d
    ON f.database_id = d.database_id
WHERE d.database_id IS NULL;

SELECT COUNT(*) AS invalid_database_ids
FROM fact_query_performance f
LEFT JOIN dim_database d
    ON f.database_id = d.database_id
WHERE d.database_id IS NULL;

SELECT COUNT(*) AS invalid_database_ids
FROM fact_transactions f
LEFT JOIN dim_database d
    ON f.database_id = d.database_id
WHERE d.database_id IS NULL;

SELECT COUNT(*) AS invalid_application_ids
FROM fact_transactions f
LEFT JOIN dim_application a
    ON f.application_id = a.application_id
WHERE a.application_id IS NULL;

SELECT COUNT(*) AS invalid_database_ids
FROM fact_incidents f
LEFT JOIN dim_database d
    ON f.database_id = d.database_id
WHERE d.database_id IS NULL;

SELECT COUNT(*) AS invalid_database_ids
FROM fact_storage f
LEFT JOIN dim_database d
    ON f.database_id = d.database_id
WHERE d.database_id IS NULL;

SELECT COUNT(*) AS invalid_database_ids
FROM fact_cost f
LEFT JOIN dim_database d
    ON f.database_id = d.database_id
WHERE d.database_id IS NULL;

SELECT
    COUNT(*) AS total_rows,

    COUNT(*) - COUNT(database_id)
        AS missing_database_id,

    COUNT(*) - COUNT(timestamp)
        AS missing_timestamp

FROM fact_performance_metrics;

SELECT
    COUNT(*) AS total_rows,

    COUNT(*) - COUNT(database_id)
        AS missing_database_id,

    COUNT(*) - COUNT(application_id)
        AS missing_application_id,

    COUNT(*) - COUNT(status)
        AS missing_status

FROM fact_transactions;

SELECT
    COUNT(*) AS total_rows,

    COUNT(*) - COUNT(database_id)
        AS missing_database_id,

    COUNT(*) - COUNT(severity)
        AS missing_severity,

    COUNT(*) - COUNT(resolution_time_minutes)
        AS missing_resolution

FROM fact_incidents;

SELECT COUNT(*) AS invalid_rows
FROM fact_storage
WHERE used_gb > allocated_gb;

SELECT COUNT(*) AS invalid_rows
FROM fact_storage
WHERE ABS(
    free_gb - (allocated_gb - used_gb)
) > 0.01;

SELECT COUNT(*) AS invalid_rows
FROM fact_cost
WHERE ABS(
    total_cost
    - (
        compute_cost
        + storage_cost
        + backup_cost
    )
) > 0.01;

SELECT COUNT(*) AS invalid_rows
FROM fact_cost
WHERE
    compute_cost < 0
    OR storage_cost < 0
    OR backup_cost < 0
    OR total_cost < 0
    OR transaction_count < 0;

SELECT DISTINCT status
FROM fact_transactions
WHERE status NOT IN ('Success', 'Failed');

SELECT COUNT(*) AS invalid_rows
FROM fact_transactions
WHERE duration_ms < 0;

SELECT DISTINCT severity
FROM fact_incidents
WHERE severity NOT IN
(
    'Low',
    'Medium',
    'High',
    'Critical'
);

SELECT COUNT(*) AS invalid_rows
FROM fact_incidents
WHERE
    downtime_minutes < 0
    OR resolution_time_minutes < 0;

SELECT DISTINCT performance_status
FROM fact_query_performance
WHERE performance_status NOT IN
(
    'Normal',
    'Slow',
    'Very Slow',
    'Critical'
);

SELECT COUNT(*) AS invalid_rows
FROM fact_query_performance
WHERE
    execution_count < 0
    OR avg_duration_ms < 0
    OR cpu_time_ms < 0
    OR logical_reads < 0
    OR logical_writes < 0
    OR rows_affected < 0
    OR wait_time_ms < 0;


SELECT
    'dim_database' AS table_name,
    COUNT(*) AS row_count
FROM dim_database

UNION ALL

SELECT
    'dim_application',
    COUNT(*)
FROM dim_application

UNION ALL

SELECT
    'dim_sla',
    COUNT(*)
FROM dim_sla

UNION ALL

SELECT
    'fact_performance_metrics',
    COUNT(*)
FROM fact_performance_metrics

UNION ALL

SELECT
    'fact_query_performance',
    COUNT(*)
FROM fact_query_performance

UNION ALL

SELECT
    'fact_transactions',
    COUNT(*)
FROM fact_transactions

UNION ALL

SELECT
    'fact_incidents',
    COUNT(*)
FROM fact_incidents

UNION ALL

SELECT
    'fact_storage',
    COUNT(*)
FROM fact_storage

UNION ALL

SELECT
    'fact_cost',
    COUNT(*)
FROM fact_cost

ORDER BY table_name;

SELECT
    COUNT(*) AS total_transactions
FROM fact_transactions;

SELECT
    COUNT(*) AS failed_transactions
FROM fact_transactions
WHERE status = 'Failed';

SELECT
    COUNT(*) AS total_transactions,

    COUNT(*) FILTER (
        WHERE status = 'Failed'
    ) AS failed_transactions,

    ROUND(
        100.0 *
        COUNT(*) FILTER (
            WHERE status = 'Failed'
        ) / COUNT(*),
        2
    ) AS failure_rate_percent

FROM fact_transactions;

SELECT
    COUNT(*) AS total_incidents
FROM fact_incidents;

SELECT
    ROUND(
        AVG(resolution_time_minutes),
        2
    ) AS mttr_minutes
FROM fact_incidents;


--============================
WITH latest_storage AS
(
    SELECT
        database_id,
        used_gb,
        allocated_gb
    FROM fact_storage
    WHERE date = (
        SELECT MAX(date)
        FROM fact_storage
    )
)

SELECT
    ROUND(
        100.0 * SUM(used_gb)
        / NULLIF(SUM(allocated_gb), 0),
        2
    ) AS storage_utilization_percent

FROM latest_storage;

SELECT
    ROUND(
        SUM(total_cost),
        2
    ) AS total_cost
FROM fact_cost;

SELECT
    ROUND(
        SUM(total_cost)
        / NULLIF(SUM(transaction_count), 0),
        4
    ) AS cost_per_transaction

FROM fact_cost;

--=======================
WITH transaction_kpi AS
(
    SELECT
        COUNT(*) AS total_transactions,

        COUNT(*) FILTER (
            WHERE status = 'Failed'
        ) AS failed_transactions,

        ROUND(
            100.0 *
            COUNT(*) FILTER (
                WHERE status = 'Failed'
            ) / COUNT(*),
            2
        ) AS failure_rate_percent

    FROM fact_transactions
),

incident_kpi AS
(
    SELECT
        COUNT(*) AS total_incidents,

        ROUND(
            AVG(resolution_time_minutes),
            2
        ) AS mttr_minutes

    FROM fact_incidents
),

storage_kpi AS
(
    SELECT
        ROUND(
            100.0 *
            SUM(used_gb)
            / NULLIF(SUM(allocated_gb), 0),
            2
        ) AS storage_utilization_percent

    FROM fact_storage

    WHERE date = (
        SELECT MAX(date)
        FROM fact_storage
    )
),

cost_kpi AS
(
    SELECT
        ROUND(
            SUM(total_cost),
            2
        ) AS total_cost,

        ROUND(
            SUM(total_cost)
            / NULLIF(SUM(transaction_count), 0),
            4
        ) AS cost_per_transaction

    FROM fact_cost
)

SELECT
    t.total_transactions,
    t.failed_transactions,
    t.failure_rate_percent,

    i.total_incidents,
    i.mttr_minutes,

    s.storage_utilization_percent,

    c.total_cost,
    c.cost_per_transaction

FROM transaction_kpi t

CROSS JOIN incident_kpi i

CROSS JOIN storage_kpi s

CROSS JOIN cost_kpi c;

--============================
SELECT
    database_id,

    ROUND(
        AVG(cpu_percent),
        2
    ) AS avg_cpu_percent,

    ROUND(
        MAX(cpu_percent),
        2
    ) AS max_cpu_percent

FROM fact_performance_metrics

GROUP BY database_id

ORDER BY avg_cpu_percent DESC;

SELECT
    database_id,

    ROUND(
        AVG(cpu_percent),
        2
    ) AS avg_cpu_percent

FROM fact_performance_metrics

GROUP BY database_id

HAVING AVG(cpu_percent) > 70

ORDER BY avg_cpu_percent DESC;


SELECT
    database_id,

    COUNT(*) AS query_count,

    ROUND(
        AVG(avg_duration_ms),
        2
    ) AS avg_query_duration_ms,

    ROUND(
        MAX(avg_duration_ms),
        2
    ) AS max_query_duration_ms

FROM fact_query_performance

GROUP BY database_id

ORDER BY avg_query_duration_ms DESC;


SELECT
    database_id,

    COUNT(*) AS problem_query_count

FROM fact_query_performance

WHERE performance_status IN
(
    'Very Slow',
    'Critical'
)

GROUP BY database_id

ORDER BY problem_query_count DESC;


SELECT
    database_id,

    COUNT(*) AS total_transactions,

    COUNT(*) FILTER (
        WHERE status = 'Failed'
    ) AS failed_transactions,

    ROUND(
        100.0 *
        COUNT(*) FILTER (
            WHERE status = 'Failed'
        ) / COUNT(*),
        2
    ) AS failure_rate_percent

FROM fact_transactions

GROUP BY database_id

ORDER BY failure_rate_percent DESC;

SELECT
    database_id,

    COUNT(*) AS incident_count,

    ROUND(
        SUM(downtime_minutes),
        2
    ) AS total_downtime_minutes

FROM fact_incidents

GROUP BY database_id

ORDER BY incident_count DESC;

--===========================

WITH cpu_analysis AS
(
    SELECT
        database_id,

        AVG(cpu_percent) AS avg_cpu_percent

    FROM fact_performance_metrics

    GROUP BY database_id
),

query_analysis AS
(
    SELECT
        database_id,

        AVG(avg_duration_ms) AS avg_query_duration_ms,

        COUNT(*) FILTER (
            WHERE performance_status IN
            (
                'Very Slow',
                'Critical'
            )
        ) AS slow_query_count

    FROM fact_query_performance

    GROUP BY database_id
),

transaction_analysis AS
(
    SELECT
        database_id,

        COUNT(*) AS total_transactions,

        COUNT(*) FILTER (
            WHERE status = 'Failed'
        ) AS failed_transactions

    FROM fact_transactions

    GROUP BY database_id
),

incident_analysis AS
(
    SELECT
        database_id,

        COUNT(*) AS incident_count,

        SUM(downtime_minutes) AS total_downtime_minutes

    FROM fact_incidents

    GROUP BY database_id
)

SELECT
    d.database_id,
    d.database_name,
    d.database_type,
    d.risk_level,

    ROUND(
        c.avg_cpu_percent,
        2
    ) AS avg_cpu_percent,

    ROUND(
        q.avg_query_duration_ms,
        2
    ) AS avg_query_duration_ms,

    q.slow_query_count,

    t.total_transactions,

    t.failed_transactions,

    ROUND(
        100.0 *
        t.failed_transactions
        / NULLIF(t.total_transactions, 0),
        2
    ) AS failure_rate_percent,

    i.incident_count,

    ROUND(
        i.total_downtime_minutes,
        2
    ) AS total_downtime_minutes

FROM dim_database d

LEFT JOIN cpu_analysis c
    ON d.database_id = c.database_id

LEFT JOIN query_analysis q
    ON d.database_id = q.database_id

LEFT JOIN transaction_analysis t
    ON d.database_id = t.database_id

LEFT JOIN incident_analysis i
    ON d.database_id = i.database_id

ORDER BY
    failure_rate_percent DESC;

--=====================================
WITH database_analysis AS
(
    SELECT
        d.database_id,
        d.database_name,

        AVG(p.cpu_percent) AS avg_cpu,

        AVG(q.avg_duration_ms) AS avg_query_duration,

        COUNT(DISTINCT q.query_id) FILTER (
            WHERE q.performance_status IN
            (
                'Very Slow',
                'Critical'
            )
        ) AS slow_queries,

        COUNT(t.transaction_id) AS total_transactions,

        COUNT(t.transaction_id) FILTER (
            WHERE t.status = 'Failed'
        ) AS failed_transactions,

        COUNT(DISTINCT i.incident_id) AS incidents,

        COALESCE(
            SUM(i.downtime_minutes),
            0
        ) AS downtime_minutes

    FROM dim_database d

    LEFT JOIN fact_performance_metrics p
        ON d.database_id = p.database_id

    LEFT JOIN fact_query_performance q
        ON d.database_id = q.database_id

    LEFT JOIN fact_transactions t
        ON d.database_id = t.database_id

    LEFT JOIN fact_incidents i
        ON d.database_id = i.database_id

    GROUP BY
        d.database_id,
        d.database_name
)

SELECT
    database_id,
    database_name,

    ROUND(avg_cpu, 2) AS avg_cpu,

    ROUND(avg_query_duration, 2)
        AS avg_query_duration_ms,

    total_transactions,
    failed_transactions,

    ROUND(
        100.0 *
        failed_transactions
        / NULLIF(total_transactions, 0),
        2
    ) AS failure_rate_percent,

    incidents,

    ROUND(
        downtime_minutes,
        2
    ) AS downtime_minutes,

    (
        CASE
            WHEN avg_cpu > 70
            THEN 1 ELSE 0
        END

        +

        CASE
            WHEN avg_query_duration > 1000
            THEN 1 ELSE 0
        END

        +

        CASE
            WHEN
                100.0 *
                failed_transactions
                / NULLIF(total_transactions, 0) > 3
            THEN 1 ELSE 0
        END

        +

        CASE
            WHEN incidents > 70
            THEN 1 ELSE 0
        END

        +

        CASE
            WHEN downtime_minutes > 500
            THEN 1 ELSE 0
        END
    ) AS risk_score

FROM database_analysis

ORDER BY risk_score DESC;

--===========================
SELECT
    CASE
        WHEN cpu_percent < 50 THEN 'Low CPU'
        WHEN cpu_percent < 70 THEN 'Medium CPU'
        WHEN cpu_percent < 85 THEN 'High CPU'
        ELSE 'Very High CPU'
    END AS cpu_category,

    COUNT(*) AS total_records,

    ROUND(AVG(cpu_percent), 2) AS avg_cpu_percent,

    SUM(errors) AS total_errors

FROM fact_performance_metrics

GROUP BY
    CASE
        WHEN cpu_percent < 50 THEN 'Low CPU'
        WHEN cpu_percent < 70 THEN 'Medium CPU'
        WHEN cpu_percent < 85 THEN 'High CPU'
        ELSE 'Very High CPU'
    END

ORDER BY
    avg_cpu_percent;

--========================
SELECT
    performance_status,

    COUNT(*) AS query_count,

    ROUND(
        AVG(avg_duration_ms),
        2
    ) AS avg_duration_ms,

    ROUND(
        MAX(avg_duration_ms),
        2
    ) AS max_duration_ms

FROM fact_query_performance

GROUP BY
    performance_status

ORDER BY
    avg_duration_ms;


--==================
SELECT
    d.database_name,

    COUNT(q.query_id) AS total_queries,

    ROUND(
        AVG(q.avg_duration_ms),
        2
    ) AS avg_query_duration_ms,

    COUNT(*) FILTER (
        WHERE q.performance_status IN ('Very Slow', 'Critical')
    ) AS slow_or_critical_queries

FROM fact_query_performance q

JOIN dim_database d
    ON q.database_id = d.database_id

GROUP BY
    d.database_name

ORDER BY
    avg_query_duration_ms DESC;

--================================
SELECT
    d.database_name,

    COUNT(i.incident_id) AS incident_count,

    ROUND(
        SUM(i.downtime_minutes),
        2
    ) AS total_downtime_minutes,

    ROUND(
        AVG(i.resolution_time_minutes),
        2
    ) AS avg_resolution_time_minutes

FROM fact_incidents i

JOIN dim_database d
    ON i.database_id = d.database_id

GROUP BY
    d.database_name

ORDER BY
    total_downtime_minutes DESC;

--==================================
SELECT
    d.database_name,

    ROUND(AVG(s.used_gb), 2) AS avg_used_gb,

    ROUND(AVG(s.allocated_gb), 2) AS avg_allocated_gb,

    ROUND(AVG(s.free_gb), 2) AS avg_free_gb,

    ROUND(
        AVG(s.used_gb / NULLIF(s.allocated_gb, 0)) * 100,
        2
    ) AS storage_utilization_percent

FROM fact_storage s

JOIN dim_database d
    ON s.database_id = d.database_id

GROUP BY
    d.database_name

ORDER BY
    storage_utilization_percent DESC;

--===========================================
SELECT
    d.database_name,

    ROUND(
        AVG(s.used_gb),
        2
    ) AS avg_used_gb,

    ROUND(
        AVG(s.allocated_gb),
        2
    ) AS avg_allocated_gb,

    ROUND(
        AVG(s.used_gb / NULLIF(s.allocated_gb, 0)) * 100,
        2
    ) AS utilization_percent,

    CASE
        WHEN AVG(s.used_gb / NULLIF(s.allocated_gb, 0)) * 100 >= 90
            THEN 'Critical'

        WHEN AVG(s.used_gb / NULLIF(s.allocated_gb, 0)) * 100 >= 80
            THEN 'High'

        WHEN AVG(s.used_gb / NULLIF(s.allocated_gb, 0)) * 100 >= 70
            THEN 'Medium'

        ELSE 'Low'
    END AS capacity_risk

FROM fact_storage s

JOIN dim_database d
    ON s.database_id = d.database_id

GROUP BY
    d.database_name

ORDER BY
    utilization_percent DESC;

--======================================
WITH storage_start AS
(
    SELECT DISTINCT ON (database_id)
        database_id,
        date,
        used_gb
    FROM fact_storage
    ORDER BY
        database_id,
        date ASC
),

storage_end AS
(
    SELECT DISTINCT ON (database_id)
        database_id,
        date,
        used_gb
    FROM fact_storage
    ORDER BY
        database_id,
        date DESC
)

SELECT
    d.database_name,

    ROUND(
        s1.used_gb,
        2
    ) AS starting_used_gb,

    ROUND(
        s2.used_gb,
        2
    ) AS ending_used_gb,

    ROUND(
        s2.used_gb - s1.used_gb,
        2
    ) AS growth_gb,

    ROUND(
        (
            (s2.used_gb - s1.used_gb)
            / NULLIF(s1.used_gb, 0)
        ) * 100,
        2
    ) AS growth_percent

FROM storage_start s1

JOIN storage_end s2
    ON s1.database_id = s2.database_id

JOIN dim_database d
    ON s1.database_id = d.database_id

ORDER BY
    growth_percent DESC;

--====================================
SELECT
    d.database_name,

    ROUND(
        SUM(c.compute_cost),
        2
    ) AS total_compute_cost,

    ROUND(
        SUM(c.storage_cost),
        2
    ) AS total_storage_cost,

    ROUND(
        SUM(c.backup_cost),
        2
    ) AS total_backup_cost,

    ROUND(
        SUM(c.total_cost),
        2
    ) AS total_cost

FROM fact_cost c

JOIN dim_database d
    ON c.database_id = d.database_id

GROUP BY
    d.database_name

ORDER BY
    total_cost DESC;

--=========================
SELECT
    d.database_name,

    SUM(c.total_cost) AS total_cost,

    SUM(c.transaction_count) AS total_transactions,

    ROUND(
        SUM(c.total_cost)
        / NULLIF(SUM(c.transaction_count), 0),
        4
    ) AS cost_per_transaction

FROM fact_cost c

JOIN dim_database d
    ON c.database_id = d.database_id

GROUP BY
    d.database_name

ORDER BY
    cost_per_transaction DESC;

--=====================
SELECT
    month,

    ROUND(
        SUM(compute_cost),
        2
    ) AS compute_cost,

    ROUND(
        SUM(storage_cost),
        2
    ) AS storage_cost,

    ROUND(
        SUM(backup_cost),
        2
    ) AS backup_cost,

    ROUND(
        SUM(total_cost),
        2
    ) AS total_cost

FROM fact_cost

GROUP BY
    month

ORDER BY
    month;
--==============================
SELECT
    severity,

    COUNT(*) AS incident_count,

    ROUND(
        AVG(downtime_minutes),
        2
    ) AS avg_downtime_minutes,

    ROUND(
        AVG(resolution_time_minutes),
        2
    ) AS avg_resolution_time_minutes

FROM fact_incidents

GROUP BY
    severity

ORDER BY
    CASE severity
        WHEN 'Critical' THEN 1
        WHEN 'High' THEN 2
        WHEN 'Medium' THEN 3
        WHEN 'Low' THEN 4
    END;

--=============================
SELECT
    i.severity,

    COUNT(*) AS total_incidents,

    ROUND(
        AVG(i.resolution_time_minutes),
        2
    ) AS avg_resolution_minutes,

    s.resolution_target_minutes,

    COUNT(*) FILTER (
        WHERE i.resolution_time_minutes
              <= s.resolution_target_minutes
    ) AS incidents_within_sla,

    COUNT(*) FILTER (
        WHERE i.resolution_time_minutes
              > s.resolution_target_minutes
    ) AS incidents_breached_sla

FROM fact_incidents i

JOIN dim_sla s
    ON i.severity = s.severity

GROUP BY
    i.severity,
    s.resolution_target_minutes

ORDER BY
    CASE i.severity
        WHEN 'Critical' THEN 1
        WHEN 'High' THEN 2
        WHEN 'Medium' THEN 3
        WHEN 'Low' THEN 4
    END;

--=======================
SELECT
    i.severity,

    COUNT(*) AS total_incidents,

    COUNT(*) FILTER (
        WHERE i.resolution_time_minutes
              <= s.resolution_target_minutes
    ) AS incidents_within_sla,

    ROUND(
        COUNT(*) FILTER (
            WHERE i.resolution_time_minutes
                  <= s.resolution_target_minutes
        ) * 100.0
        / NULLIF(COUNT(*), 0),
        2
    ) AS sla_compliance_percent

FROM fact_incidents i

JOIN dim_sla s
    ON i.severity = s.severity

GROUP BY
    i.severity

ORDER BY
    sla_compliance_percent;

--=====================================
SELECT
    d.database_name,

    COUNT(i.incident_id) AS total_incidents,

    COUNT(*) FILTER (
        WHERE i.resolution_time_minutes
              <= s.resolution_target_minutes
    ) AS incidents_within_sla,

    COUNT(*) FILTER (
        WHERE i.resolution_time_minutes
              > s.resolution_target_minutes
    ) AS sla_breaches,

    ROUND(
        COUNT(*) FILTER (
            WHERE i.resolution_time_minutes
                  <= s.resolution_target_minutes
        ) * 100.0
        / NULLIF(COUNT(*), 0),
        2
    ) AS sla_compliance_percent

FROM fact_incidents i

JOIN dim_database d
    ON i.database_id = d.database_id

JOIN dim_sla s
    ON i.severity = s.severity

GROUP BY
    d.database_name

ORDER BY
    sla_compliance_percent;

--===================================
SELECT
    status,

    COUNT(*) AS incident_count,

    ROUND(
        SUM(downtime_minutes),
        2
    ) AS total_downtime_minutes,

    ROUND(
        AVG(resolution_time_minutes),
        2
    ) AS avg_resolution_minutes

FROM fact_incidents

GROUP BY
    status

ORDER BY
    incident_count DESC;

--============================
SELECT

    COUNT(*) AS total_incidents,

    COUNT(*) FILTER (
        WHERE i.resolution_time_minutes
              <= s.resolution_target_minutes
    ) AS incidents_within_sla,

    COUNT(*) FILTER (
        WHERE i.resolution_time_minutes
              > s.resolution_target_minutes
    ) AS sla_breaches,

    ROUND(
        COUNT(*) FILTER (
            WHERE i.resolution_time_minutes
                  <= s.resolution_target_minutes
        ) * 100.0
        / NULLIF(COUNT(*), 0),
        2
    ) AS sla_compliance_percent,

    ROUND(
        AVG(i.resolution_time_minutes),
        2
    ) AS avg_resolution_time_minutes,

    ROUND(
        SUM(i.downtime_minutes),
        2
    ) AS total_downtime_minutes

FROM fact_incidents i

JOIN dim_sla s
    ON i.severity = s.severity;

--==============================================

WITH performance AS
(
    SELECT
        database_id,

        ROUND(AVG(cpu_percent), 2) AS avg_cpu_percent,

        ROUND(AVG(memory_percent), 2) AS avg_memory_percent,

        ROUND(AVG(disk_io_percent), 2) AS avg_disk_io_percent

    FROM fact_performance_metrics

    GROUP BY database_id
),

queries AS
(
    SELECT
        database_id,

        COUNT(*) AS total_queries,

        ROUND(
            AVG(avg_duration_ms),
            2
        ) AS avg_query_duration_ms,

        COUNT(*) FILTER (
            WHERE performance_status IN ('Very Slow', 'Critical')
        ) AS slow_or_critical_queries

    FROM fact_query_performance

    GROUP BY database_id
),

transactions AS
(
    SELECT
        database_id,

        COUNT(*) AS total_transactions,

        COUNT(*) FILTER (
            WHERE status = 'Failed'
        ) AS failed_transactions,

        ROUND(
            COUNT(*) FILTER (
                WHERE status = 'Failed'
            ) * 100.0
            / NULLIF(COUNT(*), 0),
            2
        ) AS failure_rate_percent

    FROM fact_transactions

    GROUP BY database_id
),

incidents AS
(
    SELECT
        database_id,

        COUNT(*) AS incident_count,

        ROUND(
            SUM(downtime_minutes),
            2
        ) AS total_downtime_minutes,

        ROUND(
            AVG(resolution_time_minutes),
            2
        ) AS avg_resolution_time_minutes

    FROM fact_incidents

    GROUP BY database_id
),

storage AS
(
    SELECT
        database_id,

        ROUND(
            AVG(used_gb),
            2
        ) AS avg_used_gb,

        ROUND(
            AVG(used_gb / NULLIF(allocated_gb, 0)) * 100,
            2
        ) AS storage_utilization_percent

    FROM fact_storage

    GROUP BY database_id
),

cost AS
(
    SELECT
        database_id,

        ROUND(
            SUM(total_cost),
            2
        ) AS total_cost,

        ROUND(
            SUM(total_cost)
            / NULLIF(SUM(transaction_count), 0),
            4
        ) AS cost_per_transaction

    FROM fact_cost

    GROUP BY database_id
)

SELECT
    d.database_id,
    d.database_name,
    d.database_type,
    d.risk_level,
    d.environment,
    d.region,

    -- Performance
    p.avg_cpu_percent,
    p.avg_memory_percent,
    p.avg_disk_io_percent,

    -- Queries
    q.total_queries,
    q.avg_query_duration_ms,
    q.slow_or_critical_queries,

    -- Transactions
    t.total_transactions,
    t.failed_transactions,
    t.failure_rate_percent,

    -- Incidents
    i.incident_count,
    i.total_downtime_minutes,
    i.avg_resolution_time_minutes,

    -- Storage
    s.avg_used_gb,
    s.storage_utilization_percent,

    -- Cost
    c.total_cost,
    c.cost_per_transaction

FROM dim_database d

LEFT JOIN performance p
    ON d.database_id = p.database_id

LEFT JOIN queries q
    ON d.database_id = q.database_id

LEFT JOIN transactions t
    ON d.database_id = t.database_id

LEFT JOIN incidents i
    ON d.database_id = i.database_id

LEFT JOIN storage s
    ON d.database_id = s.database_id

LEFT JOIN cost c
    ON d.database_id = c.database_id

ORDER BY
    t.failure_rate_percent DESC;

--=========================================
WITH performance AS
(
    SELECT
        database_id,
        AVG(cpu_percent) AS avg_cpu
    FROM fact_performance_metrics
    GROUP BY database_id
),

queries AS
(
    SELECT
        database_id,
        AVG(avg_duration_ms) AS avg_query_duration
    FROM fact_query_performance
    GROUP BY database_id
),

transactions AS
(
    SELECT
        database_id,

        COUNT(*) AS total_transactions,

        COUNT(*) FILTER (
            WHERE status = 'Failed'
        ) AS failed_transactions

    FROM fact_transactions

    GROUP BY database_id
),

incidents AS
(
    SELECT
        database_id,

        COUNT(*) AS incident_count,

        SUM(downtime_minutes) AS total_downtime

    FROM fact_incidents

    GROUP BY database_id
),

storage AS
(
    SELECT
        database_id,

        AVG(
            used_gb / NULLIF(allocated_gb, 0)
        ) * 100 AS storage_utilization

    FROM fact_storage

    GROUP BY database_id
),

cost AS
(
    SELECT
        database_id,

        SUM(total_cost) AS total_cost

    FROM fact_cost

    GROUP BY database_id
)

SELECT
    d.database_name,

    ROUND(p.avg_cpu, 2) AS avg_cpu_percent,

    ROUND(q.avg_query_duration, 2)
        AS avg_query_duration_ms,

    ROUND(
        t.failed_transactions * 100.0
        / NULLIF(t.total_transactions, 0),
        2
    ) AS failure_rate_percent,

    i.incident_count,

    ROUND(i.total_downtime, 2)
        AS total_downtime_minutes,

    ROUND(s.storage_utilization, 2)
        AS storage_utilization_percent,

    ROUND(c.total_cost, 2)
        AS total_cost,

    (
        CASE
            WHEN p.avg_cpu > 70
            THEN 1
            ELSE 0
        END

        +

        CASE
            WHEN q.avg_query_duration > 1000
            THEN 1
            ELSE 0
        END

        +

        CASE
            WHEN t.failed_transactions * 100.0
                 / NULLIF(t.total_transactions, 0) > 3
            THEN 1
            ELSE 0
        END

        +

        CASE
            WHEN i.incident_count > 70
            THEN 1
            ELSE 0
        END

        +

        CASE
            WHEN i.total_downtime > 500
            THEN 1
            ELSE 0
        END

        +

        CASE
            WHEN s.storage_utilization > 80
            THEN 1
            ELSE 0
        END

        +

        CASE
            WHEN c.total_cost > 50000
            THEN 1
            ELSE 0
        END
    ) AS risk_score

FROM dim_database d

LEFT JOIN performance p
    ON d.database_id = p.database_id

LEFT JOIN queries q
    ON d.database_id = q.database_id

LEFT JOIN transactions t
    ON d.database_id = t.database_id

LEFT JOIN incidents i
    ON d.database_id = i.database_id

LEFT JOIN storage s
    ON d.database_id = s.database_id

LEFT JOIN cost c
    ON d.database_id = c.database_id

ORDER BY
    risk_score DESC;

--==================================
WITH performance AS
(
    SELECT
        database_id,
        AVG(cpu_percent) AS avg_cpu
    FROM fact_performance_metrics
    GROUP BY database_id
),

queries AS
(
    SELECT
        database_id,
        AVG(avg_duration_ms) AS avg_query_duration
    FROM fact_query_performance
    GROUP BY database_id
),

transactions AS
(
    SELECT
        database_id,
        COUNT(*) AS total_transactions,

        COUNT(*) FILTER (
            WHERE status = 'Failed'
        ) AS failed_transactions

    FROM fact_transactions
    GROUP BY database_id
),

incidents AS
(
    SELECT
        database_id,
        COUNT(*) AS incident_count,
        SUM(downtime_minutes) AS total_downtime

    FROM fact_incidents
    GROUP BY database_id
),

storage AS
(
    SELECT
        database_id,

        AVG(
            used_gb / NULLIF(allocated_gb, 0)
        ) * 100 AS storage_utilization

    FROM fact_storage
    GROUP BY database_id
),

cost AS
(
    SELECT
        database_id,
        SUM(total_cost) AS total_cost

    FROM fact_cost
    GROUP BY database_id
),

risk_data AS
(
    SELECT
        d.database_name,

        (
            -- 1️⃣ High CPU
            CASE
                WHEN p.avg_cpu > 70
                THEN 1
                ELSE 0
            END

            +

            -- 2️⃣ Slow Queries
            CASE
                WHEN q.avg_query_duration > 1000
                THEN 1
                ELSE 0
            END

            +

            -- 3️⃣ High Transaction Failure Rate
            CASE
                WHEN
                    t.failed_transactions * 100.0
                    / NULLIF(t.total_transactions, 0) > 3
                THEN 1
                ELSE 0
            END

            +

            -- 4️⃣ High Incident Count
            CASE
                WHEN i.incident_count > 70
                THEN 1
                ELSE 0
            END

            +

            -- 5️⃣ High Downtime
            CASE
                WHEN i.total_downtime > 500
                THEN 1
                ELSE 0
            END

            +

            -- 6️⃣ High Storage Utilization
            CASE
                WHEN s.storage_utilization > 80
                THEN 1
                ELSE 0
            END

            +

            -- 7️⃣ High Cost
            CASE
                WHEN c.total_cost > 50000
                THEN 1
                ELSE 0
            END
        ) AS risk_score

    FROM dim_database d

    LEFT JOIN performance p
        ON d.database_id = p.database_id

    LEFT JOIN queries q
        ON d.database_id = q.database_id

    LEFT JOIN transactions t
        ON d.database_id = t.database_id

    LEFT JOIN incidents i
        ON d.database_id = i.database_id

    LEFT JOIN storage s
        ON d.database_id = s.database_id

    LEFT JOIN cost c
        ON d.database_id = c.database_id
)

SELECT
    database_name,

    risk_score,

    CASE
        WHEN risk_score >= 6
            THEN 'Critical Risk'

        WHEN risk_score >= 4
            THEN 'High Risk'

        WHEN risk_score >= 2
            THEN 'Medium Risk'

        ELSE 'Low Risk'
    END AS risk_category

FROM risk_data

ORDER BY
    risk_score DESC,
    database_name;