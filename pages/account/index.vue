<template>
  <div class="min-h-screen bg-white">
    <!-- Main profile container -->
    <div class="relative">
      <!-- Banner area -->
      <div class="relative h-48 md:h-64 bg-gradient-to-r from-blue-500 to-indigo-600">
        <img 
          v-if="profile.banner_image_url" 
          :src="profile.banner_image_url" 
          alt="Profile banner"
          class="w-full h-full object-cover"
        />
        
        <!-- Edit banner button -->
        <label 
          v-if="isEditing" 
          class="absolute right-4 top-4 bg-white/90 hover:bg-white text-gray-800 rounded-full p-2.5 cursor-pointer transition-all shadow-md"
        >
          <Upload class="h-5 w-5" />
          <input 
            type="file" 
            class="sr-only" 
            accept="image/*"
            @change="uploadBannerImage"
          />
        </label>
      </div>
      
      <!-- Profile card - overlapping the banner -->
      <div class="max-w-4xl mx-auto px-4 sm:px-6 -mt-24 relative z-10">
        <div class="bg-white rounded-xl shadow-lg overflow-hidden">
          <div class="p-6 sm:p-8">
            <div class="flex flex-col md:flex-row md:items-start gap-6">
              <!-- Profile image -->
              <div class="relative flex-shrink-0">
                <div class="h-32 w-32 rounded-full ring-4 ring-white overflow-hidden bg-gray-100 shadow-sm">
            <img 
                v-if="profile.profile_image_url" 
                :src="profile.profile_image_url" 
                    alt="Profile photo"
              class="w-full h-full object-cover"
            />
                  <div v-else class="w-full h-full flex items-center justify-center bg-gray-100">
                    <User class="h-12 w-12 text-gray-400" />
        </div>
        
                  <!-- Edit profile image -->
              <label 
                v-if="isEditing" 
                    class="absolute inset-0 flex items-center justify-center bg-black/40 hover:bg-black/50 cursor-pointer transition-all"
              >
                <Camera class="h-8 w-8 text-white" />
                <input 
                  type="file" 
                  class="sr-only" 
                  accept="image/*"
                  @change="uploadProfileImage"
                />
              </label>
            </div>
        </div>
        
              <!-- Profile info -->
              <div class="flex-1 md:pt-4">
                <!-- Name and basic details -->
                <div v-if="!isEditing">
                  <h1 class="text-3xl font-bold text-gray-900">
              {{ profile.first_name }} {{ profile.last_name }}
            </h1>
                  <div class="mt-2 flex flex-wrap items-center gap-x-4 gap-y-2 text-gray-600">
              <div class="flex items-center">
                      <Mail class="h-4 w-4 mr-1.5 text-gray-500" />
                {{ profile.email }}
              </div>
              <div v-if="profile.phone" class="flex items-center">
                      <Phone class="h-4 w-4 mr-1.5 text-gray-500" />
                {{ profile.phone }}
              </div>
              <div v-if="profile.city" class="flex items-center">
                      <MapPin class="h-4 w-4 mr-1.5 text-gray-500" />
                {{ profile.city }}{{ profile.country ? ', ' + profile.country : '' }}
              </div>
              <div v-if="profile.birthdate" class="flex items-center">
                      <CalendarDays class="h-4 w-4 mr-1.5 text-gray-500" />
                {{ formatDate(profile.birthdate) }}
              </div>
            </div>
            
                  <p v-if="profile.bio" class="mt-4 text-gray-700 whitespace-pre-line">
              {{ profile.bio }}
            </p>
          </div>
          
                <!-- Top edit action button -->
                <div v-if="!isEditing" class="mt-6 sm:absolute sm:top-8 sm:right-8">
                  <button 
                    @click="isEditing = true"
                    class="inline-flex items-center px-4 py-2 bg-gray-100 text-gray-800 rounded-full font-medium text-sm hover:bg-gray-200 transition-colors"
                  >
                    <Edit class="h-4 w-4 mr-1.5" />
                    Edit Profile
                  </button>
                </div>
              </div>
            </div>
            
            <!-- Edit form -->
            <div v-if="isEditing" class="mt-8 space-y-6">
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <label for="first_name" class="block text-sm font-medium text-gray-700 mb-1">
                    First Name <span class="text-red-500">*</span>
                </label>
                <input
                  id="first_name"
                  v-model="editedProfile.first_name"
                  type="text"
                  required
                    class="w-full p-3 text-base border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 focus:outline-none transition-colors"
                />
              </div>
              <div>
                <label for="last_name" class="block text-sm font-medium text-gray-700 mb-1">
                    Last Name <span class="text-red-500">*</span>
                </label>
                <input
                  id="last_name"
                  v-model="editedProfile.last_name"
                  type="text"
                  required
                    class="w-full p-3 text-base border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 focus:outline-none transition-colors"
                />
              </div>
            </div>
            
              <div>
              <label for="bio" class="block text-sm font-medium text-gray-700 mb-1">
                  Bio
              </label>
              <textarea
                id="bio"
                v-model="editedProfile.bio"
                  rows="3"
                  placeholder="Tell us about yourself..."
                  class="w-full p-3 text-base border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 focus:outline-none transition-colors"
              ></textarea>
            </div>
          </div>
        </div>
        
          <!-- Profile tabs -->
          <div v-if="!isEditing" class="border-t border-gray-100">
            <div class="px-6 pt-2">
              <nav class="flex space-x-6 overflow-x-auto no-scrollbar">
                <button 
                  v-for="tab in ['About', 'Contact', 'Address']" 
                  :key="tab"
                  @click="activeTab = tab"
                  class="py-3 font-medium text-sm border-b-2 px-1 whitespace-nowrap"
                  :class="activeTab === tab ? 'border-blue-500 text-blue-600' : 'border-transparent text-gray-500 hover:text-gray-700'"
                >
                  {{ tab }}
                </button>
              </nav>
            </div>
          </div>
          
          <!-- Tab content -->
          <div v-if="!isEditing" class="p-6 sm:p-8 pt-4">
            <!-- About tab -->
            <div v-if="activeTab === 'About'" class="space-y-6">
              <p v-if="profile.bio" class="text-gray-700">
                {{ profile.bio || 'No bio information added yet.' }}
              </p>
              <div v-else class="text-center py-8">
                <p class="text-gray-500">No bio information added yet.</p>
              </div>
            </div>
            
            <!-- Contact tab -->
            <div v-if="activeTab === 'Contact'" class="space-y-6">
              <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                <div class="bg-gray-50 p-4 rounded-lg">
                  <p class="text-sm font-medium text-gray-500">Phone</p>
                  <p class="mt-1 text-gray-900">{{ profile.phone || '—' }}</p>
                </div>
                <div class="bg-gray-50 p-4 rounded-lg">
                  <p class="text-sm font-medium text-gray-500">Email</p>
                  <p class="mt-1 text-gray-900 break-words">{{ profile.email }}</p>
                </div>
                <div class="bg-gray-50 p-4 rounded-lg" v-if="profile.birthdate">
                  <p class="text-sm font-medium text-gray-500">Birthdate</p>
                  <p class="mt-1 text-gray-900">{{ formatDate(profile.birthdate) }}</p>
                </div>
            </div>
            </div>
            
            <!-- Address tab -->
            <div v-if="activeTab === 'Address'" class="space-y-6">
              <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                <div class="bg-gray-50 p-4 rounded-lg">
                  <p class="text-sm font-medium text-gray-500">Address</p>
                  <p class="mt-1 text-gray-900">{{ profile.address || '—' }}</p>
                </div>
                <div class="bg-gray-50 p-4 rounded-lg">
                  <p class="text-sm font-medium text-gray-500">City</p>
                  <p class="mt-1 text-gray-900">{{ profile.city || '—' }}</p>
                </div>
                <div class="bg-gray-50 p-4 rounded-lg">
                  <p class="text-sm font-medium text-gray-500">Country</p>
                  <p class="mt-1 text-gray-900">{{ profile.country || '—' }}</p>
                </div>
              </div>
              
              <!-- Map placeholder -->
              <div v-if="profile.city || profile.address" class="mt-4 h-48 bg-gray-100 rounded-lg flex items-center justify-center">
                <MapPin class="h-6 w-6 text-gray-400 mr-2" />
                <span class="text-gray-500">Map view</span>
              </div>
            </div>
          </div>
          
          <!-- Edit form continued -->
          <div v-if="isEditing" class="border-t border-gray-100 p-6 sm:p-8 space-y-6">
            <!-- Contact information -->
            <div>
              <h2 class="text-lg font-medium text-gray-900 mb-4">Contact Information</h2>
              <div class="space-y-4">
            <div>
              <label for="phone" class="block text-sm font-medium text-gray-700 mb-1">
                    Phone
              </label>
              <div class="relative">
                <Phone class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-5 w-5" />
                <input
                  id="phone"
                  v-model="editedProfile.phone"
                  type="tel"
                      placeholder="+1 (555) 123-4567"
                      class="w-full p-3 pl-10 text-base border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 focus:outline-none transition-colors"
                />
              </div>
            </div>
            
            <div>
                  <p class="text-sm font-medium text-gray-700 mb-1">
                    Email <span class="text-xs text-gray-500">(non-editable)</span>
              </p>
                  <div class="p-3 bg-gray-50 rounded-lg text-gray-700 border border-gray-200">
                {{ profile.email }}
              </div>
            </div>
          </div>
        </div>
        
            <!-- Address information -->
            <div>
              <h2 class="text-lg font-medium text-gray-900 mb-4">Address</h2>
              <div class="space-y-4">
                    <div>
              <label for="address" class="block text-sm font-medium text-gray-700 mb-1">
                    Street Address
              </label>
              <input
                id="address"
                v-model="editedProfile.address"
                type="text"
                    placeholder="123 Main St"
                    class="w-full p-3 text-base border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 focus:outline-none transition-colors"
              />
            </div>
            
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <label for="city" class="block text-sm font-medium text-gray-700 mb-1">
                      City
                </label>
                <input
                  id="city"
                  v-model="editedProfile.city"
                  type="text"
                      class="w-full p-3 text-base border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 focus:outline-none transition-colors"
                />
              </div>
              
              <div>
                <label for="country" class="block text-sm font-medium text-gray-700 mb-1">
                      Country
                </label>
                <input
                  id="country"
                  v-model="editedProfile.country"
                  type="text"
                      class="w-full p-3 text-base border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 focus:outline-none transition-colors"
                />
              </div>
            </div>
          </div>
        </div>
        
            <!-- Action buttons -->
            <div class="flex space-x-4 pt-4">
            <button
              @click="saveProfile"
              :disabled="isSaving"
                class="flex-1 py-3 bg-blue-600 text-white font-medium rounded-lg 
                  disabled:opacity-50 disabled:cursor-not-allowed hover:bg-blue-700 transition-colors flex items-center justify-center"
            >
              <Loader2 v-if="isSaving" class="animate-spin -ml-1 mr-2 h-5 w-5" />
                {{ isSaving ? 'Saving...' : 'Save Changes' }}
            </button>
            
            <button
              @click="cancelEdit"
                class="py-3 px-6 border border-gray-300 text-gray-700 font-medium rounded-lg 
                hover:bg-gray-50 transition-colors"
            >
                Cancel
            </button>
            </div>
          </div>
        </div>
        
        <!-- Logout button -->
        <div v-if="!isEditing" class="mt-6 mb-20 md:mb-8">
        <button 
          @click="logout" 
            class="text-red-600 font-medium flex items-center hover:text-red-700 transition-colors"
          >
            <LogOut class="h-5 w-5 mr-2" />
            Sign Out
          </button>
        </div>
      </div>
    </div>
    
    <!-- Navigation menu (bottom bar on mobile, side bar on desktop) -->
    <div class="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 z-40 md:hidden">
      <div class="flex justify-around items-center">
        <NuxtLink 
          v-for="item in navItems" 
          :key="item.path"
          :to="item.path"
          class="flex flex-col items-center py-3"
          :class="$route.path === item.path ? 'text-blue-600' : 'text-gray-500'"
        >
          <component :is="item.icon" class="h-6 w-6 mb-1" />
          <span class="text-xs font-medium">{{ item.name }}</span>
        </NuxtLink>
      </div>
    </div>
    
    <div class="hidden md:block fixed top-0 left-0 bottom-0 w-64 bg-white border-r border-gray-200">
      <div class="flex flex-col h-full">
        <div class="p-6 mb-4">
          <h1 class="text-xl font-bold">My Account</h1>
        </div>
        
        <nav class="flex-1 px-4">
          <NuxtLink 
            v-for="item in navItems" 
            :key="item.path"
            :to="item.path"
            class="flex items-center py-3 px-4 rounded-lg mb-1"
            :class="$route.path === item.path ? 'bg-blue-50 text-blue-600' : 'text-gray-700 hover:bg-gray-50'"
          >
            <component :is="item.icon" class="h-5 w-5 mr-3" />
            <span class="font-medium">{{ item.name }}</span>
          </NuxtLink>
        </nav>
        
        <div class="p-4 mt-auto">
          <button 
            @click="logout" 
            class="flex items-center text-gray-700 p-2 hover:text-red-600 transition-colors w-full"
          >
            <LogOut class="h-5 w-5 mr-3" />
            <span class="font-medium">Sign Out</span>
        </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, reactive, onMounted } from 'vue'
