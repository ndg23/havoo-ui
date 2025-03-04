export const useTerms = () => {
  const sections = [
    {
      title: 'Conditions Générales d\'Utilisation',
      content: [
        {
          subtitle: '1. Acceptation des conditions',
          text: 'En accédant et en utilisant l\'application Havoo Services, vous acceptez d\'être lié par ces conditions. Si vous n\'acceptez pas ces conditions, veuillez ne pas utiliser nos services.'
        },
        {
          subtitle: '2. Modifications des conditions',
          text: 'Nous nous réservons le droit de modifier ces conditions à tout moment. Les modifications prennent effet dès leur publication. Votre utilisation continue des services après toute modification constitue votre acceptation des conditions modifiées.'
        }
      ]
    },
    {
      title: 'Utilisation des Services',
      content: [
        {
          subtitle: '3. Éligibilité',
          text: 'Vous devez avoir au moins 18 ans et être légalement capable de contracter pour utiliser nos services. Si vous agissez pour le compte d\'une entreprise, vous déclarez avoir l\'autorité pour engager cette entité.'
        },
        {
          subtitle: '4. Compte utilisateur',
          text: 'Vous êtes responsable de maintenir la confidentialité de vos identifiants et de toutes les activités qui se produisent sous votre compte. Vous devez nous informer immédiatement de toute utilisation non autorisée.'
        }
      ]
    },
    {
      title: 'Services et Paiements',
      content: [
        {
          subtitle: '5. Description des services',
          text: 'Havoo Services est une plateforme de mise en relation entre particuliers et professionnels. Nous ne fournissons pas directement les services mais facilitons leur réservation.'
        },
        {
          subtitle: '6. Tarification et paiements',
          text: 'Les tarifs sont fixés par les prestataires. Nous appliquons des frais de service clairement indiqués. Les paiements sont sécurisés et traités par nos partenaires de confiance.'
        }
      ]
    },
    {
      title: 'Responsabilités',
      content: [
        {
          subtitle: '7. Obligations des utilisateurs',
          text: 'Vous vous engagez à fournir des informations exactes, à respecter les lois en vigueur et à ne pas utiliser nos services à des fins illégales ou non autorisées.'
        },
        {
          subtitle: '8. Limitation de responsabilité',
          text: 'Nous ne sommes pas responsables des actions des prestataires ou des utilisateurs. Notre responsabilité est limitée au fonctionnement de la plateforme.'
        }
      ]
    },
    {
      title: 'Protection des données',
      content: [
        {
          subtitle: '9. Collecte des données',
          text: 'Nous collectons et traitons vos données conformément à notre politique de confidentialité et au RGPD. Vos données sont sécurisées et ne sont jamais vendues à des tiers.'
        },
        {
          subtitle: '10. Cookies et traceurs',
          text: 'Nous utilisons des cookies et autres technologies similaires pour améliorer votre expérience. Vous pouvez gérer vos préférences dans les paramètres.'
        }
      ]
    }
  ]

  return {
    sections
  }
} 