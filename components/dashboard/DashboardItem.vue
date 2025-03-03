<template>
    <div class="bg-white rounded-xl shadow-sm p-6 hover:shadow-md transition-shadow">
      <div class="flex items-start justify-between">
        <div>
          <p class="text-sm font-medium text-gray-500">{{ title }}</p>
          <p class="mt-2 text-3xl font-bold text-gray-900">{{ value }}</p>
        </div>
        <div :class="`p-3 rounded-xl bg-${color}-50`">
          <component
            :is="icon"
            class="w-6 h-6"
            :class="`text-${color}-600`"
          />
        </div>
      </div>
      
      <div class="mt-4 flex items-center">
        <span
          :class="[
            'inline-flex items-center text-sm font-medium',
            trend.startsWith('+') ? 'text-green-600' : 'text-red-600'
          ]"
        >
          <component
            :is="trend.startsWith('+') ? ArrowUpIcon : ArrowDownIcon"
            class="w-4 h-4 mr-1"
          />
          {{ trend }}
        </span>
        <span class="text-sm text-gray-500 ml-2">vs mois dernier</span>
      </div>
    </div>
  </template>
  