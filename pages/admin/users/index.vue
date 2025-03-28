<template>
  <div class="space-y-6 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- Header -->
    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
      <div>
        <h1 class="text-3xl font-bold text-gray-900 dark:text-white tracking-tight">Utilisateurs</h1>
        <p class="text-gray-600 dark:text-gray-400 mt-1">Gérez les utilisateurs de la plateforme</p>
      </div>
      
      <div class="flex items-center gap-3">
        <UButton 
          icon="i-heroicons-arrow-down-tray" 
          color="gray" 
          variant="ghost" 
          @click="exportData"
        >
          Exporter
        </UButton>
        <UButton 
          icon="i-heroicons-plus" 
          @click="openAddUserModal"
        >
          Ajouter
        </UButton>
      </div>
    </div>

    <!-- Table -->
    <UCard>
      <UTable
        :rows="users"
        :columns="columns"
        :loading="isLoading"
        :search-value="search"
        @update:search-value="search = $event"
      >
        <!-- User cell -->
        <template #user-data="{ row }">
          <div class="flex items-center gap-3">
            <div class="h-10 w-10 rounded-full bg-primary-100 dark:bg-primary-900/30 flex items-center justify-center text-primary-700 dark:text-primary-400 font-medium">
              {{ getInitials(row.first_name + ' ' + row.last_name) }}
            </div>
            <div>
              <p class="text-sm font-medium text-gray-900 dark:text-white">
                {{ row.first_name }} {{ row.last_name }}
              </p>
              <p class="text-xs text-gray-500 dark:text-gray-400">
                {{ row.email }}
              </p>
            </div>
          </div>
        </template>

        <!-- Role cell -->
        <template #role-data="{ row }">
          <UBadge
            :color="getRoleBadgeColor(row.role)"
            variant="subtle"
            size="sm"
          >
            {{ formatRole(row.role) }}
          </UBadge>
        </template>

        <!-- Status cell -->
        <template #status-data="{ row }">
          <UBadge
            :color="row.is_active ? 'green' : 'red'"
            variant="subtle"
            size="sm"
          >
            <div class="flex items-center gap-1">
              <div 
                class="w-1.5 h-1.5 rounded-full"
                :class="row.is_active ? 'bg-green-500' : 'bg-red-500'"
              />
              {{ row.is_active ? 'Actif' : 'Bloqué' }}
            </div>
          </UBadge>
        </template>

        <!-- Date cell -->
        <template #created_at-data="{ row }">
          {{ formatDate(row.created_at) }}
        </template>

        <!-- Actions cell -->
        <template #actions-data="{ row }">
          <UDropdown
            :items="[
              [
                {
                  label: 'Modifier',
                  icon: 'i-heroicons-pencil-square',
                  click: () => editUser(row)
                },
                {
                  label: 'Voir le profil',
                  icon: 'i-heroicons-eye',
                  click: () => viewUser(row)
                }
              ],
              [
                {
                  label: row.is_active ? 'Bloquer' : 'Débloquer',
                  icon: row.is_active ? 'i-heroicons-lock-closed' : 'i-heroicons-lock-open',
                  click: () => toggleUserStatus(row)
                }
              ]
            ]"
          >
            <UButton
              color="gray"
              variant="ghost"
              icon="i-heroicons-ellipsis-horizontal"
            />
          </UDropdown>
        </template>
      </UTable>
    </UCard>
  </div>
  
  <!-- Modal d'ajout/modification d'utilisateur -->
  <TransitionRoot appear :show="showUserModal" as="template">
    <Dialog as="div" @close="showUserModal = false" class="relative z-50">
      <TransitionChild
        enter="duration-300 ease-out"
        enter-from="opacity-0"
        enter-to="opacity-100"
        leave="duration-200 ease-in"
        leave-from="opacity-100"
        leave-to="opacity-0"
      >
        <div class="fixed inset-0 bg-black/30" />
      </TransitionChild>

      <div class="fixed inset-0 overflow-y-auto">
        <div class="flex min-h-full items-center justify-center p-4">
          <TransitionChild
            enter="duration-300 ease-out"
            enter-from="opacity-0 scale-95"
            enter-to="opacity-100 scale-100"
            leave="duration-200 ease-in"
            leave-from="opacity-100 scale-100"
            leave-to="opacity-0 scale-95"
          >
            <DialogPanel class="w-full max-w-2xl transform overflow-hidden rounded-3xl bg-white p-8 border border-gray-100 shadow-xl transition-all">
              <DialogTitle as="h3" class="text-xl font-semibold text-gray-900">
                {{ editMode ? 'Modifier l\'utilisateur' : 'Ajouter un utilisateur' }}
              </DialogTitle>

              <form @submit.prevent="saveUser" class="mt-8">
                <div class="space-y-8">
                  <!-- Nom et Prénom -->
                  <div class="grid grid-cols-2 gap-4">
                    <div>
                      <label class="block text-base font-semibold text-gray-900 mb-2">Prénom</label>
                      <input
                        v-model="userForm.first_name"
                        type="text"
                        required
                        class="block w-full px-4 py-3.5 text-gray-900 border border-gray-200 rounded-2xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors text-lg"
                      />
                    </div>
                    <div>
                      <label class="block text-base font-semibold text-gray-900 mb-2">Nom</label>
                      <input
                        v-model="userForm.last_name"
                        type="text"
                        required
                        class="block w-full px-4 py-3.5 text-gray-900 border border-gray-200 rounded-2xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors text-lg"
                      />
                    </div>
                  </div>

                  <!-- Email -->
                  <div>
                    <label class="block text-base font-semibold text-gray-900 mb-2">Email</label>
                    <input
                      v-model="userForm.email"
                      type="email"
                      required
                      :disabled="editMode"
                      class="block w-full px-4 py-3.5 text-gray-900 border border-gray-200 rounded-2xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors text-lg disabled:opacity-60 disabled:cursor-not-allowed"
                    />
                  </div>

                  <!-- Mot de passe (uniquement pour la création) -->
                  <div v-if="!editMode">
                    <label class="block text-base font-semibold text-gray-900 mb-2">Mot de passe</label>
                    <input
                      v-model="userForm.password"
                      type="password"
                      required
                      minlength="8"
                      class="block w-full px-4 py-3.5 text-gray-900 border border-gray-200 rounded-2xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors text-lg"
                    />
                  </div>

                  <!-- Rôle -->
                  <div>
                    <label class="block text-base font-semibold text-gray-900 mb-2">Rôle</label>
                    <select
                      v-model="userForm.role"
                      class="block w-full px-4 py-3.5 text-gray-900 border border-gray-200 rounded-2xl focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors text-lg"
                    >
                      <option value="client">Client</option>
                      <option value="expert">Expert</option>
                      <option value="admin">Administrateur</option>
                    </select>
                  </div>

                  <!-- Statut -->
                  <div>
                    <label class="block text-base font-semibold text-gray-900 mb-2">Statut</label>
                    <div class="space-y-4">
                      <div class="flex items-center bg-gray-50 p-4 rounded-2xl">
                        <Switch
                          v-model="userForm.is_active"
                          :class="[userForm.is_active ? 'bg-primary-600' : 'bg-gray-200']"
                          class="relative inline-flex h-7 w-14 flex-shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out"
                        >
                          <span
                            :class="[userForm.is_active ? 'translate-x-7' : 'translate-x-0']"
                            class="pointer-events-none relative inline-block h-6 w-6 transform rounded-full bg-white shadow ring-0 transition duration-200 ease-in-out"
                          />
                        </Switch>
                        <span class="ml-3 text-base text-gray-700">
                          {{ userForm.is_active ? 'Compte actif' : 'Compte inactif' }}
                        </span>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="mt-8 flex justify-end space-x-4">
                  <button
                    type="button"
                    class="px-6 py-4 text-base font-semibold text-gray-700 hover:bg-gray-50 rounded-2xl focus:outline-none focus:ring-2 focus:ring-gray-200 transition-all"
                    @click="showUserModal = false"
                  >
                    Annuler
                  </button>
                  <button
                    type="submit"
                    class="px-6 py-4 bg-primary-600 text-white rounded-2xl font-semibold hover:bg-primary-700 focus:ring-4 focus:ring-primary-500/50 transition-all disabled:opacity-50 disabled:hover:bg-primary-600 flex items-center justify-center gap-2 text-base"
                    :disabled="isSaving"
                  >
                    <Loader2 v-if="isSaving" class="w-5 h-5 animate-spin" />
                    <UserPlus v-else class="w-5 h-5" />
                    {{ isSaving ? 'Enregistrement en cours...' : (editMode ? 'Enregistrer les modifications' : 'Ajouter l\'utilisateur') }}
                  </button>
                </div>
              </form>
            </DialogPanel>
          </TransitionChild>
        </div>
      </div>
    </Dialog>
  </TransitionRoot>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import { useRouter } from 'vue-router';
