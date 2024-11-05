<script setup>
import { ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()
const activeIndex = ref('')

// 根据当前路径设置激活的导航项
watch(
  () => route.path,
  (newPath) => {
    if (newPath === '/profiles/published' || newPath === '/profiles') {
      activeIndex.value = '1'
    } else if (newPath === '/profiles/finished') {
      activeIndex.value = '2'
    } else if (newPath === '/profiles/comment') {
      activeIndex.value = '3'
    }
  },
  { immediate: true }
)

// 切换导航项
function menuSelect(index) {
  activeIndex.value = index
  if (index === '1') {
    router.push('/profiles/published')
  } else if (index === '2') {
    router.push('/profiles/finished')
  } else if (index === '3') {
    router.push('/profiles/comment')
  }
}
</script>

<template>
  <div class="container">
    <el-menu :default-active="activeIndex" mode="horizontal" @select="menuSelect">
      <el-menu-item index="1">
        <router-link to="/profiles/published">已发布</router-link>
      </el-menu-item>
      <el-menu-item index="2">
        <router-link to="/profiles/finished">已完成</router-link>
      </el-menu-item>
      <el-menu-item index="3">
        <router-link to="/profiles/comment">交易评价</router-link>
      </el-menu-item>
    </el-menu>
  </div>
</template>

<style scoped lang="scss">
.container {
  width: auto;
}

.el-menu-item.is-active {
  background-color: white; /* 选中时的背景颜色 */
  color: $comColor; /* 选中时的文字颜色 */
  border-color: $comColor;
}
</style>
