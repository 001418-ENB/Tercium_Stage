#!/bin/bash
# test_ports.sh
# Usage : ./test_ports.sh <IP cible> <port>

IP=$1
PORT=$2

echo "Test de connexion à $IP:$PORT"
nc -zv -w3 $IP $PORT
if [ $? -eq 0 ]; then
    echo "✅ Port $PORT ouvert sur $IP"
else
    echo "❌ Port $PORT fermé ou filtré"
fi

#  nc -zv tente une connexion TCP sans envoi de données.
# -w3 fixe un timeout à 3 secondes.
# À utiliser ponctuellement, ou via cron.
