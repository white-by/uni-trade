<script setup></script>

<template>
  <nav class="app-topnav">
    <div class="container">
      <div class="logo">
        <RouterLink to="/">校园二手交易站</RouterLink>
      </div>
      <div class="site-name">校园二手交易站</div>
    </div>
  </nav>
</template>

<style scoped lang="scss">
.container {
  padding: 0 50px;
  width: 100%;
  display: flex; /* 使用 flex 布局 */
  align-items: center; /* 垂直居中对齐 */
  height: 63px; /* 确保整个导航的高度一致 */
}

.logo {
  display: flex;
  align-items: center;

  a {
    display: block;
    height: 50px; /* 根据需要调整 */
    width: 50px; /* 根据需要调整 */
    background: url('@/assets/images/logo.png') no-repeat center / contain; /* 确保 logo 显示 */
    text-indent: -9999px; /* 隐藏文本 */
  }
}

.site-name {
  font-size: 20px;
  color: #ffffff; /* 白色字体 */
  margin-left: 10px; /* 使文字与 logo 保持距离 */
  font-weight: bold;
}

.app-topnav {
  background: #333;
}
</style>
