-- View for complete user profiles with their skills
CREATE VIEW view_user_profiles_with_skills AS
SELECT 
    p.*,
    COALESCE(
        json_agg(
            json_build_object(
                'skill_id', s.id,
                'skill_name', s.name,
                'skill_category', s.category,
                'level', us.level
            )
        ) FILTER (WHERE s.id IS NOT NULL), 
        '[]'::json
    ) as skills
FROM 
    profiles p
LEFT JOIN 
    user_skills us ON p.id = us.user_id
LEFT JOIN 
    skills s ON us.skill_id = s.id
GROUP BY 
    p.id;

-- View for experts with their services and average rating
CREATE VIEW view_experts_with_services AS
SELECT 
    p.*,
    COALESCE(
        json_agg(
            json_build_object(
                'service_id', s.id,
                'title', s.title,
                'description', s.description,
                'price', s.price,
                'category', s.category,
                'is_active', s.is_active
            )
        ) FILTER (WHERE s.id IS NOT NULL), 
        '[]'::json
    ) as services
FROM 
    profiles p
LEFT JOIN 
    services s ON p.id = s.expert_id
WHERE 
    p.is_expert = TRUE
GROUP BY 
    p.id;

-- View for client requests with proposals count
CREATE VIEW view_client_requests_with_proposals AS
SELECT 
    r.*,
    p.first_name || ' ' || p.last_name as client_name,
    p.email as client_email,
    COUNT(pr.id) as proposals_count,
    COALESCE(
        json_agg(
            json_build_object(
                'proposal_id', pr.id,
                'expert_id', pr.expert_id,
                'expert_name', ep.first_name || ' ' || ep.last_name,
                'price', pr.price,
                'duration', pr.duration,
                'status', pr.status
            )
        ) FILTER (WHERE pr.id IS NOT NULL), 
        '[]'::json
    ) as proposals
FROM 
    requests r
JOIN 
    profiles p ON r.client_id = p.id
LEFT JOIN 
    proposals pr ON r.id = pr.request_id
LEFT JOIN 
    profiles ep ON pr.expert_id = ep.id
GROUP BY 
    r.id, p.id;

-- View for active contracts with client and expert details
CREATE VIEW view_active_contracts AS
SELECT 
    c.*,
    cp.first_name || ' ' || cp.last_name as client_name,
    cp.email as client_email,
    ep.first_name || ' ' || ep.last_name as expert_name,
    ep.email as expert_email,
    r.title as request_title,
    r.description as request_description,
    p.price as proposal_price,
    p.duration as proposal_duration
FROM 
    contracts c
JOIN 
    profiles cp ON c.client_id = cp.id
JOIN 
    profiles ep ON c.expert_id = ep.id
JOIN 
    requests r ON c.request_id = r.id
JOIN 
    proposals p ON c.proposal_id = p.id
WHERE 
    c.status = 'active';

-- View for user reviews (received)
CREATE VIEW view_user_reviews AS
SELECT 
    rv.*,
    rr.first_name || ' ' || rr.last_name as reviewer_name,
    re.first_name || ' ' || re.last_name as reviewee_name,
    c.title as contract_title
FROM 
    reviews rv
JOIN 
    profiles rr ON rv.reviewer_id = rr.id
JOIN 
    profiles re ON rv.reviewee_id = re.id
JOIN 
    contracts c ON rv.contract_id = c.id;

-- View for user messages grouped by conversation
CREATE VIEW view_user_conversations AS
SELECT 
    LEAST(m.sender_id, m.receiver_id) || '_' || GREATEST(m.sender_id, m.receiver_id) as conversation_id,
    LEAST(m.sender_id, m.receiver_id) as user1_id,
    GREATEST(m.sender_id, m.receiver_id) as user2_id,
    p1.first_name || ' ' || p1.last_name as user1_name,
    p2.first_name || ' ' || p2.last_name as user2_name,
    MAX(m.created_at) as last_message_time,
    COUNT(m.id) as message_count,
    SUM(CASE WHEN m.is_read = FALSE THEN 1 ELSE 0 END) as unread_count
FROM 
    messages m
JOIN 
    profiles p1 ON LEAST(m.sender_id, m.receiver_id) = p1.id
JOIN 
    profiles p2 ON GREATEST(m.sender_id, m.receiver_id) = p2.id
GROUP BY 
    conversation_id, user1_id, user2_id, user1_name, user2_name;

-- View for payment status by contract
CREATE VIEW view_contract_payments AS
SELECT 
    c.*,
    cp.first_name || ' ' || cp.last_name as client_name,
    ep.first_name || ' ' || ep.last_name as expert_name,
    SUM(p.amount) as total_paid,
    c.price - SUM(p.amount) as remaining_amount,
    CASE 
        WHEN SUM(p.amount) >= c.price THEN 'paid'
        WHEN SUM(p.amount) > 0 THEN 'partially_paid'
        ELSE 'unpaid'
    END as payment_status
FROM 
    contracts c
JOIN 
    profiles cp ON c.client_id = cp.id
JOIN 
    profiles ep ON c.expert_id = ep.id
LEFT JOIN 
    payments p ON c.id = p.contract_id AND p.status = 'completed'
GROUP BY 
    c.id, cp.id, ep.id;

-- View for expert verification status
CREATE VIEW view_expert_verification_status AS
SELECT 
    p.*,
    ev.status as verification_status,
    ev.submitted_at,
    ev.reviewed_at,
    ev.rejection_reason,
    ra.first_name || ' ' || ra.last_name as reviewed_by_name
FROM 
    profiles p
LEFT JOIN 
    expert_verifications ev ON p.id = ev.user_id AND ev.status = 
    (SELECT status FROM expert_verifications WHERE user_id = p.id ORDER BY submitted_at DESC LIMIT 1)
LEFT JOIN 
    profiles ra ON ev.reviewed_by = ra.id
WHERE 
    p.is_expert = TRUE OR p.expert_status IS NOT NULL;

-- View for user notifications with reference details
CREATE VIEW view_user_notifications_with_details AS
SELECT 
    n.*,
    CASE 
        WHEN n.reference_type = 'contract' THEN 
            (SELECT json_build_object('id', id, 'title', title, 'status', status) FROM contracts WHERE id = n.reference_id)
        WHEN n.reference_type = 'proposal' THEN 
            (SELECT json_build_object('id', id, 'price', price, 'status', status) FROM proposals WHERE id = n.reference_id)
        WHEN n.reference_type = 'message' THEN 
            (SELECT json_build_object('id', id, 'sender_id', sender_id, 'content', content) FROM messages WHERE id = n.reference_id)
        WHEN n.reference_type = 'review' THEN 
            (SELECT json_build_object('id', id, 'rating', rating, 'comment', comment) FROM reviews WHERE id = n.reference_id)
        ELSE NULL
    END as reference_details
FROM 
    notifications n;