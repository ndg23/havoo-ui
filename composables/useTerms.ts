export const useTerms = () => {
  const sections = [
    {
      id: 'introduction',
      title: 'Introduction',
      content: {
        text: 'Sunutaf est une plateforme innovante qui connecte les experts et les particuliers en Afrique. Ces conditions régissent votre utilisation de nos services.',
        subsections: [
          {
            title: 'Acceptation des conditions',
            text: 'En utilisant Sunutaf, vous acceptez d être lié par ces conditions. Si vous n\'acceptez pas ces conditions, vous ne devez pas utiliser la plateforme.'
          },
          {
            title: 'Modifications',
            text: 'Nous nous réservons le droit de modifier ces conditions à tout moment. Les modifications prennent effet dès leur publication.'
          }
        ]
      }
    },
    {
      id: 'eligibilite',
      title: 'Éligibilité',
      content: {
        text: 'Pour utiliser Sunutaf, vous devez remplir certaines conditions d\'éligibilité.',
        list: [
          'Être âgé d\'au moins 18 ans',
          'Avoir la capacité juridique de contracter',
          'Résider dans un pays où Sunutaf opère',
          'Fournir des informations exactes et à jour'
        ]
      }
    },
    {
      id: 'services',
      title: 'Services',
      content: {
        subsections: [
          {
            title: 'Description des services',
            text: 'Sunutaf permet la mise en relation entre experts qualifiés et clients pour divers services.',
            list: [
              'Services à domicile',
              'Services professionnels',
              'Conseil et expertise',
              'Formation et éducation'
            ]
          },
          {
            title: 'Qualité des services',
            text: 'Nous nous efforçons de maintenir une haute qualité de service à travers notre plateforme.',
            list: [
              'Vérification des experts',
              'Système d\'évaluation',
              'Support client 24/7',
              'Garantie satisfaction'
            ]
          }
        ]
      }
    },
    {
      id: 'paiements',
      title: 'Paiements',
      content: {
        text: 'Les transactions financières sur Sunutaf sont sécurisées et transparentes.',
        subsections: [
          {
            title: 'Méthodes de paiement',
            list: [
              'Mobile Money',
              'Cartes bancaires',
              'Transferts bancaires',
              'Paiements en espèces (selon conditions)'
            ]
          },
          {
            title: 'Commission',
            text: 'Sunutaf prélève une commission de 10% sur chaque transaction réussie.'
          }
        ]
      }
    }
  ]

  return {
    sections
  }
} 