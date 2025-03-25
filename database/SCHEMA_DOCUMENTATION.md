# Documentation du Schéma de Base de Données Havoo-UI

## Introduction

Cette documentation détaille le schéma complet de la base de données utilisée par l'application Havoo-UI. Elle décrit la structure de chaque table, les relations entre elles, et les fonctionnalités associées comme les déclencheurs et les politiques de sécurité.

## Structure de la Base de données

Le schéma est organisé autour de plusieurs concepts clés :

- **Utilisateurs et Profils** : Gestion des informations personnelles des utilisateurs
- **Compétences et Catégories** : Classification des expertises
- **Demandes et Offres** : Système de mise en relation entre clients et experts
- **Messagerie** : Système de communication entre utilisateurs
- **Vérification d'Experts** : Processus de validation des experts

## Tables Principales

### Profils (profiles)

Table centrale contenant les informations des utilisateurs.

| Champ | Type | Description |
|-------|------|-------------|
| id | UUID | Clé primaire, lié à auth.users |
| first_name | VARCHAR(255) | Prénom (obligatoire) |
| last_name | VARCHAR(255) | Nom (obligatoire) |
| email | VARCHAR(255) | Email (unique, obligatoire) |
| phone | VARCHAR(50) | Numéro de téléphone |
| bio | TEXT | Biographie/description |
| avatar_url | TEXT | URL de l'avatar |
| is_verified | BOOLEAN | Statut de vérification |
| is_active | BOOLEAN | Compte actif ou non |
| is_admin | BOOLEAN | Statut administrateur |
| role | VARCHAR(20) | Rôle ('client' ou 'expert') |
| is_expert | BOOLEAN | Utilisateur expert ou non |
| city | VARCHAR(255) | Ville |
| zip_code | VARCHAR(255) | Code postal |
| country | VARCHAR(255) | Pays |
| address | TEXT | Adresse complète |
| birthdate | DATE | Date de naissance |
| website | VARCHAR(255) | Site web |
| hourly_rate | DECIMAL(10,2) | Tarif horaire |
| availability_status | VARCHAR(20) | Statut de disponibilité |
| created_at | TIMESTAMP | Date de création |
| updated_at | TIMESTAMP | Date de dernière mise à jour |
| profile_completion_percentage | INTEGER | Pourcentage de complétion du profil |

### Catégories (categories)

Classification principale des domaines d'expertise.

| Champ | Type | Description |
|-------|------|-------------|
| id | UUID | Clé primaire |
| is_active | BOOLEAN | Statut d'activation |
| name | VARCHAR(255) | Nom de la catégorie (unique) |
| description | TEXT | Description de la catégorie |
| created_at | TIMESTAMP | Date de création |
| updated_at | TIMESTAMP | Date de dernière mise à jour |

### Compétences (skills)

Compétences spécifiques associées aux catégories.

| Champ | Type | Description |
|-------|------|-------------|
| id | UUID | Clé primaire |
| is_active | BOOLEAN | Statut d'activation |
| name | VARCHAR(255) | Nom de la compétence (unique) |
| category_id | UUID | Référence à la catégorie parente |
| created_at | TIMESTAMP | Date de création |
| updated_at | TIMESTAMP | Date de dernière mise à jour |

### Compétences des utilisateurs (user_skills)

Table d'association entre utilisateurs et compétences.

| Champ | Type | Description |
|-------|------|-------------|
| user_id | UUID | Référence au profil utilisateur |
| skill_id | UUID | Référence à la compétence |

### Demandes (requests)

Demandes de service créées par les clients.

| Champ | Type | Description |
|-------|------|-------------|
| id | UUID | Clé primaire |
| client_id | UUID | Référence au profil client |
| title | VARCHAR(255) | Titre de la demande |
| description | TEXT | Description détaillée |
| budget | DECIMAL(10,2) | Budget proposé |
| deadline | DATE | Date limite |
| status | VARCHAR(50) | Statut ('open', 'assigned', 'completed', 'cancelled') |
| category_id | UUID | Référence à la catégorie |
| created_at | TIMESTAMP | Date de création |
| updated_at | TIMESTAMP | Date de dernière mise à jour |

### Deals (deals)

Gestion des propositions et contrats.

| Champ | Type | Description |
|-------|------|-------------|
| id | UUID | Clé primaire |
| request_id | UUID | Référence à la demande |
| expert_id | UUID | Référence au profil expert |
| client_id | UUID | Référence au profil client |
| price | DECIMAL(10,2) | Prix proposé |
| duration | INTEGER | Durée en jours |
| message | TEXT | Message de proposition |
| status | VARCHAR(50) | Statut ('proposal', 'active', 'completed', 'rejected', 'cancelled') |
| created_at | TIMESTAMP | Date de création |
| updated_at | TIMESTAMP | Date de dernière mise à jour |

