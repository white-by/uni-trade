<script setup>
import { ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useProfilesStore } from '@/store/profilesStore'

const profilesStore = useProfilesStore()

const route = useRoute()
const router = useRouter()
const activeIndex = ref('')

// 根据当前路径设置激活的导航项
const setActiveIndex = (path) => {
  const userIdPattern = new RegExp(`/profiles/\\d+/(\\w+)$`)
  console.log('userIdPattern', userIdPattern)

  const match = path.match(userIdPattern)
  console.log('match', match)

  if (match) {
    const subPath = match[1] // 提取路径的最后部分
    if (subPath === 'published') {
      activeIndex.value = '1'
    } else if (subPath === 'finished') {
      activeIndex.value = '2'
    } else if (subPath === 'receivedComment') {
      activeIndex.value = '3'
    } else if (subPath === 'givenComment') {
      activeIndex.value = '4'
    }
  }
}

// 监听路由路径变化，动态更新导航状态
watch(
  () => route.path,
  (newPath) => {
    setActiveIndex(newPath)
  },
  { immediate: true }
)

// 监听用户信息加载完成
watch(
  () => profilesStore.introduction.userID,
  (newUserID) => {
    if (newUserID) {
      setActiveIndex(route.path)
    }
  }
)

// 切换导航项
function menuSelect(index) {
  activeIndex.value = index
  const userID = profilesStore.introduction.userID // 获取当前用户ID
  console.log('当前userID:', userID)
  if (index === '1') {
    router.push(`/profiles/${userID}/published`)
  } else if (index === '2') {
    router.push(`/profiles/${userID}/finished`)
  } else if (index === '3') {
    router.push(`/profiles/${userID}/receivedComment`)
  } else if (index === '4') {
    router.push(`/profiles/${userID}/givenComment`)
  }
}
</script>

<template>
  <div class="container">
    <el-menu :default-active="activeIndex" mode="horizontal" @select="menuSelect">
      <el-menu-item index="1">
        <router-link :to="`/profiles/${profilesStore.introduction.userID}/published`">发布中</router-link>
      </el-menu-item>
      <el-menu-item index="2">
        <router-link :to="`/profiles/${profilesStore.introduction.userID}/finished`">已完成</router-link>
      </el-menu-item>
      <el-menu-item index="3">
        <router-link :to="`/profiles/${profilesStore.introduction.userID}/receivedComment`">收到的评价</router-link>
      </el-menu-item>
      <el-menu-item index="4">
        <router-link :to="`/profiles/${profilesStore.introduction.userID}/givenComment`">发布的评价</router-link>
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
