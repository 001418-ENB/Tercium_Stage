# 🧠 Supervision Prometheus – Stratégie de Cohérence (Binaire vs APT)

## 📌 Objectif

Documenter une stratégie cohérente d'installation, de service systemd et de maintenance pour Prometheus et ses exporters en environnement sécurisé.

---

## 📂 Structure Recommandée

```
/opt/
├── prometheus/
│   ├── prometheus
│   └── promtool
├── node_exporter/
├── blackbox_exporter/
├── telegraf_exporter/

~/monitoring/
├── Makefile
├── README.md
├── grafana/
│   ├── dashboards/
│   └── alerts/
├── scripts/
│   ├── check_exporters.sh
│   ├── verify_ports_exporters.sh
│   └── change_prometheus_port.sh
```

---

## ⚙️ Stratégie d'installation

| Composant                  | Méthode          | Répertoire            | Utilisateur        |
|---------------------------|------------------|------------------------|--------------------|
| Prometheus                | Binaire          | `/opt/prometheus/`     | `prometheus`       |
| Exporters (Node/Blackbox) | Binaire          | `/opt/<exporter>/`     | `prometheus`       |
| Fail2Ban/Wazuh/Suricata   | APT              | `/usr/`, `/etc/`       | auto (via apt)     |

---

## 🛡️ Bonnes pratiques

- ❌ **Ne pas mélanger apt & binaire.**
- ✅ Préférer `/opt/` pour les services manuels.
- ✅ Créer `prometheus:x:` comme user unique pour les services.
- ✅ Uniformiser les fichiers `.service` avec chemins absolus et UID ≥ 1000.
- ✅ Toujours tester avec `promtool check config`.

---

## 🧪 Exemple de service Prometheus

```ini
[Unit]
Description=Prometheus Service
After=network.target

[Service]
User=prometheus
ExecStart=/opt/prometheus/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus \
  --web.listen-address=:9091
Restart=always

[Install]
WantedBy=multi-user.target
```

---

## 🧰 Scripts utiles

- `check_exporters.sh` : Vérifie l’état des targets dans Prometheus
- `verify_ports_exporters.sh` : Vérifie les ports à l’écoute
- `change_prometheus_port.sh` : Permet de reconfigurer dynamiquement Prometheus

---

## 📅 Date de génération

Fichier généré automatiquement le 2025-07-25 11:22:44.

