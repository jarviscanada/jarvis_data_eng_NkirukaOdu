#!/bin/bash

psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

if [ $# -ne  5 ]; then
  echo "invalid number of arguments"
  exit 1
fi

hostname=$(hostname -f)
lscpu_out=$(lscpu)
minfo_out=$(cat /proc/meminfo)

cpu_number=$(echo "$lscpu_out" | grep "^CPU(s):" | awk '{ print $2 }')
cpu_architecture=$(echo "$lscpu_out" | grep "^Arch" | awk '{ print $2 }')
cpu_model=$(echo "$lscpu_out"  | grep -E "Model name:" | sed 's/Model name://g' | xargs)
cpu_mhz=$(echo "$lscpu_out"  | grep -E "CPU MHz:" | awk '{print $3}' | xargs)
l2_cache=$(echo "$lscpu_out"  | grep -E "L2 cache:" | awk '{print $3}' | sed 's/K//g' | xargs)
total_mem=$(echo "$minfo_out"  | grep -E "MemTotal:" | awk '{print $2}' | xargs)
timestamp=$(vmstat -t | tail -1 | awk '{print $(NF-1), $(NF)}')


insert_stmt=$(cat <<-END
INSERT INTO host_info
(hostname,cpu_number,cpu_architecture,cpu_model,cpu_mhz,l2_cache,total_mem,"timestamp")
VALUES
('$hostname','$cpu_number','$cpu_architecture','$cpu_model','$cpu_mhz','$l2_cache','$total_mem','$timestamp')
END
)


export PGPASSWORD=$psql_password
psql -h "$psql_host" -p "$psql_port" -d "$db_name" -U "$psql_user"  -c "$insert_stmt"

exit $?