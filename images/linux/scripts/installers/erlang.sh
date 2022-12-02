#!/bin/bash -e
################################################################################
##  File:  erlang.sh
##  Desc:  Installs erlang
################################################################################

# Source the helpers for use with the script
source $HELPER_SCRIPTS/install.sh
source $HELPER_SCRIPTS/os.sh

source_list=/etc/apt/sources.list.d/eslerlang.list
source_key=/usr/share/keyrings/eslerlang.gpg

# Install Erlang
if isUbuntu22; then
    #echo "deb [signed-by=/usr/share/keyrings/eslerlang.gpg] https://packages.erlang-solutions.com/ubuntu focal contrib" | tee $source_list
    #wget -qO- https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | gpg --dearmor | tee $source_key
    wget -qO- https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/erlang.gpg
    apt-get update
    apt-get install -y erlang
else
    wget -q -O - https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | gpg --dearmor > $source_key
    echo "deb [signed-by=$source_key]  https://packages.erlang-solutions.com/ubuntu $(lsb_release -cs) contrib" > $source_list
    apt-get update
    apt-get install -y --no-install-recommends esl-erlang
fi

# Install rebar3
rebar3_url="https://github.com/erlang/rebar3/releases/latest/download/rebar3"
download_with_retries $rebar3_url "/usr/local/bin" "rebar3"
chmod +x /usr/local/bin/rebar3

# Clean up source list
rm $source_list
rm $source_key

invoke_tests "Tools" "erlang"
