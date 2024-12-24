<script setup>
import { ref, onMounted, watch } from 'vue'
import { getProductsListAPI } from '@/api/products.js'
import { useCategoryStore } from '@/store/sortCategory'
import { useSearchStore } from '@/store/searchStore'
import { useSelectStore } from '@/store/selectStore'
import { ElMessage } from 'element-plus'

const productsList = ref([]) // 商品列表
const categoryStore = useCategoryStore() // 分类状态
const searchStore = useSearchStore() // 搜索状态
const selectStore = useSelectStore()

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

    if (res.data.data == null || res.data.data.length < pageSize.value) {
      hasMoreData.value = false // 没有更多数据了
    }

    if (res.data.data != null) {
      productsList.value.push(...res.data.data) // 追加新数据
      currentPage.value += 1 // 加载下一页
    }
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

// 字段映射方法
const mapSelectDataToProducts = (selectData) => {
  return selectData.map((item) => {
    return {
      id: item.id,
      name: item.title,
      price: item.price,
      picture: item.imageUrl
    }
  })
}

// 监听selectStore中的selectData变化
watch(
  () => selectStore.selectData,
  (newSelectData) => {
    if (newSelectData && newSelectData.length > 0) {
      productsList.value = mapSelectDataToProducts(newSelectData) // 手动映射数据
      hasMoreData.value = false // 停止无限滚动
    } else {
      productsList.value = []
      hasMoreData.value = false
    }
  },
  () => {
    resetListState() // 重置列表状态（例如清空已有数据、重置分页等）
    getProductsList() // 重新获取商品列表
  },
  { deep: true }
)
</script>

<template>
  <div
    v-infinite-scroll="getProductsList"
    infinite-scroll-distance="20"
    class="product-container"
    v-if="productsList.length > 0"
  >
    <el-row :gutter="20" class="product-row">
      <el-col :span="4" v-for="product in productsList" :key="product.id">
        <div class="product-card">
          <RouterLink :to="`/detail/${product.id}`" class="product-link">
            <img :src="getFirstImageURL(product.picture)" class="product-image" />
            <div class="product-info">
              <h3 class="product-title" :title="product.name">{{ product.name }}</h3>
              <p class="product-price">￥{{ product.price }}</p>
              <div class="seller-info">
                <div class="seller-left">
                  <img :src="product.sellerPic" alt="卖家头像" class="seller-avatar" />
                  <span class="seller-name">{{ product.sellerName }}</span>
                </div>
                <div class="seller-right">
                  <p v-if="product.deliveryMethod === 0">无需快递</p>
                  <p v-else-if="product.deliveryMethod === 1">自提</p>
                  <p v-else>邮寄</p>
                </div>
              </div>
            </div>
          </RouterLink>
        </div>
      </el-col>
    </el-row>
    <el-backtop :right="50" :bottom="80" :target="'.product-container'" />
  </div>

  <!-- 没有商品时显示 -->
  <div v-else class="no-product-container">
    <img src="@/assets/images/none/暂无商品.png" alt="暂无商品" class="no-product-image" />
  </div>
</template>

<style scoped>
.product-container {
  padding-left: 60px;
  padding-right: 60px;
  padding-top: 20px;
  /* height: 820px; */
  /* height: 100%; */
  overflow-y: auto;
  min-height: 600px;
  height: calc(100vh - 125px);
}

.product-card {
  margin: 20px;
  border: 1px solid #e0e0e0; /* 添加边框 */
  background-color: white;
  border-radius: 8px; /* 圆角 */
  overflow: hidden; /* 防止内容溢出边框 */
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1); /* 阴影效果 */
  transition: transform 0.3s, box-shadow 0.3s; /* 悬停时的动画效果 */
}

.product-card:hover {
  transform: translateY(-5px); /* 悬停时轻微上移 */
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.2); /* 增加阴影 */
}

.product-image {
  width: 100%;
  height: 200px;
  object-fit: cover;
  display: block;
}

.product-info {
  padding: 12px;
}

.product-title {
  font-size: 18px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  margin: 0 0 5px;
}

.product-price {
  font-size: 22px;
  color: #f56c6c;
  font-weight: 700;
}

.seller-info {
  display: flex;
  justify-content: space-between; /* 左右对齐 */
  align-items: center; /* 垂直居中 */
  margin-top: 13px; /* 与价格的间距 */
}

.seller-left {
  display: flex;
  align-items: center; /* 垂直居中 */
}

.seller-right {
  color: #888a8e;
}

.seller-avatar {
  width: 24px; /* 头像大小 */
  height: 24px;
  border-radius: 50%; /* 圆形头像 */
  margin-right: 8px; /* 头像和卖家姓名之间的间距 */
}

.seller-name {
  font-size: 14px; /* 卖家姓名字体大小 */
  color: #606266; /* 默认颜色 */
  max-width: 80px; /* 限制姓名长度 */
  white-space: nowrap; /* 单行显示 */
  overflow: hidden; /* 超出隐藏 */
  text-overflow: ellipsis; /* 超出显示省略号 */
}

.free-shipping-icon {
  width: 40px; /* 包邮图片宽度 */
  height: auto; /* 保持比例 */
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
