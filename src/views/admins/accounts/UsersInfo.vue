<script setup>
import { ref, nextTick, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search } from '@element-plus/icons-vue'

import { getUsersListApi, addUserApi, editUserApi, deleteUserApi } from '@/api/usersInfo'

const queryForm = ref({
  searchQuery: '',
  pageNum: 1,
  pageSize: 5
})
const total = ref(0)
const usersList = ref([])

const getUsersList = async () => {
  // console.log('query: ', queryForm.value)
  const res = await getUsersListApi(queryForm.value)
  // console.log('res: ', res.data)
  usersList.value = res.data.data.usersList
  total.value = res.data.data.total
  // console.log('usersList: ', usersList.value)
}
onMounted(() => {
  getUsersList()
})

// 弹窗显示状态和标题
const dialogVisible = ref(false)
const dialogTitle = ref('编辑用户')

// 编辑表单数据
const userForm = ref({
  userID: '',
  userName: '',
  mail: '',
  tel: '',
  schoolName: '',
  gender: null,
  status: null
})

// 表单验证规则
const rules = {
  userName: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  mail: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入有效的邮箱地址', trigger: ['blur', 'change'] }
  ],
  tel: [
    { required: true, message: '请输入电话', trigger: 'blur' },
    { pattern: /^[0-9]+$/, message: '电话号码只能包含数字', trigger: 'blur' }
  ],
  schoolName: [{ required: true, message: '请输入学校全称', trigger: 'blur' }],
  gender: [{ required: true, message: '请选择性别', trigger: 'change' }],
  status: [{ required: true, message: '请选择用户状态', trigger: 'change' }]
}

// 表单引用
const formRef = ref(null)

// 打开新增用户表单
const openAddUserForm = () => {
  dialogTitle.value = '新增用户'
  userForm.value = {
    userID: '',
    userName: '',
    mail: '',
    tel: '',
    schoolName: '',
    gender: null,
    status: null
  }
  dialogVisible.value = true
  nextTick(() => formRef.value?.clearValidate())
}

// 在关闭弹窗时重置表单数据
const closeDialog = () => {
  dialogVisible.value = false
  // 重置表单数据为初始状态
  userForm.value = {
    userID: '',
    userName: '',
    mail: '',
    tel: '',
    schoolName: '',
    gender: null,
    status: null
  }
  formRef.value?.clearValidate()
}

// 编辑用户
const editUser = (user) => {
  dialogTitle.value = '编辑用户'
  userForm.value = { ...user }
  dialogVisible.value = true
  nextTick(() => formRef.value?.clearValidate())
}

const handlePageChange = (pageNum) => {
  queryForm.value.pageNum = pageNum
  getUsersList()
}

// 提交表单
// function submitEditForm() {
//   formRef.value.validate((valid) => {
//     if (valid) {
//       console.log('提交的表单数据:', editUserForm.value)
//       if (editUserForm.value.userID) {
//         const index = usersList.value.findIndex((user) => user.userID === editUserForm.value.userID)
//         if (index !== -1) {
//           usersList[index] = { ...editUserForm.value }
//           ElMessage.success('用户信息已更新')
//         }
//       } else {
//         const newUser = { ...editUserForm.value, userID: Date.now() }
//         usersList.value.push(newUser)
//         ElMessage.success('新增用户成功')
//       }
//       dialogVisible.value = false
//     } else {
//       console.log('表单校验失败')
//       return false
//     }
//   })
// }
const handleConfirm = async () => {
  formRef.value.validate(async (valid) => {
    if (valid) {
      console.log('提交的表单数据:', userForm.value)

      if (userForm.value.userID) {
        await editUserApi(userForm.value)
        ElMessage.success('用户信息已更新')
      } else {
        await addUserApi(userForm.value)
        ElMessage.success('用户信息已添加')
      }

      dialogVisible.value = false
      // 刷新
      getUsersList()
    } else {
      console.log('表单校验失败')
      return false
    }
  })
}

