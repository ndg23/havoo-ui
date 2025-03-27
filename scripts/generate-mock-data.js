import { createClient } from '@supabase/supabase-js';
import { faker } from '@faker-js/faker/locale/fr';
import dotenv from 'dotenv';

dotenv.config();

// Initialiser le client Supabase
const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_KEY;
const supabase = createClient(supabaseUrl, supabaseKey);

// Configuration
const NUM_USERS = 20;
const NUM_CATEGORIES = 8;
const NUM_SKILLS_PER_CATEGORY = 5;
const NUM_REQUESTS = 30;
const NUM_SERVICES = 40;
const NUM_PROPOSALS = 25;
const NUM_CONTRACTS = 15;

// Fonction principale
async function generateMockData() {
    console.log('🚀 Génération des données de test...');

    try {
        // Générer des catégories
        console.log('📂 Génération des catégories...');
        const professions = await generateCategories();

        // Générer des compétences
        console.log('🔧 Génération des compétences...');
        const skills = await generateSkills(professions);

        // Générer des utilisateurs
        console.log('👤 Génération des utilisateurs...');
        const users = await generateUsers();

        // Attribuer des compétences aux utilisateurs
        console.log('🔗 Attribution des compétences aux utilisateurs...');
        await assignSkillsToUsers(users, skills);

        // Générer des demandes
        console.log('📝 Génération des demandes...');
        const missions = await generateRequests(users, professions);

        // Générer des services
        console.log('🛠️ Génération des services...');
        await generateServices(users, professions, skills);

        // Générer des propositions
        console.log('📨 Génération des propositions...');
        await generateProposals(missions, users);

        // Générer des contrats
        console.log('📄 Génération des contrats...');
        await generateContracts(missions, users);

        console.log('✅ Génération des données terminée avec succès!');
    } catch (error) {
        console.error('❌ Erreur lors de la génération des données:', error);
    }
}

// Générer des catégories
async function generateCategories() {
    const professions = [];

    for (let i = 0; i < NUM_CATEGORIES; i++) {
        professions.push({
            name: faker.commerce.department(),
            description: faker.lorem.paragraph()
        });
    }

    const { data, error } = await supabase
        .from('professions')
        .insert(professions)
        .select();

    if (error) throw error;
    return data;
}

// Générer des compétences
async function generateSkills(professions) {
    const skills = [];

    for (const category of professions) {
        for (let i = 0; i < NUM_SKILLS_PER_CATEGORY; i++) {
            skills.push({
                name: faker.lorem.word(),
                profession_id: category.id
            });
        }
    }

    const { data, error } = await supabase
        .from('skills')
        .insert(skills)
        .select();

    if (error) throw error;
    return data;
}

// Générer des utilisateurs
async function generateUsers() {
    const users = [];

    for (let i = 0; i < NUM_USERS; i++) {
        const firstName = faker.person.firstName();
        const lastName = faker.person.lastName();
        const email = faker.internet.email({ firstName, lastName });
        const isExpert = Math.random() > 0.5;

        // Créer un utilisateur dans Auth
        const { data: authData, error: authError } = await supabase.auth.admin.createUser({
            email,
            password: 'password123',
            email_confirm: true
        });

        if (authError) throw authError;

        // Créer un profil
        const profile = {
            id: authData.user.id,
            first_name: firstName,
            last_name: lastName,
            email,
            phone: faker.phone.number(),
            bio: faker.lorem.paragraph(),
            avatar_url: faker.image.avatar(),
            role: isExpert ? 'expert' : 'client',
            is_expert: isExpert,
            city: faker.location.city(),
            zip_code: faker.location.zipCode(),
            country: 'France',
            location: faker.location.streetAddress(),
            birthdate: faker.date.past({ years: 40 }).toISOString().split('T')[0],
            gender: Math.random() > 0.5 ? 'male' : 'female',
            website: faker.internet.url(),
            hourly_rate: isExpert ? faker.number.int({ min: 20, max: 150 }) : null,
            availability_status: isExpert ? faker.helpers.arrayElement(['available', 'busy', 'unavailable']) : null,
            available_days: isExpert ? JSON.stringify(Array.from({ length: 7 }, () => Math.random() > 0.3)) : null,
            available_hours: isExpert ? JSON.stringify({ start: '09:00', end: '18:00' }) : null,
            email_notifications: true,
            push_notifications: Math.random() > 0.3
        };

        users.push(profile);
    }

    const { data, error } = await supabase
        .from('profiles')
        .insert(users)
        .select();

    if (error) throw error;

    // Créer des vérifications pour les experts
    const experts = data.filter(user => user.is_expert);
    const verifications = experts.map(expert => ({
        user_id: expert.id,
        document_type: faker.helpers.arrayElement(['id_card', 'passport', 'driver_license']),
        document_number: faker.string.alphanumeric(10).toUpperCase(),
        document_url: faker.image.url(),
        status: faker.helpers.arrayElement(['pending', 'approved', 'rejected']),
        submitted_at: faker.date.recent({ days: 30 }).toISOString()
    }));

    await supabase.from('verifications').insert(verifications);

    return data;
}

