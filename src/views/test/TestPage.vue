<script setup>
import { getUsersListApi } from '@/api/usersInfo'
import { ref } from 'vue'
const queryForm = ref({
  pageNum: 1,
  pageSize: 5
})

const usersList = ref([])

const getUsersList = async () => {
  const res = await getUsersListApi(queryForm.value)

  usersList.value = res.data.data.usersList
  console.log(usersList.value)
  console.log(res.data)
}

getUsersList()
</script>

<template>
  <div class="">
    <el-table :data="usersList" border>
      <el-table-column label="用户名" prop="userName" align="center"></el-table-column>
      <el-table-column label="头像" align="center">
        <template #default="{ row }">
          <img :src="row.avatarUrl" alt="头像" style="width: 80px" />
        </template>
      </el-table-column>
      <el-table-column label="性别" prop="gender" align="center">
        <template #default="{ row }">
          <span>{{ row.gender === 0 ? '女' : '男' }}</span>
        </template>
      </el-table-column>
      <el-table-column label="学校" prop="school" align="center"></el-table-column>
      <el-table-column label="邮箱" prop="mail" align="center"></el-table-column>
      <el-table-column label="电话" prop="tel" align="center"></el-table-column>
      <el-table-column label="用户状态" prop="userStatus" align="center">
        <template #default="{ row }">
          <el-tag :type="row.userStatus === 0 ? 'success' : 'danger'" style="font-size: 14px; padding: 15px 17px">
            {{ row.userStatus === 0 ? '正常' : '异常' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center">
        <template #default="{ row }">
          <el-row type="flex" justify="center" :gutter="10">
            <el-button @click="editUser(row)" type="primary">编辑</el-button>
            <el-button @click="deleteUser(row.userID)" type="danger">删除</el-button>
          </el-row>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<style scoped></style>
