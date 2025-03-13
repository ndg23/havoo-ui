// components/ExpertCard.vue
<template>
  <div class="expert-card" @click="navigateToProfile">
    <div class="avatar">
      <img v-if="expert.avatar" :src="expert.avatar" :alt="expert.name">
      <img v-else src="/images/default-avatar.png" :alt="expert.name">
    </div>
    <div class="expert-content">
      <div class="expert-header">
        <span class="expert-name">{{ expert.name }}</span>
        <i v-if="expert.isVerified" class="fas fa-check-circle verification-badge"></i>
        <span class="expert-meta">· {{ expert.occupation }}</span>
        <div class="rating">
          <i class="fas fa-star"></i>
          <span class="rating-value">{{ formatRating(expert.rating) }}</span>
          <span class="reviews-count">({{ expert.reviewsCount }})</span>
        </div>
      </div>
      <div class="expert-bio">{{ expert.bio }}</div>
      <div class="expert-skills">
        <span v-for="(skill, index) in expert.skills" :key="index" class="skill">
          {{ skill.name }}
        </span>
      </div>
      <div class="expert-footer">
        <div class="hourly-rate">{{ formatCurrency(expert.hourlyRate) }}</div>
        <div class="availability" :class="{ 'available': expert.isAvailable, 'busy': !expert.isAvailable }">
          <i class="fas fa-circle"></i>
          <span>{{ expert.isAvailable ? 'Disponible' : 'Occupé' }}</span>
        </div>
        <button class="contact-btn" @click.stop="contactExpert">Contacter</button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    expert: {
      type: Object,
      required: true
    }
  },
  
  methods: {
    formatRating(rating) {
      return rating ? rating.toFixed(1) : '0.0'
    },
    
    formatCurrency(amount) {
      return amount ? `${amount.toLocaleString()} FCFA/h` : 'Tarif non défini'
    },
    
    navigateToProfile() {
      this.$router.push(`/experts/${this.expert.id}`)
    },
    
    contactExpert() {
      this.$emit('contact', this.expert)
    }
  }
}
</script>

<style scoped>
.expert-card {
  padding: var(--space-md);
  border-bottom: 1px solid var(--border-color);
  display: flex;
  gap: var(--space-md);
  transition: background-color 0.2s;
  cursor: pointer;
}

.expert-card:hover {
  background-color: rgba(0, 0, 0, 0.02);
}

.avatar {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  background-color: var(--bg-secondary);
  overflow: hidden;
  flex-shrink: 0;
}

.avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.expert-content {
  flex: 1;
}

.expert-header {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  margin-bottom: var(--space-xs);
}

.expert-name {
  font-weight: 700;
  font-size: 15px;
  margin-right: var(--space-xs);
}

.verification-badge {
  color: var(--primary-color);
  margin-right: var(--space-xs);
}

.expert-meta {
  color: var(--text-secondary);
  font-size: 14px;
  margin-right: auto;
}

.rating {
  display: flex;
  align-items: center;
  gap: 2px;
  margin-left: auto;
}

.rating .fas {
  color: #FFD700;
  font-size: 14px;
}

.rating-value {
  font-weight: 600;
  font-size: 14px;
}

.reviews-count {
  color: var(--text-secondary);
  font-size: 13px;
}

.expert-bio {
  margin-bottom: var(--space-sm);
  color: var(--text-color);
  font-size: 15px;
}

.expert-skills {
  display: flex;
  flex-wrap: wrap;
  gap: var(--space-xs);
  margin-bottom: var(--space-sm);
}

.skill {
  background-color: var(--bg-secondary);
  border-radius: 4px;
  padding: 2px 8px;
  font-size: 13px;
  color: var(--primary-color);
}

.expert-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 14px;
  color: var(--text-secondary);
}

.hourly-rate {
  font-weight: 700;
  color: var(--success-color);
}

.availability {
  display: flex;
  align-items: center;
  gap: var(--space-xs);
}

.available {
  color: var(--success-color);
}

.busy {
  color: var(--accent-color);
}

.contact-btn {
  background-color: var(--primary-color);
  color: white;
  border: none;
  border-radius: 9999px;
  padding: var(--space-xs) var(--space-md);
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: background-color 0.2s;
}

.contact-btn:hover {
  background-color: #1a8cd8;
}

@media (max-width: 600px) {
  .expert-header {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .rating {
    margin-left: 0;
    margin-top: var(--space-xs);
  }
}
</style>