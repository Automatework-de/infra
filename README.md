# infra

Infrastructure as Code for Automatework Self-Hosting Platform

- bootstrap.sh: initial server bootstrap
- ansible/: Ansible-Roles & Playbooks
- deploy/: Docker-Compose service definitions
- .github/workflows/: CI/CD pipelines

## Cloud-Init Templates

* **cloud-config/hcloud_cx_base.yaml** – User-Data-Skript für eine frische Hetzner-CX-VM  
  (Ubuntu 22.04, User *silas*, Docker CE, Caddy, UFW, Fail2Ban, Auto-TLS)

### Erstes Setup

…

4. **Secrets vorbereiten**  
   - Siehe `docs/phase-e.md` Abschnitt **Secrets & SOPS**  
   - Stelle sicher, dass dein AGE-Key unter `~/.config/sops/age/keys.txt` verfügbar ist  
   - Verschlüssle alle `secrets/*.env` mit:
     ```bash
     sops -e -i secrets/*.env
     ```
