<template>
  <div class="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">
    <!-- Hero Section -->
    <section class="pt-24 pb-16 px-4">
      <div class="max-w-5xl mx-auto text-center">
        <h1 class="text-4xl sm:text-5xl font-bold text-gray-900 mb-6">
          Notre Mission
        </h1>
        <p class="text-xl text-gray-600 max-w-3xl mx-auto leading-relaxed">
          Simplifier la vie quotidienne en connectant les particuliers avec des experts qualifiés 
          pour tous leurs besoins de services à domicile.
        </p>
      </div>
    </section>

    <!-- Stats Section -->
    <section class="py-16 px-4">
      <div class="max-w-6xl mx-auto">
        <div class="grid md:grid-cols-3 gap-8">
          <div class="bg-white rounded-2xl p-8 text-center">
            <div class="text-4xl font-bold text-indigo-600 mb-2">15K+</div>
            <div class="text-gray-600">Clients satisfaits</div>
          </div>
          <div class="bg-white rounded-2xl p-8 text-center">
            <div class="text-4xl font-bold text-indigo-600 mb-2">2.5K+</div>
            <div class="text-gray-600">Experts vérifiés</div>
          </div>
          <div class="bg-white rounded-2xl p-8 text-center">
            <div class="text-4xl font-bold text-indigo-600 mb-2">4.9/5</div>
            <div class="text-gray-600">Note moyenne</div>
          </div>
        </div>
      </div>
    </section>

    <!-- Values Section -->
    <section class="py-16 px-4">
      <div class="max-w-6xl mx-auto">
        <h2 class="text-3xl font-bold text-gray-900 text-center mb-12">
          Nos Valeurs
        </h2>
        <div class="grid md:grid-cols-3 gap-12">
          <div v-for="value in values" :key="value.title" class="text-center">
            <div class="w-16 h-16 bg-indigo-50 rounded-2xl flex items-center justify-center mx-auto mb-6">
              <component :is="value.icon" class="w-8 h-8 text-indigo-600" />
            </div>
            <h3 class="text-xl font-semibold text-gray-900 mb-4">{{ value.title }}</h3>
            <p class="text-gray-600 leading-relaxed">{{ value.description }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- Team Section -->
    <section class="py-16 px-4">
      <div class="max-w-6xl mx-auto">
        <h2 class="text-3xl font-bold text-gray-900 text-center mb-12">
          Notre Équipe
        </h2>
        <div class="grid md:grid-cols-4 gap-8">
          <div v-for="member in team" :key="member.name" class="text-center">
            <img 
              :src="member.image" 
              :alt="member.name"
              class="w-32 h-32 rounded-full mx-auto mb-4 object-cover"
            />
            <h3 class="font-medium text-gray-900">{{ member.name }}</h3>
            <p class="text-gray-500 text-sm">{{ member.role }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA Section -->
    <section class="py-24 px-4">
      <div class="max-w-4xl mx-auto text-center">
        <h2 class="text-3xl font-bold text-gray-900 mb-6">
          Prêt à nous rejoindre ?
        </h2>
        <p class="text-xl text-gray-600 mb-8">
          Devenez expert ou trouvez le professionnel qu'il vous faut.
        </p>
        <div class="flex flex-col sm:flex-row gap-4 justify-center">
          <NuxtLink
            to="/auth/register-expert"
            class="inline-flex items-center px-6 py-3 rounded-xl bg-indigo-600 text-white font-medium hover:bg-indigo-700 transition-colors"
          >
            Devenir expert
          </NuxtLink>
          <NuxtLink
            to="/demande"
            class="inline-flex items-center px-6 py-3 rounded-xl bg-white text-indigo-600 font-medium border-2 border-indigo-600 hover:bg-indigo-50 transition-colors"
          >
            Publier une demande
          </NuxtLink>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
import { ShieldCheckIcon, HeartIcon, SparklesIcon } from '@heroicons/vue/24/outline'

const values = [
  {
    title: 'Confiance',
    icon: ShieldCheckIcon,
    description: 'Nous vérifions rigoureusement chaque expert pour garantir votre sécurité et la qualité du service.'
  },
  {
    title: 'Bienveillance',
    icon: HeartIcon,
    description: 'Notre équipe est à votre écoute pour vous accompagner et vous conseiller au mieux.'
  },
  {
    title: 'Excellence',
    icon: SparklesIcon,
    description: 'Nous nous efforçons d\'offrir la meilleure expérience possible à nos utilisateurs.'
  }
]

const team = [
  {
    name: 'Sarah Martin',
    role: 'CEO & Co-fondatrice',
    image: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330'
  },
  {
    name: 'Marc Dubois',
    role: 'CTO',
    image: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e'
  },
  {
    name: 'Julie Chen',
    role: 'Directrice Marketing',
    image: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80'
  },
  {
    name: 'Thomas Rey',
    role: 'Responsable Produit',
    image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e'
  }
]
</script> 