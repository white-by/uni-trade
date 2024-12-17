<!-- 暂时删掉了卖家的评价功能，目前只有买家能评价 -->

<template>
  <UserNav />
  <!-- 我买到的 -->
  <div style="display: flex; justify-content: center; margin: 50px">
    <el-card>
      <el-row style="margin-bottom: 20px; color: dimgray"><h3>我买到的</h3></el-row
      ><el-table :data="purchasedData" stripe border empty-text="暂无买到的订单">
        <el-table-column prop="tradeID" label="订单号" width="80"></el-table-column>

        <el-table-column prop="goodsName" label="商品名称" width="150"></el-table-column>
        <el-table-column label="实付" width="80"
          ><template #default="{ row }"> {{ row.price + row.shippingCost }}元 </template></el-table-column
        >
        <el-table-column prop="deliveryMethod" label="发货方式" width="100">
          <template #default="{ row }">
            <span v-if="row.deliveryMethod == '0'">无需快递</span>
            <span v-else-if="row.deliveryMethod == '1'">自提</span>
            <span v-else-if="row.deliveryMethod == '2'">邮寄</span>
            <span v-else>未知方式</span>
          </template></el-table-column
        >
        <el-table-column prop="shippingAddress.name" label="联系人" width="80"></el-table-column>
        <el-table-column prop="shippingAddress.tel" label="联系电话" width="130"></el-table-column>
        <!-- 用户自己的收货地址 -->
        <el-table-column label="我的地址" width="200">
          <template #default="{ row }">
            {{ row.shippingAddress.province }}
            {{ row.shippingAddress.city }}
            {{ row.shippingAddress.area }}
            {{ row.shippingAddress.detailArea }}
          </template>
        </el-table-column>

        <!-- 查看详情 -->
        <el-table-column label="更多" width="80"
          ><template #default="scope">
            <el-popover effect="light" trigger="hover" placement="top" width="auto">
              <template #default>
                <div>商品金额: {{ scope.row.price }}元</div>
                <div v-if="scope.row.shippingCost != 0">运费: {{ scope.row.shippingCost }}元</div>
                <div>
                  发货地址: {{ scope.row.senderAddress.province }}
                  {{ scope.row.senderAddress.city }}
                  {{ scope.row.senderAddress.area }}
                  {{ scope.row.senderAddress.detailArea }}
                </div>
                <div>卖家: {{ scope.row.sellerName }}</div>
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
              @click="openAddressEditDialog(scope.row)"
            >
              修改地址
            </el-button>

            <el-button
              v-if="scope.row.status == '已发货'"
              size="small"
              type="primary"
              plain
              @click="handleReceiving(scope.$index, scope.row)"
            >
              确认收货
            </el-button>
            <el-button
              v-if="scope.row.status == '交易完成'"
              size="small"
              type="primary"
              plain
              @click="showCommentDialog(scope.row)"
            >
              去评价
            </el-button>
            <el-button
              v-if="scope.row.status == '未发货' || scope.row.status == '已发货'"
              size="small"
              type="danger"
              @click="showRefundDialog(scope.row)"
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
            <el-button
              v-if="scope.row.status == '未付款'"
              size="small"
              type="primary"
              plain
              @click="handlePay(scope.$index, scope.row)"
            >
              去付款
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
        <el-button type="primary" @click="throttledConfirmAddressEdit">确认修改</el-button>
      </span>
    </el-dialog>

    <!-- 评价对话框 -->
    <el-dialog title="评价内容" v-model="commentDialogVisible" width="500px" @close="resetCommentForm">
      <el-input
        v-model="comment"
        placeholder="请输入评价内容"
        :rows="3"
        type="textarea"
        style="margin-bottom: 10px"
      ></el-input>
      <span class="dialog-footer" style="display: flex; justify-content: center">
        <el-button type="primary" @click="throttledHandleComment">确 定</el-button>
      </span>
    </el-dialog>

    <!-- 退款对话框 -->
    <el-dialog title="退款理由" v-model="refundDialogVisible" width="500px" @close="resetRefundForm">
      <el-input
        v-model="refundReason"
        placeholder="请条理清晰地填写退款理由。纠纷订单将交付管理员处理。"
        :rows="3"
        type="textarea"
        style="margin-bottom: 10px"
      ></el-input>
      <span class="dialog-footer" style="display: flex; justify-content: center">
        <el-button type="primary" @click="throttledHandleRefund">确 定</el-button>
      </span>
    </el-dialog>
  </div>

  <!-- 我卖出的 -->
  <div style="display: flex; justify-content: center; margin: 50px">
    <el-card
      ><el-row style="margin-bottom: 20px; color: dimgray"><h3>我卖出的</h3></el-row
      ><el-table :data="selledData" stripe border empty-text="暂无卖出的订单">
        <el-table-column prop="tradeID" label="订单号" width="80"></el-table-column>

        <el-table-column prop="goodsName" label="商品名称" width="150"></el-table-column>
        <el-table-column label="实收" width="80"
          ><template #default="{ row }"> {{ row.price + row.shippingCost }}元 </template></el-table-column
        >
        <el-table-column prop="deliveryMethod" label="发货方式" width="100">
          <template #default="{ row }">
            <span v-if="row.deliveryMethod == '0'">无需快递</span>
            <span v-else-if="row.deliveryMethod == '1'">自提</span>
            <span v-else-if="row.deliveryMethod == '2'">邮寄</span>
            <span v-else>未知方式</span>
          </template>
        </el-table-column>
        <el-table-column prop="shippingAddress.name" label="联系人" width="80"></el-table-column>
        <el-table-column prop="shippingAddress.tel" label="联系电话" width="130"></el-table-column>

        <!-- 买家的收货地址 -->
        <el-table-column label="收货地址" width="200">
          <template #default="{ row }">
            {{ row.shippingAddress.province }}
            {{ row.shippingAddress.city }}
            {{ row.shippingAddress.area }}
            {{ row.shippingAddress.detailArea }}
          </template>
        </el-table-column>

        <!-- 详细信息 -->
        <el-table-column label="更多" width="80"
          ><template #default="scope">
            <el-popover effect="light" trigger="hover" placement="top" width="auto">
              <template #default>
                <div>商品金额: {{ scope.row.price }}元</div>
                <div v-if="scope.row.shippingCost != 0">运费: {{ scope.row.shippingCost }}元</div>
                <div>
                  发货地址: {{ scope.row.senderAddress.province }}
                  {{ scope.row.senderAddress.city }}
                  {{ scope.row.senderAddress.area }}
                  {{ scope.row.senderAddress.detailArea }}
                </div>
                <div>买家: {{ scope.row.sellerName }}</div>
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
              @click="handleCancelOrder(scope.$index, scope.row)"
            >
              取消订单
            </el-button>

            <el-button
              v-if="scope.row.status == '退款中'"
              size="small"
              type="primary"
              plain
              @click="handleAcceptRefund(scope.$index, scope.row)"
            >
              同意退款
            </el-button>
            <el-button
              v-if="scope.row.status == '退款中'"
              size="small"
              type="danger"
              @click="showRejectRefundDialog(scope.row)"
            >
              拒绝退款
            </el-button>
          </template></el-table-column
        >
      </el-table>

      <!-- 拒绝退款对话框 -->
      <el-dialog title="拒绝退款理由" v-model="rejectRefundDialogVisible" width="500px" @close="resetRefundForm">
        <el-input
          v-model="refundReason"
          placeholder="请条理清晰地填写拒绝退款理由。纠纷订单将交付管理员处理。"
          :rows="3"
          type="textarea"
          style="margin-bottom: 10px"
        ></el-input>
        <span class="dialog-footer" style="display: flex; justify-content: center">
          <el-button type="primary" @click="throttledHandleRejectRefund">确 定</el-button>
        </span>
      </el-dialog>

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
import { onMounted, ref, reactive, nextTick } from 'vue'
import AreaComponets from '@/components/AreaComponets.vue'
import { getPurchasedDataAPI, getSelledDataAPI, operateOrderAPI, editAddressAPI } from '@/api/order.js'
import { ElMessage, ElMessageBox } from 'element-plus'
import useThrottle from '@/hooks/useThrottle'
import { useRouter } from 'vue-router'