import { debounce } from 'lodash';
import { 
  Plus, Search, Edit, Trash2, RefreshCw, X, CheckCircle, AlertTriangle, 
  Info, Users, ChevronLeft, ChevronRight, Eye, EyeOff, User, Download,
  UserPlus, UserCheck, UserX, Shield, Mail, Ban, Loader2
} from 'lucide-vue-next';
import { Dialog, DialogPanel, DialogTitle, TransitionRoot, TransitionChild, Switch } from '@headlessui/vue'
import { useSupabaseClient } from '#imports';
import { format } from 'date-fns';
import { fr } from 'date-fns/locale';
const supabase = useSupabaseClient();
const router = useRouter();

// État des données
const users = ref([]);
const isLoading = ref(true);
const search = ref('');
const roleFilter = ref('all');
const statusFilter = ref('all');
const currentPage = ref(1);
const itemsPerPage = ref(10);
const notification = ref({
  show: false,
  type: 'info',
  title: '',
  message: ''
});

// Statistiques
const stats = ref([
  {
    label: 'Utilisateurs',
    value: 0,
    icon: Users,
    colorClass: 'bg-blue-500'
  },
  {
    label: 'Clients',
    value: 0,
    icon: User,
    colorClass: 'bg-green-500'
  },
  {
    label: 'Experts',
    value: 0,
    icon: UserCheck,
    colorClass: 'bg-purple-500'
  },
  {
    label: 'Administrateurs',
    value: 0,
    icon: Shield,
    colorClass: 'bg-amber-500'
  }
]);

