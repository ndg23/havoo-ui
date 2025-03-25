# Diagramme Entité-Relation de la Base de Données Havoo-UI

Ce document présente le diagramme entité-relation (ERD) du schéma de base de données Havoo-UI en utilisant la syntaxe Mermaid.

## Diagramme

```mermaid
erDiagram
    profiles ||--o{ user_skills : has
    profiles ||--o{ requests : creates
    profiles ||--o{ deals : participates
    profiles ||--o{ services : offers
    profiles ||--o{ reviews : gives
    profiles ||--o{ conversation_participants : participates
    profiles ||--o{ messages : sends
    profiles ||--o{ verifications : requests
    
    categories ||--o{ skills : contains
    categories ||--o{ requests : categorizes
    categories ||--o{ services : categorizes
    
    skills ||--o{ user_skills : included_in
    skills ||--o{ service_skills : included_in
    
    requests ||--o{ deals : has
    requests ||--o{ conversations : related_to
    
    deals ||--o{ reviews : receives
    deals ||--o{ conversations : related_to
    
    services ||--o{ service_skills : has
    
    conversations ||--o{ conversation_participants : has
    conversations ||--o{ messages : contains
    
    profiles {
        UUID id PK
        VARCHAR first_name
        VARCHAR last_name
        VARCHAR email
        VARCHAR phone
        TEXT bio
        TEXT avatar_url
        BOOLEAN is_verified
        BOOLEAN is_active
        BOOLEAN is_admin
        VARCHAR role
        BOOLEAN is_expert
        VARCHAR city
        VARCHAR zip_code
        VARCHAR country
        TEXT address
        DATE birthdate
        VARCHAR website
        DECIMAL hourly_rate
        VARCHAR availability_status
        TIMESTAMP created_at
        TIMESTAMP updated_at
        INTEGER profile_completion_percentage
    }
    
    categories {
        UUID id PK
        BOOLEAN is_active
        VARCHAR name
        TEXT description
        TIMESTAMP created_at
        TIMESTAMP updated_at
    }
    
    skills {
        UUID id PK
        BOOLEAN is_active
        VARCHAR name
        UUID category_id FK
        TIMESTAMP created_at
        TIMESTAMP updated_at
    }
    
    user_skills {
        UUID user_id PK,FK
        UUID skill_id PK,FK
    }
    
    requests {
        UUID id PK
        UUID client_id FK
        VARCHAR title
        TEXT description
        DECIMAL budget
        DATE deadline
        VARCHAR status
        UUID category_id FK
        TIMESTAMP created_at
        TIMESTAMP updated_at
    }
    
    deals {
        UUID id PK
        UUID request_id FK
        UUID expert_id FK
        UUID client_id FK
        DECIMAL price
        INTEGER duration
        TEXT message
        VARCHAR status
        TIMESTAMP created_at
        TIMESTAMP updated_at
    }
    
    services {
        UUID id PK
        UUID expert_id FK
        UUID category_id FK
        VARCHAR title
        TEXT description
        DECIMAL price
        INTEGER delivery_time
        BOOLEAN is_active
        VARCHAR location_type
        DECIMAL location_latitude
        DECIMAL location_longitude
        TIMESTAMP created_at
        TIMESTAMP updated_at
    }
    
    service_skills {
        UUID service_id PK,FK
        UUID skill_id PK,FK
    }
    
    reviews {
        UUID id PK
        UUID deal_id FK
        UUID reviewer_id FK
        UUID reviewee_id FK
        INTEGER rating
        TEXT comment
        TIMESTAMP created_at
        TIMESTAMP updated_at
    }
    
    conversations {
        UUID id PK
        UUID request_id FK
        UUID deal_id FK
        TEXT last_message
        TIMESTAMP last_message_at
        TIMESTAMP created_at
        TIMESTAMP updated_at
    }
    
    conversation_participants {
        UUID conversation_id PK,FK
        UUID profile_id PK,FK
    }
    
    messages {
        UUID id PK
        UUID conversation_id FK
        UUID sender_id FK
        TEXT content
        BOOLEAN is_read
        TIMESTAMP created_at
        TIMESTAMP updated_at
    }
    
    verifications {
        UUID id PK
        UUID user_id FK
        VARCHAR status
        JSONB documents
        TEXT rejection_reason
        TIMESTAMP created_at
        TIMESTAMP updated_at
        UUID reviewed_by FK
        TIMESTAMP reviewed_at
    }
    
    settings {
        UUID id PK
        TEXT key
        JSONB value
        TIMESTAMP created_at
        TIMESTAMP updated_at
    }
```

## Notes sur le Diagramme

1. **Relations principales** :
   - Les profils utilisateurs (`profiles`) sont au centre du modèle et reliés à plusieurs autres entités
   - Les catégories (`categories`) contiennent des compétences (`skills`)
   - Les demandes (`requests`) et les contrats (`deals`) sont liés pour le flux de travail principal
   - Les conversations (`conversations`) peuvent être associées à des demandes ou des contrats

2. **Tables de jonction** :
   - `user_skills` : Associe les utilisateurs à leurs compétences
   - `service_skills` : Associe les services aux compétences requises
   - `conversation_participants` : Associe les utilisateurs aux conversations

3. **Clés étrangères** :
   - Les flèches indiquent les références de clés étrangères
   - Toutes les clés primaires sont des UUID pour la sécurité et l'évolutivité

4. **Notes sur la cardinalité** :
   - `||--o{` : Relation un-à-plusieurs (par exemple, un profil peut avoir plusieurs compétences)
   - Les contraintes d'intégrité référentielle sont appliquées via les clés étrangères

Ce diagramme ERD peut être visualisé en utilisant n'importe quel interpréteur Mermaid, comme l'extension Markdown Preview Enhanced dans VS Code ou des outils en ligne comme Mermaid Live Editor. 