const { throttled } = useThrottle() // 节流
const router = useRouter()

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

// 对话框状态
const commentDialogVisible = ref(false)
const refundDialogVisible = ref(false)
const rejectRefundDialogVisible = ref(false)

// 当前操作的订单信息
const currentOrder = reactive({
  id: null,
  targetStatus: ''
})

// 评价和退款的输入内容
const comment = ref('')
const refundReason = ref('')

// 重置评价表单数据
const resetCommentForm = () => {
  comment.value = ''
}

// 重置退款表单数据
const resetRefundForm = () => {
  refundReason.value = ''
}

// 显示评价对话框
const showCommentDialog = (order) => {
  currentOrder.id = order.tradeID
  currentOrder.targetStatus = '已评价'
  commentDialogVisible.value = true
}

// 显示退款对话框
const showRefundDialog = (order) => {
  currentOrder.id = order.tradeID
  currentOrder.targetStatus = '退款中'
  refundDialogVisible.value = true
}

// 显示拒绝退款对话框
const showRejectRefundDialog = (order) => {
  currentOrder.id = order.tradeID
  currentOrder.targetStatus = '处理中'
  rejectRefundDialogVisible.value = true
}

const handlePay = async (index, row) => {
  const orderId = row.tradeID
  localStorage.setItem('tradeId', orderId)
  router.push({
    path: '/pay',
    query: {
      id: orderId
    }
  })
}

