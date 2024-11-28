<script setup>
import { ref, onMounted } from 'vue'
import { Search } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getProductListApi, deleteProductApi } from '@/api/saleInfo'

const queryForm = ref({
  searchQuery: '',
  pageNum: 1,
  pageSize: 5
})
const total = ref(0)
const productList = ref([])

const getProductList = async () => {
  // console.log('query: ', queryForm.value)
  const res = await getProductListApi(queryForm.value)
  // console.log('res: ', res.data)
  productList.value = res.data.data.productList
  total.value = res.data.data.total
  // console.log('productList: ', productList.value)
}

const handlePageChange = (pageNum) => {
  queryForm.value.pageNum = pageNum
  getProductList()
}

// 删除商品
const deleteProduct = async (productID) => {
  try {
    await ElMessageBox.confirm('确定要删除此商品吗？', '提示', {
      confirmButtonText: '确认',
      cancelButtonText: '取消',
      type: 'warning'
    })
    await deleteProductApi(productID)
    // productList.value = productList.value.filter((product) => product.productID !== productID)
    ElMessage.success('商品已删除')
    getProductList()
  } catch (error) {
    console.log('商品删除操作已取消', error)
  }
}

onMounted(() => {
  getProductList()
})
</script>

<template>
  <div class="contain">
    <h1>商品管理</h1>
    <br /><br />
    <div style="display: flex; justify-content: space-between; margin-bottom: 15px">
      <div style="display: flex; justify-content: flex-end">
        <el-input
          v-model="queryForm.searchQuery"
          placeholder="请输入商品ID进行搜索"
          @keyup.enter="getProductList"
          style="width: 250px"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
        </el-input>
      </div>
    </div>

    <!-- 商品列表 -->
    <el-table :data="productList" border>
      <el-table-column prop="id" label="商品编号" align="center"></el-table-column>

      <el-table-column prop="title" label="商品名称" align="center"></el-table-column>
      <el-table-column prop="price" label="价格" align="center"></el-table-column>
      <el-table-column prop="category" label="分类" align="center"></el-table-column>
      <el-table-column prop="userName" label="发布者" align="center"></el-table-column>
      <el-table-column prop="description" label="物品描述" align="center"></el-table-column>

      <el-table-column label="图片" align="center">
        <template #default="{ row }">
          <!-- 使用 el-popover 显示图片 -->
          <el-popover trigger="hover" placement="top" width="150px">
            <template #default>
              <div class="image-list">
                <!-- 遍历 imageUrl 字段中的图片URL -->
                <el-image v-for="(url, index) in row.imageUrl.split(',')" :key="index" :src="url" fit="cover" />
              </div>
            </template>
            <template #reference>
              <el-button link type="primary" size="small"> 查看图片 </el-button>
            </template>
          </el-popover>
        </template>
      </el-table-column>

      <el-table-column prop="deliveryMethod" label="配送方式" align="center"> </el-table-column>
      <el-table-column label="发货地址" align="center">
        <template #default="{ row }"> {{ row.province }}{{ row.city }}{{ row.area }}{{ row.detailArea }} </template>
      </el-table-column>
      <el-table-column prop="shippingCost" label="邮费" align="center"> </el-table-column>
      <!-- 查看详情 -->
      <el-table-column label="更多" align="center"
        ><template #default="scope">
          <el-popover effect="light" trigger="hover" placement="top" width="auto">
            <template #default>
              <div>浏览量: {{ scope.row.views }}</div>
              <div>收藏量: {{ scope.row.stars }}</div>
              <div>发布时间: {{ scope.row.postTime }}</div>
              <div v-if="scope.row.isSold === 0">销售状态: 未售出</div>
              <div v-if="scope.row.isSold === 1">销售状态: 已售出</div>
            </template>
            <template #reference>
              <el-button link type="primary" size="small"> 查看详情 </el-button>
            </template>
          </el-popover>
        </template></el-table-column
      >
      <el-table-column label="操作" align="center">
        <template #default="{ row }">
          <el-row type="flex" justify="center" :gutter="10">
            <el-button @click="deleteProduct(row.productID)" type="danger">删除</el-button>
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

.el-select {
  width: 90% !important;
}
</style>
