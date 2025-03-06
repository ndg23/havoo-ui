export interface Tables {
  profiles: {
    id: string
    first_name: string
    last_name: string
    email: string
    bio?: string
    is_expert: boolean
    created_at: string
    updated_at: string
  }
  experts: {
    id: string
    bio: string
    hourly_rate: number
    availability_status: string
    verification_status: string
    created_at: string
    updated_at: string
  }
  profile_skills: {
    profile_id: string
    skill_id: string
    created_at: string
  }
  expert_services: {
    expert_id: string
    service_id: string
    price_per_hour: number
    created_at: string
  }
}

export type Database = {
  public: {
    Tables: Tables
  }
} 