// Attribuer des compétences aux utilisateurs
async function assignSkillsToUsers(users, skills) {
    const userSkills = [];

    for (const user of users) {
        if (user.is_expert) {
            // Attribuer 3-7 compétences aléatoires à chaque expert
            const numSkills = faker.number.int({ min: 3, max: 7 });
            const shuffledSkills = faker.helpers.shuffle([...skills]).slice(0, numSkills);

            for (const skill of shuffledSkills) {
                userSkills.push({
                    user_id: user.id,
                    skill_id: skill.id
                });
            }
        }
    }

    const { error } = await supabase
        .from('user_skills')
        .insert(userSkills);

    if (error) throw error;
}

// Générer des demandes
async function generateRequests(users, professions) {
    const clients = users.filter(user => !user.is_expert);
    const missions = [];

    for (let i = 0; i < NUM_REQUESTS; i++) {
        const client = faker.helpers.arrayElement(clients);
        const category = faker.helpers.arrayElement(professions);
        const createdAt = faker.date.recent({ days: 60 });

        missions.push({
            client_id: client.id,
            title: faker.lorem.sentence({ min: 3, max: 8 }),
            description: faker.lorem.paragraphs(3),
            budget: faker.number.int({ min: 100, max: 5000 }),
            deadline: faker.date.future({ years: 0.5, refDate: createdAt }).toISOString().split('T')[0],
            status: faker.helpers.arrayElement(['open', 'assigned', 'completed', 'cancelled']),
            profession_id: category.id,
            created_at: createdAt.toISOString()
        });
    }

    const { data, error } = await supabase
        .from('missions')
        .insert(missions)
        .select();

    if (error) throw error;
    return data;
}

// Générer des services
async function generateServices(users, professions, skills) {
    const experts = users.filter(user => user.is_expert);
    const services = [];

    for (let i = 0; i < NUM_SERVICES; i++) {
        const expert = faker.helpers.arrayElement(experts);
        const category = faker.helpers.arrayElement(professions);

        services.push({
            expert_id: expert.id,
            profession_id: category.id,
            title: faker.lorem.sentence({ min: 3, max: 8 }),
            description: faker.lorem.paragraphs(2),
            price: faker.number.int({ min: 50, max: 1000 }),
            delivery_time: faker.number.int({ min: 1, max: 30 }),
            is_active: Math.random() > 0.2,
            created_at: faker.date.recent({ days: 90 }).toISOString()
        });
    }

    const { data, error } = await supabase
        .from('services')
        .insert(services)
        .select();

    if (error) throw error;

    // Attribuer des compétences aux services
    const serviceSkills = [];

    for (const service of data) {
        // Attribuer 2-5 compétences aléatoires à chaque service
        const numSkills = faker.number.int({ min: 2, max: 5 });
        const shuffledSkills = faker.helpers.shuffle([...skills]).slice(0, numSkills);

        for (const skill of shuffledSkills) {
            serviceSkills.push({
                service_id: service.id,
                skill_id: skill.id
            });
        }
    }

    await supabase.from('service_skills').insert(serviceSkills);

    return data;
}

// Générer des propositions
async function generateProposals(missions, users) {
    const experts = users.filter(user => user.is_expert);
    const proposals = [];

    for (let i = 0; i < NUM_PROPOSALS; i++) {
        const mission = faker.helpers.arrayElement(missions);
        const expert = faker.helpers.arrayElement(experts);

        // Éviter les doublons
        if (proposals.some(p => p.mission_id === mission.id && p.expert_id === expert.id)) {
            continue;
        }

        proposals.push({
            mission_id: mission.id,
            expert_id: expert.id,
            price: faker.number.int({ min: 100, max: mission.budget || 3000 }),
            duration: faker.number.int({ min: 1, max: 30 }),
            message: faker.lorem.paragraphs(1),
            status: faker.helpers.arrayElement(['pending', 'accepted', 'rejected']),
            created_at: faker.date.recent({ days: 30 }).toISOString()
        });
    }

    const { error } = await supabase
        .from('proposals')
        .insert(proposals);

    if (error) throw error;
}

// Générer des contrats
async function generateContracts(missions, users) {
    const contracts = [];

    // Sélectionner des demandes assignées ou complétées
    const assignedRequests = missions.filter(r => ['assigned', 'completed'].includes(r.status));

    for (const mission of assignedRequests.slice(0, NUM_CONTRACTS)) {
        // Trouver un expert aléatoire
        const expert = faker.helpers.arrayElement(users.filter(u => u.is_expert));

        contracts.push({
            mission_id: mission.id,
            client_id: mission.client_id,
            expert_id: expert.id,
            title: `Contrat: ${mission.title}`,
            price: faker.number.int({ min: 100, max: mission.budget || 3000 }),
            status: mission.status === 'completed' ? 'completed' : 'active',
            created_at: faker.date.recent({ days: 20 }).toISOString()
        });
    }

    const { error } = await supabase
        .from('contracts')
        .insert(contracts);

    if (error) throw error;
}

// Exécuter le script
generateMockData();