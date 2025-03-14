// Créer un contrat sans milestones
export const createContract = async(contractData) => {
    const { data, error } = await supabase
        .from('contracts')
        .insert({
            client_id: contractData.clientId,
            expert_id: contractData.expertId,
            request_id: contractData.requestId,
            proposal_id: contractData.proposalId,
            title: contractData.title,
            description: contractData.description,
            amount: contractData.amount,
            status: 'draft',
            start_date: contractData.startDate || null,
            end_date: contractData.endDate || null,
            deliverable_description: contractData.deliverableDescription || null
                // Les champs liés aux milestones ont été supprimés
        })
        .select()
        .single();

    if (error) throw error;
    return data;
};

// Autres fonctions simplifiées...
export const finalizeContract = async(contractId) => {
    const { data, error } = await supabase
        .from('contracts')
        .update({
            status: 'completed',
            end_date: new Date().toISOString()
        })
        .eq('id', contractId)
        .select()
        .single();

    if (error) throw error;
    return data;
};