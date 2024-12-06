<!-- 结算页 -->

<template>
  <UserNav />
  <div class="checkout-page" v-if="cartStore.selectedProduct">
    <div class="container">
      <div class="wrapper">
        <!-- 收货地址 -->
        <h3 class="box-title">收货地址</h3>
        <div class="box-body">
          <div class="address">
            <div class="text">
              <div class="none" v-if="cartStore.selectedProduct.value.deliveryMethod == '无需快递'">该商品无需快递</div>
              <div class="none" v-else-if="!curAddress">您需要先添加收货地址才可提交订单。</div>
              <ul v-else>
                <li>
                  <span>收<i />货<i />人：</span>{{ curAddress.name }}
                </li>
                <li><span>联系方式：</span>{{ curAddress.tel }}</li>
                <li>
                  <span>收货地址：</span>{{ curAddress.province }}{{ curAddress.city }}{{ curAddress.area
                  }}{{ curAddress.detailArea }}
                </li>
              </ul>
            </div>
            <div class="action" v-show="cartStore.selectedProduct.value.deliveryMethod != '无需快递'">
              <el-button type="primary" plain size="large" @click="openSelectAddressDialog">切换地址</el-button>
              <el-button type="primary" plain size="large" @click="openAddDialog()">添加地址</el-button>
            </div>
          </div>
        </div>

        <!-- 商品信息 -->
        <h3 class="box-title">订单明细</h3>
        <div class="product-container">
          <div class="published-item">
            <img :src="getFirstImageURL(cartStore.selectedProduct.value.imageUrl)" alt="商品图片" class="item-image" />

            <div class="item-info">
              <h3 class="item-title">{{ cartStore.selectedProduct.value.title }}</h3>
              <span class="item-desc">{{ cartStore.selectedProduct.value.description }}</span>
            </div>
          </div>
        </div>

        <div class="box-body">
          <div class="total">
            <dl>
              <dt>商品总价：</dt>
              <dd>¥{{ cartStore.selectedProduct.value.price }}</dd>
            </dl>
            <dl>
              <dt>配送方式：</dt>
              <dd>{{ cartStore.selectedProduct.value.deliveryMethod }}</dd>
            </dl>
            <dl>
              <dt>运<i></i>费：</dt>
              <dd>¥{{ cartStore.selectedProduct.value.shippingCost }}</dd>
            </dl>
            <dl>
              <dt>应付总额：</dt>
              <dd class="price">
                ¥{{ cartStore.selectedProduct.value.shippingCost + cartStore.selectedProduct.value.price }}
              </dd>
            </dl>
          </div>
        </div>
        <!-- 提交订单 -->
        <div class="submit">
          <el-button type="primary" size="large" @click="createOrder()">提交订单</el-button>
        </div>
      </div>
    </div>
  </div>
  <div v-else>
    <p>结算状态失效，正在跳转到商品详情页...</p>
  </div>

  <!-- 切换地址 -->
  <el-dialog v-model="showSelectAddrDialog" title="切换收货地址" width="470px">
    <div class="addressWrapper">
      <div
        class="text item"
        v-for="item in addressData"
        :key="item.id"
        :class="{ active: tempActiveAddress.id === item.id }"
        @click="switchAddress(item)"
      >
        <ul>
          <li>
            <span>收<i />货<i />人：</span>{{ item.name }}
          </li>
          <li><span>联系方式：</span>{{ item.tel }}</li>
          <li><span>收货地址：</span>{{ item.province }}{{ item.city }}{{ item.area }}{{ item.detailArea }}</li>
        </ul>
      </div>
    </div>
    <template #footer>
      <span class="dialog-footer" style="display: flex; justify-content: center">
        <el-button @click="cancelSwitchAddress">取消</el-button>
        <el-button type="primary" @click="confirmSwitchAddress">确定</el-button>
      </span>
    </template>
  </el-dialog>

  <!-- 添加地址 -->
  <el-dialog title="新增地址" v-model="addDialogVisible" width="470px" @close="resetAddForm">
    <el-form :model="newAddress" :rules="rules" ref="addAddressFormRef" label-width="80px">
      <el-form-item label="联系地址" prop="province">
        <AreaComponets
          ref="_areaComponentRef"
          @updateProvince="newAddress.province = $event"
          @updateCity="newAddress.city = $event"
          @updateArea="newAddress.area = $event"
        />
        <el-input
          v-model="newAddress.detailArea"
          placeholder="请输入详细地址"
          style="margin-top: 10px; width: 340px"
        ></el-input>
      </el-form-item>
      <el-form-item label="联系人" prop="name" style="width: 420px">
        <el-input v-model="newAddress.name" placeholder="请输入联系人姓名"></el-input>
      </el-form-item>
      <el-form-item label="联系电话" prop="tel" style="width: 420px">
        <el-input v-model="newAddress.tel" placeholder="请输入联系人电话"></el-input>
      </el-form-item>
      <span class="dialog-footer" style="display: flex; justify-content: center">
        <el-button type="primary" @click="submitAddressForm">新增</el-button>
      </span>
    </el-form>
  </el-dialog>
  <UserFooter />
