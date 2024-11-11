<script setup>
import UserNav from '@/components/UserNav.vue'
import ProfilesTop from './components/ProfilesTop.vue'
import { RouterView } from 'vue-router'
import { onMounted } from 'vue'
import UserFooter from '@/components/UserFooter.vue'
import { useCategoryStore } from '@/store/sortCategory'
import { useProfilesStore } from '@/store/profilesStore'

const categoryStore = useCategoryStore()
const profilesStore = useProfilesStore()

onMounted(() => {
  categoryStore.getCategory(),
    profilesStore.getIntroduction(),
    profilesStore.getPublishedProducts(),
    profilesStore.getFinishedProducts(),
    profilesStore.getComments()
})
</script>

<template>
  <UserNav />
  <ProfilesTop />
  <RouterView />
  <UserFooter />
</template>

<style scoped></style>
