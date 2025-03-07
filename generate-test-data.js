import { createClient } from '@supabase/supabase-js'
import faker from 'faker'
import dotenv from 'dotenv';
dotenv.config();

// Configuration Supabase
const supabaseUrl = process.env.SUPABASE_URL
const supabaseKey = process.env.SUPABASE_SERVICE_KEY
const supabase = createClient(supabaseUrl, supabaseKey)

// Nombre d'enregistrements à générer
const NUM_USERS = 50
const NUM_EXPERTS = 20
const NUM_CATEGORIES = 8
const NUM_SERVICES = 30
const NUM_REQUESTS = 100
const NUM_PROPOSALS = 150

async function generateTestData() {
  console.log('Génération des données de test...')
  
  // 1. Générer des catégories
  const categories = []
  const categoryIcons = ['🏠', '🔧', '🧹', '🌱', '📚', '👶', '🖥️', '🚗']
  
  for (let i = 0; i < NUM_CATEGORIES; i++) {
    categories.push({
      name: faker.commerce.department(),
      icon: categoryIcons[i % categoryIcons.length],
      description: faker.lorem.sentence(),
      active: true
    })
  }
  
  const { data: categoriesData, error: categoriesError } = await supabase
    .from('categories')
    .insert(categories)
    .select()
  
  if (categoriesError) {
    console.error('Erreur lors de la création des catégories:', categoriesError)
    return
  }
  
  // 2. Générer des services
  const services = []
  for (let i = 0; i < NUM_SERVICES; i++) {
    services.push({
      category_id: categoriesData[Math.floor(Math.random() * categoriesData.length)].id,
      name: faker.commerce.productName(),
      description: faker.lorem.paragraph(),
      icon: faker.lorem.word(),
      active: true
    })
  }
  
  const { data: servicesData, error: servicesError } = await supabase
    .from('services')
    .insert(services)
    .select()
  
  if (servicesError) {
    console.error('Erreur lors de la création des services:', servicesError)
    return
  }
  
  // 3. Générer des utilisateurs et experts
  const users = []
  const experts = []
  
  // Utilisateurs réguliers
  for (let i = 0; i < NUM_USERS; i++) {
    const firstName = faker.name.firstName()
    const lastName = faker.name.lastName()
    const email = faker.internet.email(firstName, lastName).toLowerCase()
    
    // Créer un utilisateur dans Auth
    const { data: userData, error: userError } = await supabase.auth.admin.createUser({
      email,
      password: 'password123',
      email_confirm: true
    })
    
    if (userError) {
      console.error('Erreur lors de la création de l\'utilisateur:', userError)
      continue
    }
    
    // Ajouter au profil
    users.push({
      id: userData.user.id,
      email,
      first_name: firstName,
      last_name: lastName,
      phone: faker.phone.phoneNumber(),
      avatar_url: faker.image.avatar(),
      role: 'user',
      zip_code: faker.address.zipCode(),
      bio: faker.lorem.paragraph(),
      created_at: faker.date.past(2)
    })
  }
  
  // Experts
  for (let i = 0; i < NUM_EXPERTS; i++) {
    const firstName = faker.name.firstName()
    const lastName = faker.name.lastName()
    const email = faker.internet.email(firstName, lastName).toLowerCase()
    
    // Créer un expert dans Auth
    const { data: expertData, error: expertError } = await supabase.auth.admin.createUser({
      email,
      password: 'password123',
      email_confirm: true
    })
    
    if (expertError) {
      console.error('Erreur lors de la création de l\'expert:', expertError)
      continue
    }
    
    // Ajouter au profil
    experts.push({
      id: expertData.user.id,
      email,
      first_name: firstName,
      last_name: lastName,
      phone: faker.phone.phoneNumber(),
      avatar_url: faker.image.avatar(),
      role: 'expert',
      zip_code: faker.address.zipCode(),
      bio: faker.lorem.paragraph(),
      is_verified: Math.random() > 0.3, // 70% sont vérifiés
      rating: (Math.random() * 4 + 1).toFixed(1), // entre 1 et 5
      reviews_count: Math.floor(Math.random() * 50),
      created_at: faker.date.past(1)
    })
  }
  
  // Insérer tous les profils
  const { error: profilesError } = await supabase
    .from('profiles')
    .insert([...users, ...experts])
  
  if (profilesError) {
    console.error('Erreur lors de la création des profils:', profilesError)
    return
  }
  
  // 4. Associer des services aux experts
  const expertServices = []
  
  for (const expert of experts) {
    // Chaque expert a 2-5 services
    const numServices = Math.floor(Math.random() * 4) + 2
    const selectedServices = new Set()
    
    while (selectedServices.size < numServices) {
      const serviceIndex = Math.floor(Math.random() * servicesData.length)
      selectedServices.add(serviceIndex)
    }
    
    for (const serviceIndex of selectedServices) {
      expertServices.push({
        expert_id: expert.id,
        service_id: servicesData[serviceIndex].id,
        price: Math.floor(Math.random() * 20000) + 5000 // entre 5000 et 25000
      })
    }
  }
  
  const { error: expertServicesError } = await supabase
    .from('expert_services')
    .insert(expertServices)
  
  if (expertServicesError) {
    console.error('Erreur lors de la création des services d\'experts:', expertServicesError)
    return
  }
  
  // 5. Générer des demandes
  const requests = []
  const statuses = ['active', 'pending', 'completed', 'cancelled']
  
  for (let i = 0; i < NUM_REQUESTS; i++) {
    const clientIndex = Math.floor(Math.random() * users.length)
    const serviceIndex = Math.floor(Math.random() * servicesData.length)
    const status = statuses[Math.floor(Math.random() * statuses.length)]
    const isCompleted = status === 'completed'
    
    let expertId = null
    let resolvedAt = null
    let rating = null
    let review = null
    
    if (isCompleted) {
      const expertIndex = Math.floor(Math.random() * experts.length)
      expertId = experts[expertIndex].id
      resolvedAt = faker.date.recent(30)
      rating = Math.floor(Math.random() * 5) + 1
      review = Math.random() > 0.3 ? faker.lorem.paragraph() : null
    }
    
    requests.push({
      client_id: users[clientIndex].id,
      service_id: servicesData[serviceIndex].id,
      title: faker.lorem.sentence(),
      description: faker.lorem.paragraphs(2),
      budget: Math.floor(Math.random() * 50000) + 5000,
      location: faker.address.city(),
      date: faker.date.future(0.1),
      time: `${Math.floor(Math.random() * 12) + 8}:00`,
      duration: [1, 2, 3, 4][Math.floor(Math.random() * 4)],
      status,
      expert_id: expertId,
      resolved_at: resolvedAt,
      rating,
      review,
      created_at: faker.date.past(0.3)
    })
  }
  
  const { data: requestsData, error: requestsError } = await supabase
    .from('requests')
    .insert(requests)
    .select()
  
  if (requestsError) {
    console.error('Erreur lors de la création des demandes:', requestsError)
    return
  }
  
  // 6. Générer des propositions
  const proposals = []
  const proposalStatuses = ['pending', 'accepted', 'rejected']
  
  for (let i = 0; i < NUM_PROPOSALS; i++) {
    const requestIndex = Math.floor(Math.random() * requestsData.length)
    const expertIndex = Math.floor(Math.random() * experts.length)
    const request = requestsData[requestIndex]
    
    // Ne pas créer de proposition si la demande est déjà résolue avec un expert
    if (request.status === 'completed' && request.expert_id) {
      continue
    }
    
    proposals.push({
      request_id: request.id,
      expert_id: experts[expertIndex].id,
      price: request.budget * (0.8 + Math.random() * 0.4), // +/- 20% du budget
      message: faker.lorem.paragraph(),
      status: proposalStatuses[Math.floor(Math.random() * proposalStatuses.length)],
      created_at: faker.date.recent(15)
    })
  }
  
  // Éviter les doublons (un expert ne peut faire qu'une proposition par demande)
  const uniqueProposals = proposals.filter((proposal, index, self) => 
    index === self.findIndex(p => 
      p.request_id === proposal.request_id && p.expert_id === proposal.expert_id
    )
  )
  
  const { error: proposalsError } = await supabase
    .from('proposals')
    .insert(uniqueProposals)
  
  if (proposalsError) {
    console.error('Erreur lors de la création des propositions:', proposalsError)
    return
  }
  
  console.log('Génération des données de test terminée avec succès !')
}

generateTestData().catch(console.error) 