<template>
  <div class="min-h-screen bg-white">
    <!-- Hero Section -->
    <section class="relative overflow-hidden">
      <!-- Motif de fond subtil -->
      <div class="absolute inset-0 bg-grid-pattern opacity-5"></div>
      <!-- Formes décoratives -->
      <div class="absolute top-40 right-10 w-64 h-64 rounded-full bg-blue-100 blur-3xl opacity-50"></div>
      <div class="absolute bottom-40 left-10 w-64 h-64 rounded-full bg-primary-100 blur-3xl opacity-50"></div>
      
      <div class="relative max-w-7xl mx-auto px-4 pt-32 pb-20">
        <div class="text-center mb-16">
          <h1 class="text-5xl sm:text-6xl font-bold text-gray-900 tracking-tight">
            À propos de nous
          </h1>
          <p class="mt-6 text-xl text-gray-600 max-w-3xl mx-auto">
            Notre mission est de simplifier votre quotidien en vous connectant avec les meilleurs experts professionnels.
          </p>
        </div>
      </div>
    </section>

    <!-- Notre histoire -->
    <section class="py-20">
      <div class="max-w-7xl mx-auto px-4">
        <div class="grid md:grid-cols-2 gap-20 items-center">
          <div>
            <h2 class="text-3xl font-bold text-gray-900 mb-6">Notre histoire</h2>
            <div class="space-y-4 text-lg text-gray-600">
              <p>
                Fondée en 2020, notre plateforme est née d'un constat simple : trouver un expert de confiance pour réaliser un service à domicile est souvent compliqué, chronophage et stressant.
              </p>
              <p>
                Notre équipe de passionnés a décidé de créer une solution qui transforme cette expérience en un processus simple, transparent et sécurisé pour tous.
              </p>
              <p>
                Aujourd'hui, nous sommes fiers de connecter quotidiennement des milliers de clients avec nos experts vérifiés, contribuant à améliorer le quotidien de chacun.
              </p>
            </div>
          </div>
          <div class="relative">
            <img 
              src="https://images.unsplash.com/photo-1521791136064-7986c2920216" 
              alt="Notre équipe"
              class="rounded-2xl shadow-lg w-full h-auto object-cover"
            />
            <div class="absolute inset-0 rounded-2xl bg-gradient-to-tr from-primary-600/10 to-transparent"></div>
          </div>
        </div>
      </div>
    </section>

    <!-- Nos valeurs - style cartes GAFAM -->
    <section class="py-20 bg-gray-50">
      <div class="max-w-7xl mx-auto px-4">
        <div class="text-center mb-16">
          <h2 class="text-3xl font-bold text-gray-900">Nos valeurs</h2>
          <p class="mt-4 text-xl text-gray-600 max-w-3xl mx-auto">
            Ces principes guident chacune de nos actions et décisions
          </p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
          <!-- Valeur 1 -->
          <div class="bg-white rounded-2xl border border-gray-100 p-8 flex flex-col items-center text-center">
            <div class="w-16 h-16 bg-blue-100 rounded-2xl flex items-center justify-center mb-6">
              <Shield class="w-8 h-8 text-blue-600" />
            </div>
            <h3 class="text-xl font-bold text-gray-900 mb-3">Confiance</h3>
            <p class="text-gray-600">
              Nous vérifions rigoureusement chaque expert pour garantir une qualité de service exceptionnelle.
            </p>
          </div>

          <!-- Valeur 2 -->
          <div class="bg-white rounded-2xl border border-gray-100 p-8 flex flex-col items-center text-center">
            <div class="w-16 h-16 bg-primary-100 rounded-2xl flex items-center justify-center mb-6">
              <Target class="w-8 h-8 text-primary-600" />
            </div>
            <h3 class="text-xl font-bold text-gray-900 mb-3">Simplicité</h3>
            <p class="text-gray-600">
              Nous rendons accessibles des services complexes grâce à une expérience utilisateur intuitive.
            </p>
          </div>

          <!-- Valeur 3 -->
          <div class="bg-white rounded-2xl border border-gray-100 p-8 flex flex-col items-center text-center">
            <div class="w-16 h-16 bg-green-100 rounded-2xl flex items-center justify-center mb-6">
              <Heart class="w-8 h-8 text-green-600" />
            </div>
            <h3 class="text-xl font-bold text-gray-900 mb-3">Satisfaction</h3>
            <p class="text-gray-600">
              Nous ne sommes satisfaits que lorsque vous l'êtes, avec une garantie sur tous les services.
            </p>
          </div>
        </div>
      </div>
    </section>

    <!-- Notre équipe -->
    <section class="py-20">
      <div class="max-w-7xl mx-auto px-4">
        <div class="text-center mb-16">
          <h2 class="text-3xl font-bold text-gray-900">Notre équipe</h2>
          <p class="mt-4 text-xl text-gray-600 max-w-3xl mx-auto">
            Des passionnés qui travaillent chaque jour pour améliorer votre expérience
          </p>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-8">
          <!-- Membre 1 -->
          <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden transition-transform hover:scale-[1.02]">
            <div class="aspect-square overflow-hidden">
              <img 
                src="https://randomuser.me/api/portraits/men/32.jpg" 
                alt="CEO"
                class="w-full h-full object-cover"
              />
            </div>
            <div class="p-6">
              <h3 class="text-lg font-bold text-gray-900">Alexandre Martin</h3>
              <p class="text-primary-600 mb-3">CEO & Co-fondateur</p>
              <p class="text-gray-600 text-sm">
                Entrepreneur passionné par l'innovation et l'expérience utilisateur.
              </p>
            </div>
          </div>

          <!-- Membre 2 -->
          <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden transition-transform hover:scale-[1.02]">
            <div class="aspect-square overflow-hidden">
              <img 
                src="https://randomuser.me/api/portraits/women/44.jpg" 
                alt="CTO"
                class="w-full h-full object-cover"
              />
            </div>
            <div class="p-6">
              <h3 class="text-lg font-bold text-gray-900">Sophie Dubois</h3>
              <p class="text-primary-600 mb-3">CTO & Co-fondatrice</p>
              <p class="text-gray-600 text-sm">
                Experte en développement et architecture de plateformes sécurisées.
              </p>
            </div>
          </div>

          <!-- Membre 3 -->
          <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden transition-transform hover:scale-[1.02]">
            <div class="aspect-square overflow-hidden">
              <img 
                src="https://randomuser.me/api/portraits/men/68.jpg" 
                alt="CMO"
                class="w-full h-full object-cover"
              />
            </div>
            <div class="p-6">
              <h3 class="text-lg font-bold text-gray-900">Thomas Legrand</h3>
              <p class="text-primary-600 mb-3">Directeur Marketing</p>
              <p class="text-gray-600 text-sm">
                Stratège digital avec plus de 10 ans d'expérience dans la croissance.
              </p>
            </div>
          </div>

          <!-- Membre 4 -->
          <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden transition-transform hover:scale-[1.02]">
            <div class="aspect-square overflow-hidden">
              <img 
                src="https://randomuser.me/api/portraits/women/65.jpg" 
                alt="Head of Customer Success"
                class="w-full h-full object-cover"
              />
            </div>
            <div class="p-6">
              <h3 class="text-lg font-bold text-gray-900">Emma Laurent</h3>
              <p class="text-primary-600 mb-3">Responsable Satisfaction Client</p>
              <p class="text-gray-600 text-sm">
                Dédiée à offrir un service exceptionnel à chaque client.
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Chiffres clés - style GAFAM impact -->
    <section class="py-20 bg-gray-900 text-white relative overflow-hidden">
      <div class="absolute inset-0 bg-grid-pattern-dark opacity-10"></div>
      <div class="absolute top-20 right-20 w-64 h-64 rounded-full bg-primary-500 blur-3xl opacity-10"></div>
      <div class="absolute bottom-20 left-20 w-64 h-64 rounded-full bg-blue-500 blur-3xl opacity-10"></div>
      
      <div class="max-w-7xl mx-auto px-4 relative">
        <div class="text-center mb-16">
          <h2 class="text-3xl font-bold text-white">Notre impact</h2>
          <p class="mt-4 text-xl text-gray-300 max-w-3xl mx-auto">
            Des chiffres qui reflètent notre engagement envers la qualité
          </p>
        </div>

        <div class="grid grid-cols-2 md:grid-cols-4 gap-8">
          <!-- Chiffre 1 -->
          <div class="text-center">
            <div class="text-5xl font-bold text-primary-400 mb-2">10K+</div>
            <p class="text-gray-300">Clients satisfaits</p>
          </div>

          <!-- Chiffre 2 -->
          <div class="text-center">
            <div class="text-5xl font-bold text-primary-400 mb-2">2.5K+</div>
            <p class="text-gray-300">Experts certifiés</p>
          </div>

          <!-- Chiffre 3 -->
          <div class="text-center">
            <div class="text-5xl font-bold text-primary-400 mb-2">15K+</div>
            <p class="text-gray-300">Services réalisés</p>
          </div>

          <!-- Chiffre 4 -->
          <div class="text-center">
            <div class="text-5xl font-bold text-primary-400 mb-2">4.9/5</div>
            <p class="text-gray-300">Note moyenne</p>
          </div>
        </div>
      </div>
    </section>

    <!-- Rejoignez-nous - CTA -->
    <section class="py-16 bg-white">
      <div class="max-w-5xl mx-auto px-4 text-center">
        <h2 class="text-3xl font-bold text-gray-900 mb-6">Prêt à nous rejoindre ?</h2>
        <p class="text-xl text-gray-600 max-w-3xl mx-auto mb-8">
          Que vous soyez à la recherche d'un expert ou souhaitiez proposer vos services, notre plateforme est faite pour vous.
        </p>
        <div class="flex flex-col sm:flex-row gap-4 justify-center">
          <NuxtLink 
            to="/experts" 
            class="px-8 py-3 bg-blue-600 text-white font-medium rounded-xl hover:bg-blue-700 transition-colors"
          >
            Trouver un expert
          </NuxtLink>
          <NuxtLink 
            to="/register-expert" 
            class="px-8 py-3 bg-primary-600 text-white font-medium rounded-xl hover:bg-primary-700 transition-colors"
          >
            Devenir expert
          </NuxtLink>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
import { Shield, Target, Heart } from 'lucide-vue-next'

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