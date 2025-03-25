# Coding Standards for Havoo UI

Ce document définit les normes de codage et les meilleures pratiques à suivre pour le projet Havoo UI.

## Structure du Projet

- Les composants réutilisables doivent être placés dans le dossier `/components`
- Les pages doivent être placées dans le dossier `/pages`
- Les fonctions utilitaires doivent être placées dans le dossier `/utils`
- Les définitions de types doivent être placées dans le dossier `/types`
- Les scripts de base de données doivent être placés dans le dossier `/database`

## Base de Données

### Identifiants

- **IMPORTANT** : Tous les identifiants (clés primaires et étrangères) DOIVENT utiliser le type **UUID** pour assurer la cohérence et la scalabilité.
- N'utilisez JAMAIS de type INTEGER ou SERIAL pour les clés primaires.
- Utilisez `uuid_generate_v4()` pour générer de nouveaux UUIDs.
- Définissez les contraintes d'intégrité référentielle appropriées pour toutes les clés étrangères.

Exemple de définition de table avec UUID :

```sql
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE skills (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    description TEXT,
    category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### Tables

- Nommez les tables au pluriel (ex: `users`, `categories`, `skills`)
- Incluez toujours les colonnes `created_at` et `updated_at` pour suivre l'historique des modifications
- Définissez des contraintes appropriées pour garantir l'intégrité des données
- Documentez clairement la structure et le but de chaque table

### Fonctions

- Préfixez les fonctions avec un verbe (ex: `get_`, `create_`, `update_`, `delete_`)
- Utilisez SECURITY DEFINER uniquement lorsque nécessaire
- Documentez clairement les paramètres d'entrée et de sortie

## Frontend

### Composants Vue

- Utilisez la composition API avec `<script setup>`
- Organisez le code dans cet ordre : imports, props, refs, computed, methods, watch, lifecycle hooks
- Nommez les composants en PascalCase (ex: `UserProfile.vue`, `ContractCard.vue`)

### Style

- Utilisez Tailwind CSS pour le styling
- Utilisez des classes utilitaires directement dans les templates quand c'est simple
- Extrayez les styles complexes ou répétitifs en classes composées dans un fichier CSS

### Types TypeScript

- Définissez des interfaces pour toutes les données structurées
- Utilisez des types stricts plutôt que `any` quand c'est possible
- Documentez les propriétés complexes

## Gestion de Version

- Suivez le versionnement sémantique (Semantic Versioning)
- Mettez à jour le CHANGELOG.md pour chaque nouvelle version
- Catégorisez les changements en Added, Changed, Deprecated, Removed, Fixed, Security

## Tests

- Écrivez des tests unitaires pour les fonctions utilitaires
- Écrivez des tests d'intégration pour les composants complexes
- Visez une couverture de test d'au moins 70%

## Documentation

- Documentez toutes les fonctions et composants publics
- Utilisez des commentaires pour expliquer le "pourquoi" plutôt que le "quoi"
- Mettez à jour la documentation lors de changements significatifs 