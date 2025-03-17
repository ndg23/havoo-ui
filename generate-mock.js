import { createClient } from '@supabase/supabase-js';
import { faker } from '@faker-js/faker/locale/fr';
import dotenv from 'dotenv';

// Charger les variables d'environnement
dotenv.config();

// Configuration Supabase
const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_KEY;
const supabase = createClient(supabaseUrl, supabaseKey);

// Function to log detailed errors
function logError(operation, error) {
    console.error(`Error during ${operation}:`, error);
    console.error('Error details:', JSON.stringify(error, null, 2));
    if (error.message) console.error('Message:', error.message);
    if (error.hint) console.error('Hint:', error.hint);
    if (error.details) console.error('Details:', error.details);
    if (error.code) console.error('Code:', error.code);
}

// Fonction pour générer des catégories de services
async function generateCategories() {
    try {
        console.log('Fetching existing categories...');
        const { data: existingCategories, error: fetchError } = await supabase
            .from('categories')
            .select('*');

        if (fetchError) {
            logError('fetching categories', fetchError);
            throw fetchError;
        }

        console.log(`Found ${existingCategories?.length || 0} existing categories`);

        // If categories already exist, return them
        if (existingCategories && existingCategories.length > 0) {
            console.log('Using existing categories');
            return existingCategories;
        }

        // Define categories to insert
        const categories = [
            { name: 'Ménage', description: 'Services de nettoyage et d\'entretien' },
            { name: 'Jardinage', description: 'Entretien et aménagement de jardins' },
            { name: 'Bricolage', description: 'Petits travaux et réparations' },
            { name: 'Garde d\'enfants', description: 'Services de garde et d\'accompagnement d\'enfants' },
            { name: 'Cours particuliers', description: 'Enseignement et soutien scolaire' },
            { name: 'Informatique', description: 'Assistance et dépannage informatique' }
        ];

        // Log table structure to debug
        console.log('Getting service_categories table structure...');
        const { data: tableInfo, error: tableError } = await supabase.rpc('get_table_ddl', {
            table_name: 'categories'
        });

        if (tableError) {
            console.log('Could not get table structure:', tableError);
        } else {
            console.log('Table structure:', tableInfo);
        }

        console.log('Inserting categories...');
        console.log('Categories to insert:', JSON.stringify(categories, null, 2));

        const { data, error } = await supabase
            .from('categories')
            .insert(categories)
            .select();

        if (error) {
            logError('inserting categories', error);
            throw error;
        }

        return data || [];
    } catch (error) {
        logError('generateCategories', error);
        throw error;
    }
}

