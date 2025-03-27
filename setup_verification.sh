#!/bin/bash

# Script pour initialiser le système de vérification des experts dans Supabase
# Ce script exécute le fichier database/setup_verification_system.sql
# Auteur: Havoo Team
# Date: Juin 2024

# Définition des couleurs pour une meilleure lisibilité
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Afficher le titre
echo -e "${BLUE}==========================================================${NC}"
echo -e "${BLUE}   INITIALISATION DU SYSTÈME DE VÉRIFICATION D'EXPERTS${NC}"
echo -e "${BLUE}==========================================================${NC}"
echo

# Vérifier les variables d'environnement
if [ -z "$SUPABASE_URL" ] || [ -z "$SUPABASE_KEY" ]; then
  echo -e "${RED}Erreur: Variables d'environnement manquantes${NC}"
  echo -e "${YELLOW}Veuillez définir les variables suivantes:${NC}"
  echo -e "  export SUPABASE_URL=https://votre-projet.supabase.co"
  echo -e "  export SUPABASE_KEY=votre-clé-service-role"
  exit 1
fi

# Vérifier l'existence du fichier SQL
SQL_FILE="database/setup_verification_system.sql"
if [ ! -f "$SQL_FILE" ]; then
  echo -e "${RED}Erreur: Fichier SQL introuvable - ${SQL_FILE}${NC}"
  echo -e "Veuillez créer ce fichier en vous basant sur la documentation du projet."
  exit 1
fi

echo -e "${YELLOW}Vérification des prérequis...${NC}"
echo "✓ Variables d'environnement configurées"
echo "✓ Fichier SQL disponible: ${SQL_FILE}"
echo

# Exécution du script SQL
echo -e "${YELLOW}Configuration du système de vérification des experts...${NC}"
echo "→ Connexion à Supabase: ${SUPABASE_URL}"
echo "→ Exécution du script SQL..."

RESPONSE=$(curl -s -X POST \
  -H "apikey: $SUPABASE_KEY" \
  -H "Authorization: Bearer $SUPABASE_KEY" \
  -H "Content-Type: application/json" \
  --data-binary @"$SQL_FILE" \
  "$SUPABASE_URL/rest/v1/sql")

# Vérifier si la requête a réussi
if [[ $RESPONSE == *"error"* ]]; then
  echo -e "${RED}Erreur lors de l'exécution du script SQL:${NC}"
  echo $RESPONSE | jq '.'
  exit 1
else
  echo -e "${GREEN}Le système de vérification des experts a été configuré avec succès!${NC}"
  echo
  echo -e "${BLUE}Fonctionnalités disponibles:${NC}"
  echo "✓ Politiques RLS pour la table verifications"
  echo "✓ Politiques RLS pour le bucket de stockage documents"
  echo "✓ Fonction mission_expert_verification pour les utilisateurs"
  echo "✓ Fonctions admin_verify_expert et admin_process_verification pour les administrateurs"
  echo "✓ Triggers pour les mises à jour automatiques"
  echo
  echo -e "${GREEN}Vous pouvez maintenant utiliser le système de vérification d'experts!${NC}"
fi

# Instructions supplémentaires
echo
echo -e "${YELLOW}Prochaines étapes:${NC}"
echo "1. Assurez-vous que votre frontend utilise correctement la fonction mission_expert_verification"
echo "2. Créez une interface d'administration pour gérer les demandes de vérification"
echo "3. Testez le téléchargement de documents via le bucket 'documents'"
echo
echo -e "${BLUE}==========================================================${NC}" 