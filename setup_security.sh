#!/bin/bash

# Script pour initialiser les politiques de sécurité dans Supabase
# Assurez-vous d'avoir les variables d'environnement SUPABASE_URL et SUPABASE_KEY définies

# Vérifier les variables d'environnement
if [ -z "$SUPABASE_URL" ] || [ -z "$SUPABASE_KEY" ]; then
  echo "Erreur: Veuillez définir les variables d'environnement SUPABASE_URL et SUPABASE_KEY"
  echo "Exemple:"
  echo "export SUPABASE_URL=https://votre-projet.supabase.co"
  echo "export SUPABASE_KEY=votre-clé-service-role"
  exit 1
fi

echo "Configuration des politiques de sécurité..."

# Exécuter le script SQL à l'aide de l'API REST de Supabase
curl -X POST \
  -H "apikey: $SUPABASE_KEY" \
  -H "Authorization: Bearer $SUPABASE_KEY" \
  -H "Content-Type: application/json" \
  --data-binary @database/init_security.sql \
  "$SUPABASE_URL/rest/v1/sql" 

if [ $? -eq 0 ]; then
  echo "Les politiques de sécurité ont été configurées avec succès."
  echo "Vous pouvez maintenant télécharger des documents pour la vérification d'experts."
else
  echo "Une erreur est survenue lors de la configuration des politiques de sécurité."
  echo "Veuillez vérifier vos informations d'identification Supabase et réessayer."
fi 