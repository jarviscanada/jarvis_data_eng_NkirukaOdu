<<<<<<< HEAD
nux Cluster Monitoring Agent ```

# Introduction
The Linux Cluster Monitoring Agent (LCMA) involves clusters of nodes that runs on centos7 through Google cloud platform. It is used by the Linux Cluster Administrator (LCA) to monitor the usage of the hardware components of the servers. This hardware information provided by the LCMA includes the host-name,cpu number,cpu architecture,cpu model,cpu mhz,L2_cache, while the usage information provides details of memory usage, number of idle cpu, cpu kernel, disk io, and the available disks used up by a particular host. The LCMA uses crontab to provide a real time analytics about the server hardware utilisation. The server hardware and the resource usage details are stored in the host_agent database for further reference and management. 
Having good knowledge about the hardware specification and its utilisation will help the LCA to understand how to manage the server resources better, to avoid over utilisation/under utilisation.

***Technologies used in this project include:***
- Google Cloud Platform (GCP)
- Docker 
- Bash 
- SQL (PostgreSQL) 
- Git

# Quick Start

- Start a psql instance using psql_docker.sh
``` 
./scripts/psql_docker.sh create db_username db_password 
```

``` 
./scripts/psql_docker.sh start 
```

``` 
./scripts/psql_docker.sh stop
```

- Create tables using ddl.sql

``` 
psql -h localhost -U postgres -d host_agent -f sql/ddl.sql 
```

- Insert hardware specs data into the DB using host_info.sh
``` 
./scripts/host_info.sh psql_host psql_port db_name psql_user psql_password 
```

- Insert hardware usage data into the DB using host_usage.sh
```
.scripts/host_usage.sh psql_host psql_port db_name psql_user psql_password
```

- Crontab setup
```
* * * * * bash /home/centos/dev/jrvs/bootcamp/linux_sql/host_agent/scripts/host_usage.sh localhost 5432 host_agent 
postgres password > /tmp/host_usage.log
```
# Implementation
This section presents the architectural diagram of the LMCA, the script used to implement the project, and the database schema that describes how the data was modeled. Every server on the Linux cluster shares ```host_info.sh``` and ```host_usage.sh``` scripts. The ```psql_docker.sh``` is used to create a Postgresql 
container. The ```ddl.sql``` is used to create tables, and the host_info and host_usage scripts are used to insert hardware specification information and the
resource usage information to the created tables.  The ```queries.sql``` is used to fetch data from the tables for analytics while the ```crontab``` was 
setup to automate the resource usage timestamp for every 5minute

***Six scripts were used to implement the LCMA, they include***
- psql_docker.sh
- host_info.sh
- host_usage.sh
- ddl.sql
- crontab
- queries.sql 


## Architecture
This shows architecure of the cluster  with three Linux hosts, a Database, and agents(LCA)

![my image](./assets/lmca.png)

## Scripts

- psql_docker.sh
This script is used to setup a psql instance using docker,as well as starting and stopping a docker. 



- host_info.sh

The script collects the hardware specification data and then stores the collected data into the psql database. This script is expected to execute just 
once for each hostname(host)
```
./scripts/host_info.sh psql_host psql_port db_name psql_user psql_password
```

- host_usage.sh

This script collects the real server utilization data and sends the data to the database
```
.scripts/host_usage.sh psql_host psql_port db_name psql_user psql_password
```

- crontab

This script is used to automate the host_usage script to always provide the resourse usage data for every five minutes.
```
* * * * * bash /home/centos/dev/jrvs/bootcamp/linux_sql/host_agent/scripts/host_usage.sh localhost 5432 host_agent postgres password 
/tmp/host_usage.log
```
## Database Modeling
The database(host_agent) has two tables namely: host_info, host_usage 
- `host_info`
The table below explains the schema of the host_info table


| S/N         | Column Name | Datatype | Constraint | Description |
| ----------- | -----------| -------- | ----------- | ----------- |
| 1| Id | Serial | PRIMARY KEY (not null) | Unique name that identifies each host on the server |
| 2 | Host name | Varchar | not null | Hostname for each server |
| 3 |cpu_number | int |  not null |  not null | shows the number of cores |
| 4 | cpu_architecture | varchar |  not null | shows the cpu architecture |
| 5 | cpu_model | varchar |  not null | shows the cpu model |
| 6 | cpu_mhz | float |  not null | shows the clock of the cpu in mhz |
| 7 | L2_cache | int |  not null | shows the size of L2 cache in KB |
| 8 | total_mem | int |  not null | shows the server memory in MB |
|9| time stamp | timestamp | not null | shows the time the hardware information was taken |


- `host_usage`

| S/N         | Column Name | Datatype | Constraint | Description |
| ----------- | -----------| -------- | ----------- | ----------- |
| 1| host_id | Serial | FOREIGN KEY (not null) | Host ID from the host_info table |
| 2 | timestamp | timestamp |  not null | shows the current time of  the resource usage information|
| 3 | memory_free | int | not null | not null | Shows the amount of free memory in MB |
| 4 | cpu_idle | small int |  not null | shows the percentage of idle cpu |
| 5 | cpu_kernel | small int |  not null | shows the percentage of cpu kernel |
| 6 | disk_io | small int |  not null | shows the number of disk io
| 7 | disk_available | int |  not null | shows the available disk in MB |


# Test
Each scripts was tested on the terminal to ensure that they are working properly. The following commands was used to execute the lcma:

- start docker

``` script/psql_docker.sh start postgres password ```
- execute the ddl.sql on the terminal

```psql -h localhost -U postgres -d host_agent -f sql/ddl.sql```

- execute the host_info.sh & host_usage.sh on the terminal

```bash scripts/host_info.sh localhost 5432 host_agent postgres password```  
```bash scripts/host_usage.sh localhost 5432 host_agent postgres password ```

- execute the queries.sql on the terminal

``` psql -h localhost -U postgres -d host_agent -f sql/queries.sql ```

# Deployment
The LMCA is automatically executed using crontab. The Github is used to managed the source code, while the Database provisioning is performed through the Docker.

# Improvements
The objetive of the project was well achieved but there are more to be done to add more functionalities to the LCMA
- Creates a table that computes the most busy and idel time of the cpu
- Add more data to be collected by the LCMA
- Build anlytics system that provides better insights on the hardwarre and its  usage
=======

>>>>>>> feature/bsa_profile
