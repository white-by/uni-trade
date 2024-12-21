<!-- 只能查询 -->

<script setup>
import { ref, onMounted } from 'vue'
import { Search } from '@element-plus/icons-vue'
import useFormatTime from '@/hooks/useFormatTime'
import { getOrderListApi } from '@/api/saleInfo'

const { formatTime } = useFormatTime()

const queryForm = ref({
  searchQuery: '',
  pageNum: 1,
  pageSize: 5
})
const total = ref(0)
const orderList = ref([])

const getOrderList = async () => {
  // console.log('query: ', queryForm.value)
  const res = await getOrderListApi(queryForm.value)
  // console.log('res: ', res.data)
  orderList.value = res.data.data.orderList
  total.value = res.data.data.total
  // console.log('orderList: ', orderList.value)
}

const handlePageChange = (pageNum) => {
  queryForm.value.pageNum = pageNum
  getOrderList()
}

onMounted(() => {
  getOrderList()
})
</script>

<template>
  <div class="contain">
    <h1>订单管理</h1>
    <br /><br />
    <div style="display: flex; justify-content: space-between; margin-bottom: 15px">
      <div style="display: flex; justify-content: flex-end">
        <el-input
          v-model="queryForm.searchQuery"
          placeholder="请输入订单ID进行搜索"
          @keyup.enter="getOrderList"
          style="width: 250px"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
        </el-input>
      </div>
    </div>

    <!-- 订单列表 -->
    <el-table :data="orderList" border>
      <el-table-column prop="tradeID" label="订单号" align="center"></el-table-column>

      <el-table-column prop="goodsName" label="商品名称" align="center"></el-table-column>
      <el-table-column label="实付" align="center">
        <template #default="{ row }"> {{ row.price + row.shippingCost }}元 </template>
      </el-table-column>
      <el-table-column prop="sellerName" label="卖家" align="center"></el-table-column>
      <el-table-column prop="buyerName" label="买家" align="center"></el-table-column>
      <el-table-column prop="deliveryMethod" label="发货方式" align="center">
        <template #default="{ row }">
          <span v-if="row.deliveryMethod == '0'">无需快递</span>
          <span v-else-if="row.deliveryMethod == '1'">自提</span>
          <span v-else-if="row.deliveryMethod == '2'">邮寄</span>
          <span v-else>未知方式</span>
        </template>
      </el-table-column>
      <el-table-column label="收货地址" align="center">
        <template #default="{ row }">
          {{ row.shippingAddress.province }}
          {{ row.shippingAddress.city }}
          {{ row.shippingAddress.area }}
          {{ row.shippingAddress.detailArea }}
        </template>
      </el-table-column>
      <el-table-column label="发货地址" align="center">
        <template #default="{ row }">
          {{ row.senderAddress.province }}
          {{ row.senderAddress.city }}
          {{ row.senderAddress.area }}
          {{ row.senderAddress.detailArea }}
        </template>
      </el-table-column>

      <!-- 查看详情 -->
      <el-table-column label="更多" align="center"
        ><template #default="scope">
          <el-popover effect="light" trigger="hover" placement="top" width="auto">
            <template #default>
              <div>商品金额: {{ scope.row.price }}元</div>
              <div v-if="scope.row.shippingCost != 0">运费: {{ scope.row.shippingCost }}元</div>
              <div>卖家ID: {{ scope.row.sellerID }}</div>
              <div>买家ID: {{ scope.row.buyerID }}</div>
              <div>下单时间: {{ formatTime(scope.row.orderTime) }}</div>
              <div v-if="scope.row.payTime != '0001-01-01T00:00:00Z'">
                支付时间: {{ formatTime(scope.row.payTime) }}
              </div>
              <div v-if="scope.row.shippingTime != '0001-01-01T00:00:00Z'">
                发货时间: {{ formatTime(scope.row.shippingTime) }}
              </div>
              <div v-if="scope.row.turnoverTime != '0001-01-01T00:00:00Z'">
                成交时间: {{ formatTime(scope.row.turnoverTime) }}
              </div>
            </template>
            <template #reference>
              <el-button link type="primary" size="small"> 查看详情 </el-button>
            </template>
          </el-popover>
        </template>
      </el-table-column>
      <el-table-column prop="status" label="订单状态" align="center"></el-table-column>
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
