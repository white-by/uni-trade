<template>
  <UserNav />
  <!-- 我买到的 -->
  <div style="display: flex; justify-content: center; margin: 50px">
    <el-card>
      <el-row style="margin-bottom: 20px; color: dimgray"><h3>我买到的</h3></el-row
      ><el-table :data="purchasedData" stripe border>
        <el-table-column prop="tradeID" label="订单号"></el-table-column>

        <el-table-column prop="goodsName" label="商品名称" width="150"></el-table-column>
        <el-table-column label="实付"
          ><template #default="{ row }"> {{ row.price + row.shippingCost }}元 </template></el-table-column
        >
        <el-table-column prop="sellerName" label="卖家" width="100"></el-table-column>
        <!-- 发货方式 -->
        <el-table-column prop="deliveryMethod" label="发货方式" width="100"> </el-table-column>

        <!-- 用户自己的收货地址 -->
        <el-table-column label="我的地址" width="200">
          <template #default="{ row }">
            {{ row.shippingAddress.province }}{{ row.shippingAddress.city }}{{ row.shippingAddress.area
            }}{{ row.shippingAddress.detailArea }}
          </template>
        </el-table-column>

        <!-- 查看详情 -->
        <el-table-column label="更多"
          ><template #default="scope">
            <el-popover effect="light" trigger="hover" placement="top" width="auto">
              <template #default>
                <div>商品金额: {{ scope.row.price }}元</div>
                <div v-if="scope.row.shippingCost != 0">运费: {{ scope.row.shippingCost }}元</div>
                <div>
                  发货地址: {{ scope.row.SenderAddress.province }}{{ scope.row.SenderAddress.city
                  }}{{ scope.row.SenderAddress.area }}{{ scope.row.SenderAddress.detailArea }}
                </div>
                <div>下单时间: {{ scope.row.orderTime }}</div>
                <div>支付时间: {{ scope.row.payTime }}</div>
                <div v-if="scope.row.shippingTime">发货时间: {{ scope.row.shippingTime }}</div>
                <div v-if="scope.row.turnoverTime">成交时间: {{ scope.row.turnoverTime }}</div>
              </template>
              <template #reference>
                <el-button link type="primary" size="small"> 查看详情 </el-button>
              </template>
            </el-popover>
          </template></el-table-column
        >

        <!-- 订单状态 -->
        <el-table-column prop="status" label="订单状态" width="100"></el-table-column>

        <!-- 操作栏 -->
        <el-table-column label="操作" width="180">
          <template #default="scope">
            <el-button
              v-if="scope.row.status == '未发货'"
              :disabled="scope.row.deliveryMethod === '无需快递'"
              size="small"
              type="primary"
              plain
              @click="openEditDialog(scope.row)"
            >
              修改地址
            </el-button>

            <el-button
              v-if="scope.row.status == '已发货'"
              size="small"
              type="primary"
              plain
              @click="handleComfirm(scope.$index, scope.row)"
            >
              确认收货
            </el-button>
            <el-button
              v-if="scope.row.status == '交易完成'"
              size="small"
              type="primary"
              plain
              @click="handleComment(scope.$index, scope.row)"
            >
              去评价
            </el-button>
            <el-button
              v-if="scope.row.status == '未发货' || scope.row.status == '已发货'"
              size="small"
              type="danger"
              @click="handleRefund(scope.$index, scope.row)"
            >
              退款
            </el-button>
            <el-button
              v-if="scope.row.status == '退款中'"
              size="small"
              type="primary"
              plain
              @click="handleCancelRefund(scope.$index, scope.row)"
            >
              取消退款
            </el-button>
          </template></el-table-column
        >
      </el-table>

      <!-- 分页 -->
      <div>
        <el-pagination
          size="small"
          style="justify-content: center; margin-top: 20px"
          layout="prev, pager, next"
          :current-page="purchasedPageNum"
          :page-size="purchasedPageSize"
          :total="purchasedTotal"
          @current-change="handlePruchasedPageChange"
        />
      </div>
    </el-card>

    <!-- 修改地址对话框 -->
    <el-dialog title="修改地址" v-model="dialogVisible" width="500px" @close="resetForm">
      <el-form-item label="新地址">
        <AreaComponets
          ref="areaComponentRef"
          @updateProvince="editForm.province = $event"
          @updateCity="editForm.city = $event"
          @updateArea="editForm.area = $event"
        />
        <el-input
          v-model="editForm.detailArea"
          placeholder="请输入详细地址"
          style="margin-top: 10px; width: 340px"
        ></el-input>
      </el-form-item>

      <span class="dialog-footer" style="display: flex; justify-content: center">
        <el-button type="primary" @click="confirmEdit">确认修改</el-button>
      </span>
    </el-dialog>
  </div>

  <!-- 我卖出的 -->
  <div style="display: flex; justify-content: center; margin: 50px">
    <el-card
      ><el-row style="margin-bottom: 20px; color: dimgray"><h3>我卖出的</h3></el-row
      ><el-table :data="selledData" stripe border>
        <el-table-column prop="tradeID" label="订单号"></el-table-column>

        <el-table-column prop="goodsName" label="商品名称" width="150"></el-table-column>
        <el-table-column label="实收"
          ><template #default="{ row }"> {{ row.price + row.shippingCost }}元 </template></el-table-column
        >
        <el-table-column prop="sellerName" label="买家" width="100"></el-table-column>
        <!-- 发货方式 -->
        <el-table-column prop="deliveryMethod" label="发货方式" width="100"> </el-table-column>

        <!-- 买家的收货地址 -->
        <el-table-column label="收货地址" width="200">
          <template #default="{ row }">
            {{ row.shippingAddress.province }}{{ row.shippingAddress.city }}{{ row.shippingAddress.area
            }}{{ row.shippingAddress.detailArea }}
          </template>
        </el-table-column>

        <!-- 详细信息 -->
        <el-table-column label="更多"
          ><template #default="scope">
            <el-popover effect="light" trigger="hover" placement="top" width="auto">
              <template #default>
                <div>商品金额: {{ scope.row.price }}元</div>
                <div v-if="scope.row.shippingCost != 0">运费: {{ scope.row.shippingCost }}元</div>
                <div>
                  发货地址: {{ scope.row.SenderAddress.province }}{{ scope.row.SenderAddress.city
                  }}{{ scope.row.SenderAddress.area }}{{ scope.row.SenderAddress.detailArea }}
                </div>
                <div>下单时间: {{ scope.row.orderTime }}</div>
                <div>支付时间: {{ scope.row.payTime }}</div>
                <div v-if="scope.row.shippingTime">发货时间: {{ scope.row.shippingTime }}</div>
                <div v-if="scope.row.turnoverTime">成交时间: {{ scope.row.turnoverTime }}</div>
              </template>
              <template #reference>
                <el-button link type="primary" size="small"> 查看详情 </el-button>
              </template>
            </el-popover>
          </template></el-table-column
        >

        <!-- 订单状态 -->
        <el-table-column prop="status" label="订单状态" width="100"></el-table-column>

        <!-- 操作栏 -->
        <el-table-column label="操作" width="180">
          <template #default="scope">
            <el-button
              v-if="scope.row.status == '未发货'"
              size="small"
              type="primary"
              plain
              @click="handleDispatch(scope.row)"
            >
              去发货
            </el-button>

            <el-button
              v-if="scope.row.status == '未发货'"
              size="small"
              type="danger"
              @click="handleComfirm(scope.$index, scope.row)"
            >
              取消订单
            </el-button>
            <el-button
              v-if="scope.row.status == '交易完成'"
              size="small"
              type="primary"
              plain
              @click="handleComment(scope.$index, scope.row)"
            >
              去评价
            </el-button>
            <el-button
              v-if="scope.row.status == '退款中'"
              size="small"
              type="primary"
              plain
              @click="handleCancelRefund(scope.$index, scope.row)"
            >
              同意退款
            </el-button>
            <el-button
              v-if="scope.row.status == '退款中'"
              size="small"
              type="danger"
              @click="handleCancelRefund(scope.$index, scope.row)"
            >
              拒绝退款
            </el-button>
          </template></el-table-column
        >
      </el-table>

      <!-- 分页 -->
      <div>
        <el-pagination
          size="small"
          style="justify-content: center; margin-top: 20px"
          layout="prev, pager, next"
          :current-page="selledPageNum"
          :page-size="selledPageSize"
          :total="selledTotal"
          @current-change="handleSelledPageChange"
        />
      </div>
    </el-card>
  </div>
  <UserFooter />
