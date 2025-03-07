// generate-mock-data.js
import { createClient } from '@supabase/supabase-js';
import { faker } from '@faker-js/faker/locale/fr';
import dotenv from 'dotenv';

// Charger les variables d'environnement
dotenv.config();

// Configuration Supabase
const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_KEY;
const supabase = createClient(supabaseUrl, supabaseKey);

// Fonction pour générer des catégories de services
async function generateCategories() {
  const categories = [
    { id: faker.string.uuid(), name: 'Ménage', icon: 'Home', description: 'Services de nettoyage et d\'entretien' },
    { id: faker.string.uuid(), name: 'Jardinage', icon: 'Leaf', description: 'Entretien et aménagement de jardins' },
    { id: faker.string.uuid(), name: 'Bricolage', icon: 'Tool', description: 'Petits travaux et réparations' },
    { id: faker.string.uuid(), name: 'Garde d\'enfants', icon: 'Baby', description: 'Services de garde et d\'accompagnement d\'enfants' },
    { id: faker.string.uuid(), name: 'Cours particuliers', icon: 'BookOpen', description: 'Enseignement et soutien scolaire' },
    { id: faker.string.uuid(), name: 'Informatique', icon: 'Laptop', description: 'Assistance et dépannage informatique' }
  ];
  
  console.log('Insertion des catégories...');
  const { data, error } = await supabase
    .from('service_categories')
    .insert(categories)
    .select();
  
  if (error) throw error;
  return data || [];
}

// Fonction pour générer des services
async function generateServices(categories) {
  const services = [];
  
  // Créer des services pour chaque catégorie
  for (const category of categories) {
    // Services pour Ménage
    if (category.name === 'Ménage') {
      services.push(
        { id: faker.string.uuid(), category_id: category.id, name: 'Ménage complet', icon: '🧹', description: 'Nettoyage complet de votre domicile' },
        { id: faker.string.uuid(), category_id: category.id, name: 'Nettoyage de vitres', icon: '🪟', description: 'Nettoyage de toutes vos vitres et miroirs' },
        { id: faker.string.uuid(), category_id: category.id, name: 'Repassage', icon: '👕', description: 'Service de repassage à domicile' },
        { id: faker.string.uuid(), category_id: category.id, name: 'Nettoyage en profondeur', icon: '🧽', description: 'Nettoyage détaillé pour les endroits difficiles' }
      );
    }
    
    // Services pour Jardinage
    else if (category.name === 'Jardinage') {
      services.push(
        { id: faker.string.uuid(), category_id: category.id, name: 'Tonte de pelouse', icon: '🌿', description: 'Tonte et entretien de votre pelouse' },
        { id: faker.string.uuid(), category_id: category.id, name: 'Taille de haies', icon: '✂️', description: 'Taille et mise en forme de vos haies' },
        { id: faker.string.uuid(), category_id: category.id, name: 'Désherbage', icon: '🌱', description: 'Élimination des mauvaises herbes' },
        { id: faker.string.uuid(), category_id: category.id, name: 'Plantation', icon: '🌷', description: 'Plantation de fleurs, arbustes ou légumes' }
      );
    }
    
    // Services pour Bricolage
    else if (category.name === 'Bricolage') {
      services.push(
        { id: faker.string.uuid(), category_id: category.id, name: 'Petites réparations', icon: '🔧', description: 'Réparations diverses dans la maison' },
        { id: faker.string.uuid(), category_id: category.id, name: 'Montage de meubles', icon: '🪑', description: 'Assemblage et montage de meubles en kit' },
        { id: faker.string.uuid(), category_id: category.id, name: 'Peinture', icon: '🎨', description: 'Travaux de peinture intérieure ou extérieure' },
        { id: faker.string.uuid(), category_id: category.id, name: 'Plomberie basique', icon: '🚿', description: 'Réparations simples de plomberie' }
      );
    }
    
    // Services pour d'autres catégories
    else {
      // Ajouter 2-4 services par défaut pour les autres catégories
      const numServices = faker.number.int({ min: 2, max: 4 });
      for (let i = 0; i < numServices; i++) {
        services.push({
          id: faker.string.uuid(),
          category_id: category.id,
          name: `${category.name} - ${faker.commerce.productName()}`,
          icon: faker.helpers.arrayElement(['📱', '📚', '🎓', '💻', '🎯', '📊', '🎨', '🎵']),
          description: faker.lorem.sentence()
        });
      }
    }
  }
  
  console.log('Insertion des services...');
  const { error } = await supabase
    .from('services')
    .insert(services);
  
  if (error) throw error;
  return services;
}

