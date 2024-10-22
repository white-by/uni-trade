<script setup>
import { getCategoryAPI } from '@/api/goods';
import { onMounted } from 'vue';

const getCategory = async() => {
  const res = await getCategoryAPI()
  console.log(res);
}

onMounted(() => {
  getCategory()
})
</script>

<template>
  <header class="app-header">
    <div class="container">
      <ul class="app-header-nav">
        <!-- 左侧按钮组 -->
        <el-button type="primary" plain round>全部</el-button>
        <el-button type="primary" plain round>日常用品</el-button>
        <el-button type="primary" plain round>数码产品</el-button>
        <el-button type="primary" plain round>二手教材</el-button>
      </ul>
      <!-- 右侧“发布闲置”按钮 -->
      <div class="release-button">
        <el-button size="large" type="primary" round>发布闲置</el-button>
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

  .release-button {
    margin-left: auto; /* 将右侧按钮推到最右边 */
    el-button {
      padding: 10px 30px; /* 发布按钮大小调整 */
      font-size: 16px; /* 发布按钮的字体大小 */
    }
  }
}
</style>