### Services (services)

Services proposés par les experts.

| Champ | Type | Description |
|-------|------|-------------|
| id | UUID | Clé primaire |
| expert_id | UUID | Référence au profil expert |
| category_id | UUID | Référence à la catégorie |
| title | VARCHAR(255) | Titre du service |
| description | TEXT | Description détaillée |
| price | DECIMAL(10,2) | Prix du service |
| delivery_time | INTEGER | Temps de livraison en jours |
| is_active | BOOLEAN | Statut d'activation |
| location_type | VARCHAR(20) | Type de localisation ('remote', 'onsite', 'hybrid') |
| location_latitude | DECIMAL(10,8) | Latitude (pour services sur site) |
| location_longitude | DECIMAL(11,8) | Longitude (pour services sur site) |
| created_at | TIMESTAMP | Date de création |
| updated_at | TIMESTAMP | Date de dernière mise à jour |

### Compétences des services (service_skills)

Association entre services et compétences.

| Champ | Type | Description |
|-------|------|-------------|
| service_id | UUID | Référence au service |
| skill_id | UUID | Référence à la compétence |

### Avis (reviews)

Évaluations après réalisation des deals.

| Champ | Type | Description |
|-------|------|-------------|
| id | UUID | Clé primaire |
| deal_id | UUID | Référence au deal |
| reviewer_id | UUID | Référence au profil évaluateur |
| reviewee_id | UUID | Référence au profil évalué |
| rating | INTEGER | Note (1-5) |
| comment | TEXT | Commentaire |
| created_at | TIMESTAMP | Date de création |
| updated_at | TIMESTAMP | Date de dernière mise à jour |

### Conversations (conversations)

Gestion des fils de discussion.

| Champ | Type | Description |
|-------|------|-------------|
| id | UUID | Clé primaire |
| request_id | UUID | Référence à la demande (optionnel) |
| deal_id | UUID | Référence au deal (optionnel) |
| last_message | TEXT | Dernier message |
| last_message_at | TIMESTAMP | Date du dernier message |
| created_at | TIMESTAMP | Date de création |
| updated_at | TIMESTAMP | Date de dernière mise à jour |

### Participants aux conversations (conversation_participants)

Utilisateurs impliqués dans les conversations.

| Champ | Type | Description |
|-------|------|-------------|
| conversation_id | UUID | Référence à la conversation |
| profile_id | UUID | Référence au profil participant |

### Messages (messages)

Messages individuels dans les conversations.

| Champ | Type | Description |
|-------|------|-------------|
| id | UUID | Clé primaire |
| conversation_id | UUID | Référence à la conversation |
| sender_id | UUID | Référence au profil expéditeur |
| content | TEXT | Contenu du message |
| is_read | BOOLEAN | Statut de lecture |
| created_at | TIMESTAMP | Date de création |
| updated_at | TIMESTAMP | Date de dernière mise à jour |

### Vérifications (verifications)

Gestion des demandes de vérification d'experts.

| Champ | Type | Description |
|-------|------|-------------|
| id | UUID | Clé primaire |
| user_id | UUID | Référence au profil utilisateur |
| status | VARCHAR(20) | Statut ('pending', 'approved', 'rejected') |
| documents | JSONB | Documents fournis (format JSON) |
| rejection_reason | TEXT | Raison de rejet |
| created_at | TIMESTAMP | Date de création |
| updated_at | TIMESTAMP | Date de dernière mise à jour |
| reviewed_by | UUID | Référence au profil administrateur |
| reviewed_at | TIMESTAMP | Date de revue |

### Paramètres (settings)

Paramètres globaux de l'application.

| Champ | Type | Description |
|-------|------|-------------|
| id | UUID | Clé primaire |
| key | TEXT | Clé de paramètre (unique) |
| value | JSONB | Valeur (format JSON) |
| created_at | TIMESTAMP | Date de création |
| updated_at | TIMESTAMP | Date de dernière mise à jour |

## Index

Le schéma inclut plusieurs index pour optimiser les performances :