</template>

<script setup>
import UserNav from '@/components/UserNav.vue'
import UserFooter from '@/components/UserFooter.vue'
import { onMounted, ref } from 'vue'
import AreaComponets from '@/components/AreaComponets.vue'
import { getPurchasedDataAPI, getSelledDataAPI } from '@/api/order.js'

// 从接口拿取“我买到的”订单信息
let purchasedPageNum = ref(1) //表格页码
let purchasedPageSize = ref(5) //每页最大展示条数
const purchasedTotal = ref(0)
const purchasedData = ref([])
const getPurchasedData = async () => {
  const res = await getPurchasedDataAPI(purchasedPageNum.value, purchasedPageSize.value)
  console.log('getPurchasedDataAPI响应:', res.data.data)
  purchasedData.value = res.data.data.orderList
  purchasedTotal.value = res.data.data.total
}

const handlePruchasedPageChange = (page) => {
  purchasedPageNum.value = page
  getPurchasedData()
}

// 从接口拿取“我卖出的”订单信息
let selledPageNum = ref(1) //表格页码
let selledPageSize = ref(5) //每页最大展示条数
const selledTotal = ref(0)
const selledData = ref([])
const getSelledData = async () => {
  const res = await getSelledDataAPI(selledPageNum.value, selledPageSize.value)
  console.log('getSelledDataAPI响应:', res.data.data)
  selledData.value = res.data.data.orderList
  selledTotal.value = res.data.data.total
}

const handleSelledPageChange = (page) => {
  selledPageNum.value = page
  getSelledData()
}

onMounted(() => {
  getPurchasedData(), getSelledData()
})

//修改地址组件逻辑
const areaComponentRef = ref(null)
const dialogVisible = ref(false)
const editForm = ref({
  tradeID: '',
  province: '',
  city: '',
  area: '',
  detailArea: ''
})

const openEditDialog = (row) => {
  dialogVisible.value = true
  editForm.value = { ...row }
}

const confirmEdit = () => {
  // 更新订单数据中的地址信息
  const order = purchasedData.value.find((item) => item.tradeID === editForm.value.tradeID)
  if (order) {
    order.shippingAddress.province = editForm.value.province
    order.shippingAddress.city = editForm.value.city
    order.shippingAddress.area = editForm.value.area
    order.shippingAddress.detailArea = editForm.value.detailArea
    console.log('更新后的地址信息：', order.shippingAddress)
  }
  dialogVisible.value = false
  resetForm()
}

const resetForm = () => {
  //重置表单数据
  editForm.value = { tradeID: '', province: '', city: '', area: '', detailAddress: '' }
  if (areaComponentRef.value) {
    areaComponentRef.value.resetAddress()
  }
  console.log('已重置表单数据')
}
</script>
