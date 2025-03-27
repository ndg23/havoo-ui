export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export interface Database {
  public: {
    Tables: {
      profiles: {
        Row: {
          id: string;
          first_name: string;
          last_name: string;
          email: string;
          phone: string | null;
          avatar_url: string | null;
          profession: string | null;
          experience: number | null;
          bio: string | null;
          is_expert: boolean;
          is_available: boolean;
          is_verified: boolean;
          hourly_rate: number | null;
          created_at: string;
          updated_at: string;
          notification_preferences?: {
            email: boolean;
            sms: boolean;
            app: boolean;
            messages: boolean;
            proposals: boolean;
            contracts: boolean;
            payments: boolean;
          };
        }
        Insert: {
          id: string;
          first_name: string;
          last_name: string;
          email: string;
          phone?: string | null;
          avatar_url?: string | null;
          profession?: string | null;
          experience?: number | null;
          bio?: string | null;
          is_expert?: boolean;
          is_available?: boolean;
          is_verified?: boolean;
          hourly_rate?: number | null;
          created_at?: string;
          updated_at?: string;
        }
        Update: {
          id?: string;
          first_name?: string;
          last_name?: string;
          email?: string;
          phone?: string | null;
          avatar_url?: string | null;
          profession?: string | null;
          experience?: number | null;
          bio?: string | null;
          is_expert?: boolean;
          is_available?: boolean;
          is_verified?: boolean;
          hourly_rate?: number | null;
          created_at?: string;
          updated_at?: string;
          notification_preferences?: object;
        }
      }
      
      missions: {
        Row: {
          id: number;
          client_id: string;
          title: string;
          description: string;
          budget: number | null;
          deadline: string | null;
          status: 'open' | 'assigned' | 'completed' | 'cancelled';
          skills_required: string[] | null;
          created_at: string;
          updated_at: string;
        }
        Insert: {
          client_id: string;
          title: string;
          description: string;
          budget?: number | null;
          deadline?: string | null;
          status?: 'open' | 'assigned' | 'completed' | 'cancelled';
          skills_required?: string[] | null;
        }
        Update: {
          title?: string;
          description?: string;
          budget?: number | null;
          deadline?: string | null;
          status?: 'open' | 'assigned' | 'completed' | 'cancelled';
          skills_required?: string[] | null;
        }
      }
      
      proposals: {
        Row: {
          id: number;
          mission_id: number;
          expert_id: string;
          price: number;
          duration: number;
          message: string;
          status: 'pending' | 'accepted' | 'rejected';
          created_at: string;
          updated_at: string;
        }
        Insert: {
          mission_id: number;
          expert_id: string;
          price: number;
          duration: number;
          message: string;
          status?: 'pending' | 'accepted' | 'rejected';
        }
        Update: {
          price?: number;
          duration?: number;
          message?: string;
          status?: 'pending' | 'accepted' | 'rejected';
        }
      }
      
      contracts: {
        Row: {
          id: number;
          mission_id: number | null;
          proposal_id: number | null;
          client_id: string;
          expert_id: string;
          title: string;
          description: string | null;
          price: number;
          start_date: string | null;
          end_date: string | null;
          status: 'pending' | 'active' | 'completed' | 'cancelled';
          created_at: string;
          updated_at: string;
        }
        Insert: {
          mission_id?: number | null;
          proposal_id?: number | null;
          client_id: string;
          expert_id: string;
          title: string;
          description?: string | null;
          price: number;
          start_date?: string | null;
          end_date?: string | null;
          status?: 'pending' | 'active' | 'completed' | 'cancelled';
        }
        Update: {
          title?: string;
          description?: string | null;
          price?: number;
          start_date?: string | null;
          end_date?: string | null;
          status?: 'pending' | 'active' | 'completed' | 'cancelled';
        }
      }
      
      skills: {
        Row: {
          id: number;
          name: string;
          category: string | null;
        }
      }
      
      user_skills: {
        Row: {
          id: number;
          user_id: string;
          skill_id: number;
          level: number;
        }
        Insert: {
          user_id: string;
          skill_id: number;
          level: number;
        }
        Update: {
          level?: number;
        }
      }
      
      messages: {
        Row: {
          id: number;
          sender_id: string;
          receiver_id: string;
          contract_id: number | null;
          content: string;
          is_read: boolean;
          created_at: string;
        }
        Insert: {
          sender_id: string;
          receiver_id: string;
          contract_id?: number | null;
          content: string;
          is_read?: boolean;
        }
      }
    }
  }
}

export interface Contract {
  id: string;
  created_at: string;
  client_id: string;
  expert_id: string;
  mission_id: string;
  proposal_id: string;
  title: string;
  description: string;
  status: 'draft' | 'active' | 'completed' | 'cancelled';
  amount: number;
  start_date: string | null;
  end_date: string | null;
  deliverable_description: string | null;
  deliverable_files: string[] | null;
}

export interface Payment {
  id: string;
  contract_id: string;
  amount: number;
  status: 'pending' | 'completed' | 'failed' | 'refunded';
  payment_method: string | null;
  payment_date: string | null;
  transaction_id: string | null;
} 