// Fonction pour créer des compétences
async function generateSkills() {
  const skills = [
    { id: faker.string.uuid(), name: 'Informatique', icon: '💻' },
    { id: faker.string.uuid(), name: 'Photographie', icon: '📷' },
    { id: faker.string.uuid(), name: 'Cuisine', icon: '🍳' },
    { id: faker.string.uuid(), name: 'Jardinage', icon: '🌱' },
    { id: faker.string.uuid(), name: 'Bricolage', icon: '🔨' },
    { id: faker.string.uuid(), name: 'Langues étrangères', icon: '🌍' },
    { id: faker.string.uuid(), name: 'Musique', icon: '🎵' },
    { id: faker.string.uuid(), name: 'Sport', icon: '🏃‍♂️' },
    { id: faker.string.uuid(), name: 'Art', icon: '🎨' },
    { id: faker.string.uuid(), name: 'Enseignement', icon: '📚' }
  ];
  
  console.log('Insertion des compétences...');
  const { data, error } = await supabase
    .from('skills')
    .insert(skills)
    .select();
  
  if (error) throw error;
  return data || [];
}

// Fonction pour créer des utilisateurs
async function generateUsers(count = 10, skills) {
  const users = [];
  const profiles = [];
  const expertProfiles = [];
  const userSettings = [];
  const expertIds = [];
  
  console.log(`Création de ${count} utilisateurs...`);
  
  for (let i = 0; i < count; i++) {
    const firstName = faker.person.firstName();
    const lastName = faker.person.lastName();
    const email = faker.internet.email({ firstName, lastName }).toLowerCase();
    const password = 'Password123'; // Mot de passe simple pour les tests
    const isExpert = faker.datatype.boolean(0.5); // 50% des utilisateurs sont des experts
    
    // Attribuer un rôle aléatoire
    // Le premier utilisateur est toujours admin pour les tests
    let role = i === 0 ? 'admin' : (isExpert ? 'expert' : 'user');
    
    try {
      // Créer l'utilisateur dans auth
      const { data: userData, error: userError } = await supabase.auth.admin.createUser({
        email,
        password,
        email_confirm: true
      });
      
      if (userError) {
        console.error(`Erreur lors de la création de l'utilisateur ${email}:`, userError);
        continue;
      }
      
      const userId = userData.user.id;
      users.push(userData.user);
      
      // Créer le profil avec le rôle
      const profile = {
        id: userId,
        first_name: firstName,
        last_name: lastName,
        email: email,
        role: role,
        phone: faker.phone.number('+33 6 ## ## ## ##'),
        address: faker.location.streetAddress(),
        city: faker.location.city(),
        country: 'France',
        avatar_url: `https://ui-avatars.com/api/?name=${encodeURIComponent(firstName+'+'+lastName)}&background=random&size=256`,
        bio: faker.lorem.paragraph(),
        created_at: faker.date.past({ years: 1 }).toISOString(),
        updated_at: faker.date.recent().toISOString()
      };
      
      profiles.push(profile);
      
      // Si c'est un expert, créer également un profil d'expert
      if (isExpert) {
        expertIds.push(userId);
        
        // Sélectionner 1 à 3 compétences aléatoires pour l'expert
        const expertSkills = faker.helpers.arrayElements(
          skills, 
          faker.number.int({ min: 1, max: 3 })
        );
        
        // Créer un profil d'expert avec des compétences
        const expertProfile = {
          profile_id: userId,
          title: faker.person.jobTitle(),
          hourly_rate: faker.number.int({ min: 20, max: 80 }),
          years_experience: faker.number.int({ min: 1, max: 20 }),
          skills: expertSkills.map(skill => skill.id),
          rating: faker.number.float({ min: 3.5, max: 5, precision: 0.1 }),
          reviews_count: faker.number.int({ min: 0, max: 50 }),
          verified: faker.datatype.boolean(0.7),
          // availability: generateAvailabilityPattern(),
          created_at: profile.created_at,
          updated_at: profile.updated_at
        };
        
        expertProfiles.push(expertProfile);
      }
      
      // Créer des préférences de notification pour l'utilisateur
      userSettings.push({
        id: faker.string.uuid(),
        // profile_id: userId,
        email_notifications: faker.datatype.boolean(0.8),
        push_notifications: faker.datatype.boolean(0.6),
        language: faker.helpers.arrayElement(['fr', 'en']),
        theme: faker.helpers.arrayElement(['light', 'dark', 'system']),
        updated_at: profile.updated_at
      });
      
    } catch (error) {
      console.error(`Erreur lors de la création de l'utilisateur ${email}:`, error);
    }
  }
  
  // Insérer les profils dans la base de données
  if (profiles.length > 0) {
    const { error: profileError } = await supabase
      .from('profiles')
      .insert(profiles);
    
    if (profileError) throw profileError;
  }
  
  // Insérer les profils experts
  if (expertProfiles.length > 0) {
    const { error: expertError } = await supabase
      .from('expert_profiles')
      .insert(expertProfiles);
    
    if (expertError) throw expertError;
  }
  
  // Insérer les paramètres utilisateur
  if (userSettings.length > 0) {
    const { error: settingsError } = await supabase
      .from('user_settings')
      .insert(userSettings);
    
    if (settingsError) throw settingsError;
  }
  
  return { users, expertIds };
}

