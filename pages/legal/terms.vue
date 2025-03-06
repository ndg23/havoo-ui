<template>
  <div class="bg-gray-50 min-h-screen">
      <!-- En-tête -->
    <div class="bg-white border-b border-gray-200 sticky top-0 z-10">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
          <div class="flex items-center">
            <NuxtLink to="/" class="flex-shrink-0">
            </NuxtLink>
            <h1 class="ml-4 text-xl font-semibold text-gray-900">Conditions d'utilisation</h1>
          </div>
          <div>
            <NuxtLink to="/" class="text-primary-600 hover:text-primary-800 font-medium">
              Retour à l'accueil
            </NuxtLink>
          </div>
        </div>
      </div>
      </div>

    <!-- Contenu principal -->
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 lg:py-12">
      <div class="lg:grid lg:grid-cols-12 lg:gap-8">
        <!-- Barre latérale de navigation -->
        <aside class="lg:col-span-3">
          <nav class="sticky top-24 space-y-1 bg-white rounded-lg shadow-sm border border-gray-200 p-4">
            <p class="text-xs uppercase tracking-wider text-gray-500 font-semibold mb-2">
              Naviguer
            </p>
            <button 
          v-for="(section, index) in sections" 
          :key="index"
              @click="scrollToSection(section.id)"
              class="block w-full text-left px-3 py-2 text-sm rounded-md transition-colors"
              :class="activeSection === section.id ? 'bg-primary-50 text-primary-700 font-medium' : 'text-gray-600 hover:bg-gray-50'"
        >
            {{ section.title }}
            </button>
            
            <div class="mt-6 border-t border-gray-200 pt-4">
              <p class="text-xs uppercase tracking-wider text-gray-500 font-semibold mb-2">
                Autres documents
              </p>
              <NuxtLink 
                to="/legal/privacy"
                class="block px-3 py-2 text-sm rounded-md text-gray-600 hover:bg-gray-50"
              >
                Politique de confidentialité
              </NuxtLink>
              <NuxtLink 
                to="/legal/cookies"
                class="block px-3 py-2 text-sm rounded-md text-gray-600 hover:bg-gray-50"
              >
                Politique des cookies
              </NuxtLink>
            </div>
            
            <div class="mt-6 bg-blue-50 rounded-lg p-4">
              <h4 class="text-sm font-medium text-blue-800">Dernière mise à jour</h4>
              <p class="text-sm text-blue-600 mt-1">15 juin 2023</p>
              <div class="mt-3 flex items-center">
                <FileText class="h-4 w-4 text-blue-600 mr-2" />
                <a href="#" class="text-sm text-blue-600 hover:text-blue-800">
                  Télécharger en PDF
                </a>
              </div>
            </div>
          </nav>
        </aside>

        <!-- Contenu des conditions -->
        <div class="mt-8 lg:mt-0 lg:col-span-9">
          <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
            <!-- Introduction -->
            <div class="px-6 py-4 bg-gray-50 border-b border-gray-200">
              <h2 class="text-lg font-semibold text-gray-900">
                Conditions Générales d'Utilisation de la plateforme
          </h2>
              <p class="mt-1 text-sm text-gray-600">
                En vigueur depuis le 15 juin 2023
              </p>
            </div>
            
            <!-- Préambule -->
            <div class="p-6 prose prose-sm max-w-none">
              <p>
                Bienvenue sur notre plateforme de services à domicile. Avant d'utiliser nos services, 
                nous vous invitons à lire attentivement les présentes Conditions Générales d'Utilisation
                qui constituent un contrat entre vous et notre société.
              </p>
              <p>
                En utilisant notre plateforme, vous acceptez d'être lié par les présentes conditions.
                Si vous n'acceptez pas ces conditions, veuillez ne pas utiliser notre plateforme.
              </p>
            </div>
            
            <!-- Sections des conditions -->
            <div class="border-t border-gray-200">
              <div 
                v-for="(section, index) in sections" 
                :key="index"
                :id="section.id"
                :ref="el => sectionRefs[section.id] = el"
                class="p-6 border-b border-gray-200 section-container"
              >
                <h3 class="text-lg font-semibold text-gray-900 mb-4">
                  Article {{ index + 1 }} - {{ section.title }}
                </h3>
                
                <div class="prose prose-sm max-w-none">
                  <div v-for="(subsection, subIndex) in section.content" :key="subIndex" class="mb-4">
                    <h4 v-if="subsection.title" class="font-medium text-gray-900 mb-2">
                      {{ index + 1 }}.{{ subIndex + 1 }}. {{ subsection.title }}
                    </h4>
                    <p v-for="(paragraph, pIndex) in subsection.paragraphs" :key="pIndex" class="mb-2">
                      {{ paragraph }}
                    </p>
                  </div>
                </div>
              </div>
            </div>
            
            <!-- Pied de page -->
            <div class="px-6 py-4 bg-gray-50 border-t border-gray-200 text-center">
              <p class="text-sm text-gray-600">
                Pour toute question concernant ces conditions, contactez-nous à 
                <a href="mailto:legal@example.com" class="text-primary-600 hover:text-primary-800">
                  legal@example.com
                </a>
              </p>
            </div>
          </div>
          
          <!-- Boutons de navigation entre sections -->
          <div class="mt-6 flex justify-between">
            <button 
              @click="navigateToPreviousSection"
              class="inline-flex items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50"
              :disabled="!previousSection"
            >
              <ChevronLeft class="h-4 w-4 mr-1" />
              Section précédente
            </button>
            
            <button 
              @click="navigateToNextSection"
              class="inline-flex items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50"
              :disabled="!nextSection"
            >
              Section suivante
              <ChevronRight class="h-4 w-4 ml-1" />
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { ChevronLeft, ChevronRight, FileText } from 'lucide-vue-next'

