<template>
  <div class="">
    <h1>这是测试页面</h1>
    <br />
  </div>
</template>

<script setup>
import { getPurchasedDataAPI } from '@/api/order'
import { onMounted } from 'vue'

const getPurchasedData = async () => {
  const res = await getPurchasedDataAPI(1, 1, 5)
  console.log('API响应:', res.data.data)
}

onMounted(() => {
  getPurchasedData()
})
</script>

<style scoped lang="scss"></style>
