<template>
  <header class="app-header">
    <div class="category-container">
      <ul class="app-header-nav">
        <el-button
          type="primary"
          plain
          round
          :class="{ active: selectedCategoryID === 0 }"
          @click="handleCategoryClick(0)"
        >
          全部
        </el-button>

        <el-button
          v-for="category in categoryStore.categoryList.data"
          :key="category.categoryID"
          type="primary"
          plain
          round
          :class="{ active: selectedCategoryID === category.categoryID }"
          @click="handleCategoryClick(category.categoryID)"
        >
          {{ category.categoryName }}
        </el-button>
      </ul>
    </div>

    <!-- 筛选按钮和发布闲置 -->
    <div class="function-button-container">
      <SelectProduct />
      <PostProduct />
    </div>
  </header>
</template>

<script setup>
import PostProduct from '@/components/PostProduct.vue'
import SelectProduct from '@/components/SelectProduct.vue'
import { useCategoryStore } from '@/store/sortCategory'
import { ref } from 'vue'

// 分类状态
const categoryStore = useCategoryStore()
// 当前选中的分类ID
const selectedCategoryID = ref(categoryStore.categoryID)

// 点击分类
const handleCategoryClick = (categoryID) => {
  categoryStore.setCategoryID(categoryID)
  selectedCategoryID.value = categoryID
}

// onMounted(() => {
//   console.log('selectedCategoryID:', selectedCategoryID.value)
// })
</script>

<style scoped lang="scss">
.app-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: rgba(255, 255, 255, 0.8);
  padding: 10px 20px;
  position: relative; /* 确保相对定位 */
}

.category-container {
  flex: 1; /* 左侧占据剩余空间 */
  overflow-x: auto; /* 横向滚动 */
  white-space: nowrap; /* 防止按钮换行 */
}

.app-header-nav {
  display: flex;
  align-items: center;
  gap: 10px;
}

.app-header-nav .el-button.active {
  background-color: $comColor;
  color: white;
  border-color: $comColor;
}

.function-button-container {
  position: sticky; /* 固定在页面右侧 */
  margin-left: 40px;
  margin-right: 10px;
  display: flex;
  align-items: center;
  gap: 10px;
  z-index: 10; /* 确保位于滚动分类按钮之上 */
}
</style>