// Sections des conditions d'utilisation
const sections = [
  {
    id: 'definitions',
    title: 'Définitions',
    content: [
      {
        paragraphs: [
          'Dans les présentes conditions générales d\'utilisation, les termes ci-dessous ont la signification suivante :',
          '"Plateforme" : le site web et l\'application mobile permettant d\'accéder aux services.',
          '"Utilisateur" : toute personne ayant créé un compte sur la Plateforme.',
          '"Client" : Utilisateur qui publie des demandes de services sur la Plateforme.',
          '"Expert" : Utilisateur qui propose ses services professionnels via la Plateforme.',
            '"Service" : prestation réalisée par un Expert au bénéfice d\'un Client.',
          '"Demande" : publication d\'un Client précisant ses besoins en matière de services.'
        ]
      }
    ]
  },
  {
    id: 'inscription',
    title: 'Inscription et compte utilisateur',
    content: [
      {
        title: 'Conditions d\'inscription',
        paragraphs: [
          'Pour s\'inscrire sur la Plateforme, l\'Utilisateur doit être une personne physique âgée d\'au moins 18 ans et jouissant de sa pleine capacité juridique, ou une personne morale dûment enregistrée.',
          'L\'Utilisateur garantit que les informations fournies lors de son inscription sont exactes, sincères et à jour. Il s\'engage à les mettre à jour régulièrement.'
        ]
      },
      {
        title: 'Création et gestion du compte',
        paragraphs: [
          'L\'inscription s\'effectue via un formulaire en ligne. L\'Utilisateur choisit un identifiant et un mot de passe qui lui permettront d\'accéder à son compte.',
          'L\'Utilisateur est seul responsable de la préservation et de la confidentialité de son identifiant et de son mot de passe. Il s\'engage à prendre toutes les mesures nécessaires pour empêcher l\'utilisation de son compte par des tiers non autorisés.',
          'Toute connexion ou transmission de données effectuée en utilisant les identifiants de l\'Utilisateur sera réputée avoir été effectuée par l\'Utilisateur lui-même.'
        ]
      },
      {
        title: 'Vérification d\'identité',
    paragraphs: [
          'La Plateforme se réserve le droit de mettre en place des procédures de vérification d\'identité, notamment pour les Experts.',
          'Ces procédures peuvent inclure la transmission de documents officiels d\'identité et/ou professionnels.',
          'L\'Utilisateur accepte de se soumettre à ces procédures pour pouvoir bénéficier de l\'ensemble des fonctionnalités de la Plateforme.'
        ]
      }
    ]
  },
  {
    id: 'services',
    title: 'Description des services',
    content: [
      {
        title: 'Objet de la Plateforme',
        paragraphs: [
          'La Plateforme est un service de mise en relation entre des Clients ayant des besoins de services à domicile et des Experts proposant leurs compétences professionnelles.',
          'La Plateforme agit uniquement comme intermédiaire et n\'est pas partie aux contrats conclus entre les Clients et les Experts.'
        ]
      },
      {
        title: 'Services proposés aux Clients',
        paragraphs: [
          'Publication de demandes de services avec description, budget et contraintes horaires',
          'Recherche d\'Experts par catégorie, localisation ou notation',
          'Réception et évaluation de propositions d\'Experts',
          'Système de messagerie intégrée avec les Experts',
          'Gestion du paiement sécurisé des prestations',
          'Évaluation des services rendus'
        ]
      },
      {
        title: 'Services proposés aux Experts',
    paragraphs: [
          'Création d\'un profil professionnel détaillé',
          'Recherche et réponse aux demandes de services',
          'Proposition de services avec tarification personnalisée',
          'Système de messagerie intégrée avec les Clients',
          'Gestion du calendrier et des rendez-vous',
          'Réception des paiements via la Plateforme'
        ]
      }
    ]
  },
  {
    id: 'conditions-expert',
    title: 'Conditions spécifiques pour les Experts',
    content: [
      {
        title: 'Éligibilité et vérification',
        paragraphs: [
          'Pour devenir Expert sur la Plateforme, l\'Utilisateur doit remplir des conditions d\'éligibilité notamment en matière de qualifications professionnelles, d\'expérience et de capacité à exercer légalement son activité.',
          'L\'Expert s\'engage à fournir tous les documents justificatifs demandés dans le cadre de la procédure de vérification (pièce d\'identité, justificatif de domicile, diplômes, certifications, assurances professionnelles, etc.).',
          'La Plateforme se réserve le droit de refuser ou suspendre le statut d\'Expert si les conditions d\'éligibilité ne sont pas remplies ou si les documents fournis sont incomplets ou frauduleux.'
        ]
      },
      {
        title: 'Obligations et responsabilités',
        paragraphs: [
          'L\'Expert s\'engage à exécuter les services avec professionnalisme, dans le respect des règles de l\'art de sa profession et des délais convenus avec le Client.',
          'L\'Expert est seul responsable de la qualité des services qu\'il fournit, de sa conformité aux lois et règlements en vigueur, et des conséquences dommageables pouvant résulter de leur exécution.',
          'L\'Expert doit disposer des assurances professionnelles adaptées à son activité et couvrant sa responsabilité civile professionnelle.',
          'L\'Expert est tenu de respecter les règles fiscales et sociales applicables à son activité, notamment en matière de déclaration de revenus.'
        ]
      },
      {
        title: 'Commissions et frais',
    paragraphs: [
          'En contrepartie de l\'utilisation de la Plateforme, l\'Expert accepte qu\'une commission soit prélevée sur le montant payé par le Client pour chaque service réalisé.',
          'Le taux de commission applicable est celui en vigueur au moment de l\'acceptation de la proposition par le Client, tel qu\'indiqué dans les paramètres du compte Expert.',
          'Des frais supplémentaires peuvent s\'appliquer pour des services optionnels proposés par la Plateforme (mise en avant du profil, fonctionnalités premium, etc.).'
        ]
      }
    ]
  },
  {
    id: 'conditions-client',
    title: 'Conditions spécifiques pour les Clients',
    content: [
      {
        title: 'Publication des demandes',
        paragraphs: [
          'Le Client est responsable de la description précise et complète de ses besoins lors de la publication d\'une demande de service.',
          'Le Client s\'engage à ne pas publier de demandes illicites, contraires aux bonnes mœurs ou à l\'ordre public.',
          'La Plateforme se réserve le droit de refuser ou retirer toute demande qui ne respecterait pas les présentes conditions.'
        ]
      },
      {
        title: 'Sélection et accord avec un Expert',
        paragraphs: [
          'Le Client est libre de sélectionner l\'Expert de son choix parmi ceux ayant proposé leurs services.',
          'La formation du contrat entre le Client et l\'Expert intervient lors de l\'acceptation explicite d\'une proposition par le Client via la Plateforme.',
          'Une fois la proposition acceptée, le Client s\'engage à respecter les termes convenus avec l\'Expert (date, horaire, lieu, etc.).'
        ]
      },
      {
        title: 'Paiement des services',
        paragraphs: [
          'Le Client s\'engage à payer le prix convenu pour les services via les moyens de paiement proposés par la Plateforme.',
          'Le paiement est généralement sécurisé en amont de la prestation, puis libéré à l\'Expert après confirmation de la bonne exécution du service.',
          'Le Client accepte que les frais de service de la Plateforme puissent être ajoutés au montant total à payer.'
        ]
      },
      {
        title: 'Évaluation des prestations',
    paragraphs: [
          'Le Client est invité à évaluer les services réalisés par l\'Expert après leur exécution.',
          'Ces évaluations doivent être objectives, sincères et respectueuses.',
          'La Plateforme se réserve le droit de modérer ou supprimer les évaluations qui ne respecteraient pas ces principes.'
        ]
      }
    ]
  },
  {
    id: 'payements',
    title: 'Conditions financières et paiements',
    content: [
      {
        title: 'Tarification des services',
        paragraphs: [
          'Les tarifs des services sont librement fixés par les Experts et clairement indiqués dans leurs propositions.',
          'La Plateforme peut suggérer des fourchettes de prix indicatives basées sur le marché, mais ne fixe pas les tarifs des prestations.'
        ]
      },
      {
        title: 'Frais de service',
        paragraphs: [
          'La Plateforme perçoit une commission sur chaque transaction réalisée entre un Client et un Expert.',
          'Cette commission est calculée sous forme de pourcentage du montant total de la prestation.',
          'Le détail des commissions et frais applicables est disponible dans la rubrique "Frais de service" accessible depuis le compte utilisateur.'
        ]
      },
      {
        title: 'Modalités de paiement',
        paragraphs: [
          'Les paiements sont effectués exclusivement via les moyens de paiement sécurisés proposés par la Plateforme.',
          'Le Client procède au paiement lors de l\'acceptation d\'une proposition d\'Expert.',
          'Le montant est conservé en séquestre par la Plateforme jusqu\'à confirmation de la bonne exécution du service.'
        ]
      },
      {
        title: 'Versement aux Experts',
        paragraphs: [
          'Le montant dû à l\'Expert (déduction faite de la commission de la Plateforme) est versé sur son compte bancaire dans un délai de 7 jours ouvrés après confirmation de la bonne exécution du service.',
          'L\'Expert est responsable de la véracité et de l\'exactitude des coordonnées bancaires fournies pour le versement.'
        ]
      },
      {
        title: 'Facturation',
    paragraphs: [
          'Une facture électronique est automatiquement générée et mise à disposition du Client et de l\'Expert pour chaque transaction.',
          'Cette facture détaille le service réalisé, son prix, les frais de service et les taxes applicables.'
        ]
      }
    ]
  },
  {
    id: 'intellectual-property',
    title: 'Propriété intellectuelle',
    content: [
      {
        title: 'Droits de la Plateforme',
        paragraphs: [
          'La Plateforme et son contenu (logiciels, architecture, textes, graphiques, images, sons, vidéos, etc.) sont protégés par des droits de propriété intellectuelle.',
          'Ces éléments sont la propriété exclusive de la société exploitant la Plateforme ou de tiers ayant autorisé leur utilisation.',
          'Toute reproduction, représentation, modification ou exploitation non autorisée de tout ou partie de la Plateforme est interdite et constituerait une contrefaçon sanctionnée par le Code de la propriété intellectuelle.'
        ]
      },
      {
        title: 'Licence d\'utilisation',
        paragraphs: [
          'La Plateforme concède à l\'Utilisateur un droit d\'usage personnel, non exclusif et non transférable, des fonctionnalités de la Plateforme, dans le cadre d\'une utilisation normale et conforme à sa destination.',
          'Cette licence est consentie pour le monde entier et pour la durée de l\'inscription de l\'Utilisateur à la Plateforme.',
          'L\'Utilisateur s\'engage à ne pas détourner l\'usage de la Plateforme à des fins autres que celles pour lesquelles elle a été conçue.'
        ]
      },
      {
        title: 'Contenus générés par les Utilisateurs',
    paragraphs: [
          'L\'Utilisateur conserve l\'intégralité des droits de propriété intellectuelle sur les contenus qu\'il publie sur la Plateforme (textes, images, etc.).',
          'Toutefois, en publiant du contenu sur la Plateforme, l\'Utilisateur concède à la Plateforme une licence mondiale, non exclusive, gratuite, pour la durée de protection des droits, d\'utiliser, reproduire, représenter, diffuser et adapter ce contenu, sur tout support et par tout moyen, aux fins de fourniture des services de la Plateforme et de promotion de celle-ci.',
          'L\'Utilisateur garantit qu\'il dispose de tous les droits nécessaires pour accorder cette licence et que son contenu ne porte pas atteinte aux droits des tiers.'
        ]
      }
    ]
  },
  {
    id: 'data-protection',
    title: 'Protection des données personnelles',
    content: [
      {
        title: 'Politique de confidentialité',
        paragraphs: [
          'La Plateforme collecte et traite les données personnelles des Utilisateurs conformément à sa Politique de confidentialité, accessible depuis toutes les pages de la Plateforme.',
          'Cette politique détaille les types de données collectées, leurs finalités de traitement, leur durée de conservation, ainsi que les droits des Utilisateurs concernant leurs données.'
        ]
      },
      {
        title: 'Droits des Utilisateurs',
        paragraphs: [
          'Conformément à la réglementation applicable en matière de protection des données personnelles, notamment le Règlement Général sur la Protection des Données (RGPD), l\'Utilisateur dispose de droits d\'accès, de rectification, d\'effacement, de limitation, d\'opposition et de portabilité concernant ses données.',
          'Pour exercer ces droits, l\'Utilisateur peut contacter le Délégué à la Protection des Données de la Plateforme à l\'adresse indiquée dans la Politique de confidentialité.'
        ]
      },
      {
        title: 'Sécurité des données',
    paragraphs: [
          'La Plateforme met en œuvre des mesures techniques et organisationnelles appropriées pour assurer la sécurité des données personnelles des Utilisateurs et prévenir leur accès non autorisé, leur altération, leur divulgation ou leur destruction.',
          'En cas de violation de données susceptible d\'engendrer un risque élevé pour les droits et libertés des Utilisateurs, la Plateforme s\'engage à les en informer dans les délais prévus par la réglementation applicable.'
        ]
      }
    ]
  },
  {
    id: 'responsibility',
    title: 'Responsabilité et garanties',
    content: [
      {
        title: 'Responsabilité de la Plateforme',
        paragraphs: [
          'La Plateforme agit en qualité d\'intermédiaire technique mettant en relation des Clients et des Experts. Elle n\'est pas partie aux contrats conclus entre eux et ne saurait être tenue responsable de l\'exécution ou de l\'inexécution de ces contrats.',
          'La Plateforme s\'efforce d\'assurer la disponibilité et le bon fonctionnement de ses services, mais ne peut garantir une disponibilité continue et sans erreur.',
          'La responsabilité de la Plateforme ne pourra être engagée qu\'en cas de faute prouvée et pour les dommages directs résultant de cette faute, à l\'exclusion de tout dommage indirect.'
        ]
      },
      {
        title: 'Responsabilité des Utilisateurs',
        paragraphs: [
          'L\'Utilisateur est seul responsable de l\'utilisation qu\'il fait de la Plateforme et des contenus qu\'il y publie.',
          'L\'Expert est seul responsable de la qualité et de la légalité des services qu\'il propose et réalise.',
          'Le Client est seul responsable de la définition précise de ses besoins et de la vérification de l\'adéquation des propositions des Experts à ces besoins.'
        ]
      },
      {
        title: 'Exclusion de garanties',
        paragraphs: [
          'La Plateforme ne garantit pas que les Experts disposent des compétences, qualifications et assurances nécessaires pour réaliser les services proposés, malgré les procédures de vérification mises en place.',
          'La Plateforme ne garantit pas la qualité, la sécurité ou la légalité des services réalisés par les Experts, ni la véracité ou l\'exactitude des informations fournies par les Utilisateurs.'
        ]
      },
      {
        title: 'Force majeure',
    paragraphs: [
          'Ni la Plateforme ni l\'Utilisateur ne pourra être tenu responsable d\'un manquement à ses obligations résultant d\'un cas de force majeure tel que défini par la jurisprudence des tribunaux français.'
        ]
      }
    ]
  },
  {
    id: 'termination',
    title: 'Suspension et résiliation',
    content: [
      {
        title: 'Suspension du compte',
        paragraphs: [
          'La Plateforme se réserve le droit de suspendre temporairement l\'accès au compte d\'un Utilisateur en cas de manquement aux présentes conditions, de comportement frauduleux ou de tout autre motif légitime.',
          'L\'Utilisateur sera informé de cette suspension et des motifs la justifiant, sauf si cette information compromet la sécurité de la Plateforme ou d\'autres Utilisateurs.'
        ]
      },
      {
        title: 'Résiliation par l\'Utilisateur',
        paragraphs: [
          'L\'Utilisateur peut à tout moment résilier son inscription à la Plateforme en supprimant son compte depuis les paramètres de celui-ci.',
          'La résiliation prend effet immédiatement, sous réserve de l\'achèvement des transactions en cours et du respect des obligations qui survivent à la résiliation.'
        ]
      },
      {
        title: 'Résiliation par la Plateforme',
        paragraphs: [
          'La Plateforme peut résilier le compte d\'un Utilisateur en cas de manquement grave ou répété aux présentes conditions, de comportement frauduleux ou préjudiciable, ou d\'inactivité prolongée.',
          'La Plateforme notifiera à l\'Utilisateur cette résiliation et les motifs la justifiant, sauf si cette notification compromet la sécurité de la Plateforme ou d\'autres Utilisateurs.'
        ]
      },
      {
        title: 'Conséquences de la résiliation',
    paragraphs: [
          'En cas de résiliation, l\'Utilisateur perdra l\'accès à son compte et à toutes les fonctionnalités de la Plateforme.',
          'Les transactions en cours devront être achevées conformément aux conditions convenues.',
          'Les données de l\'Utilisateur seront traitées conformément à la Politique de confidentialité.'
        ]
      }
    ]
  },
  {
    id: 'disputes',
    title: 'Litiges et droit applicable',
    content: [
      {
        title: 'Loi applicable',
        paragraphs: [
          'Les présentes conditions générales d\'utilisation sont soumises au droit français.',
          'La langue d\'interprétation des présentes conditions est le français. En cas de traduction dans une autre langue, seule la version française fait foi.'
        ]
      },
      {
        title: 'Résolution amiable des litiges',
        paragraphs: [
          'En cas de litige relatif à l\'utilisation de la Plateforme, l\'Utilisateur s\'engage à contacter d\'abord le service client de la Plateforme pour rechercher une solution amiable.',
          'Pour les litiges entre Clients et Experts, la Plateforme propose un service de médiation accessible depuis l\'interface de gestion des commandes.'
        ]
      },
      {
        title: 'Médiation et juridiction compétente',
    paragraphs: [
          'Conformément aux dispositions du Code de la consommation, l\'Utilisateur consommateur a le droit de recourir à un médiateur de la consommation en vue de la résolution amiable d\'un litige avec la Plateforme.',
          'À défaut de résolution amiable, tout litige relatif à l\'utilisation de la Plateforme sera soumis aux tribunaux français compétents selon les règles de procédure applicables.'
        ]
      }
    ]
  },
  {
    id: 'modifications',
    title: 'Modifications des conditions',
    content: [
      {
    paragraphs: [
          'La Plateforme se réserve le droit de modifier les présentes conditions générales d\'utilisation à tout moment.',
          'Les Utilisateurs seront informés de toute modification par notification sur la Plateforme et/ou par email, au moins 15 jours avant l\'entrée en vigueur des nouvelles conditions.',
          'L\'Utilisateur qui continue à utiliser la Plateforme après l\'entrée en vigueur des modifications est réputé avoir accepté les nouvelles conditions.',
          'En cas de désaccord avec les nouvelles conditions, l\'Utilisateur est libre de résilier son inscription à la Plateforme avant leur entrée en vigueur.'
        ]
      }
    ]
  }
]