// Table columns configuration
const columns = [
  {
    key: 'user',
    label: 'Utilisateur',
    sortable: true
  },
  {
    key: 'email',
    label: 'Email',
    sortable: true
  },
  {
    key: 'role',
    label: 'Rôle',
    sortable: true
  },
  {
    key: 'status',
    label: 'Statut',
    sortable: true
  },
  {
    key: 'created_at',
    label: 'Date d\'inscription',
    sortable: true
  },
  {
    key: 'actions',
    label: '',
    sortable: false
  }
];

// Computed properties
const filteredUsers = computed(() => {
  if (!users.value) return [];
  
  let result = [...users.value];
  
  // Filtre de recherche
  if (search.value) {
    const searchLower = search.value.toLowerCase();
    result = result.filter(user => 
      user.first_name?.toLowerCase().includes(searchLower) || 
      user.last_name?.toLowerCase().includes(searchLower) ||
      user.email?.toLowerCase().includes(searchLower) ||
      user.phone?.toLowerCase().includes(searchLower)
    );
  }
  
  // Filtre de rôle
  if (roleFilter.value !== 'all') {
    result = result.filter(user => user.role === roleFilter.value);
  }
  
  // Filtre de statut
  if (statusFilter.value !== 'all') {
    const isActive = statusFilter.value === 'active';
    result = result.filter(user => user.is_active === isActive);
  }
  
  return result;
});

// Pagination
const totalPages = computed(() => {
  return Math.ceil(filteredUsers.value.length / itemsPerPage.value);
});

const paginatedUsers = computed(() => {
  const startIndex = (currentPage.value - 1) * itemsPerPage.value;
  const endIndex = startIndex + itemsPerPage.value;
  return filteredUsers.value.slice(startIndex, endIndex);
});

// Charger les données
const loadData = async () => {
  isLoading.value = true;
  
  try {
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .order('created_at', { ascending: false });
    
    if (error) throw error;
    
    users.value = data || [];
    
    // Mettre à jour les statistiques
    updateStats();
    
  } catch (error) {
    console.error('Erreur lors du chargement des données:', error);
    showNotification('error', 'Erreur', 'Impossible de charger les utilisateurs');
  } finally {
    isLoading.value = false;
  }
};

