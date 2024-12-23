<template>
  <div>
    <!-- 编辑物品按钮 -->
    <el-button type="primary" @click="openDialog" round size="large">{{ label }}</el-button>

    <!-- 弹出表单对话框 -->
    <el-dialog title="编辑物品" v-model="dialogVisible" width="50%" align-center center @close="resetForm">
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
          >
          </el-input>
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
            :file-list="imageList"
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
              <el-input-number v-model="form.price" :precision="2" :step="1" :min="0" :max="999999">
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
          <el-col :span="3" v-if="label == '编辑'">
            <el-button type="primary" @click="submitForm" style="width: 100%">提交</el-button>
          </el-col>
          <el-col :span="3">
            <el-button @click="closeDialog" style="width: 100%">取消</el-button>
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
import { ref, reactive, watch, onMounted } from 'vue'
import { useCategoryStore } from '@/store/sortCategory'
import axios from 'axios'
import { addAddressAPI } from '@/api/address'
import { editPublishedProductsAPI } from '@/api/profiles'
import { ElMessage } from 'element-plus'
import { useAddressStore } from '@/store/addressStore'

onMounted(() => {
  getAddressList()
})

const addressStore = useAddressStore()
const categoryStore = useCategoryStore()
const showSelectAddrDialog = ref(false)
const addressData = ref([]) // 地址列表
const curAddress = ref(null) // 当前显示的地址
const activeAddress = ref({}) // 激活的地址
const tempActiveAddress = ref({}) // 临时选中的地址

const props = defineProps({
  item: Object, // 通过 v-model:item 传递的商品数据
  label: {
    // 接收按钮文字
    type: String,
    default: '编辑'
  }
})
const emit = defineEmits(['update:item']) // 用于触发更新事件

// 表单可见状态
const dialogVisible = ref(false)

// 表单数据
const form = reactive({ ...props.item })
const originalData = reactive({ ...props.item }) // 存储原始数据以便取消时恢复

// 用于绑定图片上传列表
const imageList = ref([])

// 监听 item 的变化以更新表单数据
watch(
  () => props.item,
  (newVal) => {
    Object.assign(form, newVal)
    Object.assign(originalData, newVal)
    // 如果 imageUrl 存在，将图片 URL 分割成数组并赋值给 imageList
    if (newVal.imageUrl) {
      imageList.value = newVal.imageUrl.split(',').map((url) => ({ url }))
    }
    // 根据 addrID 查找地址并设置 curAddress
    if (newVal.addrID && addressData.value.length > 0) {
      const matchedAddress = addressData.value.find((addr) => addr.id === newVal.addrID)
      curAddress.value = matchedAddress || null
    }
  },
  { immediate: true }
)

