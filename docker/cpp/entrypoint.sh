#!/bin/bash -eE

# Copyright 2020 TON DEV SOLUTIONS LTD.
#
# Licensed under the SOFTWARE EVALUATION License (the "License"); you may not use
# this file except in compliance with the License.  You may obtain a copy of the
# License at:
#
# https://www.ton.dev/licenses
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific TON DEV software governing permissions and limitations
# under the License.

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
# shellcheck source=env.sh
. "${SCRIPT_DIR}/env.sh"

[ ! -f "${TON_WORK_DIR}/done" ] && echo "INFO: setup TON node..." \
&& echo "INFO: MY_ADDR = ${MY_ADDR}:${ADNL_PORT}" \
&& mkdir -p "${TON_WORK_DIR}" \
&& > ${TON_WORK_DIR}/done \
&& mkdir -p "${TON_WORK_DIR}/etc" \
&& mkdir -p "${TON_WORK_DIR}/db" \
&& cp "${CONFIGS_DIR}/ton-global.config.json" "${TON_WORK_DIR}/etc/ton-global.config.json" \
&& echo "INFO: generate initial ${TON_WORK_DIR}/db/config.json..." \
&& "${TON_BUILD_DIR}/validator-engine/validator-engine" -C "${TON_WORK_DIR}/etc/ton-global.config.json" --db "${TON_WORK_DIR}/db" --ip "${MY_ADDR}:${ADNL_PORT}" \
&& cp "${KEYS_DIR}/server" "${TON_WORK_DIR}/db/keyring/$(awk '{print $1}' "${KEYS_DIR}/keys_s")" \
&& cp "${KEYS_DIR}/liteserver" "${TON_WORK_DIR}/db/keyring/$(awk '{print $1}' "${KEYS_DIR}/keys_l")" \
&& awk '{
    if (NR == 1) {
        server_id = $2
    } else if (NR == 2) {
        client_id = $2
    } else if (NR == 3) {
        liteserver_id = $2
    } else {
        print $0;
        if ($1 == "\"control\"") {
            print "      {";
            print "         \"id\": \"" server_id "\","
            print "         \"port\": 3030,"
            print "         \"allowed\": ["
            print "            {";
            print "               \"id\": \"" client_id "\","
            print "               \"permissions\": 15"
            print "            }";
            print "         ]"
            print "      }";
        } else if ($1 == "\"liteservers\"") {
            print "      {";
            print "         \"id\": \"" liteserver_id "\","
            print "         \"port\": 3031"
            print "      }";
        }
    }
}' "${KEYS_DIR}/keys_s" "${KEYS_DIR}/keys_c" "${KEYS_DIR}/keys_l" "${TON_WORK_DIR}/db/config.json" > "${TON_WORK_DIR}/db/config.json.tmp" \
&& mv "${TON_WORK_DIR}/db/config.json.tmp" "${TON_WORK_DIR}/db/config.json"

find "${TON_WORK_DIR}"
echo "INFO: setup TON node... DONE"

echo "INFO: start TON node..."
echo "INFO: logs to stdout/stderr"
"${TON_BUILD_DIR}/validator-engine/validator-engine" -C "${TON_WORK_DIR}/etc/ton-global.config.json" --db "${TON_WORK_DIR}/db" > /dev/stdout 2> /dev/stderr
