<script setup>
import { ref, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search } from '@element-plus/icons-vue'

// 用户列表数据
const userList = ref([
  {
    userID: 1,
    userName: 'tav',
    mail: 'tav@123.com',
    tel: '1234567890',
    gender: 0,
    school: 'school1',
    userStatus: 0,
    avatarUrl: 'https://via.placeholder.com/200'
  },
  {
    userID: 2,
    userName: 'urge',
    mail: 'urge@123.com',
    tel: '0987654321',
    gender: 0,
    school: 'school2',
    userStatus: 1,
    avatarUrl: 'https://via.placeholder.com/200'
  }
])

// 搜索框的绑定值
const searchQuery = ref('')

// 分页相关变量
const currentPage = ref(1)
const pageSize = ref(5)

// 计算过滤后的用户列表
const filteredUserList = computed(() => {
  if (!searchQuery.value) return userList.value
  return userList.value.filter((user) => user.userName.includes(searchQuery.value))
})

// 编辑/新增用户弹窗显示状态
const dialogVisible = ref(false)
const dialogTitle = ref('编辑用户') // 弹窗标题

// 编辑表单数据
const editUserForm = ref({
  userID: '',
  userName: '',
  mail: '',
  tel: '',
  gender: 1,
  userStatus: 0
})

// 表单验证规则
const rules = {
  userName: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  mail: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入有效的邮箱地址', trigger: ['blur', 'change'] }
  ],
  tel: [{ required: true, message: '请输入电话', trigger: 'blur' }],
  gender: [{ required: true, message: '请选择性别', trigger: 'change' }],
  userStatus: [{ required: true, message: '请选择用户状态', trigger: 'change' }],
  school: [{ required: true, message: '请输入学校', trigger: 'blur' }]
}

// 打开新增用户表单
const openAddUserForm = () => {
  dialogTitle.value = '新增用户' // 修改弹窗标题
  editUserForm.value = {
    // 清空表单
    userID: '',
    userName: '',
    mail: '',
    tel: '',
    gender: 0,
    userStatus: 0
  }
  dialogVisible.value = true
  formRef.value.clearValidate()
}

// 编辑用户
const editUser = (user) => {
  dialogTitle.value = '编辑用户' // 修改弹窗标题
  editUserForm.value = { ...user } // 填充表单数据
  dialogVisible.value = true
  formRef.value.clearValidate()
}

// 表单引用
const formRef = ref(null)
// 提交表单
function submitEditForm() {
  formRef.value.validate((valid) => {
    if (valid) {
      console.log('提交的表单数据:', editUserForm.value)
      if (editUserForm.value.userID) {
        // 编辑用户
        const index = userList.value.findIndex((user) => user.userID === editUserForm.value.userID)
        if (index !== -1) {
          userList.value[index] = { ...editUserForm.value }
          ElMessage.success('用户信息已更新')
        }
      } else {
        // 新增用户
        const newUser = { ...editUserForm.value, userID: Date.now() }
        userList.value.push(newUser)
        ElMessage.success('新增用户成功')
      }
      dialogVisible.value = false // 关闭对话框
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
    userList.value = userList.value.filter((user) => user.userID !== userID)
    ElMessage.success('用户已删除')
  } catch (error) {
    console.log(error)
    console.log('用户删除操作已取消')
  }
}

// 处理分页
const handlePageChange = (newPage) => {
  currentPage.value = newPage
}
</script>

<template>
  <div>
    <h1>用户信息</h1>
    <br />
    <!-- 新增按钮 -->
    <div style="display: flex; justify-content: space-between; margin-bottom: 15px">
      <!-- 增加按钮 -->
      <el-button type="primary" @click="openAddUserForm">增加</el-button>

      <!-- 搜索框 -->
      <div style="display: flex; justify-content: flex-end">
        <el-input v-model="searchQuery" placeholder="请输入用户名进行搜索" style="width: 200px">
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
        </el-input>
      </div>
    </div>

    <!-- 用户列表 -->
    <el-table :data="filteredUserList" border>
      <el-table-column label="用户名" prop="userName" width="180" align="center"></el-table-column>
      <el-table-column label="头像" width="180" align="center">
        <template #default="{ row }">
          <img :src="row.avatarUrl" alt="头像" style="width: 80px" />
        </template>
      </el-table-column>

      <el-table-column label="性别" prop="gender" width="100" align="center">
        <template #default="{ row }">
          <span>{{ row.gender === 0 ? '女' : '男' }}</span>
        </template>
      </el-table-column>
      <el-table-column label="学校" prop="school" width="180" align="center"></el-table-column>
      <el-table-column label="邮箱" prop="mail" width="250" align="center"></el-table-column>
      <el-table-column label="电话" prop="tel" width="250" align="center"></el-table-column>

      <el-table-column label="用户状态" prop="userStatus" width="120" align="center">
        <template #default="{ row }">
          <el-tag :type="row.userStatus === 0 ? 'success' : 'danger'" style="font-size: 14px; padding: 15px 17px">
            {{ row.userStatus === 0 ? '正常' : '异常' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="190" align="center">
        <template #default="{ row }">
          <el-button @click="editUser(row)" type="primary">编辑</el-button>
          <el-button @click="deleteUser(row.userID)" type="danger">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 分页 -->
    <div class="pagination-container">
      <el-pagination
        :current-page="currentPage"
        :page-size="pageSize"
        :total="userList.length"
        layout="total, prev, pager, next, jumper"
        @current-change="handlePageChange"
      />
    </div>

    <!-- 编辑/新增用户弹窗 -->
    <el-dialog :title="dialogTitle" v-model="dialogVisible">
      <el-form :model="editUserForm" :rules="rules" ref="formRef" label-width="120px">
        <el-form-item label="用户名" prop="userName">
          <el-input v-model="editUserForm.userName" placeholder="请输入用户名"></el-input>
        </el-form-item>

        <el-form-item label="性别" prop="gender">
          <el-radio-group v-model="editUserForm.gender">
            <el-radio :value="0">女</el-radio>
            <el-radio :value="1">男</el-radio>
          </el-radio-group>
        </el-form-item>

        <el-form-item label="邮箱" prop="mail">
          <el-input v-model="editUserForm.mail" placeholder="请输入邮箱"></el-input>
        </el-form-item>

        <el-form-item label="电话" prop="tel">
          <el-input v-model="editUserForm.tel" placeholder="请输入电话"></el-input>
        </el-form-item>

        <el-form-item label="用户状态" prop="userStatus">
          <el-radio-group v-model="editUserForm.userStatus">
            <el-radio :value="0">正常</el-radio>
            <el-radio :value="1">异常</el-radio>
          </el-radio-group>
        </el-form-item>

        <el-form-item>
          <el-button type="primary" @click="submitEditForm">提交</el-button>
          <el-button @click="dialogVisible = false">取消</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<style scoped>
.el-table .el-table-column {
  text-align: center;
}

.pagination-container {
  display: flex;
  justify-content: center; /* 水平居中 */
  align-items: center; /* 垂直居中 (可选) */
  margin-top: 20px; /* 可根据需要调整分页与内容的距离 */
}
</style>
