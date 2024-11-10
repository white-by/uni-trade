<template>
  <div v-if="userStore.userList.length">
    <el-table :data="userStore.usersList" style="width: 100%">
      <el-table-column prop="avatarUrl" label="头像" width="120">
        <template #default="scope">
          <img :src="scope.row.avatarUrl" alt="avatar" class="avatar" />
        </template>
      </el-table-column>

      <el-table-column prop="userName" label="用户名" width="150" />
      <el-table-column prop="mail" label="邮箱" width="200" />
      <el-table-column prop="tel" label="电话" width="150" />

      <el-table-column prop="gender" label="性别" width="100">
        <template #default="scope">
          {{ scope.row.gender === 0 ? '女' : '男' }}
        </template>
      </el-table-column>

      <el-table-column prop="status" label="状态" width="100">
        <template #default="scope">
          {{ scope.row.status === 1 ? '活跃' : '禁用' }}
        </template>
      </el-table-column>

      <el-table-column prop="school" label="学校ID" width="100" />

      <el-table-column label="操作" width="150">
        <template #default="scope">
          <el-button type="primary" size="small" @click="editUser(scope.row)">编辑</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>

  <div v-else>
    <!-- 没有数据时的显示 -->
    <p>No data available</p>
  </div>
</template>

<script setup>
import { useUserStore } from '@/store/userStore'
import { onMounted } from 'vue'

// 获取 Pinia store
const userStore = useUserStore()

onMounted(() => {
  // 每次页面刷新时请求数据
  userStore.getUsersList()
})
</script>

<style scoped lang="scss">
.avatar {
  width: 100px;
  height: 100px;
  border-radius: 50%;
  margin-bottom: 10px;
}
</style>
