<template>
  <div>
    <!-- 发布物品按钮 -->
    <el-button type="primary" @click="openPostProductDialog" round size="large">发布闲置</el-button>

    <!-- 弹出表单对话框 -->
    <el-dialog title="发布闲置" v-model="dialogVisible" width="50%" align-center center @close="closePostProductDialog">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="120px" class="custom-form">
        <!-- 物品标题 -->
        <el-form-item label="物品标题" prop="title">
          <el-input v-model="form.title" placeholder="输入物品标题" style="width: 90%" class="input"></el-input>
        </el-form-item>

        <!-- 物品描述 -->
        <el-form-item label="物品描述" prop="description">
          <el-input
            v-model="form.description"
            type="textarea"
            placeholder="描述你的物品"
            :rows="6"
            style="width: 90%"
            maxlength="300"
            show-word-limit
          ></el-input>
        </el-form-item>

        <!-- 物品图片上传 -->
        <el-form-item label="物品图片" prop="imageUrl">
          <el-upload
            ref="uploadRef"
            class="uploadPic"
            list-type="picture-card"
            action="#"
            :limit="5"
            :http-request="upload"
            :on-preview="handlePictureCardPreview"
            :on-remove="handleRemove"
            :on-success="onUploadSuccess"
          >
            <div class="el-upload__text"><em>上传图片</em></div>
            <template #tip>
              <div class="el-upload__tip">请上传大小不超过 2MB 的 JPG / PNG 格式图片，最多 5 张</div>
            </template>
          </el-upload>
        </el-form-item>
        <el-dialog v-model="picDialogVisible">
          <img w-full :src="dialogImageUrl" alt="Preview Image" />
        </el-dialog>

        <el-row>
          <!-- 物品类别 -->
          <el-col :span="8">
            <el-form-item label="物品类别" prop="category">
              <el-select v-model="form.category" placeholder="选择物品类别">
                <el-option
                  v-for="category in categoryStore.categoryList.data"
                  :key="category.categoryID"
                  :label="category.categoryName"
                  :value="category.categoryName"
                ></el-option>
              </el-select>
            </el-form-item>
          </el-col>

          <!-- 配送方式 -->
          <el-col :span="8" :offset="6">
            <el-form-item label="配送方式" prop="deliveryMethod">
              <el-select v-model="form.deliveryMethod" placeholder="选择配送方式">
                <el-option label="邮寄" value="邮寄"></el-option>
                <el-option label="自提" value="自提"></el-option>
                <el-option label="无需快递" value="无需快递"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row>
          <!-- 售价 -->
          <el-col :span="8">
            <el-form-item label="售价 " prop="price">
              <el-input-number v-model="form.price" :precision="2" :step="1" :min="0" :max="99">
                <template #prefix>
                  <span>￥</span>
                </template>
              </el-input-number>
            </el-form-item>
          </el-col>

          <!-- 运费 -->
          <el-col :span="8" :offset="6">
            <el-form-item label="运费 ">
              <el-input-number
                v-model="form.shippingCost"
                :precision="2"
                :step="1"
                :min="0"
                :max="99999"
                :disabled="isShippingDisabled"
              >
                <template #prefix>
                  <span>￥</span>
                </template>
              </el-input-number>
            </el-form-item>
          </el-col>
        </el-row>

        <!-- 详细地址 -->
        <el-form-item label="详细地址">
          <div class="text">
            <div class="none" v-if="form.deliveryMethod == '无需快递'">该商品无需快递</div>
            <div class="none" v-else-if="!curAddress">您需要先添加发货地址才可发布闲置。</div>
            <div v-else>
              {{ curAddress.province }}
              {{ curAddress.city }}
              {{ curAddress.area }}
              {{ curAddress.detailArea }}
            </div>
          </div>
          <div class="action" v-show="form.deliveryMethod != '无需快递'">
            <el-button type="primary" plain @click="openSelectAddressDialog">切换地址</el-button>
            <el-button type="primary" plain @click="openAddDialog()">添加地址</el-button>
          </div>
        </el-form-item>

        <!-- 提交和取消按钮 -->
        <el-row justify="center" :gutter="50" class="btn">
          <!-- 使用justify="center"使按钮居中，gutter增加间距 -->
          <el-col :span="3">
            <el-button type="primary" @click="submitForm" style="width: 100%">提交</el-button>
          </el-col>
          <el-col :span="3">
            <el-button @click="dialogVisible = false" style="width: 100%">取消</el-button>
          </el-col>
        </el-row>
      </el-form>
    </el-dialog>

    <!-- 切换地址 -->
    <el-dialog v-model="showSelectAddrDialog" title="切换发货地址" width="470px">
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
      <el-form :model="newAddress" :rules="addrRules" ref="addAddressFormRef" label-width="80px">
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
  </div>
