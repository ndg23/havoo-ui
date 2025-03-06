export interface Skill {
  id: string
  name: string
  icon?: string
  created_at?: string
}

export interface Service {
  id: string
  name: string
  icon?: string
  category_id: string
  description?: string
  created_at?: string
  updated_at?: string
}

export interface Expert {
  id: string
  bio: string
  hourly_rate: number
  availability_status: 'available' | 'unavailable' | 'busy'
  verification_status: 'pending' | 'verified' | 'rejected'
  average_rating?: number
  review_count?: number
  created_at?: string
  updated_at?: string
}

export interface Profile {
  id: string
  first_name: string
  last_name: string
  email: string
  phone?: string
  address?: string
  city?: string
  country?: string
  birthdate?: string
  gender?: string
  bio?: string
  profile_image_url?: string
  banner_image_url?: string
  is_expert: boolean
  created_at?: string
  updated_at?: string
} 