import { 
  User, Edit, Loader2, Mail, Phone, MapPin, 
  Camera, Upload, LogOut, Home, Settings, FileText, 
  ShoppingBag, CalendarDays, CreditCard
} from 'lucide-vue-next'

const router = useRouter()
const client = useSupabaseClient()

// States
const loading = ref(true)
const isEditing = ref(false)
const isSaving = ref(false)
const profile = ref({})
const editedProfile = reactive({})
const activeTab = ref('About')

// Navigation menu
const navItems = [
  { name: 'Profile', path: '/account', icon: User },
  { name: 'Requests', path: '/account/my-demands', icon: FileText },
  { name: 'Services', path: '/account/my-services', icon: ShoppingBag },
  { name: 'Payments', path: '/account/payments', icon: CreditCard },
  { name: 'Settings', path: '/account/settings', icon: Settings },
]

// Format date
const formatDate = (dateString) => {
  if (!dateString) return ''
  const date = new Date(dateString)
  return date.toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

// Fetch profile data
const fetchProfile = async () => {
  try {
    loading.value = true
    
    // Get authenticated user
    const { data: { user }, error: authError } = await client.auth.getUser()
    if (authError) throw authError
    if (!user) {
      // Redirect to login page if not authenticated
      router.push('/auth/login')
      return
    }
    
    // Get profile data
    const { data, error } = await client
      .from('profiles')
      .select('*')
      .eq('id', user.id)
      .single()
    
    if (error) throw error
    
    profile.value = data || {}
    
    // Initialize edit form
    Object.keys(profile.value).forEach(key => {
      editedProfile[key] = profile.value[key]
    })
  } catch (error) {
    console.error('Error fetching profile:', error)
  } finally {
    loading.value = false
  }
}

// Save profile changes
const saveProfile = async () => {
  try {
    // Validate required fields
    if (!editedProfile.first_name?.trim() || !editedProfile.last_name?.trim()) {
      alert('First name and last name are required')
      return
    }
    
    isSaving.value = true
    
    const { data: { user } } = await client.auth.getUser()
    if (!user) throw new Error('Not authenticated')
    
    const { error } = await client
      .from('profiles')
      .update({
        first_name: editedProfile.first_name,
        last_name: editedProfile.last_name,
        phone: editedProfile.phone,
        address: editedProfile.address,
        city: editedProfile.city,
        country: editedProfile.country,
        birthdate: editedProfile.birthdate,
        bio: editedProfile.bio,
        updated_at: new Date().toISOString()
      })
      .eq('id', user.id)
    
    if (error) throw error
    
    // Update local state
    Object.keys(editedProfile).forEach(key => {
      profile.value[key] = editedProfile[key]
    })
    
    // Exit edit mode
    isEditing.value = false
  } catch (error) {
    console.error('Error updating profile:', error)
    alert('An error occurred while updating your profile')
  } finally {
    isSaving.value = false
  }
}

// Cancel edits
const cancelEdit = () => {
  // Reset form values
  Object.keys(profile.value).forEach(key => {
    editedProfile[key] = profile.value[key]
  })
  isEditing.value = false
}

// Upload profile image
const uploadProfileImage = async (event) => {
  try {
    const file = event.target.files[0]
    if (!file) return
    
    const { data: { user } } = await client.auth.getUser()
    if (!user) throw new Error('Not authenticated')
    
    // Generate unique filename
    const fileExt = file.name.split('.').pop()
    const fileName = `profile-${user.id}-${Date.now()}.${fileExt}`
    const filePath = `profile-images/${fileName}`
    
    // Upload file
    const { error: uploadError } = await client.storage
      .from('avatars')
      .upload(filePath, file)
    
    if (uploadError) throw uploadError
    
    // Get public URL
    const { data } = client.storage
      .from('avatars')
      .getPublicUrl(filePath)
    
    const publicUrl = data.publicUrl
    
    // Update profile with new URL
    const { error: updateError } = await client
      .from('profiles')
      .update({ profile_image_url: publicUrl })
      .eq('id', user.id)
    
    if (updateError) throw updateError
    
    // Update local state
    profile.value.profile_image_url = publicUrl
    editedProfile.profile_image_url = publicUrl
  } catch (error) {
    console.error('Error uploading image:', error)
    alert('An error occurred while uploading the image')
  }
}

// Upload banner image
const uploadBannerImage = async (event) => {
  try {
    const file = event.target.files[0]
    if (!file) return
    
    const { data: { user } } = await client.auth.getUser()
    if (!user) throw new Error('Not authenticated')
    
    // Generate unique filename
    const fileExt = file.name.split('.').pop()
    const fileName = `banner-${user.id}-${Date.now()}.${fileExt}`
    const filePath = `banner-images/${fileName}`
    
    // Upload file
    const { error: uploadError } = await client.storage
      .from('avatars')
      .upload(filePath, file)
    
    if (uploadError) throw uploadError
    
    // Get public URL
    const { data } = client.storage
      .from('avatars')
      .getPublicUrl(filePath)
    
    const publicUrl = data.publicUrl
    
    // Update profile with new URL
    const { error: updateError } = await client
      .from('profiles')
      .update({ banner_image_url: publicUrl })
      .eq('id', user.id)
    
    if (updateError) throw updateError
    
    // Update local state
    profile.value.banner_image_url = publicUrl
    editedProfile.banner_image_url = publicUrl
  } catch (error) {
    console.error('Error uploading banner:', error)
    alert('An error occurred while uploading the banner')
  }
}

// Sign out
const logout = async () => {
  try {
    const { error } = await client.auth.signOut()
    if (error) throw error
    
    // Redirect to home page
    router.push('/')
  } catch (error) {
    console.error('Error signing out:', error)
  }
}

// Load data when component mounts
onMounted(fetchProfile)

definePageMeta({
  layout: 'default',
  auth: true
})
</script> 

<style scoped>
/* Hide scrollbar while still allowing scrolling */
.no-scrollbar::-webkit-scrollbar {
  display: none;
}
.no-scrollbar {
  -ms-overflow-style: none;
  scrollbar-width: none;
}
</style> 