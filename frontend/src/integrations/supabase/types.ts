export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "14.5"
  }
  public: {
    Tables: {
      ai_prompts: {
        Row: {
          content: string
          description: string | null
          function_name: string
          id: string
          key: string
          label: string
          prompt_type: string
          updated_at: string
          updated_by: string | null
        }
        Insert: {
          content: string
          description?: string | null
          function_name: string
          id?: string
          key: string
          label: string
          prompt_type?: string
          updated_at?: string
          updated_by?: string | null
        }
        Update: {
          content?: string
          description?: string | null
          function_name?: string
          id?: string
          key?: string
          label?: string
          prompt_type?: string
          updated_at?: string
          updated_by?: string | null
        }
        Relationships: []
      }
      companies: {
        Row: {
          cnpj: string | null
          created_at: string
          id: string
          name: string
          status: string
        }
        Insert: {
          cnpj?: string | null
          created_at?: string
          id?: string
          name: string
          status?: string
        }
        Update: {
          cnpj?: string | null
          created_at?: string
          id?: string
          name?: string
          status?: string
        }
        Relationships: []
      }
      departments: {
        Row: {
          company_id: string
          created_at: string
          id: string
          name: string
        }
        Insert: {
          company_id: string
          created_at?: string
          id?: string
          name: string
        }
        Update: {
          company_id?: string
          created_at?: string
          id?: string
          name?: string
        }
        Relationships: [
          {
            foreignKeyName: "departments_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      hr_conversations: {
        Row: {
          created_at: string
          id: string
          title: string | null
          user_id: string
        }
        Insert: {
          created_at?: string
          id?: string
          title?: string | null
          user_id: string
        }
        Update: {
          created_at?: string
          id?: string
          title?: string | null
          user_id?: string
        }
        Relationships: []
      }
      hr_messages: {
        Row: {
          content: string
          conversation_id: string
          created_at: string
          id: string
          role: string
        }
        Insert: {
          content: string
          conversation_id: string
          created_at?: string
          id?: string
          role: string
        }
        Update: {
          content?: string
          conversation_id?: string
          created_at?: string
          id?: string
          role?: string
        }
        Relationships: [
          {
            foreignKeyName: "hr_messages_conversation_id_fkey"
            columns: ["conversation_id"]
            isOneToOne: false
            referencedRelation: "hr_conversations"
            referencedColumns: ["id"]
          },
        ]
      }
      notifications: {
        Row: {
          created_at: string
          id: string
          message: string | null
          read: boolean
          title: string
          type: string
          user_id: string
        }
        Insert: {
          created_at?: string
          id?: string
          message?: string | null
          read?: boolean
          title: string
          type: string
          user_id: string
        }
        Update: {
          created_at?: string
          id?: string
          message?: string | null
          read?: boolean
          title?: string
          type?: string
          user_id?: string
        }
        Relationships: []
      }
      profile_comparisons: {
        Row: {
          ai_analysis: Json | null
          comparison_type: string
          compatibility_score: number | null
          created_at: string
          id: string
          user1_id: string
          user2_id: string
        }
        Insert: {
          ai_analysis?: Json | null
          comparison_type?: string
          compatibility_score?: number | null
          created_at?: string
          id?: string
          user1_id: string
          user2_id: string
        }
        Update: {
          ai_analysis?: Json | null
          comparison_type?: string
          compatibility_score?: number | null
          created_at?: string
          id?: string
          user1_id?: string
          user2_id?: string
        }
        Relationships: []
      }
      profiles: {
        Row: {
          company_id: string | null
          cpf: string | null
          created_at: string
          department_id: string | null
          email: string
          id: string
          name: string
          phone: string | null
          user_id: string
        }
        Insert: {
          company_id?: string | null
          cpf?: string | null
          created_at?: string
          department_id?: string | null
          email: string
          id?: string
          name: string
          phone?: string | null
          user_id: string
        }
        Update: {
          company_id?: string | null
          cpf?: string | null
          created_at?: string
          department_id?: string | null
          email?: string
          id?: string
          name?: string
          phone?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "profiles_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "profiles_department_id_fkey"
            columns: ["department_id"]
            isOneToOne: false
            referencedRelation: "departments"
            referencedColumns: ["id"]
          },
        ]
      }
      scenario_blocks: {
        Row: {
          block_number: number
          id: string
          ocean_weights_a: Json
          ocean_weights_b: Json
          ocean_weights_c: Json
          ocean_weights_d: Json
          option_a: string
          option_b: string
          option_c: string
          option_d: string
          scenario: string
          weights_a: Json
          weights_b: Json
          weights_c: Json
          weights_d: Json
        }
        Insert: {
          block_number: number
          id?: string
          ocean_weights_a?: Json
          ocean_weights_b?: Json
          ocean_weights_c?: Json
          ocean_weights_d?: Json
          option_a: string
          option_b: string
          option_c: string
          option_d: string
          scenario: string
          weights_a?: Json
          weights_b?: Json
          weights_c?: Json
          weights_d?: Json
        }
        Update: {
          block_number?: number
          id?: string
          ocean_weights_a?: Json
          ocean_weights_b?: Json
          ocean_weights_c?: Json
          ocean_weights_d?: Json
          option_a?: string
          option_b?: string
          option_c?: string
          option_d?: string
          scenario?: string
          weights_a?: Json
          weights_b?: Json
          weights_c?: Json
          weights_d?: Json
        }
        Relationships: []
      }
      test_invitations: {
        Row: {
          company_id: string
          created_at: string | null
          department_id: string | null
          description: string | null
          expires_at: string | null
          id: string
          invited_by: string
          is_active: boolean | null
          max_uses: number | null
          token: string
          used_count: number | null
        }
        Insert: {
          company_id: string
          created_at?: string | null
          department_id?: string | null
          description?: string | null
          expires_at?: string | null
          id?: string
          invited_by: string
          is_active?: boolean | null
          max_uses?: number | null
          token?: string
          used_count?: number | null
        }
        Update: {
          company_id?: string
          created_at?: string | null
          department_id?: string | null
          description?: string | null
          expires_at?: string | null
          id?: string
          invited_by?: string
          is_active?: boolean | null
          max_uses?: number | null
          token?: string
          used_count?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "test_invitations_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "test_invitations_department_id_fkey"
            columns: ["department_id"]
            isOneToOne: false
            referencedRelation: "departments"
            referencedColumns: ["id"]
          },
        ]
      }
      test_responses: {
        Row: {
          block_number: number
          created_at: string
          id: string
          least_option: string
          most_option: string
          user_id: string
        }
        Insert: {
          block_number: number
          created_at?: string
          id?: string
          least_option: string
          most_option: string
          user_id: string
        }
        Update: {
          block_number?: number
          created_at?: string
          id?: string
          least_option?: string
          most_option?: string
          user_id?: string
        }
        Relationships: []
      }
      test_results: {
        Row: {
          ai_analysis: Json | null
          big_five: Json
          completed_at: string
          disc_adapted: Json
          disc_natural: Json
          id: string
          iem: number | null
          share_token: string | null
          user_id: string
        }
        Insert: {
          ai_analysis?: Json | null
          big_five?: Json
          completed_at?: string
          disc_adapted?: Json
          disc_natural?: Json
          id?: string
          iem?: number | null
          share_token?: string | null
          user_id: string
        }
        Update: {
          ai_analysis?: Json | null
          big_five?: Json
          completed_at?: string
          disc_adapted?: Json
          disc_natural?: Json
          id?: string
          iem?: number | null
          share_token?: string | null
          user_id?: string
        }
        Relationships: []
      }
      user_managers: {
        Row: {
          created_at: string | null
          id: string
          is_primary: boolean | null
          manager_id: string
          user_id: string
        }
        Insert: {
          created_at?: string | null
          id?: string
          is_primary?: boolean | null
          manager_id: string
          user_id: string
        }
        Update: {
          created_at?: string | null
          id?: string
          is_primary?: boolean | null
          manager_id?: string
          user_id?: string
        }
        Relationships: []
      }
      user_roles: {
        Row: {
          company_id: string | null
          id: string
          role: Database["public"]["Enums"]["app_role"]
          user_id: string
        }
        Insert: {
          company_id?: string | null
          id?: string
          role?: Database["public"]["Enums"]["app_role"]
          user_id: string
        }
        Update: {
          company_id?: string | null
          id?: string
          role?: Database["public"]["Enums"]["app_role"]
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "user_roles_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      claim_invitation: {
        Args: { token_param: string }
        Returns: {
          company_id: string
          created_at: string | null
          department_id: string | null
          description: string | null
          expires_at: string | null
          id: string
          invited_by: string
          is_active: boolean | null
          max_uses: number | null
          token: string
          used_count: number | null
        }[]
        SetofOptions: {
          from: "*"
          to: "test_invitations"
          isOneToOne: false
          isSetofReturn: true
        }
      }
      delete_company_cascade: {
        Args: { _company_id: string }
        Returns: undefined
      }
      get_user_company_id: { Args: never; Returns: string }
      has_role: {
        Args: {
          _role: Database["public"]["Enums"]["app_role"]
          _user_id: string
        }
        Returns: boolean
      }
      is_company_admin: { Args: { _company_id: string }; Returns: boolean }
      is_master_admin: { Args: never; Returns: boolean }
      is_member: { Args: { _company_id: string }; Returns: boolean }
    }
    Enums: {
      app_role: "master_admin" | "company_admin" | "leader" | "user"
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {
      app_role: ["master_admin", "company_admin", "leader", "user"],
    },
  },
} as const
