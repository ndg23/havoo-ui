<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900">
    <AppHeader />
    
    <main class="container mx-auto px-4 py-8 max-w-6xl">
      <div class="flex flex-col md:flex-row gap-6">
        <!-- Sidebar de navigation -->
        <div class="w-full md:w-64 shrink-0">
          <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm p-4 sticky top-20">
            <NuxtLink 
              to="/account" 
              class="flex items-center mb-4 text-gray-900 dark:text-white font-medium hover:text-primary-600 dark:hover:text-primary-400"
            >
              <ChevronLeft class="h-4 w-4 mr-1.5" />
              Retour au profil
            </NuxtLink>
            
            <div class="space-y-1 pt-2 border-t border-gray-200 dark:border-gray-700">
              <NavLink to="/account/settings">
                <Settings2 class="h-4 w-4 mr-2" />
                Paramètres
              </NavLink>
              <NavLink to="/account/services">
                <PackageIcon class="h-4 w-4 mr-2" />
                Mes services
              </NavLink>
              <NavLink to="/account/proposals">
                <MessageSquare class="h-4 w-4 mr-2" />
                Mes propositions
              </NavLink>
              <NavLink to="/account/messages">
                <Mail class="h-4 w-4 mr-2" />
                Messages
              </NavLink>
            </div>
          </div>
        </div>
        
        <!-- Contenu principal -->
        <div class="flex-1 min-w-0">
          <slot />
        </div>
      </div>
    </main>
    
    <AppFooter />
  </div>
</template>

<script setup>
import { ref, onMounted, computed, provide } from 'vue'
import { useSupabaseClient, useSupabaseUser } from '#imports'
import {
  UserCheck, 
  UserX, 
  Calendar, 
  MapPin,   
  Phone, 
  Link,
  Camera,
  ChevronLeft,
  Settings2,
  PackageIcon,
  MessageSquare,
  Mail
} from 'lucide-vue-next'
import Navbar from '~/components/Navbar.vue'
import AppHeader from '~/components/account/AccountHeader.vue'

// États
const profile = ref(null)
const user = useSupabaseUser()
const supabase = useSupabaseClient()

// Propriétés calculées
const isExpert = computed(() => {
  return profile.value?.is_expert
})

// Méthodes
const fetchProfile = async () => {
  try {
    if (!user.value?.id) return
    
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', user.value.id)
      .single()
    
    if (error) throw error
    
    profile.value = data
  } catch (error) {
    console.error('Erreur lors du chargement du profil:', error)
  }
}

const formatDate = (dateString) => {
  if (!dateString) return 'Date inconnue'
  
  const date = new Date(dateString)
  return new Intl.DateTimeFormat('fr-FR', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  }).format(date)
}

// Partager les données avec les composants enfants
provide('userProfile', profile)
provide('isExpert', isExpert)

// Initialisation
onMounted(() => {
  fetchProfile()
})

// Composant NavLink réutilisable
const NavLink = defineComponent({
  props: {
    to: {
      type: String,
      required: true
    }
  },
  setup(props, { slots }) {
    const route = useRoute()
    const isActive = computed(() => route.path === props.to || route.path.startsWith(`${props.to}/`))
    
    return () => h(
      'NuxtLink',
      {
        to: props.to,
        class: [
          'flex items-center py-2 px-3 rounded-lg text-sm font-medium transition-colors',
          isActive.value 
            ? 'bg-primary-50 dark:bg-primary-900/20 text-primary-700 dark:text-primary-400' 
            : 'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700'
        ]
      },
      slots.default()
    )
  }
})

definePageMeta({
  layout: 'account'
})
</script>