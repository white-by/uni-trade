<script setup>
import LayoutNav from './components/LayoutNav.vue'
import LayoutHeader from './components/LayoutHeader.vue'
import UserFooter from '@/components/UserFooter.vue'
import { useCategoryStore } from '@/store/sortCategory'
import { onMounted } from 'vue'

const categoryStore = useCategoryStore()

onMounted(() => categoryStore.getCategory())
</script>

<template>
  <div>
    <LayoutNav />
    <LayoutHeader />
    <!--二级路由出口组件---->
    <RouterView />
    <UserFooter />
  </div>
</template>
