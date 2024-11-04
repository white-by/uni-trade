<template>
  <!--TODO: 
  1. 把省市区下拉框搬过来，放进地址编辑dialog里。也许可以让地址下拉框独立成组件？
  2. 实付栏数据应为商品价格+运费
  5. 接口文档的数据有待更改
  -->
  <UserNav />
  <!--我买到的-->
  <div style="display: flex; justify-content: center; margin: 50px">
    <el-card>
      <el-row style="margin-bottom: 20px; color: dimgray"><h3>我买到的</h3></el-row
      ><el-table :data="purchasedData" stripe border>
        <el-table-column prop="tradeID" label="订单号"></el-table-column>

        <el-table-column prop="goodsName" label="商品名称" width="100"></el-table-column>
        <el-table-column prop="price" label="实付"></el-table-column>
        <el-table-column prop="sellerName" label="卖家" width="100"></el-table-column>
        <el-table-column prop="shippingAddress" label="我的地址" width="280"></el-table-column>
        <el-table-column label="更多"
          ><template #default="scope">
            <el-popover effect="light" trigger="hover" placement="top" width="auto">
              <template #default>
                <div>商品金额: {{ scope.row.price }}元</div>
                <div v-if="scope.row.shippingCost != 0">运费: {{ scope.row.shippingCost }}元</div>
                <div>发货地址: {{ scope.row.SenderAddress }}</div>
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
        <el-table-column prop="status" label="订单状态" width="100"></el-table-column>
        <el-table-column label="操作" width="180">
          <template #default="scope">
            <el-button v-if="scope.row.status == '未发货'" size="small" type="plain" @click="openEditDialog(scope.row)">
              修改地址
            </el-button>

            <el-button
              v-if="scope.row.status == '已发货'"
              size="small"
              type="plain"
              @click="handleComfirm(scope.$index, scope.row)"
            >
              确认收货
            </el-button>
            <el-button
              v-if="scope.row.status == '交易完成'"
              size="small"
              type="plain"
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
              type="plain"
              @click="handleCancelRefund(scope.$index, scope.row)"
            >
              取消退款
            </el-button>
          </template></el-table-column
        >
      </el-table>
      <div>
        <el-pagination
          size="small"
          style="justify-content: center; margin-top: 20px"
          layout="prev, pager, next"
          :total="50"
        />
      </div>
    </el-card>
    <!-- 修改地址对话框，待修改 -->
    <el-dialog title="修改地址" v-model="dialogVisible" width="500px" @close="resetForm">
      <el-form>
        <el-form-item label="地址" label-width="80px">
          <el-input v-model="editForm.shippingAddress" placeholder="请输入新地址"></el-input>
        </el-form-item>
      </el-form>
      <span class="dialog-footer">
        <el-button type="primary" @click="confirmEdit">确认修改</el-button>
      </span>
    </el-dialog>
  </div>

  <!--我卖出的-->
  <div style="display: flex; justify-content: center; margin: 50px">
    <el-card
      ><el-row style="margin-bottom: 20px; color: dimgray"><h3>我卖出的</h3></el-row
      ><el-table :data="selledData" stripe border>
        <el-table-column prop="tradeID" label="订单号"></el-table-column>

        <el-table-column prop="goodsName" label="商品名称" width="100"></el-table-column>
        <el-table-column prop="price" label="实收"></el-table-column>
        <el-table-column prop="sellerName" label="买家" width="100"></el-table-column>
        <el-table-column prop="shippingAddress" label="收货地址" width="280"></el-table-column>
        <el-table-column label="更多"
          ><template #default="scope">
            <el-popover effect="light" trigger="hover" placement="top" width="auto">
              <template #default>
                <div>商品金额: {{ scope.row.price }}元</div>
                <div v-if="scope.row.shippingCost != 0">运费: {{ scope.row.shippingCost }}元</div>
                <div>发货地址: {{ scope.row.SenderAddress }}</div>
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
        <el-table-column prop="status" label="订单状态" width="100"></el-table-column>
        <el-table-column label="操作" width="180">
          <template #default="scope">
            <el-button v-if="scope.row.status == '未发货'" size="small" type="plain" @click="handleDispatch(scope.row)">
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
              type="plain"
              @click="handleComment(scope.$index, scope.row)"
            >
              去评价
            </el-button>
            <el-button
              v-if="scope.row.status == '退款中'"
              size="small"
              type="plain"
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
      <div>
        <el-pagination
          size="small"
          style="justify-content: center; margin-top: 20px"
          layout="prev, pager, next"
          :total="50"
        />
      </div>
    </el-card>

    <!-- 修改地址对话框，待修改 -->
    <el-dialog title="修改地址" v-model="dialogVisible" width="500px" @close="resetForm">
      <el-form-item label="新地址">
        <AreaComponets
          ref="areaComponentRef"
          @updateProvince="editForm.province = $event"
          @updateCity="editForm.city = $event"
          @updateArea="editForm.area = $event"
        />
        <el-input
          v-model="editForm.detailAddress"
          placeholder="请输入详细地址"
          style="margin-top: 10px; width: auto"
        ></el-input>
      </el-form-item>

      <span class="dialog-footer">
        <el-button type="primary" @click="confirmEdit">确认修改</el-button>
      </span>
    </el-dialog>
  </div>
  <UserFooter />
