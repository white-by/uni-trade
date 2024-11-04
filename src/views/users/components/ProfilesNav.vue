<script setup></script>

<template>
  <div class="container">
    <el-menu :default-active="activeIndex" mode="horizontal" @select="menuSelect">
      <el-menu-item index="1" :class="{ active: $route.path === '/profiles/published' || $route.path === '/profiles' }">
        <router-link to="/profiles/published"> 已发布</router-link></el-menu-item
      >
      <el-menu-item index="2" :class="{ active: $route.path === '/profiles/finished' }"
        ><router-link to="/profiles/finished">已完成</router-link></el-menu-item
      >
      <el-menu-item index="3" :class="{ active: $route.path === '/profiles/comment' }">
        <router-link to="/profiles/comment">交易评价</router-link></el-menu-item
      >
    </el-menu>
  </div>
</template>

<style scoped lang="scss">
.container {
  width: auto;
}

.active {
  background-color: white; /* 选中时的背景颜色 */
  color: $comColor; /* 选中时的文字颜色 */
  border-color: $comColor;
}
</style>