// Fonction pour lier des experts et des services
async function generateExpertServices(expertIds, services) {
  const expertServices = [];
  
  console.log('Liaison experts-services...');
  
  for (const expertId of expertIds) {
    // Chaque expert propose 2-5 services
    const numServices = faker.number.int({ min: 2, max: 5 });
    const selectedServices = faker.helpers.arrayElements(services, numServices);
    
    for (const service of selectedServices) {
      expertServices.push({
        id: faker.string.uuid(),
        expert_id: expertId,
        service_id: service.id,
        price_per_hour: faker.number.float({ min: 15, max: 60, precision: 0.01 }),
        description: faker.lorem.paragraph()
      });
    }
  }
  
  if (expertServices.length > 0) {
    const { error } = await supabase
      .from('expert_services')
      .insert(expertServices);
    
    if (error) throw error;
  }
  
  return expertServices;
}

// Fonction pour générer des demandes de service
async function generateRequests(users, services, categoryIds, count = 20) {
  const requests = [];
  const statuses = ['active', 'pending', 'completed', 'cancelled'];
  
  console.log(`Génération de ${count} demandes...`);
  
  // Filtrer pour obtenir uniquement les clients (non-experts)
  const clientIds = users.filter(user => !user.is_expert).map(user => user.id);
  
  for (let i = 0; i < count; i++) {
    // Sélectionner un service aléatoire
    const service = faker.helpers.arrayElement(services);
    
    // Générer une date future dans les 30 prochains jours
    const futureDate = faker.date.soon({ days: 30 });
    const formattedDate = futureDate.toISOString().split('T')[0];
    
    // Heure entre 8h et 19h
    const hour = faker.number.int({ min: 8, max: 19 });
    const minute = faker.helpers.arrayElement([0, 15, 30, 45]);
    const time = `${hour.toString().padStart(2, '0')}:${minute.toString().padStart(2, '0')}`;
    
    // S'assurer qu'il y a au moins un client
    const clientId = clientIds.length > 0 
      ? faker.helpers.arrayElement(clientIds) 
      : users[0].id;
    
    // Créer la demande
    const request = {
      id: faker.string.uuid(),
      client_id: clientId,
      service_id: service.id,
      // category_id: service.category_id, // Ajout du champ category_id
      title: faker.helpers.arrayElement([
        `Besoin de ${service.name}`,
        `Recherche personne pour ${service.name}`,
        `${service.name} à domicile`,
        `${service.name} urgent`
      ]),
      description: faker.lorem.paragraphs(2),
      location: `${faker.location.streetAddress()}, ${faker.location.city()}, ${faker.location.zipCode()}`,
      date: formattedDate,
      time: time,
      duration: faker.helpers.arrayElement([30, 60, 90, 120, 180]),
      budget: faker.number.float({ min: 20, max: 100, precision: 0.01 }),
      status: faker.helpers.arrayElement(statuses),
      // is_flexible_date: faker.datatype.boolean(0.3),
      created_at: faker.date.recent({ days: 30 }).toISOString()
    };
    
    requests.push(request);
  }
  
  // Insérer les demandes
  const { error } = await supabase
    .from('requests')
    .insert(requests);
  
  if (error) throw error;
  
  return requests;
}

