<template>
  <div class="container">
    <div class="icon">
      <!-- 😢 -->
      <img src="@/assets/images/logo2.png" alt="logo" class="logo" />
    </div>
    <h1>404</h1>
    <p>抱歉，页面走丢了！您可以返回首页继续浏览。</p>
    <el-button type="primary" @click="toHome" size="large">进入首页</el-button>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'

const router = useRouter()

// 返回首页方法
const toHome = () => {
  router.push('/') // 跳转到首页
}
</script>

<style scoped>
/* Logo 样式 */
.logo {
  width: 100px;
  height: auto;
}

.container {
  background-color: #f5f5f5;
  text-align: center;
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
  height: 100vh;
  font-family: Arial, sans-serif;
  color: #333;
}

h1 {
  font-size: 10rem;
  margin: 0;
}

p {
  font-size: 1.5rem;
  margin: 20px 0;
}

/* 动画效果 */
@keyframes float {
  0%,
  100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-40px);
  }
}

.icon {
  font-size: 6rem;
  animation: float 3s ease-in-out infinite;
}
</style>
