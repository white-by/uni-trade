<script setup></script>

<template>
  <div class="profile-container">
    <router-link to="/profiles/published">
      <el-button
        type="primary"
        round
        plain
        class="first-button"
        :class="{ active: $route.path === '/profiles/published' }"
      >
        已发布
      </el-button>
    </router-link>
    <router-link to="/profiles/finished">
      <el-button type="primary" round plain :class="{ active: $route.path === '/profiles/finished' }">
        已完成
      </el-button>
    </router-link>
    <router-link to="/profiles/comment">
      <el-button type="primary" round plain :class="{ active: $route.path === '/profiles/comment' }">
        交易评价
      </el-button>
    </router-link>
  </div>
</template>

<style scoped lang="scss">
.profile-container {
  background-color: #f9f9f9; /* 空白背景 */
  width: 70%;
  margin: 0 auto; /* 水平居中 */
  padding: 20px; /* 内边距 */
  border-radius: 10px; /* 圆角 */
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); /* 阴影效果 */
  margin-top: 3%;
}
.el-button {
  margin-right: 30px;
}
.first-button {
  margin-left: 20px;
}
.active {
  background-color: $comColor; /* 选中时的背景颜色 */
  color: white; /* 选中时的文字颜色 */
  border-color: $comColor;
}
</style>