// Fonction pour générer des propositions
async function generateProposals(requests, expertIds) {
  const proposals = [];
  const statuses = ['pending', 'accepted', 'rejected'];
  
  console.log('Génération des propositions...');
  
  // Pour chaque demande active, générer 0-3 propositions
  for (const request of requests.filter(r => r.status === 'active')) {
    const numProposals = faker.number.int({ min: 0, max: 3 });
    
    // Sélectionner des experts aléatoires
    const selectedExperts = faker.helpers.arrayElements(expertIds, Math.min(numProposals, expertIds.length));
    
    for (const expertId of selectedExperts) {
      proposals.push({
        id: faker.string.uuid(),
        request_id: request.id,
        expert_id: expertId,
        price: faker.number.float({ min: request.budget * 0.8, max: request.budget * 1.2, precision: 0.01 }),
        message: faker.lorem.paragraph(),
        status: faker.helpers.arrayElement(statuses),
        created_at: faker.date.recent({ days: 10 }).toISOString()
      });
    }
  }
  
  if (proposals.length > 0) {
    const { error } = await supabase
      .from('proposals')
      .insert(proposals);
    
    if (error) throw error;
  }
  
  return proposals;
}

// Fonction pour générer des contrats
async function generateContracts(proposals) {
  const contracts = [];
  const statuses = ['pending', 'active', 'completed', 'cancelled'];
  
  console.log('Génération des contrats...');
  
  // Pour chaque proposition acceptée, créer un contrat
  for (const proposal of proposals.filter(p => p.status === 'accepted')) {
    const request = await supabase
      .from('requests')
      .select('client_id, date')
      .eq('id', proposal.request_id)
      .single();
    
    if (request.error || !request.data) continue;
    
    const startDate = new Date(request.data.date);
    const endDate = new Date(startDate);
    endDate.setDate(endDate.getDate() + faker.number.int({ min: 1, max: 30 }));
    
    contracts.push({
      id: faker.string.uuid(),
      request_id: proposal.request_id,
      proposal_id: proposal.id,
      client_id: request.data.client_id,
      expert_id: proposal.expert_id,
      start_date: startDate.toISOString().split('T')[0],
      end_date: endDate.toISOString().split('T')[0],
      total_amount: proposal.price,
      status: faker.helpers.arrayElement(statuses),
      created_at: faker.date.recent({ days: 5 }).toISOString()
    });
  }
  
  if (contracts.length > 0) {
    const { error } = await supabase
      .from('contracts')
      .insert(contracts);
    
    if (error) throw error;
  }
  
  return contracts;
}

// Fonction pour générer des avis
async function generateReviews(contracts) {
  const reviews = [];
  
  console.log('Génération des avis...');
  
  // Pour chaque contrat terminé, créer un avis
  for (const contract of contracts.filter(c => c.status === 'completed')) {
    reviews.push({
      id: faker.string.uuid(),
      contract_id: contract.id,
      client_id: contract.client_id,
      expert_id: contract.expert_id,
      rating: faker.number.int({ min: 3, max: 5 }),
      comment: faker.lorem.paragraph(),
      created_at: faker.date.recent({ days: 2 }).toISOString()
    });
  }
  
  if (reviews.length > 0) {
    const { error } = await supabase
      .from('reviews')
      .insert(reviews);
    
    if (error) throw error;
  }
  
  return reviews;
}

// Fonction pour générer des conversations
async function generateConversations(requests, clientIds, expertIds) {
  const conversations = [];
  const participants = [];
  const messages = [];
  
  console.log('Génération des conversations...');
  
  for (const request of requests) {
    // Créer une conversation pour chaque demande
    const conversationId = faker.string.uuid();
    
    conversations.push({
      id: conversationId,
      request_id: request.id,
      created_at: faker.date.recent({ days: 15 }).toISOString()
    });
    
    // Ajouter le client comme participant
    participants.push({
      id: faker.string.uuid(),
      conversation_id: conversationId,
      profile_id: request.client_id,
      created_at: faker.date.recent({ days: 15 }).toISOString()
    });
    
    // Ajouter un expert aléatoire comme participant
    const expertId = faker.helpers.arrayElement(expertIds);
    participants.push({
      id: faker.string.uuid(),
      conversation_id: conversationId,
      profile_id: expertId,
      created_at: faker.date.recent({ days: 15 }).toISOString()
    });
    
    // Générer 1-10 messages pour cette conversation
    const numMessages = faker.number.int({ min: 1, max: 10 });
    for (let i = 0; i < numMessages; i++) {
      const senderId = faker.helpers.arrayElement([request.client_id, expertId]);
      messages.push({
        id: faker.string.uuid(),
        conversation_id: conversationId,
        sender_id: senderId,
        content: faker.lorem.paragraph(),
        read: faker.datatype.boolean(0.7),
        created_at: faker.date.recent({ days: 10 }).toISOString()
      });
    }
  }
  
  // Insérer les conversations
  if (conversations.length > 0) {
    const { error: convError } = await supabase
      .from('conversations')
      .insert(conversations);
    
    if (convError) throw convError;
  }
  
  // Insérer les participants
  if (participants.length > 0) {
    const { error: partError } = await supabase
      .from('conversation_participants')
      .insert(participants);
    
    if (partError) throw partError;
  }
  
  // Insérer les messages
  if (messages.length > 0) {
    const { error: msgError } = await supabase
      .from('messages')
      .insert(messages);
    
    if (msgError) throw msgError;
  }
  
  return { conversations, messages };
}

