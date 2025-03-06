// generate-mock-data.js
import { createClient } from '@supabase/supabase-js';
import { faker } from '@faker-js/faker/locale/fr';
import dotenv from 'dotenv';

// Charger les variables d'environnement
dotenv.config();

// Configuration Supabase
const supabaseUrl = process.env.SUPABASE_URL || 'VOTRE_URL_SUPABASE';
const supabaseKey = process.env.SUPABASE_KEY || 'VOTRE_CLE_SERVICE_SUPABASE';
const supabase = createClient(supabaseUrl, supabaseKey);

// Fonction pour générer des catégories de services
async function generateCategories() {
  const categories = [
    { id: '1', name: 'Ménage', icon: 'Home' },
    { id: '2', name: 'Jardinage', icon: 'Leaf' },
    { id: '3', name: 'Bricolage', icon: 'Tool' },
    { id: '4', name: 'Garde d\'enfants', icon: 'Baby' },
    { id: '5', name: 'Cours particuliers', icon: 'BookOpen' },
    { id: '6', name: 'Informatique', icon: 'Laptop' }
  ];
  
  console.log('Insertion des catégories...');
  const { error } = await supabase
    .from('service_categories')
    .upsert(categories, { onConflict: 'id' });
  
  if (error) throw error;
  return categories;
}

// Fonction pour générer des services
async function generateServices(categories) {
  const services = [
    // Ménage
    { id: '101', category_id: '1', name: 'Ménage complet' },
    { id: '102', category_id: '1', name: 'Nettoyage de vitres' },
    { id: '103', category_id: '1', name: 'Repassage' },
    { id: '104', category_id: '1', name: 'Nettoyage en profondeur' },
    
    // Jardinage
    { id: '201', category_id: '2', name: 'Tonte de pelouse' },
    { id: '202', category_id: '2', name: 'Taille de haies' },
    { id: '203', category_id: '2', name: 'Désherbage' },
    { id: '204', category_id: '2', name: 'Plantation' },
    
    // Bricolage
    { id: '301', category_id: '3', name: 'Petites réparations' },
    { id: '302', category_id: '3', name: 'Montage de meubles' },
    { id: '303', category_id: '3', name: 'Peinture' },
    { id: '304', category_id: '3', name: 'Plomberie basique' },
    
    // Garde d'enfants
    { id: '401', category_id: '4', name: 'Garde régulière' },
    { id: '402', category_id: '4', name: 'Garde ponctuelle' },
    { id: '403', category_id: '4', name: 'Sortie d\'école' },
    
    // Cours particuliers
    { id: '501', category_id: '5', name: 'Mathématiques' },
    { id: '502', category_id: '5', name: 'Français' },
    { id: '503', category_id: '5', name: 'Anglais' },
    { id: '504', category_id: '5', name: 'Physique-Chimie' },
    
    // Informatique
    { id: '601', category_id: '6', name: 'Dépannage informatique' },
    { id: '602', category_id: '6', name: 'Installation logiciel' },
    { id: '603', category_id: '6', name: 'Récupération de données' },
    { id: '604', category_id: '6', name: 'Création de site web' }
  ];
  
  console.log('Insertion des services...');
  const { error } = await supabase
    .from('services')
    .upsert(services, { onConflict: 'id' });
  
  if (error) throw error;
  return services;
}

// Fonction pour créer des utilisateurs
async function generateUsers(count = 10) {
  const users = [];
  const profiles = [];
  
  console.log(`Création de ${count} utilisateurs...`);
  
  for (let i = 0; i < count; i++) {
    const firstName = faker.person.firstName();
    const lastName = faker.person.lastName();
    const email = faker.internet.email({ firstName, lastName }).toLowerCase();
    const password = 'Password123'; // Mot de passe simple pour les tests
    
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
    
    // Créer le profil
    const profile = {
      id: userId,
      first_name: firstName,
      last_name: lastName,
      email: email,
      phone: faker.phone.number('+33 6 ## ## ## ##'),
      address: faker.location.streetAddress(),
      city: faker.location.city(),
      postal_code: faker.location.zipCode(),
      bio: faker.lorem.paragraph(),
      created_at: new Date().toISOString(),
      role: faker.helpers.arrayElement(['user', 'expert']), // Certains utilisateurs sont experts
    };
    
    profiles.push(profile);
  }
  
  // Insérer les profils
  if (profiles.length > 0) {
    const { error: profileError } = await supabase
      .from('profiles')
      .upsert(profiles, { onConflict: 'id' });
    
    if (profileError) throw profileError;
  }
  
  return users;
}

