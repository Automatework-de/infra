# ADR 001: Secrets Management mit SOPS + AGE

Datum: 2025-07-04

## Kontext
Wir brauchen ein sicheres, versionskontrollierbares Verfahren für Anwendungs- und Infrastruktur-Secrets, das:
- einfach in Ansible-Playbooks integrierbar ist  
- kollaboratives Arbeiten erlaubt  
- sich später auf Vault/HashiCorp ausweiten lässt

## Entscheidung
Wir verwenden [Mozilla SOPS](https://github.com/mozilla/sops) in Kombination mit AGE-Keys.  
Ideal, weil…
- keine zentrale Infrastruktur nötig  
- Client-seitige Verschlüsselung  
- Ansible-Collection `community.sops` entschlüsselt on-the-fly

Konfigurationsdatei: `.sops.yaml` mit Regex-Regeln für ENV-Variablen.

## Konsequenzen
- Secrets liegen verschlüsselt im Git-Repo  
- Bearbeiten per `sops`-CLI  
- Späterer Umstieg auf KMS/DNS-Challenges möglich