// 获取地址列表
const getAddressList = async () => {
  addressData.value = addressStore.addressData
  // 初始化 curAddress
  if (props.item.addrID) {
    const matchedAddress = addressData.value.find((item) => item.id === props.item.addrID)
    if (matchedAddress) {
      curAddress.value = { ...matchedAddress }
      activeAddress.value = { ...matchedAddress } // 同步激活地址
    }
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
// 打开新增地址对话框
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

// 新增地址表单引用
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
        addressStore.getAddressList()
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
// 重置新增地址表单
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

  // 上传图片
  axios
    .post('/api/v2/upload', formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
        Authorization: 'OeXXrpbZISBaCBiL2g74WNPweSZkwODK'
      }
    })
    .then((res) => {
      if (res.data && res.data.data && res.data.data.url) {
        // console.log('图片上传成功:', res.data.data.url)

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

// 上传成功回调
function onUploadSuccess(response, file) {
  const uploadedUrl = response.data.url
  if (uploadedUrl) {
    file.url = uploadedUrl // 为文件对象绑定真实 URL
    uploadedImages.value.push(uploadedUrl) // 添加到已上传图片列表

    // 保留原有的 form.imageUrl 数据，并拼接新的 URL
    const existingUrls = form.imageUrl ? form.imageUrl.split(',') : [] // 原有数据转换为数组
    const updatedUrls = [...existingUrls, ...uploadedImages.value] // 拼接原有数据与新数据
    form.imageUrl = [...new Set(updatedUrls)].join(',') // 去重并更新为字符串

    console.log('上传成功，当前图片列表:', form.imageUrl)
  } else {
    console.error('服务器返回的 URL 数据为空:', response)
  }
}

// 删除图片
function handleRemove(file) {
  const urlToRemove = file.url
  // console.log('删除图片:', file.url)
  if (!urlToRemove) {
    console.error('无法找到需要删除的文件 URL')
    return
  }
  uploadedImages.value = form.imageUrl.split(',')
  // 查找 URL 并删除
  const index = uploadedImages.value.findIndex((url) => url === urlToRemove)
  if (index > -1) {
    uploadedImages.value.splice(index, 1) // 从数组中删除该 URL
    form.imageUrl = uploadedImages.value.join(',') // 更新拼接字符串
    console.log('删除后图片列表:', form.imageUrl)
  } else {
    console.warn('要删除的图片 URL 未找到:', urlToRemove)
  }
}

// 大图预览
const dialogImageUrl = ref('')
const picDialogVisible = ref(false)

// 预览图片
const handlePictureCardPreview = (uploadFile) => {
  dialogImageUrl.value = uploadFile.url
  picDialogVisible.value = true
}

// 打开对话框
function openDialog() {
  dialogVisible.value = true
}

// 提交表单并触发更新事件
const submitForm = async () => {
  // 触发表单验证
  formRef.value.validate(async (valid) => {
    if (!valid) {
      console.log('表单验证失败')
      return // 验证失败，阻止继续执行
    }

    const data = {
      id: form.id,
      title: form.title,
      price: form.price,
      category: form.category,
      description: form.description,
      imageUrl: form.imageUrl,
      shippingCost: form.shippingCost,
      userName: form.userName,
      addrID: form.addrID,
      deliveryMethod: form.deliveryMethod
    }

    // 执行提交逻辑
    try {
      const res = await editPublishedProductsAPI(data)
      if (res.data.code === 1) {
        ElMessage.success('编辑成功')
        emit('update:item', form)
        closeDialog() // 关闭对话框
      } else {
        ElMessage.error('编辑失败')
      }
    } catch (error) {
      console.error('请求失败', error)
      ElMessage.error('请求失败')
    }
  })
}

// 关闭对话框
function closeDialog() {
  dialogVisible.value = false
}

// 重置表单数据
function resetForm() {
  Object.assign(form, originalData) // 恢复到打开对话框前的初始数据
  imageList.value = originalData.imageUrl ? originalData.imageUrl.split(',').map((url) => ({ url })) : []
}

// 运费输入框是否禁用
const isShippingDisabled = ref(form.deliveryMethod == '邮寄' ? false : true)
// 监听配送方式变化，禁用运费输入框
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

// 表单引用
const formRef = ref(null)
// 表单验证规则
const rules = {
  title: [{ required: true, message: '请输入物品标题', trigger: 'blur' }],
  description: [{ required: true, message: '请输入物品描述', trigger: 'blur' }],
  category: [{ required: true, message: '请选择物品类别', trigger: 'change' }],
  deliveryMethod: [{ required: true, message: '请选择配送方式', trigger: 'change' }],
  price: [
    {
      required: true,
      type: 'number',
      message: '请输入售价',
      trigger: 'blur'
    },
    {
      validator: (rule, value, callback) => {
        if (value <= 0) {
          callback(new Error('售价必须大于 0 元'))
        } else {
          callback() // 校验通过
        }
      },
      trigger: 'blur'
    }
  ],
  imageUrl: [
    {
      required: true,
      message: '请上传图片或等待上传完成',
      trigger: 'blur'
    },
    {
      validator: (rule, value, callback) => {
        if (!value || value === '') {
          callback(new Error('请上传图片或等待上传完成'))
        } else {
          callback() // 校验通过
        }
      },
      trigger: 'blur' // 使用 blur 触发自定义验证
    }
  ]
}
</script>

<style scoped lang="scss">
.btn {
  margin-top: 20px;
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
