#!/bin/bash

# Import configuration file
source /opt/bacula/etc/bacula-zabbix.conf

# Executa o comando 'status dir' via bconsole e captura a saída
output=$(echo "status dir" | bconsole)

# Conta o número de jobs que estão aguardando por mídia (label)
label_jobs=$(echo "$output" | grep -E -c "waiting for media|Cannot find any appendable volumes|is waiting for an appendable Volume")

# Envia o valor para o Zabbix via zabbix_sender
$zabbixSender -z $zabbixServer -c $zabbixAgentConfig -s "$baculaHost" -k "bacula.label.jobs" -o "$label_jobs"
