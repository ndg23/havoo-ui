<template>
  <div class="min-h-screen bg-white">
    <div class="max-w-3xl mx-auto px-6 py-16">
      <!-- En-tête -->
      <div class="mb-16">
        <h1 class="text-2xl font-semibold text-gray-900 mb-3">
          Mentions Légales
        </h1>
        <p class="text-sm text-gray-500">
          Dernière mise à jour : {{ new Date().toLocaleDateString('fr-FR', { year: 'numeric', month: 'long', day: 'numeric' }) }}
        </p>
      </div>

      <!-- Sections -->
      <div class="space-y-12">
        <section 
          v-for="(section, index) in sections" 
          :key="index"
          class="scroll-mt-8"
        >
          <h2 class="text-xl font-semibold text-gray-900 mb-6">
            {{ section.title }}
          </h2>
          
          <div class="space-y-6 text-[15px] leading-relaxed text-gray-600">
            <div v-for="(info, key) in section.content" 
                 :key="key"
                 class="flex flex-col space-y-1"
            >
              <span class="text-gray-900">{{ key }}</span>
              <span class="text-gray-600">{{ info }}</span>
            </div>
          </div>
        </section>
      </div>

      <!-- Footer -->
      <footer class="mt-16 pt-8 border-t border-gray-100">
        <p class="text-sm text-gray-500 text-center">
          Copyright © {{ new Date().getFullYear() }} Sunutaf. Tous droits réservés.
        </p>
      </footer>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  layout: 'default'
})

const sections = [
  {
    title: "Informations Légales",
    content: {
      "Raison sociale": "Sunutaf SAS",
      "Capital social": "1 000 000 FCFA",
      "RCCM": "SN DKR 2024 B 12345",
      "NINEA": "123456789",
      "Siège social": "Dakar, Sénégal",
      "Adresse": "123 Avenue de l'Indépendance, Dakar"
    }
  },
  {
    title: "Représentant Légal",
    content: {
      "Directeur de la publication": "John Doe",
      "Fonction": "Président Directeur Général",
      "Contact": "direction@Sunutaf.com"
    }
  },
  {
    title: "Hébergement",
    content: {
      "Hébergeur": "Amazon Web Services (AWS)",
      "Société": "Amazon Web Services, Inc.",
      "Adresse": "410 Terry Avenue North, Seattle, WA 98109-5210, USA",
      "Contact": "https://aws.amazon.com/contact-us/"
    }
  },
  {
    title: "Protection des Données",
    content: {
      "Délégué à la Protection des Données": "Jane Smith",
      "Email": "dpo@Sunutaf.com",
      "Déclaration CDP": "N° 2024-001234/CDP",
      "Autorité de contrôle": "Commission de Protection des Données Personnelles (CDP)"
    }
  },
  {
    title: "Contacts",
    content: {
      "Service Client": "support@Sunutaf.com",
      "Service Commercial": "commercial@Sunutaf.com",
      "Service Technique": "tech@Sunutaf.com",
      "Téléphone": "+221 XX XXX XX XX",
      "Horaires": "Lundi au Vendredi, 9h-18h (GMT)"
    }
  },
  {
    title: "Propriété Intellectuelle",
    content: {
      "Marque déposée": "Sunutaf® est une marque déposée",
      "Numéro d'enregistrement": "MA-2024-001234",
      "Droits d'auteur": "Tous les contenus de ce site sont protégés par le droit d'auteur",
      "Licence": "Tous droits réservés Sunutaf SAS"
    }
  }
]
</script>

<style scoped>
html {
  scroll-behavior: smooth;
  font-size: 17px;
  line-height: 1.47059;
  font-weight: 400;
  letter-spacing: -0.022em;
  font-family: "Times New Roman", Times, serif;
  background-color: rgb(255, 255, 255);
  color: rgb(29, 29, 31);
  font-style: normal;
}
</style> 