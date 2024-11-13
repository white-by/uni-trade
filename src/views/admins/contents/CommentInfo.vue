<script setup>
import { ref, nextTick, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search } from '@element-plus/icons-vue'

import { getCommentListApi, addCommentApi, editCommentApi, deleteCommentApi } from '@/api/commentInfo'

const queryForm = ref({
  searchQuery: '',
  pageNum: 1,
  pageSize: 10
})
const total = ref(0)
const CommentList = ref([])

const getCommentList = async () => {
  const res = await getCommentListApi(queryForm.value)
  if (res.data.code === 1) {
    CommentList.value = res.data.data.commentList
    total.value = res.data.data.total
  } else ElMessage.error('获取评论信息失败')
}
onMounted(() => {
  getCommentList()
})

// 弹窗显示状态和标题
const dialogVisible = ref(false)
const dialogTitle = ref('编辑评论')

// 编辑表单数据
const commentForm = ref({
  commentID: '',
  goodsID: '',
  commentatorID: '',
  commentatorName: '',
  commentContent: '',
  commentTime: ''
})

// 表单验证规则
const rules = {
  commentID: [{ required: true, message: '请输入评论名', trigger: 'blur' }],
  goodsID: [{ required: true, message: '请输入评论名', trigger: 'blur' }],
  commentatorID: [{ required: true, message: '请输入评论名', trigger: 'blur' }],
  commentatorName: [{ required: true, message: '请输入评论名', trigger: 'blur' }],
  commentContent: [{ required: true, message: '请输入评论名', trigger: 'blur' }],
  commentTime: [{ required: true, message: '请输入评论名', trigger: 'blur' }]
}

// 表单引用
const formRef = ref(null)

// 打开新增评论表单
const openAddCommentForm = () => {
  dialogTitle.value = '新增评论'
  commentForm.value = {
    commentID: '',
    goodsID: '',
    commentatorID: '',
    commentatorName: '',
    commentContent: '',
    commentTime: ''
  }
  dialogVisible.value = true
  nextTick(() => formRef.value?.clearValidate())
}

// 在关闭弹窗时重置表单数据
const closeDialog = () => {
  dialogVisible.value = false
  // 重置表单数据为初始状态
  commentForm.value = {
    commentID: '',
    goodsID: '',
    commentatorID: '',
    commentatorName: '',
    commentContent: '',
    commentTime: ''
  }
  formRef.value?.clearValidate()
}

// 编辑评论
const editComment = (comment) => {
  dialogTitle.value = '编辑评论'
  commentForm.value = { ...comment }
  dialogVisible.value = true
  nextTick(() => formRef.value?.clearValidate())
}

const handlePageChange = (pageNum) => {
  queryForm.value.pageNum = pageNum
  getCommentList()
}

const handleConfirm = async () => {
  formRef.value.validate(async (valid) => {
    if (valid) {
      console.log('提交的表单数据:', commentForm.value)

      if (commentForm.value.commentID) {
        const res = await editCommentApi(commentForm.value)
        if (res.data.code === 1) ElMessage.success('评论信息已更新')
        else ElMessage.error('更新失败')
      } else {
        const res = await addCommentApi(commentForm.value)
        if (res.data.code === 1) ElMessage.success('评论信息已添加')
        else ElMessage.error('添加失败')
      }

      dialogVisible.value = false
      // 刷新
      getCommentList()
    } else {
      console.log('表单校验失败')
      return false
    }
  })
}

// 删除评论
const deleteComment = async (commentID) => {
  try {
    await ElMessageBox.confirm('确定要删除此评论吗？', '提示', {
      confirmButtonText: '确认',
      cancelButtonText: '取消',
      type: 'warning'
    })
    const res = await deleteCommentApi(commentID)
    if (res.data.code === 1) {
      CommentList.value = CommentList.value.filter((comment) => comment.commentID !== commentID)
      ElMessage.success('评论已删除')
    }
    // getCommentList()
  } catch (error) {
    console.log('评论删除操作已取消', error)
  }
}
</script>

<template>
  <div class="contain">
    <h1>评论管理</h1>
    <br /><br />
    <!-- 新增按钮 -->
    <div style="display: flex; justify-content: space-between; margin-bottom: 15px">
      <el-button type="primary" @click="openAddCommentForm">增加</el-button>
      <div style="display: flex; justify-content: flex-end">
        <el-input
          v-model="queryForm.searchQuery"
          placeholder="请输入评论ID进行搜索"
          @keyup.enter="getCommentList"
          style="width: 200px"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
        </el-input>
      </div>
    </div>

    <!-- 评论列表 -->
    <el-table :data="CommentList" border>
      <el-table-column label="评论ID" prop="commentID" align="center"></el-table-column>
      <el-table-column label="商品ID" prop="goodsID" align="center"></el-table-column>
      <el-table-column label="评论人ID" prop="commentatorID" align="center"></el-table-column>
      <el-table-column label="评论人名" prop="commentatorName" align="center"></el-table-column>
      <el-table-column label="评论内容" prop="commentContent" align="center"></el-table-column>
      <el-table-column label="评论时间" prop="commentTime" align="center"></el-table-column>
      <el-table-column label="操作" align="center">
        <template #default="{ row }">
          <el-row type="flex" justify="center" :gutter="10">
            <el-button @click="editComment(row)" type="primary">编辑</el-button>
            <el-button @click="deleteComment(row.commentID)" type="danger">删除</el-button>
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

    <!-- 编辑/新增评论弹窗 -->
    <el-dialog :title="dialogTitle" v-model="dialogVisible" @close="closeDialog" style="width: 500px">
      <el-form :model="commentForm" :rules="rules" ref="formRef" label-width="120px">
        <el-form-item label="评论ID" prop="commentID">
          <el-input v-model="commentForm.commentName" placeholder="请输入评论名"></el-input>
        </el-form-item>
        <el-form-item label="商品ID" prop="goodsID">
          <el-input v-model="commentForm.mail" placeholder="请输入邮箱"></el-input>
        </el-form-item>
        <el-form-item label="评论人ID" prop="commentatorID">
          <el-input v-model="commentForm.tel" placeholder="请输入评论人ID"></el-input>
        </el-form-item>
        <el-form-item label="评论人名" prop="commentatorName">
          <el-input v-model="commentForm.tel" placeholder="请输入评论人名"></el-input>
        </el-form-item>
        <el-form-item label="评论内容" prop="commentContent">
          <el-input v-model="commentForm.tel" placeholder="请输入评论内容"></el-input>
        </el-form-item>
        <el-form-item label="评论时间" prop="commentTime">
          <el-input v-model="commentForm.tel" placeholder="请输入评论时间"></el-input>
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
