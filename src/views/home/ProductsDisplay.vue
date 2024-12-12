<script setup>
import { ref, onMounted, watch } from 'vue'
import { getProductsListAPI } from '@/api/products.js'
import { useCategoryStore } from '@/store/sortCategory'
import { useSearchStore } from '@/store/searchStore'
import { ElMessage } from 'element-plus'

const productsList = ref([]) // 商品列表
const categoryStore = useCategoryStore() // 分类状态
const searchStore = useSearchStore() // 搜索状态

const currentPage = ref(1) // 当前页码
const pageSize = ref(12) // 每页条数
const isLoading = ref(false) // 是否正在加载
const hasMoreData = ref(true) // 是否还有更多数据

// 获取第一张图片URL
const getFirstImageURL = (imageURL) => {
  return imageURL ? imageURL.split(',')[0] : ''
}

// 重置列表状态
const resetListState = () => {
  productsList.value = []
  currentPage.value = 1
  hasMoreData.value = true
}

// 获取商品列表
const getProductsList = async () => {
  if (isLoading.value || !hasMoreData.value) return

  isLoading.value = true
  try {
    const res = await getProductsListAPI(
      categoryStore.categoryID,
      currentPage.value,
      pageSize.value,
      searchStore.searchQuery
    )

    if (res.data.code === 1 && searchStore.searchQuery) {
      ElMessage.success('搜索成功')
    }

    if (res.data.data.length < pageSize.value) {
      hasMoreData.value = false // 没有更多数据了
    }

    productsList.value.push(...res.data.data) // 追加新数据
    currentPage.value += 1 // 加载下一页
  } catch (error) {
    console.error('获取商品列表失败:', error)
  } finally {
    isLoading.value = false
  }
}

// 监听分类变化
watch(
  () => categoryStore.categoryID,
  () => {
    resetListState()
    getProductsList()
  }
)

// 监听搜索内容变化
watch(
  () => searchStore.searchQuery,
  () => {
    resetListState() // 重置列表状态（例如清空已有数据、重置分页等）
    getProductsList() // 重新获取商品列表
  }
)

// 初始化加载
onMounted(() => {
  getProductsList()
})
</script>

<template>
  <div
    v-infinite-scroll="getProductsList"
    infinite-scroll-disabled="false"
    infinite-scroll-distance="20"
    class="product-container"
    v-if="productsList.length > 0"
  >
    <el-row :gutter="20" class="product-row">
      <el-col :span="4" v-for="product in productsList" :key="product.id">
        <el-card shadow="hover" class="product-card">
          <RouterLink :to="`/detail/${product.id}`">
            <img :src="getFirstImageURL(product.picture)" class="product-image" />
            <div class="product-info">
              <h3 class="product-title">{{ product.name }}</h3>
              <p class="product-price">￥{{ product.price }}</p>
            </div>
          </RouterLink>
        </el-card>
      </el-col>
    </el-row>
    <el-backtop :right="100" :bottom="100" />
  </div>
  <div v-else class="no-product-container">
    <img src="@/assets/images/none/暂无商品.png" alt="暂无商品" class="no-product-image" />
  </div>
</template>

<style scoped>
.product-container {
  padding-left: 60px;
  padding-right: 60px;
  /* height: 700px; */
  overflow-y: auto;
  min-height: 600px;
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
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  margin: 5px 0;
}

.product-price {
  font-size: 18px;
  color: #f56c6c;
}

.no-product-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 600px;
}

.no-product-image {
  max-width: 100%;
  max-height: 100%;
}
</style>
