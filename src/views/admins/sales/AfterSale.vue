<!-- 查询、同意/拒绝退款 -->

<script setup>
import { ref, onMounted } from 'vue'
import { Search } from '@element-plus/icons-vue'
import { ElMessageBox, ElMessage } from 'element-plus'
import { getRefundListApi, operateRefundListApi } from '@/api/saleInfo'

const queryForm = ref({
  searchQuery: '',
  pageNum: 1,
  pageSize: 5
})
const total = ref(0)

const refundList = ref([])
const getRefundList = async () => {
  const res = await getRefundListApi(queryForm.value)
  console.log('res: ', res.data)
  refundList.value = res.data.data.refundList
  total.value = res.data.data.total
}

onMounted(() => {
  getRefundList()
})

const handlePageChange = (pageNum) => {
  queryForm.value.pageNum = pageNum
  getRefundList()
}

// const refundList = ref([
//   {
//     tradeID: '202312010001',
//     goodsName: '二手笔记本电脑',
//     price: 4500,
//     shippingCost: 20,
//     sellerName: '张三',
//     sellerReason: '买家无理由退货',
//     buyerName: '李四',
//     buyerReason: '商品有明显划痕',
//     sellerID: 'SELLER123',
//     buyerID: 'BUYER456',
//     orderTime: '2023-12-01 14:30:00',
//     payTime: '2023-12-01 14:45:00',
//     refundTime: '2023-12-02 10:00:00',
//     shippingTime: '2023-12-01 16:00:00',
//     turnoverTime: '2023-12-02 11:00:00',
//     status: '未处理'
//   },
//   {
//     tradeID: '202312010002',
//     goodsName: 'Java编程书籍',
//     price: 80,
//     shippingCost: 10,
//     sellerName: '王五',
//     sellerReason: '商品无质量问题',
//     buyerName: '赵六',
//     buyerReason: '买错了，不需要了',
//     sellerID: 'SELLER789',
//     buyerID: 'BUYER101',
//     orderTime: '2023-12-01 15:00:00',
//     payTime: '2023-12-01 15:10:00',
//     refundTime: '2023-12-02 09:00:00',
//     shippingTime: '2023-12-01 18:00:00',
//     turnoverTime: null,
//     status: '未处理'
//   }
// ])

const handleAction = (row, action) => {
  const message = action === '同意退货' ? '确定同意退货吗？' : '确定拒绝退货吗？'
  ElMessageBox.confirm(message, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    row.status = action
    const tradeID = row.tradeID
    // console.log('测试：', tradeID)
    const res = await operateRefundListApi({ tradeID, action })
    if (res.data.code === 1) {
      ElMessage.success('操作成功！')
    }
  })
}
</script>

<template>
  <div class="contain">
    <h1>售后管理</h1>
    <br /><br />
    <div style="display: flex; justify-content: space-between; margin-bottom: 15px">
      <div style="display: flex; justify-content: flex-end">
        <el-input
          v-model="queryForm.searchQuery"
          placeholder="请输入订单ID进行搜索"
          @keyup.enter="getRefundList"
          style="width: 250px"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
        </el-input>
      </div>
    </div>

    <!-- 订单列表 -->
    <el-table :data="refundList" border>
      <el-table-column prop="tradeID" label="订单号" align="center"></el-table-column>
      <el-table-column prop="goodsName" label="商品名称" align="center"></el-table-column>

      <el-table-column prop="sellerName" label="卖家" align="center"></el-table-column>
      <!-- 卖家理由 -->
      <el-table-column label="卖家理由" align="center">
        <template #default="scope">
          <el-popover effect="light" trigger="hover" placement="top" width="auto">
            <template #default>
              {{ scope.row.sellerReason }}
            </template>
            <template #reference>
              <el-button link type="primary" size="small">查看</el-button>
            </template>
          </el-popover>
        </template>
      </el-table-column>

      <el-table-column prop="buyerName" label="买家" align="center"></el-table-column>
      <!-- 买家理由 -->
      <el-table-column label="买家理由" align="center">
        <template #default="scope">
          <el-popover effect="light" trigger="hover" placement="top" width="auto">
            <template #default>
              {{ scope.row.buyerReason }}
            </template>
            <template #reference>
              <el-button link type="primary" size="small">查看</el-button>
            </template>
          </el-popover>
        </template>
      </el-table-column>

      <!-- 查看详情 -->
      <el-table-column label="更多" align="center">
        <template #default="scope">
          <el-popover effect="light" trigger="hover" placement="top" width="auto">
            <template #default>
              <div>商品金额: {{ scope.row.price }}元</div>
              <div v-if="scope.row.shippingCost != 0">运费: {{ scope.row.shippingCost }}元</div>
              <div>卖家ID: {{ scope.row.sellerID }}</div>
              <div>买家ID: {{ scope.row.buyerID }}</div>
              <div>下单时间: {{ scope.row.orderTime }}</div>
              <div>支付时间: {{ scope.row.payTime }}</div>
              <div>退货申请时间: {{ scope.row.refundTime }}</div>
              <div v-if="scope.row.shippingTime">发货时间: {{ scope.row.shippingTime }}</div>
              <div v-if="scope.row.turnoverTime">成交时间: {{ scope.row.turnoverTime }}</div>
            </template>
            <template #reference>
              <el-button link type="primary" size="small">查看详情</el-button>
            </template>
          </el-popover>
        </template>
      </el-table-column>

      <el-table-column prop="status" label="订单状态" align="center">
        <template #default="{ row }">{{ row.status }}</template>
      </el-table-column>

      <el-table-column label="操作" align="center" width="230">
        <template #default="{ row }">
          <el-row type="flex" justify="center" :gutter="10" v-if="row.status == '未处理'">
            <el-button type="primary" @click="handleAction(row, '同意退货')">同意退货</el-button>
            <el-button type="danger" @click="handleAction(row, '拒绝退货')">拒绝退货</el-button>
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
