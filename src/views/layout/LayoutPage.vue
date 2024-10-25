<script setup>
import LayoutNav from './components/LayoutNav.vue'
import LayoutHeader from './components/LayoutHeader.vue'
import LayoutFooter from './components/LayoutFooter.vue'
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
    <LayoutFooter />
  </div>
</template>