// Mettre à jour les statistiques
const updateStats = () => {
  if (!users.value) return;
  
  stats.value[0].value = users.value.length;
  stats.value[1].value = users.value.filter(u => u.role === 'client').length;
  stats.value[2].value = users.value.filter(u => u.role === 'expert').length;
  stats.value[3].value = users.value.filter(u => u.role === 'admin').length;
};

// Réinitialiser les filtres
const resetFilters = () => {
  search.value = '';
  roleFilter.value = 'all';
  statusFilter.value = 'all';
  currentPage.value = 1;
};

// Voir les détails d'un utilisateur
const viewUser = (user) => {
  router.push(`/admin/users/${user.id}`);
};

// Formater le rôle
const formatRole = (role) => {
  const roleMap = {
    client: "Client",
    expert: "Expert",
    admin: "Administrateur"
  };
  return roleMap[role] || "Non défini";
};

// Formater la date
const formatDate = (dateString) => {
  if (!dateString) return '-';
  const date = new Date(dateString);
  return format(date, 'dd MMM yyyy', { locale: fr });
};

// Changer le statut d'un utilisateur
const toggleUserStatus = async (user) => {
  const newStatus = !user.is_active;
  const action = newStatus ? 'activer' : 'désactiver';
  
  if (!confirm(`Êtes-vous sûr de vouloir ${action} cet utilisateur ?`)) {
    return;
  }
  
  try {
    const { error } = await supabase
      .from('profiles')
      .update({ 
        is_active: newStatus,
        updated_at: new Date().toISOString()
      })
      .eq('id', user.id);
    
    if (error) throw error;
    
    // Mettre à jour l'utilisateur localement
    user.is_active = newStatus;
    
    showNotification(
      'success', 
      'Statut modifié', 
      `L'utilisateur a été ${newStatus ? 'activé' : 'désactivé'} avec succès.`
    );
    
  } catch (error) {
    console.error('Erreur lors de la modification du statut:', error);
    showNotification(
      'error', 
      'Erreur', 
      `Impossible de ${action} l'utilisateur.`
    );
  }
};

// Exporter les données
const exportData = async () => {
  try {
    if (!users.value || users.value.length === 0) {
      showNotification('info', 'Information', 'Aucune donnée à exporter');
      return;
    }
    
    // Transformer les données pour l'export
    const exportData = users.value.map(user => ({
      ID: user.id,
      Prénom: user.first_name,
      Nom: user.last_name,
      Email: user.email,
      Téléphone: user.phone || '-',
      Rôle: formatRole(user.role),
      Statut: user.is_active ? 'Actif' : 'Bloqué',
      Certifié: user.role === 'expert' ? (user.is_verified ? 'Oui' : 'Non') : '-',
      'Date d\'inscription': formatDate(user.created_at)
    }));
    
    // Convertir en CSV
    const headers = Object.keys(exportData[0]).join(',');
    const rows = exportData.map(row => Object.values(row).map(value => `"${value}"`).join(','));
    const csv = [headers, ...rows].join('\n');
    
    // Créer un blob et télécharger
    const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.setAttribute('href', url);
    link.setAttribute('download', `utilisateurs_${new Date().toISOString().split('T')[0]}.csv`);
    link.style.visibility = 'hidden';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    
    showNotification('success', 'Export réussi', 'Les données ont été exportées avec succès');
    
  } catch (error) {
    console.error('Erreur lors de l\'export:', error);
    showNotification('error', 'Erreur', 'Impossible d\'exporter les données');
  }
};

// Afficher une notification
const showNotification = (type, title, message) => {
  if (!notification.value) {
    notification.value = {
      show: false,
      type: 'info',
      title: '',
      message: ''
    };
  }
  
  notification.value.show = true;
  notification.value.type = type;
  notification.value.title = title;
  notification.value.message = message;
  
  // Masquer automatiquement après 5 secondes
  setTimeout(() => {
    if (notification.value) {
      notification.value.show = false;
    }
  }, 5000);
};

// Rafraîchir les données
const refreshData = () => {
  loadData();
};

// Charger les données au montage du composant
onMounted(() => {
  loadData();
});

