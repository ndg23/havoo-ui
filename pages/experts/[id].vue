// pages/experts/_id.vue
<template>
  <div>
    <Header />
    
    <main v-if="expert">
      <div class="profile-header">
        <div class="back-button" @click="$router.back()">
          <i class="fas fa-arrow-left"></i>
        </div>
        <h1>{{ expert.name }}</h1>
      </div>
      
      <div class="profile-hero">
        <div class="avatar-large">
          <img v-if="expert.avatar" :src="expert.avatar" :alt="expert.name">
          <img v-else src="/images/default-avatar.png" :alt="expert.name">
        </div>
        
        <div class="profile-info">
          <div class="name-and-badge">
            <h2>{{ expert.name }}</h2>
            <i v-if="expert.isVerified" class="fas fa-check-circle verification-badge"></i>
          </div>
          
          <div class="occupation">{{ expert.occupation }}</div>
          
          <div class="rating-large">
            <i class="fas fa-star"></i>
            <span class="rating-value">{{ formatRating(expert.rating) }}</span>
            <span class="reviews-count">({{ expert.reviewsCount }} avis)</span>
          </div>
          
          <div class="availability" :class="{ 'available': expert.isAvailable, 'busy': !expert.isAvailable }">
            <i class="fas fa-circle"></i>
            <span>{{ expert.isAvailable ? 'Disponible maintenant' : 'Actuellement occupé' }}</span>
          </div>
        </div>
      </div>
      
      <div class="profile-section">
        <h3>À propos</h3>
        <p class="bio">{{ expert.bio }}</p>
      </div>
      
      <div class="profile-section">
        <h3>Compétences</h3>
        <div class="skills-grid">
          <div v-for="(skill, index) in expert.skills" :key="index" class="skill-item">
            <div class="skill-name">{{ skill.name }}</div>
            <div class="skill-level">
              <div 
                v-for="n in 5" 
                :key="n" 
                class="level-dot"
                :class="{ 'filled': n <= skill.level }"
              ></div>
            </div>
          </div>
        </div>
      </div>
      
      <div class="profile-section">
        <h3>Services</h3>
        <div v-if="expert.services && expert.services.length > 0" class="services-list">
          <div v-for="(service, index) in expert.services" :key="index" class="service-card">
            <div class="service-title">{{ service.title }}</div>
            <div class="service-description">{{ service.description }}</div>
            <div class="service-price">{{ formatCurrency(service.price) }}</div>
          </div>
        </div>
        <div v-else class="empty-services">
          <p>Cet expert n'a pas encore listé ses services.</p>
        </div>
      </div>
      
      <div class="profile-section">
        <h3>Avis ({{ expert.reviewsCount }})</h3>
        <div v-if="reviews.length > 0" class="reviews-list">
          <div v-for="review in reviews" :key="review.id" class="review-card">
            <div class="review-header">
              <div class="reviewer-info">
                <div class="reviewer-avatar">
                  <img :src="review.reviewer_avatar || '/images/default-avatar.png'" :alt="review.reviewer_name">
                </div>
                <div class="reviewer-name">{{ review.reviewer_name }}</div>
              </div>
              <div class="review-rating">
                <i v-for="n in 5" :key="n" class="fas fa-star" :class="{ 'filled': n <= review.rating }"></i>
              </div>
            </div>
            <div class="review-date">{{ formatDate(review.created_at) }}</div>
            <div class="review-comment">{{ review.comment }}</div>
          </div>
        </div>
        <div v-else class="empty-reviews">
          <p>Cet expert n'a pas encore reçu d'avis.</p>
        </div>
      </div>
    </main>
    
    <div v-else-if="loading" class="loading-container">
      <span class="loading-text">Chargement du profil...</span>
    </div>
    
    <div v-else class="error-container">
      <p>Expert introuvable.</p>
      <button class="btn-primary" @click="$router.push('/experts')">Retour à la liste des experts</button>
    </div>
    
    <div v-if="expert" class="contact-fab">
      <button class="contact-btn-large" @click="contactExpert">Contacter</button>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      expert: null,
      reviews: [],
      loading: true,
      error: null
    }
  },
  
  async fetch() {
    try {
      const expertId = this.$route.params.id
      await this.fetchExpertProfile(expertId)
      await this.fetchExpertReviews(expertId)
    } catch (error) {
      console.error('Error fetching expert profile:', error)
      this.error = error.message
    } finally {
      this.loading = false
    }
  },
  
  methods: {
    async fetchExpertProfile(expertId) {
      const { data, error } = await this.$supabase
        .from('profiles')
        .select(`
          id,
          first_name,
          last_name,
          bio,
          rating,
          reviews_count,
          hourly_rate,
          availability_status,
          is_available,
          is_verified,
          avatar_url,
          user_skills (
            skill_id,
            level,
            skills (
              id,
              name,
              category_id
            )
          ),
          services (
            id,
            title,
            description,
            price,
            category_id,
            is_active
          )
        `)
        .eq('id', expertId)
        .eq('is_expert', true)
        .single()
      
      if (error) throw error
      if (!data) throw new Error('Expert not found')
      
      // Process skills with level
      const skills = data.user_skills
        ? data.user_skills
            .filter(userSkill => userSkill.skills) // Remove null values
            .map(userSkill => ({
              id: userSkill.skills.id,
              name: userSkill.skills.name,
              level: userSkill.level || 3 // Default level if not set
            }))
            .sort((a, b) => b.level - a.level) // Sort by skill level
        : []
      
      // Process active services only
      const services = data.services
        ? data.services
            .filter(service => service.is_active)
        : []
            
      // Format the expert object
      this.expert = {
        id: data.id,
        name: `${data.first_name} ${data.last_name.charAt(0)}.`,
        fullName: `${data.first_name} ${data.last_name}`,
        avatar: data.avatar_url || null,
        occupation: services.length > 0 ? services[0].title : 'Expert',
        bio: data.bio || 'Aucune biographie disponible.',
        rating: data.rating || 0,
        reviewsCount: data.reviews_count || 0,
        hourlyRate: data.hourly_rate || 0,
        isAvailable: data.is_available,
        isVerified: data.is_verified,
        availabilityStatus: data.availability_status,
        skills: skills,
        services: services
      }
    },
    
    async fetchExpertReviews(expertId) {
      const { data, error } = await this.$supabase
        .from('reviews')
        .select(`
          id,
          rating,
          comment,
          created_at,
          reviewer_id,
          profiles:reviewer_id (
            first_name,
            last_name,
            avatar_url
          )
        `)
        .eq('reviewee_id', expertId)
        .order('created_at', { ascending: false })
        .limit(5)
      
      if (error) throw error
      
      // Format the reviews
      this.reviews = data.map(review => ({
        id: review.id,
        rating: review.rating,
        comment: review.comment || 'Aucun commentaire',
        created_at: review.created_at,
        reviewer_id: review.reviewer_id,
        reviewer_name: review.profiles 
          ? `${review.profiles.first_name} ${review.profiles.last_name.charAt(0)}.`
          : 'Utilisateur',
        reviewer_avatar: review.profiles ? review.profiles.avatar_url : null
      }))
    },
    
    formatRating(rating) {
      return rating ? rating.toFixed(1) : '0.0'
    },
    
    formatCurrency(amount) {
      return amount ? `${amount.toLocaleString()} FCFA` : 'Prix non défini'
    },
    
    formatDate(dateString) {
      const date = new Date(dateString)
      return new Intl.DateTimeFormat('fr-FR', {
        day: 'numeric',
        month: 'long',
        year: 'numeric'
      }).format(date)
    },
    
    contactExpert() {
      // Navigate to contact page or open chat
      this.$router.push(`/experts/${this.expert.id}/contact`)
    }
  }
}
</script>

<style scoped>
main {
  max-width: 600px;
  margin: 0 auto;
  padding-bottom: 80px;
}

.profile-header {
  padding: var(--space-md);
  display: flex;
  align-items: center;
  border-bottom: 1px solid var(--border-color);
}

.back-button {
  margin-right: var(--space-md);
  cursor: pointer;
  width: 36px;
  height: 36px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.back-button:hover {
  background-color: var(--bg-secondary);
}

.profile-hero {
  display: flex;
  padding: var(--space-lg);
  border-bottom: 1px solid var(--border-color);
}

.avatar-large {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  overflow: hidden;
  margin-right: var(--space-lg);
  flex-shrink: 0;
}

.avatar-large img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.profile-info {
  flex: 1;
}

.name-and-badge {
  display: flex;
  align-items: center;
  margin-bottom: var(--space-xs);
}

.verification-badge {
  color: var(--accent-color);
}
</style>