// Fonction pour générer des services
async function generateServices(categories) {
    const services = [];

    for (const category of categories) {
        // Services pour Ménage
        if (category.name === 'Ménage') {
            services.push({ category_id: category.id, name: 'Ménage régulier', description: 'Nettoyage régulier de votre domicile' }, { category_id: category.id, name: 'Nettoyage de vitres', description: 'Nettoyage professionnel de vos vitres' }, { category_id: category.id, name: 'Repassage', description: 'Service de repassage de vêtements' }, { category_id: category.id, name: 'Ménage de printemps', description: 'Nettoyage approfondi de votre domicile' });
        }

        // Services pour Jardinage
        else if (category.name === 'Jardinage') {
            services.push({ category_id: category.id, name: 'Tonte de pelouse', description: 'Tonte et entretien de votre pelouse' }, { category_id: category.id, name: 'Taille de haies', description: 'Taille et mise en forme de vos haies' }, { category_id: category.id, name: 'Désherbage', description: 'Élimination des mauvaises herbes' }, { category_id: category.id, name: 'Plantation', description: 'Plantation de fleurs, arbustes ou légumes' });
        }

        // Services pour Bricolage
        else if (category.name === 'Bricolage') {
            services.push({ category_id: category.id, name: 'Petites réparations', description: 'Réparations diverses dans la maison' }, { category_id: category.id, name: 'Montage de meubles', description: 'Assemblage et montage de meubles en kit' }, { category_id: category.id, name: 'Peinture', description: 'Travaux de peinture intérieure ou extérieure' }, { category_id: category.id, name: 'Plomberie basique', description: 'Réparations simples de plomberie' });
        }

        // Services pour Garde d'enfants
        else if (category.name === 'Garde d\'enfants') {
            services.push({ category_id: category.id, name: 'Garde régulière', description: 'Garde d\'enfants à votre domicile' }, { category_id: category.id, name: 'Sortie d\'école', description: 'Récupération des enfants à l\'école' }, { category_id: category.id, name: 'Baby-sitting', description: 'Garde occasionnelle en soirée' }, { category_id: category.id, name: 'Aide aux devoirs', description: 'Accompagnement scolaire et aide aux devoirs' });
        }

        // Services pour Cours particuliers
        else if (category.name === 'Cours particuliers') {
            services.push({ category_id: category.id, name: 'Mathématiques', description: 'Cours de mathématiques tous niveaux' }, { category_id: category.id, name: 'Langues étrangères', description: 'Apprentissage et perfectionnement en langues' }, { category_id: category.id, name: 'Musique', description: 'Initiation et cours de musique' }, { category_id: category.id, name: 'Informatique', description: 'Formation aux outils informatiques' });
        }

        // Services pour Informatique
        else if (category.name === 'Informatique') {
            services.push({ category_id: category.id, name: 'Dépannage PC', description: 'Résolution de problèmes informatiques' }, { category_id: category.id, name: 'Installation logiciels', description: 'Installation et configuration de logiciels' }, { category_id: category.id, name: 'Création de site web', description: 'Conception de sites web personnalisés' }, { category_id: category.id, name: 'Formation bureautique', description: 'Initiation aux outils bureautiques' });
        }

        // Services pour d'autres catégories
        else {
            // Ajouter 2-4 services par défaut pour les autres catégories
            const numServices = faker.number.int({ min: 2, max: 4 });
            for (let i = 0; i < numServices; i++) {
                services.push({
                    category_id: category.id,
                    title: `${category.name} - ${faker.commerce.productName()}`,
                    description: faker.lorem.sentence()
                });
            }
        }
    }

    console.log('Insertion des services...');
    const { data, error } = await supabase
        .from('services')
        .insert(services)
        .select();

    if (error) throw error;
    return data || [];
}

