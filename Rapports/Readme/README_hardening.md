
# 🛡️ README – Hardening & Sécurité du Monitoring

## Objectif
Ce fichier centralise les pratiques de durcissement (hardening) de l’environnement de monitoring basé sur Prometheus, Node Exporter, Blackbox Exporter, Grafana, Suricata, Wazuh et Fail2Ban.

---

## 1. Structure des fichiers

```
/opt/
 ├── prometheus/
 ├── node_exporter/
 ├── blackbox_exporter/
 ├── grafana/
 ├── monitoring/
 │   ├── Makefile_boot
 │   ├── Makefile_tasks
 │   ├── scripts/
 │   └── logs/
```

---

## 2. Hardening système

### 🔐 Comptes utilisateurs
- Prometheus, Node Exporter, etc. doivent utiliser un `shell` `/usr/sbin/nologin`
- UID < 1000 recommandé pour utilisateur système
- Exemple :
  ```bash
  sudo useradd --no-create-home --shell /usr/sbin/nologin prometheus
  ```

### 🗂️ Permissions fichiers
- `/opt/prometheus/prometheus` → propriété `prometheus:prometheus`, permissions `755`
- `/etc/systemd/system/*.service` → root only

### 🔒 Services
- `systemctl enable --now <service>`
- `systemctl status <service>`
- Recharger systemd :
  ```bash
  sudo systemctl daemon-reload
  ```

---

## 3. Sécurité des ports

| Service               | Port  | État         | Niveau de sécurité         |
|----------------------|-------|--------------|-----------------------------|
| Prometheus           | 9091  | interne      | surveillé, non exposé      |
| Node Exporter        | 9101  | interne      | localhost ou firewall      |
| Blackbox Exporter    | 9116  | externe OK   | timeouts + tls_config      |
| Grafana              | 3000  | filtré       | HTTPS + Auth obligatoire   |

---

## 4. Outils de sécurité installés

- **Fail2Ban** (SSH, NGINX, Prosody)
- **Wazuh** (analyse comportementale, journalisation)
- **Suricata** (IDS réseau)

---

## 5. Scripts d’automatisation

- `verify_ports_exporters.sh` → vérifie état ports
- `check_exporters.sh` → vérifie les targets Prometheus
- `change_prometheus_port.sh` → modifie port Prometheus dynamiquement

Tous les scripts sont appelés par `Makefile_tasks`.

---

## 6. Tests de charge

- Apache JMeter utilisé pour simuler :
  - Surcharge réseau
  - Attaques simulées
- Résultats analysés via Prometheus et Wazuh

---

## 7. Perspectives

- Automatisation avec `n8n` en cours de test
- Déploiement multi-branche (`main`, `preprod`, `test`)
- Corrélation de logs sur seuils critiques
- Export en dashboards JSON Grafana

