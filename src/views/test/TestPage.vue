<script setup>
import { ref, onMounted, onUnmounted } from 'vue'

// 控制弹窗可见性
const dialogTableVisible = ref(false)
// 模拟是否有新公告
const hasNewAnnouncement = ref(false)
// 保存公告列表
const announcements = ref([])

// SSE 实例
let eventSource = null

// 打开弹窗的方法
const openDialog = () => {
  dialogTableVisible.value = true
  markAsRead() // 打开弹窗时标记为已读
}

// 标记公告为已读
const markAsRead = () => {
  hasNewAnnouncement.value = false
  localStorage.setItem('hasNewAnnouncement', 'false')
}

// 恢复新公告状态
const checkNewAnnouncement = () => {
  const storedAnnouncements = localStorage.getItem('announcements')
  const storedStatus = localStorage.getItem('hasNewAnnouncement')

  if (storedAnnouncements) {
    announcements.value = JSON.parse(storedAnnouncements)
  }

  hasNewAnnouncement.value = storedStatus === 'true'
}

onMounted(() => {
  checkNewAnnouncement() // 页面加载时恢复公告和红点状态

  // 连接到 SSE 服务端
  eventSource = new EventSource('http://127.0.0.1:5000/sse/announcements')

  // 接收新公告
  eventSource.onmessage = (event) => {
    try {
      const data = JSON.parse(event.data)
      if (Array.isArray(data)) {
        announcements.value = data
        localStorage.setItem('announcements', JSON.stringify(data)) // 持久化公告数据

        // 只有当对话框未打开时，才显示红点
        if (!dialogTableVisible.value && data.length > 0) {
          hasNewAnnouncement.value = true
          localStorage.setItem('hasNewAnnouncement', 'true') // 更新新公告状态
        }
      }
    } catch (error) {
      console.error('Error parsing SSE data:', error)
    }
  }

  // 处理 SSE 错误
  eventSource.onerror = () => {
    console.error('SSE 连接出错，尝试重新连接...')
    eventSource.close()
  }
})

onUnmounted(() => {
  if (eventSource) {
    eventSource.close()
  }
})
</script>

<template>
  <br /><br />

  <!-- 公告图标，带红点提示 -->
  <el-badge is-dot :hidden="!hasNewAnnouncement">
    <a href="javascript:;" @click="openDialog">
      <i class="iconfont icon-announcement" style="font-size: 24px"></i>
    </a>
  </el-badge>

  <!-- 公告弹窗 -->
  <el-dialog v-model="dialogTableVisible" title="公告栏" width="800px">
    <div class="announcement-board">
      <el-timeline>
        <el-timeline-item v-for="item in announcements" :key="item.id" :timestamp="item.date" placement="top">
          <el-card>
            <h4>{{ item.title }}</h4>
            <br />
            <p>{{ item.content }}</p>
          </el-card>
        </el-timeline-item>
      </el-timeline>
    </div>
  </el-dialog>
</template>

<style scoped>
.announcement-board {
  margin: 30px;
}
</style>
