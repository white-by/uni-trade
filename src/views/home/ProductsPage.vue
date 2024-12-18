<script setup>
import UserNav from '@/components/UserNav.vue'
import ProductsHeader from './ProductsHeader.vue'
import ProductsDisplay from './ProductsDisplay.vue'
// import UserFooter from '@/components/UserFooter.vue'
import { useCategoryStore } from '@/store/sortCategory'
import { onMounted } from 'vue'

//将分类数据存入pinia，供此页面所有组件使用，避免重复发送api请求
const categoryStore = useCategoryStore()
onMounted(() => categoryStore.getCategory())
</script>

<template>
  <div>
    <UserNav />
    <ProductsHeader />
    <ProductsDisplay />
  </div>
</template>