// Fonction pour générer des demandes de service
async function generateRequests(users, services, count = 30) {
  const requests = [];
  const statuses = ['active', 'pending', 'completed', 'cancelled'];
  
  console.log(`Génération de ${count} demandes de service...`);
  
  for (let i = 0; i < count; i++) {
    // Sélectionner un service aléatoire
    const service = faker.helpers.arrayElement(services);
    
    // Générer une date future dans les 30 prochains jours
    const futureDate = faker.date.soon({ days: 30 });
    const formattedDate = futureDate.toISOString().split('T')[0];
    
    // Heure entre 8h et 19h
    const hour = faker.number.int({ min: 8, max: 19 });
    const time = `${hour.toString().padStart(2, '0')}:00`;
    
    // Créer la demande
    const request = {
      id: faker.string.uuid(),
      client_id: faker.helpers.arrayElement(users).id,
      title: faker.helpers.arrayElement([
        `Besoin de ${service.name}`,
        `Recherche personne pour ${service.name}`,
        `${service.name} à domicile`,
        `${service.name} urgent`
      ]),
      description: faker.lorem.paragraphs(2),
      category_id: service.category_id,
      service_id: service.id,
      location: `${faker.location.city()}, ${faker.location.zipCode()}`,
      date: formattedDate,
      time: time,
      duration: faker.helpers.arrayElement([30, 60, 90, 120, 180]),
      budget: faker.number.int({ min: 20, max: 100 }),
      status: faker.helpers.arrayElement(statuses),
      is_flexible_date: faker.datatype.boolean(0.3),
      created_at: faker.date.recent({ days: 30 }).toISOString()
    };
    
    requests.push(request);
  }
  
  // Insérer les demandes
  const { error } = await supabase
    .from('requests')
    .upsert(requests, { onConflict: 'id' });
  
  if (error) throw error;
  
  return requests;
}

// Fonction pour générer des propositions sur les demandes
async function generateProposals(users, requests, count = 15) {
  const proposals = [];
  
  console.log(`Génération de ${count} propositions...`);
  
  // Sélectionner des demandes aléatoires
  const selectedRequests = faker.helpers.arrayElements(requests, Math.min(count, requests.length));
  
  for (const request of selectedRequests) {
    // Nombre de propositions pour cette demande (1 à 3)
    const proposalCount = faker.number.int({ min: 1, max: 3 });
    
    // Utilisateurs différents du client
    const availableUsers = users.filter(user => user.id !== request.client_id);
    
    if (availableUsers.length === 0) continue;
    
    // Générer les propositions
    const requestProposers = faker.helpers.arrayElements(availableUsers, Math.min(proposalCount, availableUsers.length));
    
    for (const user of requestProposers) {
      const proposal = {
        id: faker.string.uuid(),
        request_id: request.id,
        provider_id: user.id,
        message: faker.lorem.paragraph(),
        price: faker.number.int({ min: request.budget * 0.8, max: request.budget * 1.2 }),
        status: faker.helpers.arrayElement(['pending', 'accepted', 'rejected']),
        created_at: faker.date.recent({ days: 10 }).toISOString()
      };
      
      proposals.push(proposal);
    }
  }
  
  // Insérer les propositions
  if (proposals.length > 0) {
    const { error } = await supabase
      .from('proposals')
      .upsert(proposals, { onConflict: 'id' });
    
    if (error) throw error;
  }
  
  return proposals;
}

// Fonction principale
async function generateAllData() {
  try {
    console.log('Début de la génération des données...');
    
    const categories = await generateCategories();
    const services = await generateServices(categories);
    const users = await generateUsers(10);
    const requests = await generateRequests(users, services, 30);
    const proposals = await generateProposals(users, requests, 15);
    
    console.log('Génération des données terminée avec succès !');
    console.log(`- ${categories.length} catégories`);
    console.log(`- ${services.length} services`);
    console.log(`- ${users.length} utilisateurs`);
    console.log(`- ${requests.length} demandes`);
    console.log(`- ${proposals.length} propositions`);
    
  } catch (error) {
    console.error('Erreur lors de la génération des données:', error);
  }
}

// Exécuter la fonction principale
generateAllData();