#!/usr/bin/env bash
if [ ! -d ~/data/log ]; then
	mkdir -p ~/data/log || exit 1
fi

if [ ! -f ~/data/log/trace_exe.log ]; then
	touch ~/data/log/trace_exe.log || exit 1
fi

the_date=$(date "+%Y-%m-%d %H:%M:%S: ")
echo $the_date $0 $@ >> ~/data/log/trace_exe.log
cur_exe_path=$0
cur_exe_dir=$(cd $(dirname ${cur_exe_path}) && pwd)
cur_exe_name=$(basename ${cur_exe_path})
org_exe_full_path=${cur_exe_dir}/mycmds_org_${cur_exe_name}

if [ ! -e ${org_exe_full_path} ]; then
    echo "${org_exe_full_path} not exist!"
    exit 1
fi

if [ ! -x ${org_exe_full_path} ]; then
    echo "${org_exe_full_path} not executalbe!"
    exit 1
fi

exec ${org_exe_full_path} $@
