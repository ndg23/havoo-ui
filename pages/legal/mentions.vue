<template>
  <div class="min-h-screen bg-gray-50 py-12">
    <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
      <!-- Header -->
      <div class="text-center mb-12">
        <h1 class="text-3xl font-bold text-gray-900">
          Mentions Légales
        </h1>
        <p class="mt-2 text-gray-600">
          Informations légales et réglementaires
        </p>
      </div>

      <!-- Content -->
      <div class="bg-white rounded-2xl -shadow-sm border border-gray-200 overflow-hidden">
        <div class="p-8 space-y-12">
          <section v-for="section in mentions" :key="section.title">
            <h2 class="text-xl font-semibold text-gray-900 mb-6">
              {{ section.title }}
            </h2>
            <dl class="space-y-4">
              <div v-for="item in section.items" :key="item.label" 
                class="flex flex-col sm:flex-row sm:gap-4"
              >
                <dt class="text-sm font-medium text-gray-500 sm:w-1/3">
                  {{ item.label }}
                </dt>
                <dd class="text-sm text-gray-900 sm:w-2/3">
                  {{ item.value }}
                </dd>
              </div>
            </dl>
          </section>
        </div>
      </div>

      <!-- Contact Section -->
      <div class="mt-12 text-center">
        <h2 class="text-lg font-medium text-gray-900">
          Une question ?
        </h2>
        <p class="mt-2 text-gray-600">
          Notre équipe est à votre disposition
        </p>
        <NuxtLink 
          to="/contact" 
          class="mt-4 inline-flex items-center px-6 py-3 border border-transparent text-base font-medium rounded-xl text-white bg-indigo-600 hover:bg-indigo-700 transition-colors"
        >
          Nous contacter
        </NuxtLink>
      </div>
    </div>
  </div>
</template>

<script setup>
const { mentions } = useLegal()
</script> 