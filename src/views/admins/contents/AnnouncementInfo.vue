<script setup>
import { ref, nextTick, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search } from '@element-plus/icons-vue'

import {
  getAnnouncementListApi,
  addAnnouncementApi,
  editAnnouncementApi,
  deleteAnnouncementApi
} from '@/api/announcementInfo'

const queryForm = ref({
  searchQuery: '',
  pageNum: 1,
  pageSize: 10
})
const total = ref(0)
const AnnouncementList = ref([])

const getAnnouncementList = async () => {
  const res = await getAnnouncementListApi(queryForm.value)
  if (res.data.code === 1) {
    AnnouncementList.value = res.data.data.announcementList
    total.value = res.data.data.total
  } else ElMessage.error('获取公告信息失败')
}
onMounted(() => {
  getAnnouncementList()
})

// 弹窗显示状态和标题
const dialogVisible = ref(false)
const dialogTitle = ref('编辑公告')

// 编辑表单数据
const announcementForm = ref({
  announcementID: '',
  anTitle: '',
  anContent: '',
  anTime: ''
})

// 表单验证规则
const rules = {
  anTitle: [{ required: true, message: '请输入公告标题', trigger: 'blur' }],
  anContent: [{ required: true, message: '请输入公告内容', trigger: 'blur' }],
  anTime: [{ required: true, message: '请输入公告发布时间', trigger: 'blur' }]
}

// 表单引用
const formRef = ref(null)

// 打开新增公告表单
const openAddAnnouncementForm = () => {
  dialogTitle.value = '新增公告'
  announcementForm.value = {
    announcementID: '',
    anTitle: '',
    anContent: '',
    anTime: ''
  }
  dialogVisible.value = true
  nextTick(() => formRef.value?.clearValidate())
}

// 在关闭弹窗时重置表单数据
const closeDialog = () => {
  dialogVisible.value = false
  // 重置表单数据为初始状态
  announcementForm.value = {
    announcementID: '',
    anTitle: '',
    anContent: '',
    anTime: ''
  }
  formRef.value?.clearValidate()
}

// 编辑公告
const editAnnouncement = (announcement) => {
  dialogTitle.value = '编辑公告'
  announcementForm.value = { ...announcement }
  dialogVisible.value = true
  nextTick(() => formRef.value?.clearValidate())
}

const handlePageChange = (pageNum) => {
  queryForm.value.pageNum = pageNum
  getAnnouncementList()
}

const handleConfirm = async () => {
  formRef.value.validate(async (valid) => {
    if (valid) {
      console.log('提交的表单数据:', announcementForm.value)

      if (announcementForm.value.announcementID) {
        const res = await editAnnouncementApi(announcementForm.value)
        if (res.data.code === 1) ElMessage.success('公告信息已更新')
        else ElMessage.error('更新失败')
      } else {
        const res = await addAnnouncementApi(announcementForm.value)
        if (res.data.code === 1) ElMessage.success('公告信息已添加')
        else ElMessage.error('添加失败')
      }

      dialogVisible.value = false
      // 刷新
      getAnnouncementList()
    } else {
      console.log('表单校验失败')
      return false
    }
  })
}

// 删除公告
const deleteAnnouncement = async (announcementID) => {
  try {
    await ElMessageBox.confirm('确定要删除此公告吗？', '提示', {
      confirmButtonText: '确认',
      cancelButtonText: '取消',
      type: 'warning'
    })
    const res = await deleteAnnouncementApi(announcementID)
    if (res.data.code === 1) {
      AnnouncementList.value = AnnouncementList.value.filter(
        (announcement) => announcement.announcementID !== announcementID
      )
      ElMessage.success('公告已删除')
    }
    // getAnnouncementList()
  } catch (error) {
    console.log('公告删除操作已取消', error)
  }
}
</script>

<template>
  <div class="contain">
    <h1>公告管理</h1>
    <br /><br />
    <!-- 新增按钮 -->
    <div style="display: flex; justify-content: space-between; margin-bottom: 15px">
      <el-button type="primary" @click="openAddAnnouncementForm">增加</el-button>
      <div style="display: flex; justify-content: flex-end">
        <el-input
          v-model="queryForm.searchQuery"
          placeholder="请输入公告标题进行搜索"
          @keyup.enter="getAnnouncementList"
          style="width: 200px"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
        </el-input>
      </div>
    </div>

    <!-- 公告列表 -->
    <el-table :data="AnnouncementList" border>
      <el-table-column label="公告标题" prop="anTitle" align="center"></el-table-column>
      <el-table-column label="公告内容" prop="anContent" align="center"></el-table-column>
      <el-table-column label="公告发布时间" prop="anTime" align="center"></el-table-column>
      <el-table-column label="操作" align="center">
        <template #default="{ row }">
          <el-row type="flex" justify="center" :gutter="10">
            <el-button @click="editAnnouncement(row)" type="primary">编辑</el-button>
            <el-button @click="deleteAnnouncement(row.announcementID)" type="danger">删除</el-button>
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

    <!-- 编辑/新增公告弹窗 -->
    <el-dialog :title="dialogTitle" v-model="dialogVisible" @close="closeDialog" style="width: 500px">
      <el-form :model="announcementForm" :rules="rules" ref="formRef" label-width="120px">
        <el-form-item label="公告标题" prop="anTitle">
          <el-input v-model="announcementForm.anTitle" placeholder="请输入公告标题"></el-input>
        </el-form-item>
        <el-form-item label="公告内容" prop="anContent">
          <el-input
            v-model="announcementForm.anContent"
            :rows="4"
            type="textarea"
            placeholder="请输入分类描述"
            style="padding-right: 10%"
          ></el-input>
        </el-form-item>
        <el-form-item label="公告发布时间" prop="anTime">
          <el-input v-model="announcementForm.anTime" placeholder="请输入公告发布时间"></el-input>
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
