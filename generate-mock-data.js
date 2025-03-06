// generate-mock-data.js
import { createClient } from '@supabase/supabase-js';
import { faker } from '@faker-js/faker/locale/fr';
import dotenv from 'dotenv';

// Charger les variables d'environnement
dotenv.config();

    // Configuration Supabase
    const supabaseUrl = process.env.SUPABASE_URL ;
const supabaseKey = process.env.SUPABASE_KEY ;
const supabase = createClient(supabaseUrl, supabaseKey);

// Fonction pour générer des catégories de services
async function generateCategories() {
  const categories = [
    { id: faker.string.uuid(), name: 'Ménage', icon: 'Home' },
    { id: faker.string.uuid(), name: 'Jardinage', icon: 'Leaf' },
    { id: faker.string.uuid(), name: 'Bricolage', icon: 'Tool' },
    { id: faker.string.uuid(), name: 'Garde d\'enfants', icon: 'Baby' },
    { id: faker.string.uuid(), name: 'Cours particuliers', icon: 'BookOpen' },
    { id: faker.string.uuid(), name: 'Informatique', icon: 'Laptop' }
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
        { id: faker.string.uuid(), category_id: category.id, name: 'Ménage complet' },
        { id: faker.string.uuid(), category_id: category.id, name: 'Nettoyage de vitres' },
        { id: faker.string.uuid(), category_id: category.id, name: 'Repassage' },
        { id: faker.string.uuid(), category_id: category.id, name: 'Nettoyage en profondeur' }
      );
    }
    
    // Services pour Jardinage
    else if (category.name === 'Jardinage') {
      services.push(
        { id: faker.string.uuid(), category_id: category.id, name: 'Tonte de pelouse' },
        { id: faker.string.uuid(), category_id: category.id, name: 'Taille de haies' },
        { id: faker.string.uuid(), category_id: category.id, name: 'Désherbage' },
        { id: faker.string.uuid(), category_id: category.id, name: 'Plantation' }
      );
    }
    
    // Services pour Bricolage
    else if (category.name === 'Bricolage') {
      services.push(
        { id: faker.string.uuid(), category_id: category.id, name: 'Petites réparations' },
        { id: faker.string.uuid(), category_id: category.id, name: 'Montage de meubles' },
        { id: faker.string.uuid(), category_id: category.id, name: 'Peinture' },
        { id: faker.string.uuid(), category_id: category.id, name: 'Plomberie basique' }
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
          name: `${category.name} - ${faker.commerce.productName()}`
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
    } catch (err) {
      console.error(`Erreur pour l'utilisateur ${email}:`, err);
    }
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
async function generateRequests(users, services, count = 20) {
  const requests = [];
  const statuses = ['active', 'pending', 'completed', 'cancelled'];
  
  console.log(`Génération de ${count} demandes...`);
  
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
    .insert(requests);
  
  if (error) throw error;
  
  return requests;
}

// Fonction principale
async function generateAllData() {
  try {
    console.log('Début de la génération des données...');
    
    const categories = await generateCategories();
    console.log(`${categories.length} catégories créées`);
    
    const services = await generateServices(categories);
    console.log(`${services.length} services créés`);
    
    const users = await generateUsers(10);
    console.log(`${users.length} utilisateurs créés`);
    
    const requests = await generateRequests(users, services, 30);
    console.log(`${requests.length} demandes créées`);
    
    console.log('Génération des données terminée avec succès !');
    
  } catch (error) {
    console.error('Erreur lors de la génération des données:', error);
  }
}

// Exécuter la fonction principale
generateAllData();