# Nuxt Minimal Starter

Look at the [Nuxt documentation](https://nuxt.com/docs/getting-started/introduction) to learn more.

## Setup

Make sure to install dependencies:

```bash
# npm
npm install

# pnpm
pnpm install

# yarn
yarn install

# bun
bun install
```

## Changelog

We maintain a detailed changelog to track all notable changes to the mission.

- Current version: 1.1.0
- View the full [CHANGELOG.md](./CHANGELOG.md) for a detailed history of changes

## Development Server

Start the development server on `http://localhost:3000`:

```bash
# npm
npm run dev

# pnpm
pnpm dev

# yarn
yarn dev

# bun
bun run dev
```

## Production

Build the application for production:

```bash
# npm
npm run build

# pnpm
pnpm build

# yarn
yarn build

# bun
bun run build
```

Locally preview production build:

```bash
# npm
npm run preview

# pnpm
pnpm preview

# yarn
yarn preview

# bun
bun run preview
```

Check out the [deployment documentation](https://nuxt.com/docs/getting-started/deployment) for more information.

## Système de vérification d'experts

Le projet Havoo UI inclut un système de vérification d'experts qui permet aux utilisateurs de soumettre des documents pour validation et aux administrateurs de gérer ces demandes.

### Configuration

Pour configurer le système de vérification d'experts:

1. Assurez-vous que votre base de données Supabase est correctement configurée
2. Définissez les variables d'environnement nécessaires:
   ```bash
   export SUPABASE_URL=https://votre-projet.supabase.co
   export SUPABASE_KEY=votre-clé-service-role
   ```
3. Exécutez le script d'installation:
   ```bash
   ./setup_verification.sh
   ```

Ce script configure:
- Les politiques de sécurité pour la table `verifications`
- Les politiques de stockage pour le bucket `documents`
- Les fonctions SQL nécessaires pour la gestion du processus de vérification
- Les déclencheurs (triggers) pour les mises à jour automatiques

### Composants du système

#### Backend (SQL)
- Table `verifications` pour stocker les demandes
- Bucket de stockage `documents` pour les pièces justificatives
- Politiques RLS (Row Level Security) pour la sécurité des données
- Fonctions pour soumettre et traiter les demandes

#### Frontend (Vue)
- Interface de soumission de documents via `pages/account/verification.vue`
- Processus simplifié utilisant la fonction `mission_expert_verification`

### Documentation technique

Pour plus de détails sur l'implémentation, consultez les fichiers:
- `database/setup_verification_system.sql` - Configuration complète du système
- `setup_verification.sh` - Script d'initialisation
- `pages/account/verification.vue` - Interface utilisateur

### Flux de travail

1. L'utilisateur soumet ses documents via l'interface de vérification
2. Les documents sont stockés dans le bucket `documents` avec un chemin spécifique
3. Une entrée est créée dans la table `verifications` avec le statut "pending"
4. Les administrateurs reçoivent une notification
5. Les administrateurs vérifient les documents et approuvent ou rejettent la demande
6. L'utilisateur est notifié du résultat
7. Si approuvé, le statut de l'utilisateur est mis à jour en tant qu'expert

Le processus de vérification des experts permet à un utilisateur de soumettre une pièce d'identité et d'obtenir un statut d'expert vérifié. Voici les étapes du processus :

1. L'utilisateur soumet sa Carte Nationale d'Identité (CNI) via l'interface
2. Le document est chargé dans Cloudinary via l'API
3. Une demande de vérification est créée dans la table "verifications" avec l'URL Cloudinary
4. Les administrateurs reçoivent une notification et examinent le document
5. Après vérification, l'administrateur approuve ou rejette la demande
6. Le statut de l'utilisateur est mis à jour automatiquement via des triggers

Le fichier `database/setup_verification_system.sql` contient toute la configuration nécessaire et `database/admin/verification_guide.md` fournit un guide complet pour les administrateurs.

### Intégration Cloudinary

Le système utilise Cloudinary pour le stockage et la gestion des documents d'identité, offrant plusieurs avantages :

1. **Sécurité** : Cloudinary offre un stockage sécurisé avec chiffrement et gestion avancée des accès
2. **Performance** : CDN distribué mondialement pour un accès rapide aux documents
3. **Transformation** : Possibilité de redimensionner, rogner ou flouter certaines parties des documents sensibles
4. **Durabilité** : Stockage redondant et sauvegarde automatique des documents

Configuration requise :
- Compte Cloudinary avec un cloud_name
- Upload preset non-signé configuré pour la sécurité
- Variables d'environnement ou configuration dans l'application

## Module de suivi des activités

Le module d'activités permet de suivre les actions des utilisateurs dans l'application, offrant une traçabilité complète des opérations effectuées. Ce module inclut:

### Table principale
Une table `activities` stocke les informations détaillées sur chaque action:
- Utilisateur qui a effectué l'action
- Type d'action (création, modification, suppression, etc.)
- Type d'entité concernée (profil, demande, contrat, etc.)
- ID de l'entité concernée
- Détails spécifiques à l'action en format JSONB
- Adresse IP et User-Agent pour des fins d'audit
- Horodatage de l'action

### Fonctions et triggers
- Des fonctions dédiées (`log_activity`, `log_user_activity`) permettent d'enregistrer les activités
- Des triggers automatiques sont configurés sur les tables principales pour enregistrer automatiquement les modifications
- Les actions importantes (comme l'approbation de vérification ou l'acceptation d'un contrat) sont identifiées avec des types d'actions spécifiques

### Sécurité et visualisation
- Des politiques RLS garantissent que les utilisateurs ne voient que leurs propres activités
- Les administrateurs ont accès à toutes les activités pour la supervision
- Des vues SQL facilitent l'analyse des activités (`user_recent_activities`, `deal_activities`, etc.)

Le fichier `database/activities_schema.sql` contient la définition complète du module.

## Schéma de Base de Données

Le projet Havoo UI utilise un schéma de base de données cohérent avec des identifiants UUID pour une meilleure évolutivité et sécurité.

### Fichier SQL Unique

Un fichier SQL unique contenant l'ensemble de la définition de la base de données est disponible à:
```
database/complete_schema.sql
```

Ce fichier regroupe:
- Définitions de toutes les tables
- Index pour l'optimisation des performances
- Fonctions SQL (calcul de complétion de profil, gestion des vérifications, etc.)
- Triggers pour l'automatisation des processus
- Politiques de sécurité (Row Level Security)
- Configuration du stockage pour les documents

### Utilisation

Pour initialiser la base de données avec ce schéma complet:

```bash
# Via l'API REST de Supabase
export SUPABASE_URL=https://votre-projet.supabase.co
export SUPABASE_KEY=votre-clé-service-role

curl -X POST \
  -H "apikey: $SUPABASE_KEY" \
  -H "Authorization: Bearer $SUPABASE_KEY" \
  -H "Content-Type: application/json" \
  --data-binary @database/complete_schema.sql \
  "$SUPABASE_URL/rest/v1/sql"

# Ou directement via psql si vous avez accès
psql -h <host> -U <user> -d <database> -f database/complete_schema.sql
```

### Structure Principale

Le schéma est organisé autour de plusieurs concepts clés:
- **Profils utilisateurs**: Données personnelles des utilisateurs
- **Catégories et compétences**: Classification des expertises
- **Demandes et deals**: Système de mise en relation client-expert
- **Services**: Offres proposées par les experts
- **Vérifications**: Processus de validation des experts
- **Messagerie**: Communication entre utilisateurs

Pour plus de détails, consultez la documentation dans `database/schema/README.md`.
