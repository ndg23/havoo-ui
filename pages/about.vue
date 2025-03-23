<template>
  <div class="min-h-screen bg-white">
    <!-- Hero Section with Twitter-inspired design -->
    <section class="relative bg-white overflow-hidden">
      <!-- Enhanced background effects -->
      <div class="absolute inset-0 bg-gradient-to-br from-primary-50 to-white opacity-30"></div>
      <div class="absolute top-40 right-10 w-72 h-72 rounded-full bg-blue-100 blur-3xl opacity-40"></div>
      <div class="absolute bottom-40 left-10 w-72 h-72 rounded-full bg-primary-100 blur-3xl opacity-40"></div>
      
      <div class="relative max-w-4xl mx-auto px-4 py-24 sm:py-32">
        <div class="text-center">
          <!-- Twitter-style heading with gradient text -->
          <span class="inline-block px-4 py-1.5 bg-primary-50 text-primary-700 rounded-full text-sm font-medium mb-6">Notre entreprise</span>
          <h1 class="text-5xl sm:text-6xl font-bold tracking-tight">
            À propos de nous
            <span class="block mt-3 bg-clip-text text-transparent bg-gradient-to-r from-primary-600 to-blue-600">
              Notre mission. Notre vision.
            </span>
          </h1>
          <p class="mt-6 text-xl text-gray-600 max-w-3xl mx-auto">
            Simplifier votre quotidien en vous connectant avec les meilleurs 
            <span class="font-bold px-1.5 py-0.5 rounded-md bg-primary-50 text-primary-700">experts professionnels</span> 
            dans votre région.
          </p>
        </div>
      </div>
    </section>

    <!-- Notre histoire - Twitter-style layout -->
    <section class="py-24 bg-white relative">
      <div class="max-w-6xl mx-auto px-4">
        <!-- Section header with Twitter typography -->
        <div class="text-center mb-16">
          <span class="inline-block px-4 py-1.5 bg-primary-50 text-primary-700 rounded-full text-sm font-medium mb-4">Notre parcours</span>
          <h2 class="text-4xl font-bold text-gray-900">
            Une histoire d'innovation
          </h2>
        </div>
        
        <div class="grid md:grid-cols-2 gap-16 items-center">
          <div>
            <div class="space-y-6 text-lg text-gray-600">
              <p class="text-xl leading-relaxed">
                Fondée en 2020, notre plateforme est née d'un constat simple : <span class="font-medium text-gray-800">trouver un expert de confiance pour réaliser un service à domicile est souvent compliqué, chronophage et stressant.</span>
              </p>
              <p class="leading-relaxed">
                Notre équipe de passionnés a décidé de créer une solution qui transforme cette expérience en un processus simple, transparent et sécurisé pour tous.
              </p>
              <p class="leading-relaxed">
                Aujourd'hui, nous sommes fiers de connecter quotidiennement des milliers de clients avec nos experts vérifiés, contribuant à améliorer le quotidien de chacun.
              </p>
            </div>
            
            <!-- Twitter-style call-to-action button -->
            <div class="mt-8">
              <NuxtLink to="/experts" 
                class="inline-flex items-center px-6 py-3 bg-white border border-gray-200 text-gray-800 rounded-full font-medium hover:bg-gray-50 transition-all">
                <svg xmlns="http://www.w3.org/2000/svg" class="mr-3" width="20" height="20" viewBox="0 0 24 24">
                  <path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                    d="M13 7a4 4 0 1 1-8 0a4 4 0 0 1 8 0m2 4a4 4 0 0 0 0-8m-4 11H7a5 5 0 0 0-5 5a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2a5 5 0 0 0-5-5m6 0a5 5 0 0 1 5 5a2 2 0 0 1-2 2h-1.5"
                    color="currentColor" />
                </svg>
                Découvrir nos experts
              </NuxtLink>
            </div>
          </div>
          <div class="relative">
            <div class="rounded-2xl overflow-hidden border border-gray-100 transform hover:scale-[1.02] transition-all duration-300 shadow-sm">
              <div class="absolute inset-0 rounded-2xl bg-gradient-to-tr from-primary-600/10 to-transparent z-10"></div>
              <img 
                src="https://images.unsplash.com/photo-1521791136064-7986c2920216" 
                alt="Notre équipe"
                class="w-full h-auto object-cover"
              />
            </div>
            
            <!-- Enhanced rating card -->
            <div class="absolute -bottom-5 -right-5 bg-white rounded-xl border border-gray-100 p-4 flex items-center gap-3 transform hover:scale-105 transition-transform shadow-sm">
              <Star class="w-9 h-9 text-amber-400 fill-current" />
              <div>
                <div class="text-xs text-gray-500 font-medium">Note moyenne</div>
                <div class="text-2xl font-bold text-primary-600">4.9<span class="text-gray-400 text-lg">/5</span></div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Nos valeurs - Twitter cards style -->
    <section class="py-24 bg-gray-50">
      <div class="max-w-6xl mx-auto px-4">
        <div class="text-center mb-16">
          <span class="inline-block px-4 py-1.5 bg-primary-50 text-primary-700 rounded-full text-sm font-medium mb-4">Ce qui compte pour nous</span>
          <h2 class="text-4xl font-bold text-gray-900">
            Nos valeurs fondamentales
          </h2>
          <p class="mt-4 text-xl text-gray-600 max-w-3xl mx-auto">
            Ces principes guident chacune de nos actions et décisions
          </p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
          <!-- Valeur 1 - Enhanced Twitter card -->
          <div class="bg-white rounded-2xl border border-gray-100 p-8 hover:shadow-md transition-all duration-300 group">
            <div class="w-16 h-16 rounded-full bg-blue-100 group-hover:bg-blue-200 flex items-center justify-center mb-6 transition-colors">
              <Shield class="w-8 h-8 text-blue-600" />
            </div>
            <h3 class="text-xl font-bold text-gray-900 mb-3 group-hover:text-blue-600 transition-colors">Confiance</h3>
            <p class="text-gray-600 group-hover:text-gray-700 transition-colors">
              Nous vérifions rigoureusement chaque expert pour garantir une qualité de service exceptionnelle.
            </p>
          </div>

          <!-- Valeur 2 - Enhanced Twitter card -->
          <div class="bg-white rounded-2xl border border-gray-100 p-8 hover:shadow-md transition-all duration-300 group">
            <div class="w-16 h-16 rounded-full bg-primary-100 group-hover:bg-primary-200 flex items-center justify-center mb-6 transition-colors">
              <Target class="w-8 h-8 text-primary-600" />
            </div>
            <h3 class="text-xl font-bold text-gray-900 mb-3 group-hover:text-primary-600 transition-colors">Simplicité</h3>
            <p class="text-gray-600 group-hover:text-gray-700 transition-colors">
              Nous rendons accessibles des services complexes grâce à une expérience utilisateur intuitive.
            </p>
          </div>

          <!-- Valeur 3 - Enhanced Twitter card -->
          <div class="bg-white rounded-2xl border border-gray-100 p-8 hover:shadow-md transition-all duration-300 group">
            <div class="w-16 h-16 rounded-full bg-green-100 group-hover:bg-green-200 flex items-center justify-center mb-6 transition-colors">
              <Heart class="w-8 h-8 text-green-600" />
            </div>
            <h3 class="text-xl font-bold text-gray-900 mb-3 group-hover:text-green-600 transition-colors">Satisfaction</h3>
            <p class="text-gray-600 group-hover:text-gray-700 transition-colors">
              Nous ne sommes satisfaits que lorsque vous l'êtes, avec une garantie sur tous les services.
            </p>
          </div>
        </div>
      </div>
    </section>

    <!-- Notre équipe - Twitter profile cards -->
    <section class="py-24 bg-white">
      <div class="max-w-6xl mx-auto px-4">
        <div class="text-center mb-16">
          <span class="inline-block px-4 py-1.5 bg-primary-50 text-primary-700 rounded-full text-sm font-medium mb-4">Les visages derrière la plateforme</span>
          <h2 class="text-4xl font-bold text-gray-900">
            Notre équipe
          </h2>
          <p class="mt-4 text-xl text-gray-600 max-w-3xl mx-auto">
            Des passionnés qui travaillent chaque jour pour améliorer votre expérience
          </p>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-8">
          <!-- Membre 1 - Twitter profile card -->
          <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden transition-all duration-300 hover:shadow-md group">
            <div class="aspect-square overflow-hidden">
              <img 
                src="https://randomuser.me/api/portraits/men/32.jpg" 
                alt="CEO"
                class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
              />
            </div>
            <div class="p-6">
              <h3 class="text-lg font-bold text-gray-900 group-hover:text-primary-600 transition-colors">Alexandre Martin</h3>
              <p class="text-primary-600 mb-3 flex items-center">
                CEO & Co-fondateur
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 ml-1 text-primary-500" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                  <polyline points="22 4 12 14.01 9 11.01"></polyline>
                </svg>
              </p>
              <p class="text-gray-600 text-sm">
                Entrepreneur passionné par l'innovation et l'expérience utilisateur.
              </p>
            </div>
          </div>

          <!-- Membre 2 - Twitter profile card -->
          <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden transition-all duration-300 hover:shadow-md group">
            <div class="aspect-square overflow-hidden">
              <img 
                src="https://randomuser.me/api/portraits/women/44.jpg" 
                alt="CTO"
                class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
              />
            </div>
            <div class="p-6">
              <h3 class="text-lg font-bold text-gray-900 group-hover:text-primary-600 transition-colors">Sophie Dubois</h3>
              <p class="text-primary-600 mb-3 flex items-center">
                CTO & Co-fondatrice
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 ml-1 text-primary-500" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                  <polyline points="22 4 12 14.01 9 11.01"></polyline>
                </svg>
              </p>
              <p class="text-gray-600 text-sm">
                Experte en développement et architecture de plateformes sécurisées.
              </p>
            </div>
          </div>

          <!-- Membre 3 - Twitter profile card -->
          <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden transition-all duration-300 hover:shadow-md group">
            <div class="aspect-square overflow-hidden">
              <img 
                src="https://randomuser.me/api/portraits/men/68.jpg" 
                alt="CMO"
                class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
              />
            </div>
            <div class="p-6">
              <h3 class="text-lg font-bold text-gray-900 group-hover:text-primary-600 transition-colors">Thomas Legrand</h3>
              <p class="text-primary-600 mb-3">Directeur Marketing</p>
              <p class="text-gray-600 text-sm">
                Stratège digital avec plus de 10 ans d'expérience dans la croissance.
              </p>
            </div>
          </div>

          <!-- Membre 4 - Twitter profile card -->
          <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden transition-all duration-300 hover:shadow-md group">
            <div class="aspect-square overflow-hidden">
              <img 
                src="https://randomuser.me/api/portraits/women/65.jpg" 
                alt="Head of Customer Success"
                class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
              />
            </div>
            <div class="p-6">
              <h3 class="text-lg font-bold text-gray-900 group-hover:text-primary-600 transition-colors">Emma Laurent</h3>
              <p class="text-primary-600 mb-3">Responsable Satisfaction Client</p>
              <p class="text-gray-600 text-sm">
                Dédiée à offrir un service exceptionnel à chaque client.
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Chiffres clés - Twitter metrics style -->
    <section class="py-24 bg-gradient-to-r from-primary-600 to-primary-700 text-white relative overflow-hidden">
      <!-- Background elements -->
      <div class="absolute top-0 right-0 w-80 h-80 rounded-full bg-white/10 -translate-y-1/2 translate-x-1/2"></div>
      <div class="absolute bottom-0 left-0 w-80 h-80 rounded-full bg-white/10 translate-y-1/2 -translate-x-1/2"></div>
      
      <div class="max-w-6xl mx-auto px-4 relative z-10">
        <div class="text-center mb-16">
          <span class="inline-block px-4 py-1.5 bg-white/20 text-white rounded-full text-sm font-medium mb-4">En chiffres</span>
          <h2 class="text-4xl font-bold text-white">
            Notre impact
          </h2>
          <p class="mt-4 text-xl text-white/90 max-w-3xl mx-auto">
            Des chiffres qui reflètent notre engagement envers la qualité
          </p>
        </div>

        <div class="grid grid-cols-2 md:grid-cols-4 gap-8">
          <!-- Metric 1 - Twitter style -->
          <div class="text-center bg-white/10 p-6 rounded-2xl backdrop-blur-sm hover:bg-white/20 transition-colors">
            <div class="text-5xl font-bold text-white mb-2">10K+</div>
            <p class="text-white/80">Clients satisfaits</p>
          </div>

          <!-- Metric 2 - Twitter style -->
          <div class="text-center bg-white/10 p-6 rounded-2xl backdrop-blur-sm hover:bg-white/20 transition-colors">
            <div class="text-5xl font-bold text-white mb-2">2.5K+</div>
            <p class="text-white/80">Experts certifiés</p>
          </div>

          <!-- Metric 3 - Twitter style -->
          <div class="text-center bg-white/10 p-6 rounded-2xl backdrop-blur-sm hover:bg-white/20 transition-colors">
            <div class="text-5xl font-bold text-white mb-2">15K+</div>
            <p class="text-white/80">Services réalisés</p>
          </div>

          <!-- Metric 4 - Twitter style -->
          <div class="text-center bg-white/10 p-6 rounded-2xl backdrop-blur-sm hover:bg-white/20 transition-colors">
            <div class="text-5xl font-bold text-white mb-2">4.9/5</div>
            <p class="text-white/80">Note moyenne</p>
          </div>
        </div>
        
        <!-- Social proof -->
        <div class="mt-16 flex flex-wrap justify-center gap-8">
          <div class="flex items-center p-4 bg-white/10 rounded-xl backdrop-blur-sm">
            <div class="flex -space-x-2 mr-4">
              <img src="https://randomuser.me/api/portraits/women/44.jpg" class="w-10 h-10 rounded-full border-2 border-primary-500" />
              <img src="https://randomuser.me/api/portraits/men/32.jpg" class="w-10 h-10 rounded-full border-2 border-primary-500" />
              <img src="https://randomuser.me/api/portraits/women/65.jpg" class="w-10 h-10 rounded-full border-2 border-primary-500" />
            </div>
            <div class="text-sm">
              <p class="font-medium">Rejoignez nos experts</p>
              <p class="text-white/80">2,500+ professionnels</p>
            </div>
          </div>
          
          <div class="flex items-center p-4 bg-white/10 rounded-xl backdrop-blur-sm">
            <Star class="w-10 h-10 text-amber-400 fill-current mr-4" />
            <div class="text-sm">
              <p class="font-medium">Satisfaction garantie</p>
              <p class="text-white/80">ou remboursé</p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Rejoignez-nous - Twitter CTA -->
    <section class="py-24 bg-white">
      <div class="max-w-4xl mx-auto px-4 text-center">
        <span class="inline-block px-4 py-1.5 bg-primary-50 text-primary-700 rounded-full text-sm font-medium mb-4">Commencez dès aujourd'hui</span>
        <h2 class="text-4xl font-bold text-gray-900 mb-6">
          Prêt à nous rejoindre ?
        </h2>
        <p class="text-xl text-gray-600 max-w-3xl mx-auto mb-10">
          Que vous soyez à la recherche d'un expert ou souhaitiez proposer vos services, notre plateforme est faite pour vous.
        </p>
        <div class="flex flex-col sm:flex-row gap-5 justify-center">
          <NuxtLink to="/experts" 
            class="bg-primary-600 hover:bg-primary-700 text-white px-8 py-4 rounded-full font-medium text-lg transition-all flex items-center justify-center">
            <svg xmlns="http://www.w3.org/2000/svg" class="mr-3" width="20" height="20" viewBox="0 0 24 24">
              <path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                d="M13 7a4 4 0 1 1-8 0a4 4 0 0 1 8 0m2 4a4 4 0 0 0 0-8m-4 11H7a5 5 0 0 0-5 5a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2a5 5 0 0 0-5-5m6 0a5 5 0 0 1 5 5a2 2 0 0 1-2 2h-1.5"
                color="currentColor" />
            </svg>
            Trouver un expert
          </NuxtLink>
          <NuxtLink to="/register-expert" 
            class="bg-white text-gray-800 border border-gray-200 hover:bg-gray-50 px-8 py-4 rounded-full font-medium text-lg transition-all flex items-center justify-center">
            <svg xmlns="http://www.w3.org/2000/svg" class="mr-3" width="20" height="20" viewBox="0 0 24 24">
              <path fill="currentColor" fill-rule="evenodd"
                d="M2.901 22.006h10.18c.41 0 .75-.34.75-.75s-.34-.75-.75-.75H2.892c-.09 0-.16-.05-.16-.06a3.33 3.33 0 0 1 2.25-2.36l3.72-1.12c.31-.1.53-.39.53-.72v-1.94c0-.23-.11-.45-.29-.59c-1.67-1.31-2.71-2.78-2.71-6.05c0-3.01 1.5-4.67 4.24-4.67c1.742 0 2.464.723 2.49.75c.14.16.35.25.56.25c1.36 0 2.21.61 2.21 3.67c0 3.28-1.04 4.74-2.71 6.05c-.18.14-.29.36-.29.59v1.94c0 .41.34.75.75.75s.75-.34.75-.75v-1.58c1.59-1.31 3-3.13 3-7c0-1.37 0-4.96-3.41-5.16c-.46-.37-1.51-1.01-3.34-1.01c-3.59 0-5.74 2.3-5.74 6.17s1.41 5.69 3 7v1.02l-3.18.96c-1.6.49-2.86 1.8-3.27 3.43c-.11.46-.02.92.27 1.29c.31.4.81.64 1.34.64m14.849.25c0 .41.34.75.75.75s.75-.34.75-.75v-2.75H22c.41 0 .75-.34.75-.75s-.34-.75-.75-.75h-2.75v-2.75c0-.41-.34-.75-.75-.75s-.75.34-.75.75v2.75H15c-.41 0-.75.34-.75.75s.34.75.75.75h2.75z"
                color="currentColor" />
            </svg>
            Devenir expert
          </NuxtLink>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
import { Shield, Target, Heart, Star } from 'lucide-vue-next'

// La page à propos utilise le layout default
definePageMeta({
  layout: 'default'
})
</script>

<style scoped>
.bg-grid-pattern {
  background-image: url("data:image/svg+xml,%3Csvg width='40' height='40' viewBox='0 0 40 40' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='%23000' fill-opacity='0.1' fill-rule='evenodd'%3E%3Ccircle cx='2' cy='2' r='1'/%3E%3C/g%3E%3C/svg%3E");
}

.bg-grid-pattern-dark {
  background-image: url("data:image/svg+xml,%3Csvg width='40' height='40' viewBox='0 0 40 40' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='%23fff' fill-opacity='0.1' fill-rule='evenodd'%3E%3Ccircle cx='2' cy='2' r='1'/%3E%3C/g%3E%3C/svg%3E");
}
</style> 