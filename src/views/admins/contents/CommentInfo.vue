<!-- 删除，查询 -->

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search } from '@element-plus/icons-vue'

import { getCommentListApi, deleteCommentApi } from '@/api/commentInfo'

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
    console.log('返回：', CommentList.value)
    total.value = res.data.data.total
  } else ElMessage.error(res.data.msg)
}
onMounted(() => {
  getCommentList()
})

const handlePageChange = (pageNum) => {
  queryForm.value.pageNum = pageNum
  getCommentList()
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

    <div style="display: flex; justify-content: space-between; margin-bottom: 15px">
      <div style="display: flex; justify-content: flex-end">
        <el-input
          v-model="queryForm.searchQuery"
          placeholder="请输入评论人名进行搜索"
          @keyup.enter="getCommentList"
          style="width: 250px"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
        </el-input>
      </div>
    </div>

    <!-- 评论列表 -->
    <el-table :data="CommentList" border>
      <el-table-column label="商品名称" prop="goodsName" align="center"></el-table-column>
      <el-table-column label="评论人名" prop="commentatorName" align="center"></el-table-column>
      <el-table-column label="评论内容" prop="commentContent" align="center"></el-table-column>
      <el-table-column label="评论时间" prop="commentTime" align="center"></el-table-column>
      <el-table-column label="操作" align="center">
        <template #default="{ row }">
          <el-row type="flex" justify="center" :gutter="10">
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
