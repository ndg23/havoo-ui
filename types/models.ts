// Types d'énumération
export enum UserRole {
  CLIENT = 'client',
  EXPERT = 'expert',
  ADMIN = 'admin'
}

export enum ServiceStatus {
  PENDING = 'pending',
  ACCEPTED = 'accepted',
  IN_PROGRESS = 'in_progress',
  COMPLETED = 'completed',
  CANCELLED = 'cancelled'
}

export enum ExpertStatus {
  PENDING = 'pending',
  ACTIVE = 'active',
  INACTIVE = 'inactive',
  SUSPENDED = 'suspended'
}

// Interfaces principales
export interface Profile {
  id: string
  role: UserRole
  first_name: string
  last_name: string
  phone?: string
  avatar_url?: string
  address?: string
  city?: string
  country: string
  created_at: string
  updated_at: string
}

export interface Expert extends Profile {
  status: ExpertStatus
  bio?: string
  experience_years: number
  hourly_rate: number
  availability: Record<string, any>
  total_jobs: number
  rating: number
  verified: boolean
  documents?: Record<string, any>
}

export interface ServiceCategory {
  id: number
  name: string
  icon?: string
  description?: string
}

export interface Service {
  id: number
  category_id: number
  name: string
  description?: string
  icon?: string
  base_price: number
}

export interface ServiceRequest {
  id: string
  client_id: string
  service_id: number
  status: ServiceStatus
  description: string
  date_needed: string
  time_needed: string
  duration?: number
  frequency?: 'once' | 'weekly' | 'biweekly' | 'monthly'
  location: string
  budget?: number
  created_at: string
  updated_at: string
}

export interface Job {
  id: string
  request_id: string
  expert_id: string
  status: ServiceStatus
  start_time?: string
  end_time?: string
  final_price?: number
  rating?: number
  review?: string
  created_at: string
  updated_at: string
}

// Type pour les réponses de Supabase
export interface Database {
  public: {
    Tables: {
      profiles: {
        Row: Profile
        Insert: Omit<Profile, 'created_at' | 'updated_at'>
        Update: Partial<Profile>
      }
      experts: {
        Row: Expert
        Insert: Omit<Expert, 'created_at' | 'updated_at'>
        Update: Partial<Expert>
      }
      service_categories: {
        Row: ServiceCategory
        Insert: Omit<ServiceCategory, 'id'>
        Update: Partial<ServiceCategory>
      }
      services: {
        Row: Service
        Insert: Omit<Service, 'id'>
        Update: Partial<Service>
      }
      service_requests: {
        Row: ServiceRequest
        Insert: Omit<ServiceRequest, 'id' | 'created_at' | 'updated_at'>
        Update: Partial<ServiceRequest>
      }
      jobs: {
        Row: Job
        Insert: Omit<Job, 'id' | 'created_at' | 'updated_at'>
        Update: Partial<Job>
      }
    }
  }
} 