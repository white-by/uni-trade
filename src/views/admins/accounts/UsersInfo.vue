<script setup>
import { ref, nextTick, onMounted, watch } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search } from '@element-plus/icons-vue'
import { getUsersListApi, addUserApi, editUserApi, deleteUserApi } from '@/api/usersInfo'
import schoolData from '@/../public/school.json'
import useASE from '@/hooks/useASE'

const { encrypt } = useASE()

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
  status: null,
  password: '123456' // 默认密码
})

// 表单验证规则
const rules = {
  userName: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  schoolName: [{ required: true, message: '请选择学校', trigger: 'change' }],
  mail: [{ required: true, message: '请输入邮箱', trigger: 'blur' }],
  tel: [
    { required: true, message: '请输入电话', trigger: 'blur' },
    { pattern: /^[0-9]{11}$/, message: '请输入有效的电话号码', trigger: 'blur' }
  ],
  gender: [{ required: true, message: '请选择性别', trigger: 'change' }],
  status: [{ required: true, message: '请选择用户状态', trigger: 'change' }]
}

// 获取学校列表
const schoolList = Object.keys(schoolData)
// 当前选中的学校
const selectedSchool = ref('') // 默认选中第一个学校
// 邮箱后缀
const schoolEmailSuffix = ref() // 默认后缀
// 前缀
const mailPrefix = ref('')

// 动态更新邮箱前缀到 mail 字段中
const updateMail = () => {
  userForm.value.mail = `${mailPrefix.value}${schoolEmailSuffix.value}`
}
// 监听选中的学校变化
watch(
  () => userForm.value.schoolName, // 监听表单中学校的变化
  (newSchool) => {
    if (newSchool) {
      selectedSchool.value = newSchool // 同步更新 selectedSchool
      schoolEmailSuffix.value = schoolData[newSchool]
    }
  }
)

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
    status: null,
    password: '123456' // 默认密码
  }
  mailPrefix.value = ''
  schoolEmailSuffix.value = '@edu.cn'
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
    status: null,
    password: '123456' // 默认密码
  }
  formRef.value?.clearValidate()
}

// 编辑用户
const editUser = (user) => {
  dialogTitle.value = '编辑用户'
  userForm.value = { ...user }
  // 分离邮箱前缀和后缀
  const [prefix] = user.mail.split('@')
  mailPrefix.value = prefix

  dialogVisible.value = true
  nextTick(() => formRef.value?.clearValidate())
}

const handlePageChange = (pageNum) => {
  queryForm.value.pageNum = pageNum
  getUsersList()
}

const handleConfirm = async () => {
  formRef.value.validate(async (valid) => {
    if (valid) {
      const updatedMail = `${mailPrefix.value}${schoolEmailSuffix.value}`
      userForm.value.mail = updatedMail
      console.log('提交的表单数据:', userForm.value)
      if (userForm.value.userID) {
        const res = await editUserApi(userForm.value)
        if (res.data.code === 1) ElMessage.success('用户信息已更新')
        // else ElMessage.error('更新失败')
        else ElMessage.error(res.data.msg)
      } else {
        // 新增用户时移除 userID 字段
        delete userForm.value.userID
        // 默认加密密码123456
        userForm.value.password = encrypt(userForm.value.password)
        const res = await addUserApi(userForm.value)
        if (res.data.code === 1) ElMessage.success('用户信息已添加')
        // else ElMessage.error('添加失败')
        else ElMessage.error(res.data.msg)
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
      <div style="display: flex; justify-content: flex-end">
        <el-input
          v-model="queryForm.searchQuery"
          placeholder="请输入用户名进行搜索"
          @keyup.enter="getUsersList"
          style="width: 250px"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
        </el-input>
      </div>
      <el-button type="primary" @click="openAddUserForm">增加</el-button>
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
      <el-table-column label="邮箱" prop="mail" align="center" width="250"></el-table-column>
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
    <el-dialog :title="dialogTitle" v-model="dialogVisible" @close="closeDialog" style="width: 500px">
      <el-form :model="userForm" :rules="rules" ref="formRef" label-width="100px">
        <el-form-item label="用户名" prop="userName">
          <el-input v-model="userForm.userName" placeholder="请输入用户名"></el-input>
        </el-form-item>
        <!-- 根据弹窗状态显示密码框 -->
        <el-form-item label="密码" v-if="dialogTitle === '新增用户'">
          <el-input v-model="userForm.password" disabled />
        </el-form-item>
        <el-form-item label="性别" prop="gender">
          <el-radio-group v-model="userForm.gender">
            <el-radio :value="0">女</el-radio>
            <el-radio :value="1">男</el-radio>
          </el-radio-group>
        </el-form-item>

        <el-form-item label="学校" prop="schoolName">
          <el-select v-model="userForm.schoolName" placeholder="请选择学校">
            <el-option v-for="(school, index) in schoolList" :key="index" :label="school" :value="school"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="邮箱" prop="mail">
          <el-input v-model="mailPrefix" placeholder="请输入邮箱前缀" @input="updateMail">
            <template #append>{{ schoolEmailSuffix }}</template>
          </el-input>
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
        <span style="display: flex; justify-content: center">
          <el-button type="primary" @click="handleConfirm">提交</el-button>
          <el-button @click="dialogVisible = false">取消</el-button>
        </span>
      </el-form>
    </el-dialog>
  </div>
</template>

<style scoped>
h1 {
  font-size: 25px;
  color: dimgray;
}

.el-input {
  padding-right: 10%;
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

.el-select {
  width: 90% !important;
}
</style>
