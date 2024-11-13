<script setup>
import { ref, nextTick, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search } from '@element-plus/icons-vue'

import { getAdminListApi, addAdminApi, editAdminApi, deleteAdminApi } from '@/api/adminInfo'

const queryForm = ref({
  searchQuery: '',
  pageNum: 1,
  pageSize: 10
})
const total = ref(0)
const AdminList = ref([])

const getAdminList = async () => {
  const res = await getAdminListApi(queryForm.value)
  if (res.data.code === 1) {
    AdminList.value = res.data.data.adminList
    total.value = res.data.data.total
  } else ElMessage.error('获取管理员信息失败')
}
onMounted(() => {
  getAdminList()
})

// 弹窗显示状态和标题
const dialogVisible = ref(false)
const dialogTitle = ref('编辑管理员')

// 编辑表单数据
const adminForm = ref({
  adminID: '',
  adminName: '',
  mail: '',
  tel: '',
  gender: null
})

// 表单验证规则
const rules = {
  adminName: [{ required: true, message: '请输入管理员名', trigger: 'blur' }],
  mail: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入有效的邮箱地址', trigger: ['blur', 'change'] }
  ],
  tel: [
    { required: true, message: '请输入电话', trigger: 'blur' },
    { pattern: /^[0-9]+$/, message: '电话号码只能包含数字', trigger: 'blur' }
  ],
  gender: [{ required: true, message: '请选择性别', trigger: 'change' }]
}

// 表单引用
const formRef = ref(null)

// 打开新增管理员表单
const openAddAdminForm = () => {
  dialogTitle.value = '新增管理员'
  adminForm.value = {
    adminID: '',
    adminName: '',
    mail: '',
    tel: '',
    gender: null
  }
  dialogVisible.value = true
  nextTick(() => formRef.value?.clearValidate())
}

// 在关闭弹窗时重置表单数据
const closeDialog = () => {
  dialogVisible.value = false
  // 重置表单数据为初始状态
  adminForm.value = {
    adminID: '',
    adminName: '',
    mail: '',
    tel: '',
    gender: null
  }
  formRef.value?.clearValidate()
}

// 编辑管理员
const editAdmin = (admin) => {
  dialogTitle.value = '编辑管理员'
  adminForm.value = { ...admin }
  dialogVisible.value = true
  nextTick(() => formRef.value?.clearValidate())
}

const handlePageChange = (pageNum) => {
  queryForm.value.pageNum = pageNum
  getAdminList()
}

const handleConfirm = async () => {
  formRef.value.validate(async (valid) => {
    if (valid) {
      console.log('提交的表单数据:', adminForm.value)

      if (adminForm.value.adminID) {
        const res = await editAdminApi(adminForm.value)
        if (res.data.code === 1) ElMessage.success('管理员信息已更新')
        else ElMessage.error('更新失败')
      } else {
        const res = await addAdminApi(adminForm.value)
        if (res.data.code === 1) ElMessage.success('管理员信息已添加')
        else ElMessage.error('添加失败')
      }

      dialogVisible.value = false
      // 刷新
      getAdminList()
    } else {
      console.log('表单校验失败')
      return false
    }
  })
}

// 删除管理员
const deleteAdmin = async (adminID) => {
  try {
    await ElMessageBox.confirm('确定要删除此管理员吗？', '提示', {
      confirmButtonText: '确认',
      cancelButtonText: '取消',
      type: 'warning'
    })
    const res = await deleteAdminApi(adminID)
    if (res.data.code === 1) {
      AdminList.value = AdminList.value.filter((admin) => admin.adminID !== adminID)
      ElMessage.success('管理员已删除')
    }
    // getAdminList()
  } catch (error) {
    console.log('管理员删除操作已取消', error)
  }
}
</script>

<template>
  <div class="contain">
    <h1>管理员管理</h1>
    <br /><br />
    <!-- 新增按钮 -->
    <div style="display: flex; justify-content: space-between; margin-bottom: 15px">
      <el-button type="primary" @click="openAddAdminForm">增加</el-button>
      <div style="display: flex; justify-content: flex-end">
        <el-input
          v-model="queryForm.searchQuery"
          placeholder="请输入管理员名进行搜索"
          @keyup.enter="getAdminList"
          style="width: 200px"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
        </el-input>
      </div>
    </div>

    <!-- 管理员列表 -->
    <el-table :data="AdminList" border>
      <el-table-column label="管理员名" prop="adminName" align="center"></el-table-column>

      <el-table-column label="性别" prop="gender" align="center">
        <template #default="{ row }">
          <span>{{ row.gender === 0 ? '女' : '男' }}</span>
        </template>
      </el-table-column>
      <el-table-column label="邮箱" prop="mail" align="center"></el-table-column>
      <el-table-column label="电话" prop="tel" align="center"></el-table-column>
      <el-table-column label="操作" align="center">
        <template #default="{ row }">
          <el-row type="flex" justify="center" :gutter="10">
            <el-button @click="editAdmin(row)" type="primary">编辑</el-button>
            <el-button @click="deleteAdmin(row.adminID)" type="danger">删除</el-button>
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

    <!-- 编辑/新增管理员弹窗 -->
    <el-dialog :title="dialogTitle" v-model="dialogVisible" @close="closeDialog" style="width: 500px">
      <el-form :model="adminForm" :rules="rules" ref="formRef" label-width="120px">
        <el-form-item label="管理员名" prop="adminName">
          <el-input v-model="adminForm.adminName" placeholder="请输入管理员名"></el-input>
        </el-form-item>
        <el-form-item label="性别" prop="gender">
          <el-radio-group v-model="adminForm.gender">
            <el-radio :value="0">女</el-radio>
            <el-radio :value="1">男</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="邮箱" prop="mail">
          <el-input v-model="adminForm.mail" placeholder="请输入邮箱"></el-input>
        </el-form-item>
        <el-form-item label="电话" prop="tel">
          <el-input v-model="adminForm.tel" placeholder="请输入电话"></el-input>
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
</style>
