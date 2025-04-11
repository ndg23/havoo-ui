# Changelog

All notable changes to the Havoo UI mission will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this mission adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v0.2.2] - 2025-04-11

### Ajouté
- Page de réinitialisation de mot de passe avec design moderne
- Page 404 personnalisée avec navigation intuitive
- Nouveau design des boutons style Twitter 2021
- Support du mode sombre sur toutes les pages d'authentification

### Modifié
- Refonte complète de l'interface de connexion
- Amélioration des messages d'erreur pour plus de clarté
- Optimisation du formulaire de création de mission
- Simplification de la navigation entre les pages d'authentification

### Corrigé
- Gestion des erreurs de connexion plus détaillée
- Validation des champs en temps réel
- Affichage des placeholders pour les champs de type date
- Problèmes de contraste en mode sombre

### Sécurité
- Amélioration de la gestion des sessions utilisateur
- Validation renforcée des entrées utilisateur
- Meilleure gestion des redirections après authentification

### Technique
- Migration vers le nouveau composant FloatingLabelInput
- Standardisation des styles et animations
- Optimisation des performances de rendu
- Meilleure gestion des états de chargement

## [v0.2.1] - 2025-04-01

### Ajouté
- Système de signalement pour les experts et les missions
  - Bouton de signalement sur les profils experts
  - Bouton de signalement sur les pages de missions
  - Interface d'administration des signalements
  - Notifications en temps réel des nouveaux signalements
  - Filtres et recherche avancée des signalements
- Avatar par défaut en SVG base64 pour les experts sans photo de profil

### Modifié
- Amélioration du design des pages experts avec style Apple
- Optimisation des performances de chargement des avatars

### Sécurité
- Mise en place de politiques de sécurité (RLS) pour les signalements
- Validation des types de signalements et des raisons
- Protection contre les signalements multiples

## [v0.2.0] - 2025-04-01

### Ajouté
- Simplified contract rating system directly integrated with the deals table
- New view `contract_status_view` for displaying contracts with their rating status
- Migration script to standardize all ID fields to UUID format across the database
- Module d'activités complet pour le suivi des actions utilisateurs
- Guide d'administration pour le nouveau processus de vérification d'experts
- Intégration de Cloudinary pour le stockage des documents

### Modifié
- Refactored contract system to use the deals table
- Enhanced contract cards and detail pages
- Standardized database identifiers to UUID
- Updated schema and navigation components
- Improved UI/UX across the platform

### Corrigé
- Fixed contract-related issues and dependencies
- Improved error handling and mobile responsiveness
- Enhanced accessibility and performance optimizations

## [v0.1.0] - 2025-03-14

### Ajouté
- Première version de l'application
- Système d'authentification
- Profils experts
- Gestion des missions

## [v0.2.1] - 2025-04-10

### Ajouté
- Nouveau design des cartes de mission avec mise en avant du titre
- Affichage du nombre de propositions sur les missions
- Indicateur visuel si l'utilisateur a déjà fait une proposition
- Avatar par défaut avec le composable `useDefaultAvatar`
- Nouveau design des KPI style Apple Apps sur les profils experts
- Amélioration du système de notifications avec `useCustomToast`

### Modifié
- Refonte de l'affichage des statuts de mission avec de nouvelles couleurs
- Amélioration de l'affichage des informations client (plus subtil)
- Optimisation de la mise en page des méta-informations
- Meilleure hiérarchie visuelle des informations
- Standardisation des composants de statut et badges

### Corrigé
- Correction de l'affichage des avatars par défaut
- Correction du type de signalement dans les rapports
- Correction de l'affichage des notes moyennes
- Amélioration de la gestion des dates limites

### Technique
- Création du composable `useDefaultAvatar` pour la gestion des avatars
- Refactoring des fonctions de statut et de formatage
- Amélioration de la réutilisabilité des composants
- Optimisation des performances de rendu

## [1.0.0] - 2024-03-01
- Version initiale

## [Previous versions]
...

