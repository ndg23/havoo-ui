create or replace function create_verification_for_user(user_id uuid)
returns void
security definer
set search_path = public
language plpgsql
as $$
begin
  insert into verifications (user_id, status)
  values (user_id, 'pending');
end;
$$;

-- Accorder les permissions d'exécution à authenticator
grant execute on function create_verification_for_user(uuid) to authenticated;