// 确认评价
const handleComment = async () => {
  if (!comment.value) {
    ElMessage.warning('请输入评价内容')
    return
  }

  const res = await operateOrderAPI({
    id: currentOrder.id,
    status: currentOrder.targetStatus,
    comment: comment.value
  })
  if (res.data.code === 1) {
    ElMessage.success('评价成功！')
    // 最新状态
    const currentStatus = res.data.data.status
    // 查找表格中对应的订单并更新状态 插入哪张表？？要不就只有买家能评价吧
    const order = purchasedData.value.find((item) => item.tradeID === currentOrder.id)
    if (order) {
      order.status = currentStatus // 更新表格数据的状态
    }
  } else {
    ElMessage.error('网络请求失败')
  }
  commentDialogVisible.value = false
}
// 节流处理：限制每秒响应一次
const throttledHandleComment = throttled(handleComment, 1000)

// 退款
const handleRefund = async () => {
  if (!refundReason.value) {
    ElMessage.warning('请输入退款理由')
    return
  }

  const res = await operateOrderAPI({
    id: currentOrder.id,
    status: currentOrder.targetStatus,
    refundReason: refundReason.value
  })
  if (res.data.code === 1) {
    ElMessage.success('退款申请成功！')
    // 最新状态
    const currentStatus = res.data.data.status
    // 查找表格中对应的订单并更新状态
    const order = purchasedData.value.find((item) => item.tradeID === currentOrder.id)
    if (order) {
      order.status = currentStatus
    }
  } else {
    ElMessage.error('网络请求失败')
  }
  refundDialogVisible.value = false
}
// 节流处理：限制每秒响应一次
const throttledHandleRefund = throttled(handleRefund, 1000)

// 确认收货
const handleReceiving = async (index, row) => {
  try {
    await ElMessageBox.confirm('您确定要确认收货吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    const res = await operateOrderAPI({
      id: row.tradeID,
      status: '交易完成'
    })
    if (res.data.code === 1) {
      ElMessage.success('收货成功！')
      const currentStatus = res.data.data.status
      row.status = currentStatus
    } else {
      ElMessage.error('网络请求失败')
    }
  } catch {
    ElMessage.info('操作已取消')
  }
}

// 取消退款
const handleCancelRefund = async (index, row) => {
  try {
    await ElMessageBox.confirm('您确定要取消退款吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    const res = await operateOrderAPI({
      id: row.tradeID,
      status: '退款的上一个状态'
    })
    if (res.data.code === 1) {
      ElMessage.success('取消退款成功！')
      const currentStatus = res.data.data.status
      row.status = currentStatus
    } else {
      ElMessage.error('网络请求失败')
    }
  } catch {
    ElMessage.info('操作已取消')
  }
}

