<script setup>
import { ref } from 'vue'
import ProfilesNav from './components/ProfilesNav.vue'

// 示例评论数据
const comments = ref([
  {
    commentID: 1,
    goodsID: 99,
    commentatorID: 201,
    commentatorName: '用户A',
    commentatorAvatar: 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png',
    commentContent: '这个商品真不错！',
    commentTime: new Date(Date.now() - 3600 * 1000 * 2) // 2小时前
  },
  {
    commentID: 2,
    goodsID: 99,
    commentatorID: 202,
    commentatorName: '用户B',
    commentatorAvatar: 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png',
    commentContent:
      '老人小孩都爱吃！ps://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.pngps://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.pngps://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.pngps://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.pngps://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.pngps://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.pngps://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png',
    commentTime: new Date(Date.now() - 3600 * 1000 * 48) // 2天前
  },
  {
    commentID: 3,
    goodsID: 99,
    commentatorID: 202,
    commentatorName: '用户C',
    commentatorAvatar: 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png',
    commentContent: '不想写了，我好想打牌阿😭😭',
    commentTime: new Date(Date.now() - 360000 * 1000 * 48) // 2天前
  }
])

const timeAgo = (time) => {
  const now = new Date()
  const seconds = Math.floor((now - time) / 1000)
  const minutes = Math.floor(seconds / 60)
  const hours = Math.floor(seconds / 3600)
  const days = Math.floor(seconds / 86400)
  const months = Math.floor(days / 30) // 假设每个月30天
  const years = Math.floor(days / 365) // 假设每年365天

  if (seconds < 60) return `${seconds} 秒前`
  if (minutes < 60) return `${minutes} 分钟前`
  if (hours < 24) return `${hours} 小时前`
  if (days < 30) return `${days} 天前`
  if (months < 12) return `${months} 个月前`
  return `${years} 年前`
}
</script>

<template>
  <div class="profile-container">
    <div class="nav">
      <ProfilesNav />
    </div>
    <div class="comment-container">
      <div v-for="comment in comments" :key="comment.commentID" class="comment-item">
        <el-avatar :src="comment.commentatorAvatar" class="avatar" />
        <div class="comment-details">
          <div class="comment-header">
            <span class="commentator-name">{{ comment.commentatorName }}</span>
            <span class="comment-time">{{ timeAgo(comment.commentTime) }}</span>
          </div>
          <p class="comment-content">{{ comment.commentContent }}</p>
          <router-link :to="`/detail/${comment.goodsID}`" class="view-product"> 查看商品 </router-link>
          <!-- <el-divider class="div" /> -->
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped lang="scss">
.profile-container {
  background-color: #ffffff; /* 空白背景 */
  width: 70%;
  min-height: 50vh;
  margin: 0 auto; /* 水平居中 */
  border-radius: 10px; /* 圆角 */
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); /* 阴影效果 */
  margin-top: 1%;
  margin-bottom: 3%;
}
.comment-container {
  padding: 20px; /* 内边距 */
}

.comment-item {
  display: flex;
  margin-bottom: 15px;
  padding: 10px;
  border-radius: 8px; /* 评论框圆角 */
}

.avatar {
  width: 50px;
  height: 50px;
  border-radius: 50%; /* 圆形头像 */
  margin-left: 15px;
  margin-right: 25px;
}

.comment-details {
  flex: 1;
}

.comment-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.commentator-name {
  font-size: 15px;
  font-weight: bold;
  margin-bottom: 10px;
}

.comment-time {
  font-size: 0.9em;
  color: #999;
  margin-right: 10px;
}

.comment-content {
  margin: 5px 0;
  word-break: break-all; /* 强制在任何字符之间换行 */
  word-wrap: break-word; /* 允许长单词换行 */
  margin-right: 20px;
}

.view-product {
  color: $comColor; /* 确保 $comColor 定义在你的样式中 */
  text-decoration: none;
}
.view-product:hover {
  color: $helpColor;
}

.div {
  width: 100%; /* 设置宽度为100% */
  margin: 20px 0; /* 可选：设置上下边距 */
}
</style>
