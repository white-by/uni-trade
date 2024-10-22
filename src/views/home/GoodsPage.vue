<script setup>
import { ref, onMounted, watch } from 'vue'
import { getGoodsListAPI } from '@/api/goods.js'
import { useCategoryStore } from '@/store/sortCategory'

const goodsList = ref([])
const categoryStore = useCategoryStore()

const getGoodsList = async () => {
  const res = await getGoodsListAPI(categoryStore.categoryID, 12) // 使用 store 中的 categoryID
  console.log('目前参数为：', categoryStore.categoryID)
  goodsList.value = res.data
}

// 监听 categoryID 的变化，重新调用 getGoodsList
watch(
  () => categoryStore.categoryID,
  () => {
    getGoodsList()
  }
)

onMounted(() => {
  getGoodsList()
})
</script>

<template>
  <div class="product-container">
    <el-row :gutter="20" class="product-row">
      <el-col :span="4" v-for="product in goodsList.data" :key="product.id">
        <el-card shadow="hover" class="product-card">
          <!-- 接口返回值的图片地址是随便写的，所以这里目前不会渲染图片 -->
          <img :src="product.picture" class="product-image" />
          <div class="product-info">
            <h3 class="product-title">{{ product.name }}</h3>
            <p class="product-price">￥{{ product.price }}</p>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<style scoped>
.product-container {
  padding-left: 60px;
  padding-right: 60px;
}

.product-card {
  text-align: center;
  padding: 10px;
  margin-top: 20px;
  margin-bottom: 20px;
  margin-left: 10px;
  margin-right: 10px;
}

.product-image {
  width: 100%;
  height: 150px;
  object-fit: cover;
}

.product-info {
  margin-top: 10px;
}

.product-title {
  font-size: 16px;
  margin: 5px 0;
}

.product-price {
  font-size: 18px;
  color: #f56c6c;
}
</style>