</template>

<script setup>
import UserNav from '@/components/UserNav.vue'
import UserFooter from '@/components/UserFooter.vue'
import { ref, computed } from 'vue'
import AreaComponets from '@/components/AreaComponets.vue'

const dialogVisible = ref(false)
const editForm = ref({
  tradeID: '',
  province: '',
  city: '',
  area: '',
  detailAddress: ''
})

const shippingAddress = computed(() => {
  return `${editForm.value.province}${editForm.value.city}${editForm.value.area}${editForm.value.detailAddr}`
})

const openEditDialog = (row) => {
  // 打开对话框并加载当前行的地址数据
  dialogVisible.value = true
  editForm.value = { ...row }
}

const confirmEdit = () => {
  // 更新订单数据中的地址信息
  const order = purchasedData.value.find((item) => item.tradeID === editForm.value.tradeID)
  if (order) {
    order.shippingAddress = shippingAddress
  }
  console.log('更新后的地址信息：')

  dialogVisible.value = false
  resetForm()
}

const resetForm = () => {
  // 重置表单数据
  editForm.value = { tradeID: '', shippingAddress: '' }
}

//静态数据
const purchasedData = [
  {
    tradeID: 66,
    sellerID: 34,
    sellerName: '海绵纸',
    goodsID: 81,
    goodsName: '小狗玩偶',
    price: 199,
    shippingCost: 8,
    SenderAddress: '重庆金华市桃源县',
    shippingAddress: '澳门特别行政区扬州市札达县',
    orderTime: '2024-10-27 01:10:28',
    payTime: '2024-08-20 03:15:20',
    shippingTime: '',
    turnoverTime: '',
    status: '未发货'
  },
  {
    tradeID: 60,
    sellerID: 30,
    sellerName: '青枫',
    goodsID: 77,
    goodsName: '小猫玩偶',
    price: 61,
    shippingCost: 10,
    SenderAddress: '黑龙江省天津市凤县',
    shippingAddress: '福建省常州市红古区',
    orderTime: '2007-10-27 08:03:57',
    payTime: '1996-05-28 00:48:16',
    shippingTime: '2024-04-03 11:49:14',
    turnoverTime: '2002-10-08 18:00:16',
    status: '已发货'
  },
  {
    tradeID: 70,
    sellerID: 63,
    sellerName: '慕夏',
    goodsID: 78,
    goodsName: '小熊玩偶',
    price: 88,
    shippingCost: 12,
    SenderAddress: '贵州省乌兰察布市武清区',
    shippingAddress: '重庆黄南藏族自治州桃山区',
    orderTime: '1975-09-05 04:26:28',
    payTime: '2014-02-04 23:55:50',
    shippingTime: '1975-10-13 11:36:22',
    turnoverTime: '2024-01-28 05:57:33',
    status: '交易完成'
  }
]

const selledData = [
  {
    tradeID: 66,
    sellerID: 34,
    sellerName: '海绵纸',
    goodsID: 81,
    goodsName: '小狗玩偶',
    price: 199,
    shippingCost: 8,
    SenderAddress: '重庆金华市桃源县',
    shippingAddress: '澳门特别行政区扬州市札达县',
    orderTime: '2024-10-27 01:10:28',
    payTime: '2024-08-20 03:15:20',
    shippingTime: '',
    turnoverTime: '',
    status: '未发货'
  },
  {
    tradeID: 60,
    sellerID: 30,
    sellerName: '青枫',
    goodsID: 77,
    goodsName: '小猫玩偶',
    price: 61,
    shippingCost: 10,
    SenderAddress: '黑龙江省天津市凤县',
    shippingAddress: '福建省常州市红古区',
    orderTime: '2007-10-27 08:03:57',
    payTime: '1996-05-28 00:48:16',
    shippingTime: '2024-04-03 11:49:14',
    turnoverTime: '2002-10-08 18:00:16',
    status: '已发货'
  },
  {
    tradeID: 70,
    sellerID: 63,
    sellerName: '慕夏',
    goodsID: 78,
    goodsName: '小熊玩偶',
    price: 88,
    shippingCost: 12,
    SenderAddress: '贵州省乌兰察布市武清区',
    shippingAddress: '重庆黄南藏族自治州桃山区',
    orderTime: '1975-09-05 04:26:28',
    payTime: '2014-02-04 23:55:50',
    shippingTime: '1975-10-13 11:36:22',
    turnoverTime: '2024-01-28 05:57:33',
    status: '交易完成'
  }
]
</script>
