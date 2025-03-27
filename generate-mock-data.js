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
    const professions = [
        { id: faker.string.numeric(3), name: 'Photographie' },
        { id: faker.string.numeric(3), name: 'Cuisine et repas' },
        { id: faker.string.numeric(3), name: 'Jardinage de maison' },
        { id: faker.string.numeric(3), name: 'Bricolage de maison' },
        { id: faker.string.numeric(3), name: 'Garde d\'enfants ET Cours' },
        { id: faker.string.numeric(3), name: 'Cours de langues' },
        { id: faker.string.numeric(3), name: 'Informatique & Programmation' }
    ];

    console.log('Insertion des catégories...');
    const { data, error } = await supabase
        .from('service_professions')
        .insert(professions)
        .select();

    if (error) throw error;
    return data || [];
}

// Fonction pour générer des services
async function generateServices(professions) {
    const services = [];

    // Créer des services pour chaque catégorie
    for (const category of professions) {
        // Services pour Ménage
        if (category.name === 'Ménage') {
            services.push({ id: faker.string.uuid(), profession_id: category.id, name: 'Ménage complet' }, { id: faker.string.uuid(), profession_id: category.id, name: 'Nettoyage de vitres' }, { id: faker.string.uuid(), profession_id: category.id, name: 'Repassage' }, { id: faker.string.uuid(), profession_id: category.id, name: 'Nettoyage en profondeur' });
        }

        // Services pour Jardinage
        else if (category.name === 'Jardinage') {
            services.push({ id: faker.string.uuid(), profession_id: category.id, name: 'Tonte de pelouse' }, { id: faker.string.uuid(), profession_id: category.id, name: 'Taille de haies' }, { id: faker.string.uuid(), profession_id: category.id, name: 'Désherbage' }, { id: faker.string.uuid(), profession_id: category.id, name: 'Plantation' });
        }

        // Services pour Bricolage
        else if (category.name === 'Bricolage') {
            services.push({ id: faker.string.uuid(), profession_id: category.id, name: 'Petites réparations' }, { id: faker.string.uuid(), profession_id: category.id, name: 'Montage de meubles' }, { id: faker.string.uuid(), profession_id: category.id, name: 'Peinture' }, { id: faker.string.uuid(), profession_id: category.id, name: 'Plomberie basique' });
        }

        // Services pour d'autres catégories
        else {
            // Ajouter 2-4 services par défaut pour les autres catégories
            const numServices = faker.number.int({ min: 2, max: 4 });
            for (let i = 0; i < numServices; i++) {
                services.push({
                    id: faker.string.uuid(),
                    profession_id: category.id,
                    name: `${category.name} - ${faker.commerce.productName()}`,
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
        { id: faker.string.numeric(3), name: 'Mac' },
        { id: faker.string.numeric(3), name: 'Photoshop' },
        { id: faker.string.numeric(3), name: 'Word' },
        { id: faker.string.numeric(3), name: 'Excel' },
        { id: faker.string.numeric(3), name: 'Powerpoint' },
        { id: faker.string.numeric(3), name: 'Langue' },
        { id: faker.string.numeric(3), name: 'Football' },
        { id: faker.string.numeric(3), name: 'Basketball' },
        { id: faker.string.numeric(3), name: 'Tennis' },
        { id: faker.string.numeric(3), name: 'Piano' }
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
                location: faker.location.streetAddress(),
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
    const missions = [];
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
        const clientId = clientIds.length > 0 ?
            faker.helpers.arrayElement(clientIds) :
            users[0].id;

        // Créer la demande
        const mission = {
            id: faker.string.uuid(),
            client_id: clientId,
            service_id: service.id,
            // profession_id: service.profession_id, // Ajout du champ profession_id
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

        missions.push(mission);
    }

    // Insérer les demandes
    const { error } = await supabase
        .from('missions')
        .insert(missions);

    if (error) throw error;

    return missions;
}

// Fonction pour générer des propositions
async function generateProposals(missions, expertIds) {
    const proposals = [];
    const statuses = ['pending', 'accepted', 'rejected'];

    console.log('Génération des propositions...');

    // Pour chaque demande active, générer 0-3 propositions
    for (const mission of missions.filter(r => r.status === 'active')) {
        const numProposals = faker.number.int({ min: 0, max: 3 });

        // Sélectionner des experts aléatoires
        const selectedExperts = faker.helpers.arrayElements(expertIds, Math.min(numProposals, expertIds.length));

        for (const expertId of selectedExperts) {
            proposals.push({
                id: faker.string.uuid(),
                mission_id: mission.id,
                expert_id: expertId,
                price: faker.number.float({ min: mission.budget * 0.8, max: mission.budget * 1.2, precision: 0.01 }),
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
        const mission = await supabase
            .from('missions')
            .select('client_id, date')
            .eq('id', proposal.mission_id)
            .single();

        if (mission.error || !mission.data) continue;

        const startDate = new Date(mission.data.date);
        const endDate = new Date(startDate);
        endDate.setDate(endDate.getDate() + faker.number.int({ min: 1, max: 30 }));

        contracts.push({
            id: faker.string.uuid(),
            mission_id: proposal.mission_id,
            proposal_id: proposal.id,
            client_id: mission.data.client_id,
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
async function generateConversations(missions, clientIds, expertIds) {
    const conversations = [];
    const participants = [];
    const messages = [];

    console.log('Génération des conversations...');

    for (const mission of missions) {
        // Créer une conversation pour chaque demande
        const conversationId = faker.string.uuid();

        conversations.push({
            id: conversationId,
            mission_id: mission.id,
            created_at: faker.date.recent({ days: 15 }).toISOString()
        });

        // Ajouter le client comme participant
        participants.push({
            id: faker.string.uuid(),
            conversation_id: conversationId,
            profile_id: mission.client_id,
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
            const senderId = faker.helpers.arrayElement([mission.client_id, expertId]);
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
        const professions = await generateCategories();
        console.log(`${professions.length} catégories créées`);

        // Génération des services
        const services = await generateServices(professions);
        console.log(`${services.length} services créés`);

        // Génération des utilisateurs (clients et experts)
        const { users, expertIds } = await generateUsers(10, skills);
        console.log(`${users.length} utilisateurs créés, dont ${expertIds.length} experts`);

        // Liaison experts-services
        const expertServices = await generateExpertServices(expertIds, services);
        console.log(`${expertServices.length} liaisons experts-services créées`);

        // Génération des demandes
        const missions = await generateRequests(users, services, professions.map(c => c.id), 30);
        console.log(`${missions.length} demandes créées`);

        // Génération des propositions
        const proposals = await generateProposals(missions, expertIds);
        console.log(`${proposals.length} propositions créées`);

        // Génération des contrats
        const contracts = await generateContracts(proposals);
        console.log(`${contracts.length} contrats créés`);

        // Génération des avis
        const reviews = await generateReviews(contracts);
        console.log(`${reviews.length} avis créés`);

        // Génération des conversations et messages
        const { conversations, messages } = await generateConversations(
            missions,
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