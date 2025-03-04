<template>
  <div class="min-h-screen bg-gray-50 py-12">
    <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
      <!-- Header -->
      <div class="text-center mb-12">
        <h1 class="text-3xl font-bold text-gray-900">
          Conditions Générales d'Utilisation
        </h1>
        <p class="mt-2 text-gray-600">
          Dernière mise à jour : {{ formatDate(lastUpdate) }}
        </p>
      </div>

      <!-- Content -->
      <div class="bg-white rounded-2xl -shadow-sm border border-gray-200 overflow-hidden">
        <div class="p-8 space-y-12">
          <section v-for="section in sections" :key="section.title">
            <h2 class="text-xl font-semibold text-gray-900 mb-6">
              {{ section.title }}
            </h2>
            <div class="space-y-8">
              <div v-for="item in section.content" :key="item.subtitle" class="prose prose-gray max-w-none">
                <h3 class="text-lg font-medium text-gray-900 mb-3">
                  {{ item.subtitle }}
                </h3>
                <p class="text-gray-600 leading-relaxed">
                  {{ item.text }}
                </p>
              </div>
            </div>
          </section>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const { sections } = useTerms()
const lastUpdate = new Date('2024-02-28')

const formatDate = (date) => {
  return new Intl.DateTimeFormat('fr-FR', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  }).format(date)
}
</script> 