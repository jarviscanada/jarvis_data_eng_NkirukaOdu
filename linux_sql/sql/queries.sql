-- 1 group hosts by hardware info
SELECT
	cpu_number,
	id as host_id,
	total_mem,
	ROW_NUMBER () OVER ( PARTITION BY cpu_number ORDER BY total_mem DESC) AS rownumber
FROM
	host_info;

-- 2 Average memory Usage
SELECT host_usage.host_id,
       host_info.hostname,
       date_trunc('hour', host_usage.timestamp) + date_part('minute', host_usage.timestamp):: int / 5 * interval '5 min' AS ts,
				--used mem = total memory - free memory
       avg(1.0*(host_info.total_mem - host_usage.memory_free)/host_info.total_mem) AS avg_used_mem_percentage
FROM host_usage
         JOIN host_info ON host_usage.host_id = host_info.id
GROUP BY host_usage.host_id,host_info.hostname, ts
ORDER BY host_usage.host_id;


--create a fxn round5 to round timestamp to the nearest 5 min interval
CREATE FUNCTION round5(ts timestamp) RETURNS timestamp AS
$$
BEGIN
    RETURN date_trunc('hour', ts) + date_part('minute', ts):: int / 5 * interval '5 min';
END;
$$
    LANGUAGE PLPGSQL;

-- verify round5 function
SELECT
    host_id,
    round5(timestamp) AS "timestamp"
    COUNT(*) AS point_nos
FROM host_usage
    GROUP BY host_id, "timestamp" HAVING COUNT(*) < 3;
