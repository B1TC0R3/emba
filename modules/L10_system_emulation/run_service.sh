#!/firmadyne/sh

# Copyright (c) 2015 - 2016, Daming Dominic Chen
# Copyright (c) 2017 - 2020, Mingeun Kim, Dongkwan Kim, Eunsoo Kim
# Copyright (c) 2022 - 2024 Siemens Energy AG
#
# This script is based on the original scripts from the firmadyne and firmAE project
# Original firmadyne project can be found here: https://github.com/firmadyne/firmadyne
# Original firmAE project can be found here: https://github.com/pr0v3rbs/FirmAE

BUSYBOX=/firmadyne/busybox
# we should build a real and useful PATH ... currently it is just guessing
export PATH="${PATH}":/bin/:/sbin/:/usr/bin/:/usr/sbin:/usr/local/bin:/usr/local/sbin

# "${BUSYBOX}" touch /firmadyne/EMBA_service_init_done
ORANGE="\033[0;33m"
NC="\033[0m"

"${BUSYBOX}" echo -e "${ORANGE}[*] Starting services in emulated environment...${NC}"
"${BUSYBOX}" cat /firmadyne/service

if ("${EMBA_ETC}"); then
  # first, the system should do the job by itself
  # after 100sec we jump in with our service helpers
  "${BUSYBOX}" echo -e "${ORANGE}[*] Waiting 30sec before helpers starting services in emulated environment...${NC}"
  "${BUSYBOX}" sleep 30
  # some rules we need to apply for different services:
  if "${BUSYBOX}" grep -q lighttpd /firmadyne/service; then
    # ensure we have the pid file for lighttpd:
    "${BUSYBOX}" echo "[*] Creating pid directory for lighttpd service"
    "${BUSYBOX}" mkdir -p /var/run/lighttpd 2>/dev/null
  fi
  if "${BUSYBOX}" grep -q twonkystarter /firmadyne/service; then
    mkdir -p /var/twonky/twonkyserver 2>/dev/null
  fi

  "${BUSYBOX}" echo -e "${ORANGE}[*] Starting EMBA services ...${NC}"
  while (true); do
    while IFS= read -r _BINARY; do
      "${BUSYBOX}" sleep 5
      "${BUSYBOX}" echo -e "${NC}[*] $(${BUSYBOX} date) - Environment details ..."

      BINARY_NAME=$("${BUSYBOX}" echo "${_BINARY}" | "${BUSYBOX}" cut -d\  -f1)
      BINARY_NAME=$("${BUSYBOX}" basename "${BINARY_NAME}")

      "${BUSYBOX}" echo -e "\tEMBA_ETC: ${EMBA_ETC}"
      "${BUSYBOX}" echo -e "\tEMBA_BOOT: ${EMBA_BOOT}"
      "${BUSYBOX}" echo -e "\tEMBA_NET: ${EMBA_NET}"
      "${BUSYBOX}" echo -e "\tEMBA_NVRAM: ${EMBA_NVRAM}"
      "${BUSYBOX}" echo -e "\tEMBA_KERNEL: ${EMBA_KERNEL}"
      "${BUSYBOX}" echo -e "\tEMBA_NC: ${EMBA_NC}"
      "${BUSYBOX}" echo -e "\tBINARY_NAME: ${BINARY_NAME}"
      "${BUSYBOX}" echo -e "\tKernel details: $("${BUSYBOX}" uname -a)"
      "${BUSYBOX}" echo -e "\tKernel cmdline: $("${BUSYBOX}" cat /proc/cmdline)"
      "${BUSYBOX}" echo -e "\tSystem uptime: $("${BUSYBOX}" uptime)"
      "${BUSYBOX}" echo -e "\tSystem environment: $("${BUSYBOX}" env | "${BUSYBOX}" tr '\n' '|')"

      "${BUSYBOX}" echo "[*] Netstat output:"
      "${BUSYBOX}" netstat -antu
      "${BUSYBOX}" echo "[*] Network configuration:"
      "${BUSYBOX}" brctl show
      "${BUSYBOX}" ifconfig -a
      "${BUSYBOX}" echo "[*] Running processes:"
      "${BUSYBOX}" ps
      "${BUSYBOX}" echo "[*] /proc filesytem:"
      "${BUSYBOX}" ls /proc

      # debugger bins - only started with EMBA_NC=true
      if [ "${EMBA_NC}" = "true" ]; then
        if [ "${BINARY_NAME}" = "netcat" ]; then
          "${BUSYBOX}" echo -e "${NC}[*] Starting ${ORANGE}${BINARY_NAME}${NC} debugging service ..."
          # we only start our netcat listener if we set EMBA_NC_STARTER on startup (see run.sh script)
          # otherwise we move on to the next binary starter
          ${_BINARY} &
          continue
        fi
        if [ "${_BINARY}" = "/firmadyne/busybox telnetd -p 9877 -l /firmadyne/sh" ]; then
          "${BUSYBOX}" echo -e "${NC}[*] Starting ${ORANGE}Telnetd${NC} debugging service ..."
          ${_BINARY} &
          continue
        fi
      fi
      if [ "${BINARY_NAME}" = "netcat" ] || [ "${_BINARY}" = "/firmadyne/busybox telnetd -p 9877 -l /firmadyne/sh" ]; then
        continue
      fi

      # normal service startups
      if ( ! ("${BUSYBOX}" ps | "${BUSYBOX}" grep -v grep | "${BUSYBOX}" grep -sqi "${BINARY_NAME}") ); then
        "${BUSYBOX}" echo -e "${NC}[*] Starting ${ORANGE}${BINARY_NAME}${NC} service ..."
        #BINARY variable could be something like: binary parameter parameter ...
        ${_BINARY} &
      else
        "${BUSYBOX}" echo -e "${NC}[*] ${ORANGE}${BINARY_NAME}${NC} already started ..."
      fi
    done < "/firmadyne/service"
  done
fi

