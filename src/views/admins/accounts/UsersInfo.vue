<script setup>
import { ref, computed, nextTick } from 'vue'
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
  },
  {
    userID: 3,
    userName: 'urge1',
    mail: 'urge1@123.com',
    tel: '0987654321',
    gender: 1,
    school: 'school2',
    userStatus: 0,
    avatarUrl: 'https://via.placeholder.com/200'
  },
  {
    userID: 4,
    userName: 'urge2',
    mail: 'urge2@123.com',
    tel: '0987654321',
    gender: 0,
    school: 'school2',
    userStatus: 0,
    avatarUrl: 'https://via.placeholder.com/200'
  },
  {
    userID: 5,
    userName: 'urge3',
    mail: 'urg3e@123.com',
    tel: '0987654321',
    gender: 1,
    school: 'school2',
    userStatus: 1,
    avatarUrl: 'https://via.placeholder.com/200'
  },
  {
    userID: 6,
    userName: 'urge4',
    mail: 'urge4@123.com',
    tel: '0987654321',
    gender: 0,
    school: 'school2',
    userStatus: 0,
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

// 弹窗显示状态和标题
const dialogVisible = ref(false)
const dialogTitle = ref('编辑用户')

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

// 表单引用
const formRef = ref(null)

// 打开新增用户表单
const openAddUserForm = () => {
  dialogTitle.value = '新增用户' // 设置弹窗标题
  editUserForm.value = {
    userID: '',
    userName: '',
    mail: '',
    tel: '',
    gender: '',
    userStatus: ''
  }
  dialogVisible.value = true
  // 在 `nextTick` 中调用 `clearValidate` 确保表单加载完成
  nextTick(() => formRef.value?.clearValidate())
}

// 编辑用户
const editUser = (user) => {
  dialogTitle.value = '编辑用户' // 设置弹窗标题
  editUserForm.value = { ...user } // 填充表单数据
  dialogVisible.value = true
  // 在 `nextTick` 中调用 `clearValidate` 确保表单加载完成
  nextTick(() => formRef.value?.clearValidate())
}

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

// 计算当前页显示的用户列表
const paginatedUserList = computed(() => {
  const startIndex = (currentPage.value - 1) * pageSize.value
  const endIndex = startIndex + pageSize.value
  return filteredUserList.value.slice(startIndex, endIndex)
})

// 分页处理函数
const handlePageChange = (newPage) => {
  currentPage.value = newPage
}
</script>

<template>
  <div class="contain">
    <h1 class="h1">用户管理</h1>
    <br /><br />
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
    <el-table :data="paginatedUserList" border>
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
.h1 {
  font-size: 25px;
  color: dimgray;
}

.contain {
  background: #fff;
  border-radius: 10px; /* 圆角 */
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); /* 阴影效果 */
  padding: 30px;
  margin-top: 20px;
}

.el-table .el-table-column {
  text-align: center;
}

.pagination-container {
  display: flex;
  justify-content: center; /* 水平居中 */
  align-items: center; /* 垂直居中 (可选) */
  margin-top: 50px; /* 可根据需要调整分页与内容的距离 */
}
</style>
