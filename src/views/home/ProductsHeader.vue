<script setup>
import PostProduct from '@/components/PostProduct.vue'
import SelectProduct from '@/components/SelectProduct.vue'
import { useCategoryStore } from '@/store/sortCategory'
import { ref } from 'vue'

const categoryStore = useCategoryStore()
const selectedCategoryID = ref(0)

const handleCategoryClick = (categoryID) => {
  categoryStore.setCategoryID(categoryID)
  // console.log('点击了分类：', categoryID)
  selectedCategoryID.value = categoryID
}
</script>

<template>
  <header class="app-header">
    <div class="container">
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
      <div class="function-button-container">
        <SelectProduct />
        <PostProduct />
      </div>
    </div>
  </header>
</template>

<style scoped lang="scss">
.app-header {
  background: rgba(255, 255, 255, 0.8);
  padding-top: 10px; /* 调整整个按钮组与上边界的距离 */
  height: 60px;

  .container {
    display: flex;
    align-items: center;
    justify-content: space-between; /* 左右两侧内容分别对齐 */
    width: 100%; /* 容器宽度占满 */
    padding: 0 50px; /* 增加一些内边距，避免内容紧贴两侧 */
  }

  .app-header-nav {
    display: flex;
    align-items: center; /* 垂直居中对齐 */
    gap: 20px; /* 按钮之间的间距 */
    border-radius: 10px;
  }

  .app-header-nav .el-button.active {
    background-color: $comColor; /* 选中时的背景颜色 */
    color: white; /* 选中时的文字颜色 */
    border-color: $comColor;
  }

  .function-button-container {
    margin-left: auto;
    display: flex;
    gap: 10px;
  }
}
</style>