// 去发货
const handleDispatch = async (row) => {
  try {
    await ElMessageBox.confirm('您确定要发货吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    const res = await operateOrderAPI({
      id: row.tradeID,
      status: '已发货'
    })
    if (res.data.code === 1) {
      ElMessage.success('发货成功！')
      const currentStatus = res.data.data.status
      row.status = currentStatus
    } else {
      ElMessage.error('网络请求失败')
    }
  } catch {
    ElMessage.info('操作已取消')
  }
}

// 取消订单
const handleCancelOrder = async (index, row) => {
  try {
    await ElMessageBox.confirm('您确定要取消订单吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    const res = await operateOrderAPI({
      id: row.tradeID,
      status: '已取消'
    })
    if (res.data.code === 1) {
      ElMessage.success('取消订单成功！')
      const currentStatus = res.data.data.status
      row.status = currentStatus
    } else {
      ElMessage.error('网络请求失败')
    }
  } catch {
    ElMessage.info('操作已取消')
  }
}

// 同意退款
const handleAcceptRefund = async (index, row) => {
  try {
    await ElMessageBox.confirm('您确定要同意退款吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    const res = await operateOrderAPI({
      id: row.tradeID,
      status: '已退款'
    })
    if (res.data.code === 1) {
      ElMessage.success('已同意退款')
      const currentStatus = res.data.data.status
      row.status = currentStatus
    } else {
      ElMessage.error('网络请求失败')
    }
  } catch {
    ElMessage.info('操作已取消')
  }
}

// 拒绝退款
const handleRejectRefund = async () => {
  if (!refundReason.value) {
    ElMessage.warning('请输入退款理由')
    return
  }

  const res = await operateOrderAPI({
    id: currentOrder.id,
    status: '处理中',
    rejectReason: refundReason.value
  })
  if (res.data.code === 1) {
    ElMessage.success('拒绝退款，移交管理员处理')
    // 最新状态
    const currentStatus = res.data.data.status
    // 查找表格中对应的订单并更新状态
    const order = selledData.value.find((item) => item.tradeID === currentOrder.id)
    if (order) {
      order.status = currentStatus
    }
  } else {
    ElMessage.error('网络请求失败')
  }
  rejectRefundDialogVisible.value = false
}
// 节流处理：限制每秒响应一次
const throttledHandleRejectRefund = throttled(handleRejectRefund, 1000)

onMounted(() => {
  getPurchasedData(), getSelledData()
})

//修改地址组件逻辑
const areaComponentRef = ref(null)
const dialogVisible = ref(false)
const editForm = ref({
  tradeID: '',
  addrID: '',
  province: '',
  city: '',
  area: '',
  detailArea: ''
})

const openAddressEditDialog = (row) => {
  dialogVisible.value = true
  editForm.value = {
    tradeID: row.tradeID,
    addrID: row.shippingAddress.addrID,
    province: row.shippingAddress.province,
    city: row.shippingAddress.city,
    area: row.shippingAddress.area,
    detailArea: row.shippingAddress.detailArea
  }
  nextTick(() => {
    if (areaComponentRef.value) {
      areaComponentRef.value.setAddress(editForm.value.province, editForm.value.city, editForm.value.area)
    }
  })
}

const confirmAddressEdit = async () => {
  const params = {
    id: editForm.value.tradeID,
    addrID: editForm.value.addrID
  }
  // console.log('params:', params)
  const res = await editAddressAPI(params)
  if (res.data.code === 1) {
    ElMessage.success('修改成功')
    // 更新订单数据中的地址信息
    const order = purchasedData.value.find((item) => item.tradeID === editForm.value.tradeID)
    if (order) {
      order.shippingAddress.province = editForm.value.province
      order.shippingAddress.city = editForm.value.city
      order.shippingAddress.area = editForm.value.area
      order.shippingAddress.detailArea = editForm.value.detailArea
    }
  } else {
    ElMessage.error('网络请求失败')
  }

  dialogVisible.value = false
  resetForm()
}
// 节流处理：限制每秒响应一次
const throttledConfirmAddressEdit = throttled(confirmAddressEdit, 1000)

const resetForm = () => {
  //重置表单数据
  editForm.value = { tradeID: '', province: '', city: '', area: '', detailAddress: '' }
  if (areaComponentRef.value) {
    areaComponentRef.value.resetAddress()
  }
}
</script>
