<template>
    <div class="min-h-screen bg-white">
      <!-- Hero Section -->
      <section class="relative overflow-hidden py-32 lg:py-48">
        <!-- Subtle gradient background -->
        <div class="absolute inset-0 bg-gradient-to-br from-gray-50 to-white -z-10"></div>
        
        <div class="max-w-7xl mx-auto px-8 sm:px-12 lg:px-16">
          <div class="lg:grid lg:grid-cols-12 lg:gap-16 items-center">
            <!-- Left Column: Text & Form -->
            <div class="lg:col-span-6 max-w-xl mx-auto lg:max-w-none lg:mx-0">
              <div class="relative">
                <!-- Decorative element -->
                <div class="absolute -left-8 -top-8 w-24 h-24 bg-primary-500/10 rounded-full blur-2xl"></div>
                
                <h1 class="text-6xl sm:text-7xl font-bold text-gray-900 tracking-tight leading-none mb-8">
                  Trouvez
                  <br />
                  <span class="relative">
                    l'expert
                    <svg class="absolute -bottom-4 left-0 w-full" height="12" viewBox="0 0 400 12" fill="none">
                      <path d="M2 10C150.667 4.33333 374.4 -3.2 398 10" stroke="#25D366" stroke-width="4"/>
                    </svg>
                  </span>
                  <br />
                  qu'il vous faut
                </h1>

                <p class="text-2xl text-gray-500 mb-12 leading-relaxed max-w-lg">
                  Des professionnels qualifiés à votre service, avec une expérience 
                  <span class="text-primary-500 font-medium">simple et efficace</span>.
                </p>

                <!-- Call-to-action Buttons -->
                <div class="flex flex-col sm:flex-row gap-4 mb-12">
                  <NuxtLink
                    to="/demande"
                    class="inline-flex items-center justify-center px-8 py-4 text-lg font-medium text-white bg-primary-500 rounded-2xl hover:bg-primary-600 transition-colors duration-200"
                  >
                    Demander un service
                    <ArrowRightIcon class="w-5 h-5 ml-2" />
                  </NuxtLink>
                  <NuxtLink
                    to="/auth/register-expert"
                    class="inline-flex items-center justify-center px-8 py-4 text-lg font-medium text-primary-600 bg-primary-50 rounded-2xl hover:bg-primary-100 transition-colors duration-200"
                  >
                    Devenir expert
                    <UserPlusIcon class="w-5 h-5 ml-2" />
                  </NuxtLink>
                </div>

                <!-- Trust badges -->
                <div class="flex items-center gap-6 text-gray-400">
                  <div class="flex items-center gap-2">
                    <ShieldCheckIcon class="w-5 h-5" />
                    <span class="text-sm">Vérifié</span>
                  </div>
                  <div class="flex items-center gap-2">
                    <StarIcon class="w-5 h-5" />
                    <span class="text-sm">4.9/5</span>
                  </div>
                  <div class="flex items-center gap-2">
                    <UserGroupIcon class="w-5 h-5" />
                    <span class="text-sm">15K+ clients</span>
                  </div>
                </div>
              </div>

              <!-- Search Form -->
              <div class="bg-white rounded-3xl -shadow-[0_20px_50px_-20px_rgba(0,0,0,0.15)] p-3 mb-12">
                <div class="flex flex-col md:flex-row gap-3">
                  <div class="flex-1">
                    <select class="w-full h-16 px-6 text-lg bg-gray-50 rounded-2xl border-0 focus:ring-2 focus:ring-primary-500">
                      <option value="">✨ Type de service</option>
                      <option value="menage">🧹 Ménage</option>
                      <option value="jardinage">🌱 Jardinage</option>
                      <option value="bricolage">🔨 Bricolage</option>
                      <option value="garde">👶 Garde d'enfants</option>
                    </select>
                  </div>
                  <button class="h-16 px-8 bg-primary-500 hover:bg-primary-600 text-white text-lg font-medium rounded-2xl transition-all duration-200 flex items-center gap-2">
                    Rechercher
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                    </svg>
                  </button>
                </div>
              </div>

              <!-- Trust Badges -->
              <div class="flex items-center gap-8">
                <div class="flex items-center gap-3">
                  <div class="w-12 h-12 rounded-2xl bg-primary-500/10 flex items-center justify-center">
                    <svg class="w-6 h-6 text-primary-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                    </svg>
                  </div>
                  <span class="text-gray-600">Experts vérifiés</span>
                </div>
                <div class="flex items-center gap-3">
                  <div class="w-12 h-12 rounded-2xl bg-primary-500/10 flex items-center justify-center">
                    <svg class="w-6 h-6 text-primary-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                    </svg>
                  </div>
                  <span class="text-gray-600">Paiement sécurisé</span>
                </div>
              </div>
            </div>
  
            <!-- Right Column: Image -->
            <div class="mt-16 lg:mt-0 lg:col-span-6 relative">
              <div class="relative">
                <!-- Decorative elements -->
                <div class="absolute -right-12 -top-12 w-32 h-32 bg-primary-500/10 rounded-full blur-3xl"></div>
                <div class="absolute -left-8 -bottom-8 w-24 h-24 bg-yellow-500/10 rounded-full blur-2xl"></div>
                
                <!-- Main image -->
                <div class="relative rounded-3xl overflow-hidden aspect-[4/3] -shadow-2xl">
                  <img 
                    src="https://images.pexels.com/photos/7232253/pexels-photo-7232253.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2" 
                    alt="Services à domicile" 
                    class="w-full h-full object-cover"
                  />
                  <!-- Overlay gradient -->
                  <div class="absolute inset-0 bg-gradient-to-t from-black/20 to-transparent"></div>
                  
                  <!-- Floating stats card -->
                  <div class="absolute bottom-6 left-6 right-6">
                    <div class="bg-white/95 backdrop-blur-sm rounded-2xl p-6 -shadow-lg">
                      <div class="flex items-center justify-between">
                        <div>
                          <p class="text-sm text-gray-500 mb-1">Satisfaction client</p>
                          <div class="flex items-center gap-2">
                            <div class="text-yellow-400 flex">★★★★★</div>
                            <span class="text-2xl font-bold text-gray-900">4.9/5</span>
                          </div>
                        </div>
                        <div class="h-12 w-px bg-gray-200"></div>
                        <div>
                          <p class="text-sm text-gray-500 mb-1">Experts disponibles</p>
                          <p class="text-2xl font-bold text-gray-900">200+</p>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
  
      <!-- How It Works Section -->
      <section class="py-24 px-4">
        <div class="max-w-6xl mx-auto">
          <div class="text-center mb-16">
            <h2 class="text-3xl font-bold text-gray-900">
              Comment ça marche ?
            </h2>
            <p class="mt-4 text-lg text-gray-600">
              Trouvez votre expert en 3 étapes simples
            </p>
          </div>

          <div class="grid md:grid-cols-3 gap-12">
            <!-- Step 1 -->
            <div class="relative">
              <div class="flex flex-col items-center text-center">
                <div class="w-16 h-16 bg-primary-50 rounded-2xl flex items-center justify-center mb-6">
                  <svg class="w-8 h-8 text-primary-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" 
                      d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                  </svg>
                </div>
                <h3 class="text-xl font-semibold text-gray-900 mb-3">
                  1. Décrivez votre besoin
                </h3>
                <p class="text-gray-600">
                  Remplissez un formulaire simple avec vos besoins et disponibilités
                </p>
              </div>
              <!-- Connection line -->
              <div class="hidden md:block absolute top-8 left-full w-full h-0.5 bg-gray-100">
                <div class="absolute -right-2 -top-1.5 w-3 h-3 rounded-full bg-gray-100"></div>
              </div>
            </div>

            <!-- Step 2 -->
            <div class="relative">
              <div class="flex flex-col items-center text-center">
                <div class="w-16 h-16 bg-primary-50 rounded-2xl flex items-center justify-center mb-6">
                  <svg class="w-8 h-8 text-primary-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" 
                      d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
                  </svg>
                </div>
                <h3 class="text-xl font-semibold text-gray-900 mb-3">
                  2. Recevez des devis
                </h3>
                <p class="text-gray-600">
                  Les professionnels vous envoient leurs propositions rapidement
                </p>
              </div>
              <!-- Connection line -->
              <div class="hidden md:block absolute top-8 left-full w-full h-0.5 bg-gray-100">
                <div class="absolute -right-2 -top-1.5 w-3 h-3 rounded-full bg-gray-100"></div>
              </div>
            </div>

            <!-- Step 3 -->
            <div class="relative">
              <div class="flex flex-col items-center text-center">
                <div class="w-16 h-16 bg-primary-50 rounded-2xl flex items-center justify-center mb-6">
                  <svg class="w-8 h-8 text-primary-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" 
                      d="M5 13l4 4L19 7"/>
                  </svg>
                </div>
                <h3 class="text-xl font-semibold text-gray-900 mb-3">
                  3. Choisissez votre expert
                </h3>
                <p class="text-gray-600">
                  Sélectionnez le professionnel qui vous correspond le mieux
                </p>
              </div>
            </div>
          </div>

          <!-- CTA -->
          <div class="text-center mt-16">
            <NuxtLink 
              to="/demande" 
              class="inline-flex items-center px-8 py-4 bg-primary-500 text-white font-medium rounded-xl hover:bg-primary-600 transition-colors"
            >
              Démarrer maintenant
              <svg class="w-5 h-5 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
              </svg>
            </NuxtLink>
          </div>
        </div>
      </section>
  
      <!-- Features -->
      <section class="py-40 px-8 bg-gray-50">
        <div class="max-w-7xl mx-auto">
          <h2 class="text-4xl font-medium text-black mb-32 text-center">Une expérience sans égal</h2>
          <div class="grid md:grid-cols-3 gap-20">
            <div v-for="feature in features" :key="feature.id" class="text-center px-6">
              <div class="w-20 h-20 rounded-full bg-white flex items-center justify-center mx-auto mb-10 -shadow-sm">
                <span class="text-3xl text-primary-500">{{ feature.icon }}</span>
              </div>
              <h3 class="font-medium text-2xl text-black mb-6">{{ feature.title }}</h3>
              <p class="text-gray-400 text-lg leading-relaxed">{{ feature.description }}</p>
            </div>
          </div>
        </div>
      </section>
  
      <!-- Testimonial Section -->
      <section class="py-40 px-8 bg-white">
        <div class="max-w-4xl mx-auto text-center">
          <div class="text-yellow-400 flex justify-center text-2xl mb-6">★★★★★</div>
          <p class="text-3xl font-medium text-black mb-8 leading-relaxed">
            "Service impeccable, exactement quand j'en avais besoin. La qualité et le professionnalisme m'ont vraiment impressionnée."
          </p>
          <div class="flex justify-center items-center mt-12">
            <img src="https://images.unsplash.com/photo-1518791841217-8cc77978b23a?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D" alt="Client" class="w-16 h-16 rounded-full object-cover" />
            <div class="ml-4 text-left">
              <p class="text-black font-medium">Marie L.</p>
              <p class="text-gray-400">Paris</p>
            </div>
          </div>
        </div>
      </section>
  
      <!-- Call to Action -->
      <section class="py-40 px-8 bg-black text-white text-center">
        <div class="max-w-4xl mx-auto">
          <h2 class="text-5xl font-medium mb-10">Prêt à simplifier votre quotidien ?</h2>
          <p class="text-2xl text-gray-400 mb-20 max-w-2xl mx-auto leading-relaxed">Trouvez le bon expert en quelques clics et profitez d'un service d'exception.</p>
          <button class="bg-white text-black px-12 py-6 rounded-full text-xl font-medium hover:bg-gray-100 transition-colors">
            Commencer maintenant
          </button>
        </div>
      </section>
    </div>
  </template>
  
  <script setup>
  import { 
    ArrowRightIcon,
    UserPlusIcon,
    ShieldCheckIcon,
    StarIcon,
    UserGroupIcon
  } from '@heroicons/vue/24/outline'

  const services = [
    { id: 'menage', name: 'Ménage', icon: '🧹', price: 'Dès 25€/h' },
    { id: 'jardinage', name: 'Jardinage', icon: '🌱', price: 'Dès 30€/h' },
    { id: 'bricolage', name: 'Bricolage', icon: '🔨', price: 'Dès 35€/h' },
    { id: 'garde', name: 'Garde d\'enfants', icon: '👶', price: 'Dès 20€/h' },
  ]
  
  const features = [
    {
      id: 1,
      icon: '✓',
      title: 'Professionnels vérifiés',
      description: 'Tous nos experts sont rigoureusement sélectionnés pour vous garantir un service d\'excellence.'
    },
    {
      id: 2,
      icon: '✓',
      title: 'Réservation instantanée',
      description: 'Notre interface intuitive vous permet de réserver un expert en quelques secondes.'
    },
    {
      id: 3,
      icon: '✓',
      title: 'Paiement sécurisé',
      description: 'Vos transactions sont protégées par les méthodes de cryptage les plus avancées.'
    }
  ]
  </script>
  
  <style scoped>
  select {
    -webkit-appearance: none;
    background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
    background-repeat: no-repeat;
    background-position: right 1.5rem center;
    background-size: 1.5em;
  }

  /* Smooth transitions */
  .transition-all {
    transition-property: all;
    transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
    transition-duration: 150ms;
  }
  </style>