// Fonction pour générer des notifications
async function generateNotifications(clientIds, expertIds) {
  const notifications = [];
  const types = ['message', 'proposal', 'contract', 'payment', 'review'];
  
  console.log('Génération des notifications...');
  
  // Générer des notifications pour tous les utilisateurs
  const allUsers = [...clientIds, ...expertIds];
  
  for (const userId of allUsers) {
    const numNotifications = faker.number.int({ min: 2, max: 8 });
    
    for (let i = 0; i < numNotifications; i++) {
      const type = faker.helpers.arrayElement(types);
      
      notifications.push({
        id: faker.string.uuid(),
        profile_id: userId,
        type: type,
        title: getNotificationTitle(type),
        content: faker.lorem.sentence(),
        related_id: faker.string.uuid(),
        read: faker.datatype.boolean(0.5),
        created_at: faker.date.recent({ days: 5 }).toISOString()
      });
    }
  }
  
  if (notifications.length > 0) {
    const { error } = await supabase
      .from('notifications')
      .insert(notifications);
    
    if (error) throw error;
  }
  
  return notifications;
}

// Fonction auxiliaire pour générer les titres de notification
function getNotificationTitle(type) {
  switch (type) {
    case 'message':
      return 'Nouveau message reçu';
    case 'proposal':
      return 'Nouvelle proposition';
    case 'contract':
      return 'Nouveau contrat';
    case 'payment':
      return 'Paiement reçu';
    case 'review':
      return 'Nouvel avis';
    default:
      return 'Nouvelle notification';
  }
}

// Fonction principale
async function generateAllData() {
  try {
    console.log('Début de la génération des données...');
    
    // Génération des compétences
    const skills = await generateSkills();
    console.log(`${skills.length} compétences créées`);
    
    // Génération des catégories
    const categories = await generateCategories();
    console.log(`${categories.length} catégories créées`);
    
    // Génération des services
    const services = await generateServices(categories);
    console.log(`${services.length} services créés`);
    
    // Génération des utilisateurs (clients et experts)
    const { users, expertIds } = await generateUsers(10, skills);
    console.log(`${users.length} utilisateurs créés, dont ${expertIds.length} experts`);
    
    // Liaison experts-services
    const expertServices = await generateExpertServices(expertIds, services);
    console.log(`${expertServices.length} liaisons experts-services créées`);
    
    // Génération des demandes
    const requests = await generateRequests(users, services, categories.map(c => c.id), 30);
    console.log(`${requests.length} demandes créées`);
    
    // Génération des propositions
    const proposals = await generateProposals(requests, expertIds);
    console.log(`${proposals.length} propositions créées`);
    
    // Génération des contrats
    const contracts = await generateContracts(proposals);
    console.log(`${contracts.length} contrats créés`);
    
    // Génération des avis
    const reviews = await generateReviews(contracts);
    console.log(`${reviews.length} avis créés`);
    
    // Génération des conversations et messages
    const { conversations, messages } = await generateConversations(
      requests, 
      users.filter(u => !expertIds.includes(u.id)).map(u => u.id),
      expertIds
    );
    console.log(`${conversations.length} conversations et ${messages.length} messages créés`);
    
    // Génération des notifications
    const notifications = await generateNotifications(
      users.filter(u => !expertIds.includes(u.id)).map(u => u.id),
      expertIds
    );
    console.log(`${notifications.length} notifications créées`);
    
    console.log('Génération des données terminée avec succès !');
    
  } catch (error) {
    console.error('Erreur lors de la génération des données:', error);
  }
}

// Exécuter la fonction principale
generateAllData();