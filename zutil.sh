#!/bin/bash

function zupdate() {
  wget http://192.168.1.5:8008/D%3A/IdeaProjects/Markdown/zutil.sh -O $zutil.tmp
  if [ $(wc -l < $zutil.tmp) -ne 0 ]; then
    set -x
    mv $zutil.tmp ${zutil}
    set +x
  fi
  source ${zutil}
}

function zdir() {
  if [ $# == 0 ]; then
    cd $(readlink -m .)
    return
  elif [ -d "$1" ]; then
    cd $(readlink -m $1)
  else
    cd $(dirname $(readlink -m $1))
  fi
}

# 对于复杂的传参，自动收集参数 (function内使用)
# declare -A opts && _get_opts "$@"     # 收集关系参数
# pkg=${opts[--pkg]}                    # 有值参数，取值
# [ -n "${opts[-h]}" ] && echo hello    # 无值参数
# declare -a args && _get_opts "$@"     # 收集数组参数
# param=${args[0]}                      # 根据下标获取
function _get_opts() {
  # 收集数组参数
  local last_str
  local i=0
  local var
  for var in "$@"; do
      [[ ! ${var} =~ ^- ]] && [[ ! ${last_str} =~ ^- ]] && args[$((i++))]=$var
      last_str=${var}
  done
  # 收集关系参数
  while [[ $# -gt 0 ]]; do
    local key=$1
    local value=$2
    echo $key | grep -Eq '^-' && opts[$key]=$value
    if echo $value | grep -Eq '^-' || [ $# == 1 ]; then
      opts[$key]="#"
      shift 1
    else
      shift 2
    fi
  done
}

function zjad() {
  trap "rm -rf /tmp/jad_tmp /tmp/cfr-0.144.jar" RETURN SIGQUIT
  wget http://192.168.1.5:8008/D%3A/opt/cfr-0.144.jar -O /tmp/cfr-0.144.jar &> /dev/null
  PATH=$PATH:$(dirname $(ps -ef | grep -Eo "/[^ ]*/bin/java" | grep -Fv "*" | head -1))
  if [ $# -eq 2 ] && [[ $1 =~ \.jar$ ]]; then
    local jar_file=$1
    local class_file=$(unzip -l "$jar_file" | awk '{print $4}' | grep "$2")
    if [ -z "${class_file}" ] || [ $(echo "${class_file}" | wc -l) -gt 1 ]; then
      [ -n "${class_file}" ] && echo "${class_file}"
      echo "zjad failed. Please select one exist class file."
      return 1
    fi
    unzip -o $jar_file -d /tmp/jad_tmp &> /dev/null
    zjad /tmp/jad_tmp/${class_file}
  else
    java -jar /tmp/cfr-0.144.jar "$@" | less
  fi
}

# 从windows传文件到linux（使用everything软件的http服务器下载）
# zget "win_file_path" target_path target_path   # 下载到多个目标
# zget target_path                               # 从默认win路径下载到目标
# zget "win_file_path"                           # 下载到当前目录
function zget() {
  [ $# == 0 ] &&  zhelp "zget" && return
  local default_path="D:\\ftp"
  if [[ ! "$1" =~ "\\" ]] && [[ ! "$1" =~ "/"  ]]; then  # 仅文件名
    local file_path=$(echo "${default_path}\\$1" | sed 's#\\#/#g')
  elif [[ "$1" =~ "\\" ]]; then # win_path
    local file_path=$(echo "$1" | sed 's#\\#/#g' | sed 's/ /%20/g' | sed 's/%/%25/g')
  fi
  local file_name=$(echo "$file_path" | sed 's#.*/##' | sed 's/%20/ /g' | sed 's/%25/%/g')
  if [ $# -gt 1 ]; then  # zget win_file_path target_path
    shift
    local target
    for target in "$@"; do
      [ -d "${target}" ] && target="${target}/${file_name}"
      wget http://192.168.1.5:8008/${file_path} -O "${target}"
    done
  elif [[ "$1" =~ ^/ ]]; then # zget target_path
    zget $(basename $1) $1
  else  # zget win_file_path
    wget http://192.168.1.5:8008/${file_path} -O "${file_name}"
  fi
}

function zeval() {
  declare -A opts && _get_opts "$@"
  declare -a args && _get_opts "$@"
  local command="${args[@]}"
  local ssh_pwd=${opts[--pwd]}
  [ -z "${ssh_pwd}" ] && ssh_pwd="root123"
  expect -c '
    set timeout 2
    spawn '"${command}"'
    expect {
      "assword" {
        send '"${ssh_pwd}\r"'
        exp_continue
      }
      "yes/no" {
        send "yes\r"
        exp_continue
      }
    }
  '
}

function zdownload() {
  [ $# == 0 ] &&  zhelp "zdownload" && return
  local type="scp"
  local file_path=$1
  local file_new_name=$2
  local file_name=$(basename ${file_path})
  [ -n "${file_new_name}" ] && file_name=${file_new_name}
  # 使用scp上传文件，需windows开启ssh服务
  if [ "${type}" == "scp" ]; then
    zeval scp ${file_path} root@192.168.1.5:~/${file_name} --pwd root123
    return
  fi
  # 使用ftp上传文件，需windows开启ftp服务
  which ftp > /dev/null || return
  echo "open 192.168.1.5
  user ftpuser ftp123
  binary
  hash
  put ${file_path} ${file_name}
  quit" | ftp -n
  echo "Download finish. (${file_name})"
}

function zhelp() {
  local fun_name=$1
  local fun_line
  local remark
  local blank_str="                        "
  grep "^function " ${zutil} | while read -r fun_line; do
    [ -n "${fun_name}" ] && [[ ! "${fun_line}" =~ "${fun_name}" ]] && continue
    printf "%-100s\n" "-" | sed 's/ /-/g'
    remark=""
    local line_num=$(grep -n "^${fun_line}$" ${zutil} | awk -F':' '{print $1}')
    for ((line_num = line_num - 1; line_num > 0; line_num--)); do
      local line_str=$(sed -n "${line_num} p" ${zutil})
      if [ $(expr index "${line_str}" "#") -eq 1 ]; then
        remark=$(echo -e "${remark}\n${blank_str}${line_str}")
      else
        fun_line=$(echo ${fun_line} | awk '{print $2}' | sed 's/()//g')
        echo ${fun_line}"$(echo "${remark}" | tac)" | sed "1 s/${blank_str}/${blank_str:${#fun_line}}/g" | sed "s/ #/ /g"
        break
      fi
    done
  done
  printf "%-100s\n" "-" | sed 's/ /-/g'
}

function zfind() {
  if [[ $# -gt 1 && $2 != -* ]]; then
    local name=$1
    local grep_str=$2
    shift 2
    local cmd="find $(pwd) -name \"$name\" | xargs grep --color -n \"${grep_str}\" $@"
    echo "$cmd"
    eval "$cmd"
    return
  fi
  if [[ $# -gt 0 && $1 != -* ]]; then
    local name=$1
    shift
    local ext=$@
    local is_cd=false
    [[ "${ext}" =~ "-ls" ]] && ext=${ext//"-ls"/}" -exec ls -lh {} +"
    [[ "${ext}" =~ "-cd" ]] && ext=${ext//"-cd"/"-type d"} && is_cd=true
    local cmd="find $(pwd) -name \"$name\" $ext"
    echo "$cmd"
    local result=$(eval "$cmd")
    [ -n "${result}" ] && echo "${result}"
    r=$(echo "${result}" | tail -1)
    [ -n "${r}" ] && [ "${is_cd}" == "true" ] && cd ${r}
    return
  fi
  find $(pwd) "$@"
}

# 工具安装和初始化
function zmain() {
  if [[ "$0" =~ "zutil.sh" ]]; then # sh zutil.sh
    local zutil=$(readlink -m $0)
    local profile=/root/.bashrc
    local add_str="[ -f ${zutil} ] && source ${zutil} &>/dev/null ; echo zutil-add >/dev/null"
    [ ! -f ${profile} ] && touch ${profile}
    if grep -q "zutil-add" ${profile}; then
      echo "Replace config to ${profile}"
      sed -i "/zutil-add/c ${add_str}" ${profile}
    else
      echo "Add config to ${profile}"
      echo -e "\n${add_str}" >> ${profile}
    fi
    echo "${add_str}"
  else # source zutil.sh
    zutil=$(readlink -m ${BASH_SOURCE[0]})
    alias cdz='cd /tmp/zzj/'
    complete -W "$(cat ${zutil} | grep "^function [^()]*" -Eo | awk '{print $2}' | xargs)" zhelp
  fi
}

zmain "$@"
