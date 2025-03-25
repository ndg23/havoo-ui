/**
 * Utilitaires pour la gestion des vérifications administratives
 * Mis à jour pour supporter Cloudinary et le format à document unique (CNI)
 */

/**
 * Extrait les URLs des documents à partir des données de vérification
 * @param {Object} verification - Objet de vérification
 * @param {String} supabaseUrl - URL de base de Supabase
 * @returns {Object} - Objet contenant les URLs des documents
 */
export function extractDocumentUrls(verification, supabaseUrl) {
    if (!verification || !verification.documents) return { cniUrl: null };

    const documents = verification.documents;
    let cniUrl = null;

    // Extraction du document d'identité (CNI)
    if (documents.identity_document) {
        // Cas Cloudinary
        if (documents.identity_document.url) {
            cniUrl = documents.identity_document.url;
        }
        // Cas Supabase Storage
        else if (documents.identity_document.path) {
            cniUrl = `${supabaseUrl}/storage/v1/object/public/documents/${documents.identity_document.path}`;
        }
    }

    return { cniUrl };
}

/**
 * Formate les informations des documents pour l'affichage
 * @param {Object} verification - Objet de vérification
 * @returns {Object} - Informations formatées des documents
 */
export function formatDocumentInfo(verification) {
    if (!verification || !verification.documents) {
        return { identityDoc: { name: 'Aucun document' } };
    }

    const documents = verification.documents;
    const result = {
        identityDoc: { name: 'Pièce d\'identité non fournie' }
    };

    if (documents.identity_document) {
        result.identityDoc = {
            // Priorité au nom de fichier original si disponible
            name: documents.identity_document.filename || 'Carte Nationale d\'Identité',

            // Type de fichier - Cloudinary ou Supabase
            type: documents.identity_document.content_type ||
                documents.identity_document.type ||
                documents.identity_document.format ||
                '-',

            // Provider - Cloudinary ou Supabase
            provider: documents.identity_document.url ? 'Cloudinary' : 'Supabase',

            // ID public Cloudinary si disponible
            publicId: documents.identity_document.public_id || null,

            // Date d'upload
            uploadedAt: documents.identity_document.uploaded_at ?
                new Date(documents.identity_document.uploaded_at).toLocaleDateString('fr-FR') : '-'
        };
    }

    // Informations supplémentaires
    result.skills = documents.skills || [];
    result.description = documents.description || '';

    return result;
}

/**
 * Vérifie si la demande est au nouveau format avec Cloudinary
 * @param {Object} verification - Objet de vérification
 * @returns {Boolean} - True si c'est le format Cloudinary, false sinon
 */
export function isCloudinaryFormat(verification) {
    if (!verification || !verification.documents) return false;

    const documents = verification.documents;
    return documents.identity_document &&
        documents.identity_document.url &&
        documents.identity_document.url.includes('cloudinary');
}

/**
 * Vérifie si la demande est au nouveau format (CNI uniquement)
 * @param {Object} verification - Objet de vérification
 * @returns {Boolean} - True si au nouveau format, false sinon
 */
export function isNewFormat(verification) {
    if (!verification || !verification.documents) return false;

    const documents = verification.documents;
    return documents.identity_document && !documents.professional_document;
}

/**
 * Génère un rapport de vérification pour les administrateurs
 * @param {Object} verification - Objet de vérification
 * @param {Object} expert - Profil de l'expert
 * @returns {String} - Rapport formaté
 */
export function generateVerificationReport(verification, expert) {
    if (!verification || !expert) return 'Informations insuffisantes';

    const docInfo = formatDocumentInfo(verification);
    const isNewFormatRequest = isNewFormat(verification);
    const isCloudinary = isCloudinaryFormat(verification);

    let report = `RAPPORT DE VÉRIFICATION\n`;
    report += `======================\n\n`;
    report += `Expert: ${expert.first_name} ${expert.last_name}\n`;
    report += `Email: ${expert.email}\n`;
    report += `Statut: ${verification.status}\n`;
    report += `Format: ${isNewFormatRequest ? 'Nouveau (CNI uniquement)' : 'Ancien (multiple documents)'}\n`;
    report += `Provider: ${isCloudinary ? 'Cloudinary' : 'Supabase'}\n\n`;

    report += `DOCUMENT D'IDENTITÉ\n`;
    report += `------------------\n`;
    report += `Nom: ${docInfo.identityDoc.name}\n`;
    report += `Type: ${docInfo.identityDoc.type}\n`;
    report += `Provider: ${docInfo.identityDoc.provider}\n`;
    if (docInfo.identityDoc.publicId) {
        report += `Public ID: ${docInfo.identityDoc.publicId}\n`;
    }
    report += `Téléchargé le: ${docInfo.identityDoc.uploadedAt}\n\n`;

    report += `COMPÉTENCES (${docInfo.skills.length})\n`;
    report += `--------------------\n`;
    docInfo.skills.forEach((skill, index) => {
        report += `${index + 1}. ${skill.name}\n`;
    });
    report += `\n`;

    report += `DESCRIPTION\n`;
    report += `-----------\n`;
    report += `${docInfo.description || 'Aucune description fournie'}\n`;

    return report;
}

/**
 * Validation rapide du document CNI
 * @param {Object} verification - Objet de vérification
 * @returns {Object} - Résultat de validation avec statut et messages
 */
export function validateCniDocument(verification) {
    if (!verification || !verification.documents) {
        return { isValid: false, messages: ['Aucune donnée de document'] };
    }

    const documents = verification.documents;
    const messages = [];
    let isValid = true;

    // Vérification du document d'identité
    if (!documents.identity_document) {
        messages.push('Document CNI manquant');
        isValid = false;
    } else {
        // Cas Cloudinary
        if (documents.identity_document.url) {
            // Vérifier si l'URL est valide
            if (!documents.identity_document.url.includes('cloudinary.com')) {
                messages.push('L\'URL du document CNI ne semble pas être une URL Cloudinary valide');
                isValid = false;
            }

            // Vérifier si le format est indiqué
            if (!documents.identity_document.format && !documents.identity_document.type) {
                messages.push('Le format du document CNI n\'est pas indiqué');
                // Ne pas échouer pour cette raison
            }
        }
        // Cas Supabase Storage
        else if (documents.identity_document.path) {
            // Vérifier le type de fichier
            const contentType = documents.identity_document.content_type || '';
            if (!contentType.startsWith('image/') && contentType !== 'application/pdf') {
                messages.push('Le format du document CNI n\'est pas supporté (formats acceptés: images, PDF)');
                isValid = false;
            }

            // Vérifier que le chemin suit la convention
            const path = documents.identity_document.path || '';
            if (!path.includes('/cni-') && !path.includes('/id-')) {
                messages.push('Le format du chemin du document CNI est incorrect');
                // Ne pas échouer pour cette raison
            }
        } else {
            messages.push('Format de document non reconnu - ni URL Cloudinary ni chemin Supabase');
            isValid = false;
        }
    }

    // Vérification des compétences
    if (!documents.skills || documents.skills.length < 3) {
        messages.push('L\'utilisateur doit déclarer au moins 3 compétences');
        isValid = false;
    }

    // Vérification de la description
    if (!documents.description || documents.description.length < 100) {
        messages.push('La description doit contenir au moins 100 caractères');
        isValid = false;
    }

    return { isValid, messages };
}

export default {
    extractDocumentUrls,
    formatDocumentInfo,
    isNewFormat,
    isCloudinaryFormat,
    generateVerificationReport,
    validateCniDocument
};