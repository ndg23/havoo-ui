<template>
  <div class="min-h-screen bg-white">
    <div class="max-w-3xl mx-auto px-6 py-16">
      <!-- En-tête -->
      <div class="mb-16">
        <h1 class="text-2xl font-semibold text-gray-900 mb-3">
          Politique de Confidentialité
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
          
          <div class="space-y-4 leading-relaxed text-slate-800">
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
          Copyright © {{ new Date().getFullYear() }} Keetaf. Tous droits réservés.
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
      "Chez Keetaf, nous accordons une grande importance à la protection de vos données personnelles. Cette politique de confidentialité explique comment nous collectons, utilisons et protégeons vos informations lorsque vous utilisez notre plateforme.",
      "En utilisant Keetaf, vous acceptez les pratiques décrites dans cette politique de confidentialité. Si vous n'acceptez pas cette politique, veuillez ne pas utiliser nos services."
    ]
  },
  {
    title: "Données Collectées",
    paragraphs: [
      "Nous collectons les informations que vous nous fournissez directement : nom, prénom, adresse email, numéro de téléphone, et informations de paiement lors de votre inscription ou de l'utilisation de nos services.",
      "Nous recueillons également automatiquement certaines informations techniques : adresse IP, type de navigateur, appareil utilisé, pages visitées, et données d'utilisation pour améliorer nos services.",
      "Si vous êtes un expert, nous collectons des informations supplémentaires : qualifications, expérience professionnelle, et documents d'identité pour la vérification."
    ]
  },
  {
    title: "Utilisation des Données",
    paragraphs: [
      "Vos données sont utilisées pour : fournir et améliorer nos services, personnaliser votre expérience, traiter vos paiements, communiquer avec vous, et assurer la sécurité de notre plateforme.",
      "Nous analysons les données d'utilisation pour optimiser nos services et développer de nouvelles fonctionnalités adaptées à vos besoins.",
      "Vos informations nous aident également à prévenir et détecter les fraudes et autres activités abusives."
    ]
  },
  {
    title: "Protection des Données",
    paragraphs: [
      "Nous mettons en œuvre des mesures de sécurité techniques et organisationnelles pour protéger vos données : chiffrement, contrôles d'accès, et surveillance continue de notre infrastructure.",
      "Nos employés sont formés à la protection des données et n'ont accès qu'aux informations nécessaires à leur fonction.",
      "Nous effectuons régulièrement des audits de sécurité et mettons à jour nos systèmes pour maintenir le plus haut niveau de protection."
    ]
  },
  {
    title: "Partage des Données",
    paragraphs: [
      "Nous ne vendons jamais vos données personnelles. Nous les partageons uniquement avec des tiers de confiance nécessaires à la fourniture de nos services : processeurs de paiement, services de vérification d'identité, et hébergeurs.",
      "Dans certains cas, nous pouvons être tenus de partager vos informations pour respecter une obligation légale ou protéger nos droits."
    ]
  },
  {
    title: "Vos Droits",
    paragraphs: [
      "Vous disposez de droits sur vos données : accès, rectification, suppression, portabilité, limitation du traitement, et opposition au traitement.",
      "Pour exercer ces droits, contactez notre Délégué à la Protection des Données à dpo@Keetaf.com. Nous répondrons à votre demande dans un délai d'un mois."
    ]
  },
  {
    title: "Conservation des Données",
    paragraphs: [
      "Nous conservons vos données aussi longtemps que nécessaire pour fournir nos services ou respecter nos obligations légales.",
      "Après la fermeture de votre compte, nous conservons certaines données pendant la durée légale requise avant de les supprimer ou de les anonymiser."
    ]
  },
  {
    title: "Modifications",
    paragraphs: [
      "Nous pouvons mettre à jour cette politique de confidentialité. Les modifications importantes vous seront notifiées par email ou via notre plateforme.",
      "La date de dernière mise à jour en haut de cette page indique quand les derniers changements ont été effectués."
    ]
  },
  {
    title: "Contact",
    paragraphs: [
      "Pour toute question concernant cette politique ou vos données personnelles, contactez notre Délégué à la Protection des Données :",
      "Email : dpo@Keetaf.com\nAdresse : Keetaf SAS, 123 Avenue de l'Indépendance, Dakar, Sénégal"
    ]
  }
]
</script>

<style scoped>
html,body {
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

p {
  display: block;
  margin-block-start: 1em;
  margin-block-end: 1em;
  margin-inline-start: 0px;
  margin-inline-end: 0px;
  unicode-bidi: isolate;
}
</style> 