// 删除用户
const deleteUser = async (userID) => {
  try {
    await ElMessageBox.confirm('确定要删除此用户吗？', '提示', {
      confirmButtonText: '确认',
      cancelButtonText: '取消',
      type: 'warning'
    })
    await deleteUserApi(userID)
    // usersList.value = usersList.value.filter((user) => user.userID !== userID)
    ElMessage.success('用户已删除')
    getUsersList()
  } catch (error) {
    console.log('用户删除操作已取消', error)
  }
}
</script>

<template>
  <div class="contain">
    <h1>用户管理</h1>
    <br /><br />
    <!-- 新增按钮 -->
    <div style="display: flex; justify-content: space-between; margin-bottom: 15px">
      <el-button type="primary" @click="openAddUserForm">增加</el-button>
      <div style="display: flex; justify-content: flex-end">
        <el-input
          v-model="queryForm.searchQuery"
          placeholder="请输入用户名进行搜索"
          @keyup.enter="getUsersList"
          style="width: 200px"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
        </el-input>
      </div>
    </div>

    <!-- 用户列表 -->
    <el-table :data="usersList" border>
      <el-table-column label="用户名" prop="userName" align="center"></el-table-column>
      <el-table-column label="头像" align="center">
        <template #default="{ row }">
          <img :src="row.picture" alt="头像" style="height: 80px" />
        </template>
      </el-table-column>
      <el-table-column label="性别" prop="gender" align="center">
        <template #default="{ row }">
          <span>{{ row.gender === 0 ? '女' : '男' }}</span>
        </template>
      </el-table-column>
      <el-table-column label="学校" prop="schoolName" align="center"></el-table-column>
      <el-table-column label="邮箱" prop="mail" align="center"></el-table-column>
      <el-table-column label="电话" prop="tel" align="center"></el-table-column>
      <el-table-column label="用户状态" prop="status" align="center">
        <template #default="{ row }">
          <el-tag :type="row.status === 0 ? 'success' : 'danger'" style="font-size: 14px; padding: 15px 17px">
            {{ row.status === 0 ? '正常' : '异常' }}
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

    <!-- 分页 -->
    <div class="pagination-container">
      <el-pagination
        :current-page="queryForm.pageNum"
        :page-size="queryForm.pageSize"
        :total="total"
        layout="total, prev, pager, next, jumper"
        @current-change="handlePageChange"
      />
    </div>

    <!-- 编辑/新增用户弹窗 -->
    <el-dialog :title="dialogTitle" v-model="dialogVisible" @close="closeDialog">
      <el-form :model="userForm" :rules="rules" ref="formRef" label-width="120px">
        <el-form-item label="用户名" prop="userName">
          <el-input v-model="userForm.userName" placeholder="请输入用户名"></el-input>
        </el-form-item>
        <el-form-item label="性别" prop="gender">
          <el-radio-group v-model="userForm.gender">
            <el-radio :value="0">女</el-radio>
            <el-radio :value="1">男</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="学校" prop="schoolName">
          <el-input v-model="userForm.schoolName" placeholder="请输入学校全称"></el-input>
        </el-form-item>
        <el-form-item label="邮箱" prop="mail">
          <el-input v-model="userForm.mail" placeholder="请输入邮箱"></el-input>
        </el-form-item>
        <el-form-item label="电话" prop="tel">
          <el-input v-model="userForm.tel" placeholder="请输入电话"></el-input>
        </el-form-item>
        <el-form-item label="用户状态" prop="status">
          <el-radio-group v-model="userForm.status">
            <el-radio :value="0">正常</el-radio>
            <el-radio :value="1">异常</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleConfirm">提交</el-button>
          <el-button @click="dialogVisible = false">取消</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<style scoped>
h1 {
  font-size: 25px;
  color: dimgray;
}

.contain {
  background: #fff;
  border-radius: 10px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  padding: 2%;
}

.el-table .el-table-column {
  text-align: center;
}

.pagination-container {
  display: flex;
  justify-content: center;
  margin-top: 50px;
}
</style>
