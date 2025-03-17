export const useLegal = () => {
  const mentions = [
    {
      title: 'Informations légales',
      items: [
        {
          label: 'Raison sociale',
          value: 'Havoo Services SAS'
        },
        {
          label: 'Siège social',
          value: '123 Avenue des Champs-Élysées, 75008 Paris'
        },
        {
          label: 'Capital social',
          value: '10 000 FCFA'
        },
        {
          label: 'RCS',
          value: 'Paris B 123 456 789'
        }
      ]
    },
    {
      title: 'Hébergement',
      items: [
        {
          label: 'Hébergeur',
          value: 'OVH SAS'
        },
        {
          label: 'Adresse',
          value: '2 rue Kellermann - 59100 Roubaix - France'
        }
      ]
    }
  ]

  return {
    mentions
  }
} 