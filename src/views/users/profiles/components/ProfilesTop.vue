<script setup>
import { computed, onMounted } from 'vue'
import axios from 'axios'
import { useProfilesStore } from '@/store/profilesStore'

const profilesStore = useProfilesStore()

const genderText = computed(() => {
  // 避免加载时显示男
  if (profilesStore.introduction.gender === '0') return '女'
  else if (profilesStore.introduction.gender === '1') return '男'
  else return null
  // return profilesStore.introduction.gender === '0' ? '女' : '男'
})

async function fetchAvatar() {
  try {
    const response = await axios.get('https://dog.ceo/api/breeds/image/random')
    profilesStore.introduction.avatarUrl = response.data.message // 更新头像 URL
  } catch (error) {
    profilesStore.introduction.avatarUrl = 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'
    console.error('获取头像失败:', error)
  }
}

onMounted(() => {
  fetchAvatar() // 在组件挂载后获取头像
})
</script>

<template>
  <div class="profile-container">
    <el-avatar :size="120" :src="profilesStore.introduction.avatarUrl" class="avatar" />
    <div class="info-column">
      <span>{{ profilesStore.introduction.userName }}</span>
      <span>{{ genderText }}</span>
      <span>{{ profilesStore.introduction.school }}</span>
    </div>
    <div class="profile-link">
      <router-link to="/user">
        <span>个人资料 >></span>
      </router-link>
    </div>
  </div>
</template>

<style scoped lang="scss">
.profile-container {
  display: flex; /* 使用 flexbox 布局 */
  align-items: center; /* 头像与右侧信息高度平衡 */
  background-color: #ffffff; /* 空白背景 */
  width: 70%;
  margin: 0 auto; /* 水平居中 */
  padding: 20px; /* 内边距 */
  border-radius: 10px; /* 圆角 */
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); /* 阴影效果 */
  margin-top: 3%;
  flex-wrap: wrap; /* 允许换行 */
  position: relative; /* 使其子元素可以使用绝对定位 */
}

.avatar {
  margin-right: 50px; /* 头像与信息框之间的间距 */
  margin-left: 20px;
}

.info-column {
  display: flex;
  flex-direction: column; /* 信息项垂直排列 */
}

.info-column span {
  margin-bottom: 10px;
}

.info-column span:nth-child(1) {
  font-size: 25px;
  font-weight: bold;
  margin-bottom: 25px;
}

.info-column span:nth-child(2) {
  font-size: 15px;
  color: #777; /* 性别颜色稍淡 */
}

.info-column span:nth-child(3) {
  font-size: 15px;
}

.profile-link {
  position: absolute; /* 绝对定位 */
  bottom: 25px; /* 距底部20px */
  right: 25px; /* 距右侧20px */
}
.profile-link span {
  color: $comColor; /* 链接颜色 */
  text-decoration: none; /* 去掉下划线 */
  transition: color 0.3s; /* 添加平滑过渡效果 */
}
.profile-link span:hover {
  color: $helpColor;
}
</style>