</template>

<script setup>
import UserNav from '@/components/UserNav.vue'
import UserFooter from '@/components/UserFooter.vue'
import { ref, onMounted } from 'vue'
import { getAddressListAPI, addAddressAPI } from '@/api/address'
import { createOrderAPI } from '@/api/pay'
import { ElMessage } from 'element-plus'
import { useCartStore } from '@/store/cartStore'
import { useRouter } from 'vue-router'

const showSelectAddrDialog = ref(false)
const addressData = ref([]) // 地址列表
const defaultAddressId = ref(null) // 默认地址 ID
const activeAddress = ref({}) // 激活的地址
const curAddress = ref(null) // 当前显示的地址
const tempActiveAddress = ref({}) // 临时选中的地址
const cartStore = useCartStore()
const router = useRouter()

// 地址是否使用地址ID？电话号码怎么办？
const createOrder = async () => {
  const orderData = ref({
    sellerID: cartStore.selectedProduct.value.userName,
    goodsID: cartStore.selectedProduct.value.id,
    price: cartStore.selectedProduct.value.price,
    deliveryMethod: cartStore.selectedProduct.value.deliveryMethod,
    shippingCost: cartStore.selectedProduct.value.shippingCost,
    SenderAddress: {
      province: cartStore.selectedProduct.value.province,
      city: cartStore.selectedProduct.value.city,
      area: cartStore.selectedProduct.value.area,
      detailArea: cartStore.selectedProduct.value.detailArea
    },
    shippingAddress: {
      province: curAddress.value.province,
      city: curAddress.value.city,
      area: curAddress.value.area,
      detailArea: curAddress.value.detailArea,
      name: curAddress.value.name,
      tel: curAddress.value.tel
    }
  })
  console.log('orderData:', orderData.value)
  const res = await createOrderAPI(orderData.value)
  if (res.data.code === 1) {
    // 正常生成逻辑
  }
}

// 获取第一张图片URL
const getFirstImageURL = (imageURL) => {
  return imageURL ? imageURL.split(',')[0] : ''
}

// 获取地址列表
const getAddressList = async () => {
  const res = await getAddressListAPI()
  addressData.value = res.data.data

  // 找到默认地址并设置为激活状态
  const defaultAddr = addressData.value.find((address) => address.isDefault === 1)
  if (defaultAddr) {
    defaultAddressId.value = defaultAddr.id
    activeAddress.value = defaultAddr
    curAddress.value = defaultAddr
  }
}

// 打开切换地址对话框
const openSelectAddressDialog = () => {
  showSelectAddrDialog.value = true
  tempActiveAddress.value = { ...activeAddress.value } // 将当前激活地址存入临时变量
}

// 确认切换地址
const confirmSwitchAddress = () => {
  activeAddress.value = { ...tempActiveAddress.value } // 更新激活状态
  curAddress.value = { ...tempActiveAddress.value } // 更新显示的地址
  showSelectAddrDialog.value = false
}

// 取消切换地址
const cancelSwitchAddress = () => {
  tempActiveAddress.value = { ...activeAddress.value } // 恢复为之前的激活状态
  showSelectAddrDialog.value = false
}

// 切换地址
const switchAddress = (item) => {
  tempActiveAddress.value = item // 更新临时变量
}

onMounted(() => {
  getAddressList()
  // 如果 `selectedProduct` 为空，跳转回商品详情页
  if (!cartStore.selectedProduct) {
    console.warn('商品状态失效，跳转回详情界面')
    router.push(`/detail/${cartStore.selectedProduct?.id || 'default'}`) // 'default' 可作为兜底值
  }
})

//新增地址
const addDialogVisible = ref(false)
const openAddDialog = () => {
  addDialogVisible.value = true
  addAddressFormRef.value?.clearValidate()
}
const newAddress = ref({
  name: '',
  province: '',
  city: '',
  area: '',
  detailArea: '',
  tel: '',
  isDefault: 0
})

