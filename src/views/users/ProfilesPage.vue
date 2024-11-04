<script setup>
import UserNav from '@/components/UserNav.vue'
import ProfilesTop from './components/ProfilesTop.vue'
// import ProfilesNav from './components/ProfilesNav.vue'
import { RouterView } from 'vue-router'
import UserFooter from '@/components/UserFooter.vue'
</script>

<template>
  <UserNav />
  <ProfilesTop />
  <!-- <ProfilesNav /> -->
  <RouterView />
  <UserFooter />
</template>

<style scoped></style>