// Gestion de la navigation entre sections
const sectionRefs = ref({})
const activeSection = ref('definitions')

// Observer pour détecter la section visible
onMounted(() => {
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting && entry.intersectionRatio > 0.5) {
        activeSection.value = entry.target.id
      }
    })
  }, { threshold: 0.5 })
  
  // Observer toutes les sections après le premier rendu
  setTimeout(() => {
    Object.values(sectionRefs.value).forEach(el => {
      if (el) observer.observe(el)
    })
  }, 100)
})

// Méthode pour scroller vers une section
const scrollToSection = (sectionId) => {
  const element = sectionRefs.value[sectionId]
  if (element) {
    element.scrollIntoView({ behavior: 'smooth', block: 'start' })
    activeSection.value = sectionId
  }
}

// Navigation entre sections
const currentSectionIndex = computed(() => {
  return sections.findIndex(section => section.id === activeSection.value)
})

const previousSection = computed(() => {
  return currentSectionIndex.value > 0 ? sections[currentSectionIndex.value - 1] : null
})

const nextSection = computed(() => {
  return currentSectionIndex.value < sections.length - 1 ? sections[currentSectionIndex.value + 1] : null
})

const navigateToPreviousSection = () => {
  if (previousSection.value) {
    scrollToSection(previousSection.value.id)
  }
}

const navigateToNextSection = () => {
  if (nextSection.value) {
    scrollToSection(nextSection.value.id)
  }
}
</script>

<style scoped>
/* Animation pour la sidebar et le défilement */
nav {
  transition: top 0.3s ease;
}

.section-container {
  scroll-margin-top: 6rem;
}
</style> 