// Fonction pour créer des compétences
async function generateSkills() {
    try {
        console.log('Fetching existing skills...');
        const { data: existingSkills, error: fetchError } = await supabase
            .from('skills')
            .select('*');

        if (fetchError) {
            logError('fetching skills', fetchError);
            throw fetchError;
        }

        // If skills already exist, return them
        if (existingSkills && existingSkills.length > 0) {
            console.log('Using existing skills');
            return existingSkills;
        }

        const skills = [
            { name: 'Informatique' },
            { name: 'Photographie' },
            { name: 'Cuisine' },
            { name: 'Jardinage' },
            { name: 'Bricolage' },
            { name: 'Langues étrangères' },
            { name: 'Musique' },
            { name: 'Sport' },
            { name: 'Art' },
            { name: 'Enseignement' }
        ];

        console.log('Insertion des compétences...');
        const { data, error } = await supabase
            .from('skills')
            .insert(skills)
            .select();

        if (error) {
            logError('inserting skills', error);
            throw error;
        }

        return data || [];
    } catch (error) {
        logError('generateSkills', error);
        throw error;
    }
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
                is_expert: isExpert,
                role: role,
                phone: faker.phone.number('+33 6 ## ## ## ##'),
                address: faker.location.streetAddress(),
                city: faker.location.city(),
                country: 'France',
                avatar_url: `https://ui-avatars.com/api/?name=${encodeURIComponent(firstName+'+'+lastName)}&background=random&size=256`,
                bio: faker.lorem.paragraph(),
                created_at: faker.date.past({ years: 1 }).toISOString(),
                updated_at: faker.date.recent().toISOString(),
                newsletter_opt_in: faker.datatype.boolean(0.7)
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

                // Créer des liaisons user_skills
                for (const skill of expertSkills) {
                    const { error: skillError } = await supabase
                        .from('user_skills')
                        .insert({
                            user_id: userId,
                            skill_id: skill.id
                        });

                    if (skillError) {
                        console.error(`Erreur lors de l'ajout de compétences pour ${email}:`, skillError);
                    }
                }

                // Créer un profil d'expert
                const expertProfile = {
                    user_id: userId,
                    category_id: null, // Sera mis à jour ultérieurement si nécessaire
                    title: faker.person.jobTitle(),
                    hourly_rate: faker.number.int({ min: 20, max: 80 }),
                    years_experience: faker.number.int({ min: 1, max: 20 }),
                    rating: faker.number.float({ min: 3.5, max: 5, precision: 0.1 }),
                    reviews_count: faker.number.int({ min: 0, max: 50 }),
                    is_verified: faker.datatype.boolean(0.7),
                    created_at: profile.created_at,
                    updated_at: profile.updated_at
                };

                expertProfiles.push(expertProfile);
            }

            // Créer des préférences de notification pour l'utilisateur
            userSettings.push({
                user_id: userId,
                email_notifications: faker.datatype.boolean(0.8),
                push_notifications: faker.datatype.boolean(0.6),
                language: faker.helpers.arrayElement(['fr', 'en']),
                theme: faker.helpers.arrayElement(['light', 'dark', 'system']),
                created_at: profile.created_at,
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

// Fonction pour créer des liaisons experts-services
async function generateExpertServices(expertIds, services) {
    const expertServices = [];

    console.log('Création des liaisons experts-services...');

    for (const expertId of expertIds) {
        // Chaque expert propose 2-5 services
        const numServices = faker.number.int({ min: 2, max: 5 });
        const selectedServices = faker.helpers.arrayElements(services, numServices);

        for (const service of selectedServices) {
            expertServices.push({
                id: faker.string.uuid(),
                expert_id: expertId,
                service_id: service.id,
                price: faker.number.float({ min: 20, max: 100, precision: 0.01 }),
                description: faker.lorem.paragraph(),
                is_available: faker.datatype.boolean(0.9),
                created_at: faker.date.past({ years: 1 }).toISOString(),
                updated_at: faker.date.recent().toISOString()
            });
        }
    }

    // Insérer les liaisons
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
        const clientId = clientIds.length > 0 ?
            faker.helpers.arrayElement(clientIds) :
            users[0].id;

        // Créer la demande
        const request = {
            id: faker.string.uuid(),
            client_id: clientId,
            service_id: service.id,
            category_id: service.category_id,
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
            is_flexible_date: faker.datatype.boolean(0.3),
            created_at: faker.date.recent({ days: 30 }).toISOString(),
            updated_at: faker.date.recent().toISOString()
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

// Fonction pour générer des propositions d'experts
async function generateProposals(requests, expertIds) {
    const proposals = [];
    const statuses = ['pending', 'accepted', 'rejected', 'cancelled'];

    console.log('Génération des propositions...');

    for (const request of requests) {
        // 30% des demandes reçoivent entre 1 et 3 propositions
        if (faker.datatype.boolean(0.3)) {
            const numProposals = faker.number.int({ min: 1, max: 3 });

            // Sélectionner des experts aléatoires pour faire des propositions
            const selectedExperts = faker.helpers.arrayElements(expertIds, numProposals);

            for (const expertId of selectedExperts) {
                const createdAt = faker.date.between({
                    from: new Date(request.created_at),
                    to: new Date()
                }).toISOString();

                const status = faker.helpers.arrayElement(statuses);

                // Si acceptée, on définit la date d'acceptation
                let acceptedAt = null;
                if (status === 'accepted') {
                    acceptedAt = faker.date.between({
                        from: new Date(createdAt),
                        to: new Date()
                    }).toISOString();
                }

                proposals.push({
                    id: faker.string.uuid(),
                    request_id: request.id,
                    expert_id: expertId,
                    price: faker.number.float({ min: request.budget * 0.8, max: request.budget * 1.2, precision: 0.01 }),
                    message: faker.lorem.paragraph(),
                    status: status,
                    created_at: createdAt,
                    updated_at: faker.date.recent().toISOString(),
                    accepted_at: acceptedAt
                });
            }
        }
    }

    // Insérer les propositions
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
    const statuses = ['active', 'completed', 'cancelled'];

    console.log('Génération des contrats...');

    // Créer des contrats pour les propositions acceptées
    const acceptedProposals = proposals.filter(p => p.status === 'accepted');

    for (const proposal of acceptedProposals) {
        const status = faker.helpers.arrayElement(statuses);

        // Déterminer les dates selon le statut
        let completedAt = null;
        let cancelledAt = null;

        if (status === 'completed') {
            completedAt = faker.date.between({
                from: new Date(proposal.accepted_at),
                to: new Date()
            }).toISOString();
        } else if (status === 'cancelled') {
            cancelledAt = faker.date.between({
                from: new Date(proposal.accepted_at),
                to: new Date()
            }).toISOString();
        }

        contracts.push({
            id: faker.string.uuid(),
            proposal_id: proposal.id,
            client_id: null, // Sera lié via la requête
            expert_id: proposal.expert_id,
            title: `Contrat #${faker.string.alphanumeric(6).toUpperCase()}`,
            description: faker.lorem.paragraph(),
            amount: proposal.price,
            status: status,
            payment_status: status === 'completed' ? 'paid' : 'pending',
            created_at: proposal.accepted_at,
            updated_at: faker.date.recent().toISOString(),
            completed_at: completedAt,
            cancelled_at: cancelledAt
        });
    }

    // Récupérer les informations des requêtes pour compléter les contrats
    for (const contract of contracts) {
        const { data, error } = await supabase
            .from('proposals')
            .select('request_id')
            .eq('id', contract.proposal_id)
            .single();

        if (!error && data) {
            const { data: requestData, error: requestError } = await supabase
                .from('requests')
                .select('client_id')
                .eq('id', data.request_id)
                .single();

            if (!requestError && requestData) {
                contract.client_id = requestData.client_id;
            }
        }
    }

    // Insérer les contrats
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

    // Créer des avis pour les contrats complétés
    const completedContracts = contracts.filter(c => c.status === 'completed');

    for (const contract of completedContracts) {
        // 80% des contrats complétés ont un avis
        if (faker.datatype.boolean(0.8)) {
            // Avis du client pour l'expert
            reviews.push({
                id: faker.string.uuid(),
                contract_id: contract.id,
                reviewer_id: contract.client_id,
                reviewed_id: contract.expert_id,
                rating: faker.number.int({ min: 3, max: 5 }),
                comment: faker.lorem.paragraph(),
                created_at: faker.date.between({
                    from: new Date(contract.completed_at),
                    to: new Date()
                }).toISOString(),
                updated_at: faker.date.recent().toISOString()
            });

            // 50% de chance d'avoir aussi un avis de l'expert pour le client
            if (faker.datatype.boolean(0.5)) {
                reviews.push({
                    id: faker.string.uuid(),
                    contract_id: contract.id,
                    reviewer_id: contract.expert_id,
                    reviewed_id: contract.client_id,
                    rating: faker.number.int({ min: 3, max: 5 }),
                    comment: faker.lorem.paragraph(),
                    created_at: faker.date.between({
                        from: new Date(contract.completed_at),
                        to: new Date()
                    }).toISOString(),
                    updated_at: faker.date.recent().toISOString()
                });
            }
        }
    }

    // Insérer les avis
    if (reviews.length > 0) {
        const { error } = await supabase
            .from('reviews')
            .insert(reviews);

        if (error) throw error;
    }

    return reviews;
}

// Fonction pour générer des conversations et messages
async function generateConversations(requests, clientIds, expertIds) {
    const conversations = [];
    const messages = [];

    console.log('Génération des conversations et messages...');

    // Créer des conversations pour chaque demande
    for (const request of requests) {
        // Sélectionner un expert aléatoire
        const expertId = faker.helpers.arrayElement(expertIds);

        // Créer une conversation
        const conversationId = faker.string.uuid();
        const createdAt = faker.date.between({
            from: new Date(request.created_at),
            to: new Date()
        }).toISOString();

        conversations.push({
            id: conversationId,
            request_id: request.id,
            client_id: request.client_id,
            expert_id: expertId,
            last_message_at: createdAt,
            created_at: createdAt,
            updated_at: createdAt
        });

        // Générer entre 3 et 15 messages pour cette conversation
        const numMessages = faker.number.int({ min: 3, max: 15 });
        let lastMessageTime = new Date(createdAt);

        for (let i = 0; i < numMessages; i++) {
            // Ajouter entre 1 minute et 2 heures entre les messages
            const messageTime = new Date(lastMessageTime.getTime() + faker.number.int({ min: 1, max: 120 }) * 60000);

            // Alternance entre client et expert
            const senderId = i % 2 === 0 ? request.client_id : expertId;

            messages.push({
                id: faker.string.uuid(),
                conversation_id: conversationId,
                sender_id: senderId,
                content: faker.lorem.paragraph(),
                is_read: messageTime < new Date(Date.now() - 86400000), // Messages plus vieux que 24h sont lus
                created_at: messageTime.toISOString(),
                updated_at: messageTime.toISOString()
            });

            lastMessageTime = messageTime;
        }

        // Mettre à jour last_message_at avec le dernier message
        if (messages.length > 0) {
            const lastMessage = messages[messages.length - 1];
            conversations[conversations.length - 1].last_message_at = lastMessage.created_at;
            conversations[conversations.length - 1].updated_at = lastMessage.created_at;
        }
    }

    // Insérer les conversations
    if (conversations.length > 0) {
        const { error: convError } = await supabase
            .from('conversations')
            .insert(conversations);

        if (convError) throw convError;
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
    const types = ['new_request', 'new_proposal', 'message', 'contract_update', 'payment', 'review'];

    console.log('Génération des notifications...');

    // Notifications pour les clients
    for (const clientId of clientIds) {
        // 3-8 notifications par client
        const numNotifications = faker.number.int({ min: 3, max: 8 });

        for (let i = 0; i < numNotifications; i++) {
            const type = faker.helpers.arrayElement(types);
            let title, content;

            switch (type) {
                case 'new_proposal':
                    title = 'Nouvelle proposition';
                    content = 'Un expert a fait une proposition pour votre demande de service.';
                    break;
                case 'message':
                    title = 'Nouveau message';
                    content = 'Vous avez reçu un nouveau message.';
                    break;
                case 'contract_update':
                    title = 'Mise à jour du contrat';
                    content = 'Le statut de votre contrat a été mis à jour.';
                    break;
                case 'payment':
                    title = 'Paiement confirmé';
                    content = 'Votre paiement a bien été reçu.';
                    break;
                case 'review':
                    title = 'Nouvel avis';
                    content = 'Un expert a laissé un avis sur votre collaboration.';
                    break;
                default:
                    title = 'Notification';
                    content = 'Vous avez une nouvelle notification.';
            }

            notifications.push({
                id: faker.string.uuid(),
                user_id: clientId,
                type: type,
                title: title,
                content: content,
                is_read: faker.datatype.boolean(0.3),
                link: '/',
                created_at: faker.date.recent({ days: 10 }).toISOString(),
                updated_at: faker.date.recent().toISOString()
            });
        }
    }

    // Notifications pour les experts
    for (const expertId of expertIds) {
        // 3-8 notifications par expert
        const numNotifications = faker.number.int({ min: 3, max: 8 });

        for (let i = 0; i < numNotifications; i++) {
            const type = faker.helpers.arrayElement(types);
            let title, content;

            switch (type) {
                case 'new_request':
                    title = 'Nouvelle demande de service';
                    content = 'Une nouvelle demande correspond à vos compétences.';
                    break;
                case 'message':
                    title = 'Nouveau message';
                    content = 'Vous avez reçu un nouveau message d\'un client.';
                    break;
                case 'contract_update':
                    title = 'Mise à jour du contrat';
                    content = 'Un client a accepté votre proposition.';
                    break;
                case 'payment':
                    title = 'Paiement reçu';
                    content = 'Vous avez reçu un paiement pour un service.';
                    break;
                case 'review':
                    title = 'Nouvel avis';
                    content = 'Un client a laissé un avis sur votre service.';
                    break;
                default:
                    title = 'Notification';
                    content = 'Vous avez une nouvelle notification.';
            }

            notifications.push({
                id: faker.string.uuid(),
                user_id: expertId,
                type: type,
                title: title,
                content: content,
                is_read: faker.datatype.boolean(0.3),
                link: '/',
                created_at: faker.date.recent({ days: 10 }).toISOString(),
                updated_at: faker.date.recent().toISOString()
            });
        }
    }

    // Insérer les notifications
    if (notifications.length > 0) {
        const { error } = await supabase
            .from('notifications')
            .insert(notifications);

        if (error) throw error;
    }

    return notifications;
}

// Fonction principale
async function generateAllData() {
    try {
        console.log('Début de la génération des données...');

        // Test connection
        console.log('Testing Supabase connection...');
        const { data: connectionTest, error: connectionError } = await supabase.from('skills').select('count').limit(1);

        if (connectionError) {
            console.error('Supabase connection error:', connectionError);
            return;
        }

        console.log('Connection successful!');

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

// Exécution du script
generateAllData();