- `idx_requests_client_id` : Recherche rapide des demandes par client
- `idx_deals_expert_id` : Recherche rapide des deals par expert
- `idx_deals_request_id` : Recherche rapide des deals par demande
- `idx_services_expert_id` : Recherche rapide des services par expert
- `idx_user_skills_user_id` : Recherche rapide des compétences par utilisateur
- `idx_messages_conversation_id` : Recherche rapide des messages par conversation
- `idx_messages_sender_id` : Recherche rapide des messages par expéditeur
- `idx_messages_created_at` : Tri chronologique des messages
- `idx_conversations_last_message_at` : Tri des conversations par dernier message
- `idx_verifications_user_id` : Recherche rapide des vérifications par utilisateur
- `idx_verifications_status` : Filtrage rapide des vérifications par statut
- `settings_key_idx` : Recherche rapide des paramètres par clé

## Déclencheurs (Triggers)

Plusieurs déclencheurs automatisent certaines opérations :

1. **Mise à jour automatique des timestamps** :
   - `set_profiles_updated_at` : Met à jour `updated_at` lors des modifications de profils
   - `set_verifications_updated_at` : Met à jour `updated_at` lors des modifications de vérifications

2. **Calcul de complétion de profil** :
   - `calculate_profile_completion_trigger` : Calcule automatiquement le pourcentage de complétion

3. **Mise à jour du statut d'expert** :
   - `update_expert_status_on_verification` : Met à jour le statut expert lors de l'approbation d'une vérification

## Politiques de Sécurité (Row Level Security)

Le schéma définit des politiques de sécurité au niveau des lignes :

1. **Pour les vérifications** :
   - Les utilisateurs peuvent voir uniquement leurs propres vérifications
   - Les utilisateurs peuvent créer des vérifications pour eux-mêmes
   - Les administrateurs peuvent gérer toutes les vérifications

2. **Pour les paramètres** :
   - Seuls les administrateurs peuvent lire et modifier les paramètres

## Relations entre les Tables

![Diagramme des relations](https://mermaid.ink/img/pako:eNqtVMtu2zAQ_BWCJxfwA7bjJL1ZiF2kLdCgRQ5sDl5ztMWYIlWSsm0Y_veSom3JToIe2oMhcbmzM7Mzu-SdVBhJ0WHrdQTjS9_oXON2pcAUXyBQPnGP6IyB2FfJSi9lZ3lqZqiKLXptXDpZzNjkitKLuAUdB5Ul5kW1KDtTvfHGo94TuoOIofyI3uVOPU0Vx4EiOBBZEX47OOL0B-_Rkfh7ZKDIuNi4ZKnbvJJZcn5-mYmPZeYK_XfO8BZRS9dhYzUMU5JxqDH5nVCDOFQ4n2wkL1VrrRYN_ykyfb3Q2AclIu66Ns6rUGpkKYNrGGKMRXkPW6OT1xMnwOTQxPZBqY2FXUQvwpb7JC7vgrdkF9hFMD5_5yK6MbwZbLUPYmvUQIJnKeCnMg9KRmR5eDZOhf5Ql5ZnPbRjQ9Zb8ntpXGSJDGNGBZPIyP0vRj0dO8e9sGFFYTAF_lIPNWrP3vBMOefbB2lJeaeMUTuNllwaDL0jT9EZiJylOWTQo9VwC5eUUAGfEsxrpSO0GEG3bpVcI0vOYY61D9G1GEcLvdJtWkUGjc1Qe-TSmrLDuOAFVZgQ9UfVeXyq-oXqGvUTQsNaYcnzNWRYaTT0QjU6Q3b4LqZTGQqVz_ESXhEVF9aQS0uzZL84yAjdvG0Xpa-tKyI5fPNsibXfNp59C1YYXafAhbPMCrXqEGKo64Kl6cOUL2dKm9Qy22DJl1WVrW1o1Y7kE3nK_aQd-Y9zPG7wqe7-AX7tHJc?type=png)

*Note: Ce diagramme représente les relations principales entre les tables.*

## Considérations pour les Développeurs

1. **Sécurité** :
   - Toutes les clés primaires sont des UUIDs pour la sécurité et l'évolutivité
   - Les politiques RLS limitent l'accès aux données sensibles

2. **Transactions** :
   - Lors de la création d'une vérification approuvée, le statut expert est automatiquement mis à jour
   - Certaines opérations comme la création de conversations impliquent plusieurs tables

3. **Extensions** :
   - Le schéma utilise l'extension `uuid-ossp` pour la génération des UUIDs
   - D'autres extensions PostgreSQL peuvent être utilisées selon les besoins

## Conclusion

Ce schéma est conçu pour soutenir une application de mise en relation entre experts et clients, avec un accent sur la sécurité, la vérification des experts et les communications entre utilisateurs. Il offre une structure flexible qui peut être étendue pour prendre en charge des fonctionnalités supplémentaires à l'avenir. 