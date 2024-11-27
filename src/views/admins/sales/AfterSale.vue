<!-- 只能查询 -->

<script setup>
import { ref } from 'vue'
import { Search } from '@element-plus/icons-vue'

const queryForm = ref({
  searchQuery: '',
  pageNum: 1,
  pageSize: 5
})
</script>

<template>
  <div class="">
    <h1>售后管理</h1>
    <br /><br />
    <div style="display: flex; justify-content: space-between; margin-bottom: 15px">
      <div style="display: flex; justify-content: flex-end">
        <el-input v-model="queryForm.searchQuery" placeholder="请输入订单ID进行搜索" style="width: 250px">
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
        </el-input>
      </div>
    </div>
    <!-- 订单列表 -->
  </div>
</template>

<style scoped>
h1 {
  font-size: 25px;
  color: dimgray;
}
</style>
