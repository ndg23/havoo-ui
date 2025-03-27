export default defineNuxtPlugin(() => {
    useSeoMeta({
      titleTemplate: '%s | NomDeVotrePlateforme',
      defaultTitle: 'NomDeVotrePlateforme - Description courte de votre plateforme',
      description: 'Description complète de votre plateforme, optimisée pour les moteurs de recherche',
      
      // Open Graph / Facebook
      ogType: 'website',
      ogSiteName: 'NomDeVotrePlateforme',
      ogImage: 'https://keetaf.com/images/og-image.jpg',
      
      // Twitter
      twitterCard: 'summary_large_image',
      twitterSite: '@votrecompte',
      
      // Autres métadonnées importantes
      themeColor: '#votre-couleur-principale',
      
      // Robots
      robots: {
        index: true,
        follow: true,
        'max-video-preview': -1,
        'max-image-preview': 'large',
        'max-snippet': -1,
      },
    })
  })