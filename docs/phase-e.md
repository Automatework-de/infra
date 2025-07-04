## Phase E: Compose-Stacks

### Secrets & SOPS

#### Zweck
Wir halten alle sensiblen Konfigurationswerte (Passwörter, Hostnamen, Lizenz-Keys) außerhalb des Git-Verlaufs und verschlüsseln sie mit [Mozilla SOPS](https://github.com/mozilla/sops) + AGE.

#### Dateien
- `secrets/seatable_test.env`
- `secrets/seatable_prod.env`

Beide basieren auf dem offiziellen Template:
curl -I https://raw.githubusercontent.com/seatable/seatable-release/main/compose/.env-release
curl -L https://raw.githubusercontent.com/seatable/seatable-release/main/compose/.env-release \
     -o deploy/seatable/.env.example

Workflow zum Anlegen / Ändern
Kopie erzeugen
cp deploy/seatable/.env.example secrets/seatable_<env>.env

Pflichtwerte editieren
# z.B. für Test
nano secrets/seatable_test.env
SEATABLE_SERVER_HOSTNAME

SEATABLE_ADMIN_EMAIL

SEATABLE_ADMIN_PASSWORD, MYSQL_ROOT_PASSWORD, REDIS_PASSWORD

Verschlüsseln
sops -e -i secrets/seatable_test.env
sops -e -i secrets/seatable_prod.env

Commit & Push
git add secrets/
git commit -m "feat(secrets): encrypted SeaTable envs"

SOPS-Konfiguration
In .sops.yaml haben wir folgende Regel definiert:
creation_rules:
  - encrypted_regex: '^(MYSQL_|SEATABLE_|DB_)'
    age:
      - <DEIN_PUBLIC_AGE_KEY>

Das sorgt dafür, dass alle Variablen, die mit MYSQL_, SEATABLE_ oder DB_ beginnen, automatisch verschlüsselt werden.

Tipps für späteres Nachschlagen
Entschlüsseln:
sops -d secrets/seatable_test.env

Ändern:
Nach dem Editieren wieder per sops -e -i … verschlüsseln.

AGE-Keys liegen unter ~/.config/sops/age/keys.txt.
