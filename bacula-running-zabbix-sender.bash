#!/bin/bash

# Importa o arquivo de configuração
source /opt/bacula/etc/bacula-zabbix.conf

# Executa o comando 'status dir' via bconsole e captura a saída
output=$(echo "status dir" | bconsole)

# Conta o número de jobs que estão rodando (status Running)
running_jobs=$(echo "$output" | grep -E -c "is running")

# Captura o horário atual (hora em formato de 24h)
current_hour=$(date +"%-H")

# Sempre envia o número de jobs rodando para o Zabbix
$zabbixSender -z $zabbixServer \
        -c $zabbixAgentConfig \
        -s "$baculaHost" \
        -k "bacula.running.jobs" \
        -o "$running_jobs"

# Verifica se o horário está entre 9h e 11h ou se o número de jobs rodando for 0
if [[ ($current_hour -ge 9 && $current_hour -le 11 && $running_jobs -ge 1) || $running_jobs -eq 0 ]]; then
    # Envia o alerta para o Zabbix
    $zabbixSender -z $zabbixServer \
        -c $zabbixAgentConfig \
        -s "$baculaHost" \
        -k "bacula.running.jobs.alert" \
        -o "$running_jobs"
fi
