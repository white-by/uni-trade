<script setup>
import UserNav from '@/components/UserNav.vue'
import LayoutHeader from './LayoutHeader.vue'
import UserFooter from '@/components/UserFooter.vue'
import { useCategoryStore } from '@/store/sortCategory'
import { onMounted } from 'vue'

const categoryStore = useCategoryStore()

onMounted(() => categoryStore.getCategory())
</script>

<template>
  <div>
    <UserNav />
    <LayoutHeader />
    <!--二级路由出口组件---->
    <RouterView />
    <UserFooter />
  </div>
</template>