// 定义验证规则
const rules = {
  province: [{ required: true, message: '请选择省份', trigger: 'change' }],
  city: [{ required: true, message: '请选择城市', trigger: 'change' }],
  area: [{ required: true, message: '请选择区县', trigger: 'change' }],
  detailArea: [{ required: true, message: '请输入详细地址', trigger: 'blur' }],
  name: [{ required: true, message: '请输入联系人姓名', trigger: 'blur' }],
  tel: [{ required: true, message: '请输入联系电话', trigger: 'blur' }]
}

const addAddressFormRef = ref(null)
// 提交表单
const submitAddressForm = () => {
  addAddressFormRef.value.validate(async (valid) => {
    if (valid) {
      const res = await addAddressAPI(newAddress.value)
      if (res.data.code === 1) {
        const newAddressWithID = { ...newAddress.value, id: res.data.data.id }
        curAddress.value = { ...newAddressWithID }
        addDialogVisible.value = false
        resetAddForm()
        ElMessage.success('添加成功')
      } else {
        ElMessage.error(`新增地址失败: ${res.msg}`)
      }
    } else {
      ElMessage.warning('请填写完整的地址信息')
    }
  })
}

// 添加地址对话框地址组件ref
const _areaComponentRef = ref(null)
const resetAddForm = () => {
  newAddress.value = {
    name: '',
    province: '',
    city: '',
    area: '',
    detailArea: '',
    tel: '',
    isDefault: 0
  }
  if (_areaComponentRef.value) {
    _areaComponentRef.value.resetAddress()
  }
  addAddressFormRef.value?.clearValidate()
}
</script>

<style scoped lang="scss">
.checkout-page {
  margin: 20px;

  .wrapper {
    background: #fff;
    padding: 0 20px;
    .box-title {
      font-size: 16px;
      font-weight: normal;
      padding-left: 10px;
      line-height: 70px;
      border-bottom: 1px solid #f5f5f5;
    }
  }
}

.published-item {
  display: flex;
  align-items: center;
  padding: 10px;
  margin-bottom: 15px;
  border-radius: 10px;
  // box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.item-image {
  width: 100px;
  object-fit: cover;
  border-radius: 5px;
  margin-right: 20px;
}

.item-info {
  flex: 1;
  margin-left: 15px;

  .item-title {
    font-size: 1.2em;
    font-weight: bold;
    margin-bottom: 5px;
    margin-top: -20px;
    display: block;
    word-break: keep-all;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    max-width: 400px; // 你可以根据实际需要调整宽度
  }
  .item-price {
    font-size: 1em;
    color: #e91e63;
    margin-bottom: 10px;
  }
  .item-desc {
    display: block;
    word-break: keep-all;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    max-width: 800px; // 你可以根据实际需要调整宽度
  }
}

.published-container {
  padding: 20px; /* 内边距 */
}

.address {
  border: 1px solid #f5f5f5;
  display: flex;
  align-items: center;

  .text {
    flex: 1;
    min-height: 120px;
    display: flex;
    align-items: center;

    .none {
      line-height: 120px;
      color: #999;
      text-align: center;
      width: 100%;
    }

    > ul {
      flex: 1;
      padding: 20px;

      li {
        line-height: 30px;

        span {
          color: #999;
          margin-right: 5px;

          > i {
            width: 0.5em;
            display: inline-block;
          }
        }
      }
    }

    > a {
      color: $comColor;
      width: 160px;
      text-align: center;
      height: 90px;
      line-height: 90px;
      border-right: 1px solid #f5f5f5;
    }
  }

  .action {
    width: 320px;
    text-align: center;

    .btn {
      width: 140px;
      height: 46px;
      line-height: 44px;
      font-size: 14px;

      &:first-child {
        margin-right: 10px;
      }
    }
  }
}

.total {
  dl {
    display: flex;
    justify-content: flex-end;
    line-height: 50px;

    dt {
      i {
        display: inline-block;
        width: 2em;
      }
    }

    dd {
      width: 240px;
      text-align: right;
      padding-right: 70px;

      &.price {
        font-size: 20px;
        color: $priceColor;
      }
    }
  }
}

.submit {
  text-align: right;
  padding: 60px;
  border-top: 1px solid #f5f5f5;
}

.addressWrapper {
  max-height: 500px;
  overflow-y: auto;
}

.text {
  flex: 1;
  min-height: 90px;
  display: flex;
  align-items: center;

  &.item {
    border: 1px solid #f5f5f5;
    margin-bottom: 10px;
    cursor: pointer;
    border-radius: 8px; // 添加圆角
    transition: border-color 0.3s, background-color 0.3s; // 增加平滑过渡效果

    &.active,
    &:hover {
      border-color: $comColor;
      background: rgba(149, 135, 227, 0.1);
    }

    > ul {
      padding: 10px;
      font-size: 14px;
      line-height: 30px;
    }
  }
}
</style>
