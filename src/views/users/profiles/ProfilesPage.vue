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

const getIdFromUrl = () => {
  const url = window.location.pathname // 获取路径部分
  const segments = url.split('/') // 根据 / 分割路径
  return segments[2] // 假设 ID 是路径的第二个部分
}

onMounted(() => {
  const id = getIdFromUrl()
  if (id) {
    categoryStore.getCategory(),
      profilesStore.getIntroduction(id),
      profilesStore.getPublishedProducts(id),
      profilesStore.getFinishedProducts(id),
      profilesStore.getReceivedComments(id),
      profilesStore.getGivenComments(id)
  } else {
    console.error('未找到 ID 参数')
  }
})
</script>

<template>
  <UserNav />
  <ProfilesTop />
  <RouterView />
  <UserFooter />
</template>

<style scoped></style>
