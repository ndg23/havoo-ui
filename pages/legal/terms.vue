<template>
  <div class="min-h-screen bg-white">
    <div class="max-w-3xl mx-auto px-6 py-16">
      <!-- En-tête -->
      <div class="mb-16">
        <h1 class="text-2xl font-semibold text-gray-900 mb-3">
          Conditions d'Utilisation de Havoo
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
          
          <div class="space-y-2  leading-relaxed text-slate-800">
            <p v-for="paragraph in section.paragraphs" 
               :key="paragraph"
               class="text-justify"
            >
              {{ paragraph }}
            </p>
          </div>
        </section>
      </div>

      <!-- Footer -->
      <footer class="mt-16 pt-8 border-t border-gray-100">
        <p class="text-sm text-gray-500 text-center">
          Copyright © {{ new Date().getFullYear() }} Havoo. Tous droits réservés.
        </p>
      </footer>
    </div>
  </div>
</template>

<script setup lang="ts">
import { definePageMeta } from '#imports'

definePageMeta({
  layout: 'default'
})

const sections = [
  {
    title: "Introduction",
    paragraphs: [
      "Havoo est une plateforme innovante qui met en relation des experts qualifiés avec des particuliers en Afrique. Notre mission est de simplifier l'accès aux services professionnels tout en garantissant qualité et sécurité.",
      "En accédant à notre plateforme ou en utilisant nos services, vous acceptez d'être lié par les présentes conditions d'utilisation. Si vous n'acceptez pas ces conditions, nous vous prions de ne pas utiliser nos services."
    ]
  },
  {
    title: "Utilisation de nos Services",
    paragraphs: [
      "Pour utiliser Havoo, vous devez créer un compte avec des informations exactes et à jour. Vous êtes responsable de maintenir la confidentialité de vos identifiants de connexion et de toutes les activités qui se produisent sous votre compte.",
      "Nous nous réservons le droit de suspendre ou de résilier votre compte si nous constatons que vous avez fourni des informations inexactes ou que vous utilisez nos services d'une manière qui viole nos conditions."
    ]
  },
  {
    title: "Services et Paiements",
    paragraphs: [
      "Nos tarifs sont affichés en FCFA et incluent toutes les taxes applicables. Havoo agit comme intermédiaire et prélève une commission sur chaque transaction réalisée via notre plateforme.",
      "Les paiements sont traités de manière sécurisée par nos partenaires financiers agréés. Vous pouvez annuler un service jusqu'à 24 heures avant l'heure prévue, sous réserve de nos conditions d'annulation."
    ]
  },
  {
    title: "Protection de vos Données",
    paragraphs: [
      "La protection de vos données personnelles est au cœur de nos préoccupations. Nous collectons et traitons uniquement les informations nécessaires à la fourniture de nos services, conformément à notre politique de confidentialité.",
      "Vos données de paiement sont chiffrées et sécurisées selon les normes les plus strictes du secteur. Nous ne partageons vos informations avec des tiers que lorsque cela est nécessaire pour fournir nos services ou requis par la loi."
    ]
  },
  {
    title: "Contact",
    paragraphs: [
      "Pour toute question concernant ces conditions d'utilisation ou nos services, notre équipe support est disponible à l'adresse support@Havoo.com.",
      "Havoo s'engage à répondre à vos demandes dans les meilleurs délais et à maintenir une communication transparente avec tous nos utilisateurs."
    ]
  },
  {
    title: "Limitation de Responsabilité",
    paragraphs: [
      "Havoo agit uniquement en tant qu'intermédiaire entre les utilisateurs et les experts. Nous ne sommes pas responsables de la qualité des services fournis par les experts, ni des dommages directs ou indirects qui pourraient en résulter.",
      "Notre responsabilité financière est strictement limitée au montant de la commission perçue pour le service concerné. Nous ne pourrons être tenus responsables des pertes de profits, de données ou de tout autre dommage indirect."
    ]
  },
  {
    title: "Propriété Intellectuelle",
    paragraphs: [
      "L'ensemble du contenu de la plateforme Havoo (logos, textes, fonctionnalités, etc.) est protégé par les droits de propriété intellectuelle. Toute reproduction ou utilisation non autorisée de ces éléments est strictement interdite.",
      "En utilisant notre plateforme, vous vous engagez à ne pas copier, modifier, distribuer ou exploiter commercialement tout élément de notre service sans notre autorisation écrite préalable."
    ]
  },
  {
    title: "Résiliation et Suspension",
    paragraphs: [
      "Havoo se réserve le droit de suspendre ou résilier votre compte, à tout moment et sans préavis, si nous estimons que vous violez ces conditions ou que votre utilisation présente un risque pour notre plateforme ou d'autres utilisateurs.",
      "En cas de résiliation, vous perdez immédiatement l'accès à nos services. Les transactions en cours seront honorées, mais aucun remboursement ne sera effectué pour les services déjà rendus."
    ]
  },
  {
    title: "Modifications des Services",
    paragraphs: [
      "Nous nous réservons le droit de modifier, suspendre ou interrompre tout aspect de nos services à tout moment, y compris les tarifs, les fonctionnalités ou les conditions d'utilisation, sans notification préalable.",
      "Il est de votre responsabilité de consulter régulièrement ces conditions. La poursuite de votre utilisation des services après toute modification constitue votre acceptation des nouvelles conditions."
    ]
  },
  {
    title: "Droit Applicable",
    paragraphs: [
      "Ces conditions sont régies par le droit sénégalais. Tout litige relatif à leur interprétation ou leur exécution relève de la compétence exclusive des tribunaux de Dakar, sauf disposition légale contraire.",
      "En cas de litige, vous acceptez d'essayer de le résoudre d'abord à l'amiable en contactant notre service client avant d'engager toute action judiciaire."
    ]
  },
  {
    title: "Dispositions Diverses",
    paragraphs: [
      "Si une disposition de ces conditions est jugée invalide ou inapplicable, les autres dispositions restent pleinement en vigueur. Notre non-application d'une disposition ne constitue pas une renonciation à nos droits.",
      "Ces conditions constituent l'intégralité de l'accord entre vous et Havoo concernant l'utilisation de nos services, et remplacent tout accord antérieur."
    ]
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

.prose {
  max-width: none;
}
</style> 