</template>

<script setup>
import { ref, reactive, watch, nextTick, onMounted } from 'vue'
import { useCategoryStore } from '@/store/sortCategory'
import axios from 'axios'
import { postProductAPI } from '@/api/products'
import { getAddressListAPI, addAddressAPI } from '@/api/address'
import { ElMessage } from 'element-plus'

onMounted(() => {
  getAddressList()
})

const categoryStore = useCategoryStore()
const showSelectAddrDialog = ref(false)
const addressData = ref([]) // 地址列表
const defaultAddressId = ref(null) // 默认地址 ID
const curAddress = ref(null) // 当前显示的地址
const activeAddress = ref({}) // 激活的地址
const tempActiveAddress = ref({}) // 临时选中的地址

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
    // console.log('默认地址：', curAddress.value)
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
const addrRules = {
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

// 图片上传
const uploadRef = ref(null)

// 存储所有上传成功的图片 URL
const uploadedImages = ref([])

// 图片上传
function upload(options) {
  const { file, onSuccess, onError } = options // 获取回调函数
  const formData = new FormData()
  const timestamp = new Date().getTime()
  const originalName = file.name
  const extension = originalName.substring(originalName.lastIndexOf('.'))
  const newFileName = `${originalName.replace(extension, '')}_${timestamp}${extension}`

  formData.append('smfile', file, newFileName)

  axios
    .post('/api/v2/upload', formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
        Authorization: 'OeXXrpbZISBaCBiL2g74WNPweSZkwODK'
      }
    })
    .then((res) => {
      if (res.data && res.data.data && res.data.data.url) {
        console.log('图片上传成功:', res.data.data.url)

        // 调用 onSuccess 回调，传递响应和文件对象
        onSuccess(res.data, file)
      } else if (res.data.code === 'image_repeated') {
        const repeatedImageUrl = res.data.images // 重复图片的 URL
        console.warn('图片重复，使用已存在的图片:', repeatedImageUrl)
        onSuccess({ data: { url: repeatedImageUrl } }, file) // 模拟成功回调
      } else {
        console.error('图片上传失败:', res)
        onError(new Error('上传失败'))
      }
    })
    .catch((err) => {
      console.error('图片上传出错:', err)
      onError(err) // 调用 onError 回调
    })
}

function onUploadSuccess(response, file) {
  const uploadedUrl = response.data.url
  if (uploadedUrl) {
    file.url = uploadedUrl // 为文件对象绑定真实 URL
    uploadedImages.value.push(uploadedUrl) // 添加到已上传图片列表
    form.imageUrl = uploadedImages.value.join(',') // 更新拼接字符串
    console.log('上传成功，当前图片列表:', form.imageUrl)
  } else {
    console.error('服务器返回的 URL 数据为空:', response)
  }
}

