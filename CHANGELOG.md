# Changelog

All notable changes to the Havoo UI mission will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this mission adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Simplified contract rating system directly integrated with the deals table
- New view `contract_status_view` for displaying contracts with their rating status
- Migration script to standardize all ID fields to UUID format across the database
- Module d'activités complet pour le suivi des actions utilisateurs dans l'application
  - Nouvelle table `activities` pour enregistrer les actions des utilisateurs
  - Fonctions `log_activity` et `log_user_activity` pour l'enregistrement des activités
  - Triggers automatiques pour le suivi des modifications sur les tables principales (profiles, verifications, missions, deals)
  - Vues pour simplifier l'analyse des activités (user_recent_activities, deal_activities, etc.)
  - Politiques RLS pour la sécurisation des données d'activité
- Guide d'administration pour le nouveau processus de vérification d'experts
- Intégration de Cloudinary pour le stockage des documents de vérification
  - Upload direct vers Cloudinary depuis le frontend
  - Support des URLs Cloudinary dans les fonctions de vérification
  - Utilitaires d'administration adaptés pour gérer les documents Cloudinary
- Système de signalement pour les experts et les missions
  - Bouton de signalement sur les profils experts
  - Bouton de signalement sur les pages de missions
  - Interface d'administration des signalements
  - Notifications en temps réel des nouveaux signalements
  - Filtres et recherche avancée des signalements
- Avatar par défaut en SVG base64 pour les experts sans photo de profil

### Changed
- Refactored contract system to use the deals table directly instead of job_contracts
- Simplified rating workflow with direct updates to the deals table
- Enhanced contract cards to display rating status more clearly
- Improved contract detail page with better rating visualization
- Standardized all database identifiers to use UUID instead of mixed INT/UUID types
- Updated model.harmonized.sql schema to use UUID for all primary and foreign keys
- Upgraded About page with modern Twitter-inspired layout and animations
- Refined user profile cards with hover effects and verification badges
- Enhanced stats display with improved data visualization
- Updated navigation with smoother transitions and feedback
- Amélioration du design des pages experts avec style Apple
- Optimisation des performances de chargement des avatars

### Fixed
- Fixed "relation job_contracts does not exist" error by removing dependencies on non-existent table
- Resolved contract rating system by implementing a simplified approach using the deals table
- Improved error handling for contract completion and rating submission
- Eliminated inconsistencies in ID types throughout the database schema
- Improved mobile responsiveness across all primary layouts
- Fixed inconsistent styling between light and dark themes
- Enhanced accessibility for interactive elements
- Optimized performance for image-heavy sections

## [1.1.0] - 2025-03-21

### Added
- Enhanced Account Dashboard UI with Twitter 2023-inspired design
- Interactive profile completion progress tracker
- Improved loading animations with Twitter-style spinners
- New error state handling with actionable feedback

### Changed
- Upgraded About page with modern Twitter-inspired layout and animations
- Refined user profile cards with hover effects and verification badges
- Enhanced stats display with improved data visualization
- Updated navigation with smoother transitions and feedback

### Fixed
- Improved mobile responsiveness across all primary layouts
- Fixed inconsistent styling between light and dark themes
- Enhanced accessibility for interactive elements
- Optimized performance for image-heavy sections

## [1.0.0] - 2025-03-24

### Added
- New Footer component across all layouts
- Dashboard UI with Twitter-inspired design elements
- About page with enhanced visual elements and responsive design
- Account layout with improved navigation and interactive elements

### Changed
- Upgraded account layout with modern styling and animations
- Enhanced About page with Twitter-style UI components
- Improved account dashboard with profile completion indicator
- Updated navigation tabs with animated indicators
- Added floating action buttons with improved animations

### Fixed
- Improved responsive behavior across all layouts
- Enhanced visual hierarchy for better user experience
- Fixed dark/light mode consistency issues
- Optimized loading states with improved feedback

### Security
- Updated user verification methods
- Enhanced profile protection measures

## [0.9.0] - 2025-03-24

### Added
- Initial release of the UI framework
- Authentication system with login and registration
- Expert profile management
- Service mission functionality
- User dashboard
- Basic messaging system

### Changed
- N/A (initial release)

### Fixed
- N/A (initial release)

### Security
- Mise en place de politiques de sécurité (RLS) pour les signalements
- Validation des types de signalements et des raisons
- Protection contre les signalements multiples

## [Previous versions]
...

