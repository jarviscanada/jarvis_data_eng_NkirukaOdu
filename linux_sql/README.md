# Introduction
Administrator (LCA) to monitor the usage of the hardware components of the servers. This hardware information provided by the LCMA includes the hostname, 
CPU number,  Cpu architecture, CPU model, CPU Mhz, and L2_cache, while the usage information provides details of memory usage, number of idle CPU, CPU
kernel, disk io, and the available disks used up by a particular host. The LCMA uses crontab to provide real-time analytics about the server hardware
utilization. The server hardware and the resource usage details are stored in the host_agent database for further reference and management.
Having good knowledge about the hardware specification and its utilization will help the LCA to understand how to manage the server resources better, 
and to avoid overutilization/underutilization.

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
This section presents the architectural diagram of the LMCA, the script used to implement the project, and the database schema that describes how the
data was modeled.

***Five scripts were used to implement the LCMA, they include***
- psql_docker.sh
- host_info.sh
- host_usage.sh
- crontab
- queries.sql 
This section presents the architectural diagram of the LMCA, the script used to implement the project, and the database schema that describes how the 
data was modeled. Every server on the Linux cluster shares ```host_info.sh``` and ```host_usage.sh``` scripts. The ```psql_docker.sh``` is used to create a Postgresql 
container. The ```ddl.sql``` is used to create tables, and the host_info and host_usage scripts are used to insert hardware specification information and the
resource usage information to the created tables.  The ```queries.sql``` is used to fetch data from the tables for analytics while the ```crontab``` was 
setup to automate the resource usage timestamp for every 5minute

## Architecture
This shows architecure of the cluster  with three Linux hosts, a Database, and agents(LCA)

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
