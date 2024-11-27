<script setup>
import { ref } from 'vue'

// 定义公告数据
const announcements = ref([
  {
    id: 1,
    date: '2024-05-15',
    title: '公告标题 1',
    content:
      '这里是公告内容 1，公告内容 1，公告内容 1，公告内容 1，公告内容 1，公告内容 1，公告内容 1，公告内容 1；这里是公告内容 1，公告内容 1，公告内容 1，公告内容 1，公告内容 1，公告内容 1，公告内容 1，公告内容 1'
  },
  {
    id: 2,
    date: '2024-05-14',
    title: '公告标题 2',
    content: '这里是公告内容 2，公告内容 2，公告内容 2，公告内容 2，公告内容 2，公告内容 2，公告内容 2，公告内容 2'
  },
  {
    id: 3,
    date: '2024-05-13',
    title: '公告标题 3',
    content: '这里是公告内容 3，公告内容 3，公告内容 3，公告内容 3，公告内容 3，公告内容 3，公告内容 3，公告内容 3'
  }
])
</script>

<template>
  <div class="announcement-board">
    <!-- 使用时间轴展示公告 -->
    <el-timeline>
      <el-timeline-item v-for="item in announcements" :key="item.id" :timestamp="item.date" placement="top">
        <el-card>
          <h4>{{ item.title }}</h4>
          <!-- 展示公告内容 -->
          <br />
          <p>{{ item.content }}</p>
        </el-card>
      </el-timeline-item>
    </el-timeline>
  </div>
</template>

<style scoped>
.announcement-board {
  margin: 30px;
}

.el-button {
  padding: 0;
  font-size: 12px;
}
</style>