// Réinitialiser la pagination quand les filtres changent
watch([search, roleFilter, statusFilter], () => {
  currentPage.value = 1;
});

// Obtenir les initiales
const getInitials = (name) => {
  if (!name) return '';
  return name
    .split(' ')
    .map(word => word.charAt(0))
    .join('')
    .toUpperCase();
};

// Obtenir la classe pour le rôle
const getRoleBadgeColor = (role) => {
  const colors = {
    client: 'blue',
    expert: 'amber',
    admin: 'green'
  }
  return colors[role] || 'gray'
}

// Modal state and form
const showUserModal = ref(false);
const editMode = ref(false);
const isSaving = ref(false);
const userForm = ref({
  first_name: '',
  last_name: '',
  email: '',
  phone: '',
  password: '',
  role: 'client',
  is_active: true,
  is_verified: false,
  location: ''
});

// Ouvrir la modal d'ajout d'utilisateur
const openAddUserModal = () => {
  editMode.value = false;
  userForm.value = {
    first_name: '',
    last_name: '',
    email: '',
    phone: '',
    password: '',
    role: 'client',
    is_active: true,
    is_verified: false,
    location: ''
  };
  showUserModal.value = true;
};

// Modifier un utilisateur
const editUser = (user) => {
  editMode.value = true;
  userForm.value = {
    id: user.id,
    first_name: user.first_name || '',
    last_name: user.last_name || '',
    email: user.email || '',
    phone: user.phone || '',
    role: user.role || 'client',
    is_active: user.is_active !== false, // Default to true if undefined
    is_verified: user.is_verified || false,
    location: user.location || ''
  };
  showUserModal.value = true;
};

// Enregistrer un utilisateur
const saveUser = async () => {
  // Validation basique
  if (!userForm.value.email) {
    showNotification('error', 'Erreur', 'L\'email est requis');
    return;
  }
  
  if (!editMode.value && !userForm.value.password) {
    showNotification('error', 'Erreur', 'Le mot de passe est requis pour la création d\'un utilisateur');
    return;
  }
  
  isSaving.value = true;
  
  try {
    if (editMode.value) {
      // Mettre à jour un utilisateur existant
      const { error } = await supabase
        .from('profiles')
        .update({
          first_name: userForm.value.first_name,
          last_name: userForm.value.last_name,
          phone: userForm.value.phone,
          role: userForm.value.role,
          is_active: userForm.value.is_active,
          is_verified: userForm.value.role === 'expert' ? userForm.value.is_verified : false,
          location: userForm.value.location,
          updated_at: new Date().toISOString()
        })
        .eq('id', userForm.value.id);
      
      if (error) throw error;
      
      showNotification('success', 'Utilisateur mis à jour', 'L\'utilisateur a été mis à jour avec succès');
    } else {
      // Créer un nouvel utilisateur avec auth
      const { data: authData, error: authError } = await supabase.auth.signUp({
        email: userForm.value.email,
        password: userForm.value.password,
        options: {
          data: {
            first_name: userForm.value.first_name,
            last_name: userForm.value.last_name,
            role: userForm.value.role
          }
        }
      });
      
      if (authError) throw authError;
      
      if (!authData.user) {
        throw new Error('Erreur lors de la création du compte utilisateur');
      }
      
      // Mettre à jour le profil avec des informations supplémentaires
      const { error: profileError } = await supabase
        .from('profiles')
        .update({
          phone: userForm.value.phone,
          is_active: userForm.value.is_active,
          is_verified: userForm.value.role === 'expert' ? userForm.value.is_verified : false,
          location: userForm.value.location
        })
        .eq('id', authData.user.id);
      
      if (profileError) throw profileError;
      
      showNotification('success', 'Utilisateur créé', 'L\'utilisateur a été créé avec succès');
    }
    
    // Fermer la modal et rafraîchir les données
    showUserModal.value = false;
    await loadData();
    
  } catch (error) {
    console.error('Erreur lors de l\'enregistrement de l\'utilisateur:', error);
    showNotification('error', 'Erreur', error.message || 'Impossible d\'enregistrer l\'utilisateur');
  } finally {
    isSaving.value = false;
  }
};

definePageMeta({
  layout: 'admin'
});
</script> 
