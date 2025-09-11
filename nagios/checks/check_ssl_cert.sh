#!/bin/bash
# Usage: ./check_ssl_cert.sh host:port days_threshold
HOSTPORT="$1"
DAYS="${2:-30}"
if [[ -z "$HOSTPORT" ]]; then
  echo "Usage: $0 host:port [days_threshold]"
  exit 3
fi
EXPIRY_DATE=$(echo | openssl s_client -servername ${HOSTPORT%%:*} -connect $HOSTPORT 2>/dev/null | openssl x509 -noout -enddate | sed 's/notAfter=//')
if [[ -z "$EXPIRY_DATE" ]]; then
  echo "CRITICAL - could not fetch certificate"
  exit 2
fi
EXP_TS=$(date -d "$EXPIRY_DATE" +%s)
NOW_TS=$(date +%s)
DIFF_DAYS=$(( (EXP_TS - NOW_TS) / 86400 ))
if [[ $DIFF_DAYS -lt 0 ]]; then
  echo "CRITICAL - expired $DIFF_DAYS days ago"
  exit 2
elif [[ $DIFF_DAYS -lt $DAYS ]]; then
  echo "WARNING - expires in $DIFF_DAYS days"
  exit 1
else
  echo "OK - expires in $DIFF_DAYS days"
  exit 0
fi