// 删除图片
function handleRemove(file) {
  const urlToRemove = file.url
  console.log('删除图片:', file.url)
  if (!urlToRemove) {
    console.error('无法找到需要删除的文件 URL')
    return
  }
  // 查找 URL 并删除
  const index = uploadedImages.value.findIndex((url) => url === urlToRemove)
  if (index > -1) {
    uploadedImages.value.splice(index, 1) // 从数组中删除该 URL
    form.imageUrl = uploadedImages.value.join(',') // 更新拼接字符串
    console.log('删除后图片列表:', form.imageUrl)
  } else {
    console.error('要删除的图片 URL 未找到:', urlToRemove)
  }
}

// 大图预览
const dialogImageUrl = ref('')
const picDialogVisible = ref(false)

const handlePictureCardPreview = (uploadFile) => {
  dialogImageUrl.value = uploadFile.url
  picDialogVisible.value = true
}

// 打开表单
const dialogVisible = ref(false)
const openPostProductDialog = () => {
  dialogVisible.value = true
  resetForm()
}

// 关闭表单
const closePostProductDialog = () => {
  dialogVisible.value = false
  resetForm()
}

// 表单数据
let form = reactive({
  title: '',
  description: '',
  category: null,
  price: 0,
  imageUrl: '',
  address: curAddress,
  deliveryMethod: null,
  shippingCost: 0
})

const isShippingDisabled = ref(false)
// 监听配送方式的变化
watch(
  () => form.deliveryMethod,
  (newValue) => {
    if (newValue === '自提' || newValue === '无需快递') {
      isShippingDisabled.value = true
      form.shippingCost = 0 // 禁用时，自动设置运费为 0
    } else {
      isShippingDisabled.value = false
    }
  }
)

const rules = {
  title: [{ required: true, message: '请输入物品标题', trigger: 'blur' }],
  description: [{ required: true, message: '请输入物品描述', trigger: 'blur' }],
  category: [{ required: true, message: '请选择物品类别', trigger: 'change' }],
  deliveryMethod: [{ required: true, message: '请选择配送方式', trigger: 'change' }],
  price: [{ required: true, type: 'number', message: '请输入售价', trigger: 'blur' }],
  imageUrl: [{ required: true, message: '请上传图片或等待上传完成', trigger: 'blur' }]
}

// 清空表单
const resetForm = () => {
  form.title = ''
  form.description = ''
  form.category = null
  form.price = 0
  form.imageUrl = ''
  form.deliveryMethod = null
  form.shippingCost = 0
  nextTick(() => formRef.value?.clearValidate())
  nextTick(() => uploadRef.value?.clearFiles()) // 清空上传列表
}

// 表单引用
const formRef = ref(null)

// 提交表单
function submitForm() {
  formRef.value.validate(async (valid) => {
    if (valid) {
      const data = {
        title: form.title,
        description: form.description,
        category: form.category,
        price: form.price,
        imageUrl: form.imageUrl,
        addrID: form.deliveryMethod === '无需快递' ? null : curAddress.value.id,
        deliveryMethod: form.deliveryMethod,
        shippingCost: form.shippingCost
      }
      const res = await postProductAPI(data)
      if (res.data.code === 1) {
        // const id = res.data.data.id //数据库返回的商品id
        ElMessage.success('发布成功')
      } else {
        ElMessage.error('发布失败')
      }
      dialogVisible.value = false
    } else {
      console.log('表单校验失败')
      return false
    }
  })
}
</script>

<style scoped lang="scss">
.input {
  height: 40px;
}
.custom-form {
  padding-top: 20px; /* 增加表单的顶部间距 */
  padding-bottom: 20px; /* 增加表单的底部间距 */
}
.btn {
  margin-top: 40px;
}

.addressWrapper {
  max-height: 500px;
  overflow-y: auto;
}

.text {
  flex: 1;
  display: flex;
  align-items: center;

  &.item {
    border: 1px solid #f5f5f5;
    margin-bottom: 10px;
    cursor: pointer;
    border-radius: 5px; // 添加圆角
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

.action {
  width: 330px;
  text-align: center;

  .btn {
    &:first-child {
      margin-right: 10px;
    }
  }
}

.none {
  color: #999;
  width: 100%;
}
</style>
