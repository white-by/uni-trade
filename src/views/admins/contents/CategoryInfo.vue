<script setup>
import { ref, nextTick, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search } from '@element-plus/icons-vue'

import { getCategoryListApi, addCategoryApi, editCategoryApi, deleteCategoryApi } from '@/api/categoryInfo'

const queryForm = ref({
  searchQuery: '',
  pageNum: 1,
  pageSize: 10
})
const total = ref(0)
const CategoryList = ref([])

const getCategoryList = async () => {
  const res = await getCategoryListApi(queryForm.value)
  if (res.data.code === 1) {
    CategoryList.value = res.data.data.categoryList
    total.value = res.data.data.total
  } else ElMessage.error('获取分类信息失败')
}
onMounted(() => {
  getCategoryList()
})

// 弹窗显示状态和标题
const dialogVisible = ref(false)
const dialogTitle = ref('编辑分类')

// 编辑表单数据
const categoryForm = ref({
  categoryID: '',
  categoryName: '',
  description: ''
})

// 表单验证规则
const rules = {
  categoryName: [{ required: true, message: '请输入分类名', trigger: 'blur' }],
  description: [{ required: true, message: '请输入分类描述', trigger: 'blur' }]
}

// 表单引用
const formRef = ref(null)

// 打开新增分类表单
const openAddCategoryForm = () => {
  dialogTitle.value = '新增分类'
  categoryForm.value = {
    categoryID: '',
    categoryName: '',
    description: ''
  }
  dialogVisible.value = true
  nextTick(() => formRef.value?.clearValidate())
}

// 在关闭弹窗时重置表单数据
const closeDialog = () => {
  dialogVisible.value = false
  // 重置表单数据为初始状态
  categoryForm.value = {
    categoryID: '',
    categoryName: '',
    description: ''
  }
  formRef.value?.clearValidate()
}

// 编辑分类
const editCategory = (category) => {
  dialogTitle.value = '编辑分类'
  categoryForm.value = { ...category }
  dialogVisible.value = true
  nextTick(() => formRef.value?.clearValidate())
}

const handlePageChange = (pageNum) => {
  queryForm.value.pageNum = pageNum
  getCategoryList()
}

const handleConfirm = async () => {
  formRef.value.validate(async (valid) => {
    if (valid) {
      console.log('提交的表单数据:', categoryForm.value)

      if (categoryForm.value.categoryID) {
        const res = await editCategoryApi(categoryForm.value)
        if (res.data.code === 1) ElMessage.success('分类信息已更新')
        else ElMessage.error('更新失败')
      } else {
        const parma = {
          categoryName: categoryForm.value.categoryName,
          description: categoryForm.value.description
        }
        const res = await addCategoryApi(parma)
        if (res.data.code === 1) ElMessage.success('分类信息已添加')
        else ElMessage.error('添加失败')
      }

      dialogVisible.value = false
      // 刷新
      getCategoryList()
    } else {
      console.log('表单校验失败')
      return false
    }
  })
}

// 删除分类
const deleteCategory = async (categoryID) => {
  try {
    await ElMessageBox.confirm('确定要删除此分类吗？', '提示', {
      confirmButtonText: '确认',
      cancelButtonText: '取消',
      type: 'warning'
    })
    const res = await deleteCategoryApi(categoryID)
    if (res.data.code === 1) {
      CategoryList.value = CategoryList.value.filter((category) => category.categoryID !== categoryID)
      ElMessage.success('分类已删除')
    }
    // getCategoryList()
  } catch (error) {
    console.log('分类删除操作已取消', error)
  }
}
</script>

<template>
  <div class="contain">
    <h1>分类管理</h1>
    <br /><br />

    <div style="display: flex; justify-content: space-between; margin-bottom: 15px">
      <div style="display: flex; justify-content: flex-end">
        <el-input
          v-model="queryForm.searchQuery"
          placeholder="请输入分类名进行搜索"
          @keyup.enter="getCategoryList"
          style="width: 250px"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
        </el-input>
      </div>
      <!-- 新增按钮 -->
      <el-button type="primary" @click="openAddCategoryForm">增加</el-button>
    </div>

    <!-- 分类列表 -->
    <el-table :data="CategoryList" border>
      <el-table-column label="分类名" prop="categoryName" align="center"></el-table-column>
      <el-table-column label="分类描述" prop="description" align="center"></el-table-column>
      <el-table-column label="操作" align="center">
        <template #default="{ row }">
          <el-row type="flex" justify="center" :gutter="10">
            <el-button @click="editCategory(row)" type="primary">编辑</el-button>
            <el-button @click="deleteCategory(row.categoryID)" type="danger">删除</el-button>
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

    <!-- 编辑/新增分类弹窗 -->
    <el-dialog :title="dialogTitle" v-model="dialogVisible" @close="closeDialog" style="width: 500px">
      <el-form :model="categoryForm" :rules="rules" ref="formRef" label-width="100px">
        <el-form-item label="分类名" prop="categoryName">
          <el-input v-model="categoryForm.categoryName" placeholder="请输入分类名"></el-input>
        </el-form-item>
        <el-form-item label="分类描述" prop="description">
          <el-input
            v-model="categoryForm.description"
            :rows="2"
            type="textarea"
            placeholder="请输入分类描述"
            style="padding-right: 10%"
          ></el-input>
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
