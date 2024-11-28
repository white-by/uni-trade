<template>
  <div>
    <!-- 编辑物品按钮 -->
    <el-button type="primary" @click="openDialog" round size="large">{{ label }}</el-button>

    <!-- 弹出表单对话框 -->
    <el-dialog title="发布闲置" v-model="dialogVisible" width="50%" align-center center @close="resetForm">
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
          <el-row :gutter="30">
            <!-- 省份 -->
            <el-col :span="6">
              <el-select v-model="form.province" placeholder="选择省份" style="width: 120%">
                <el-option v-for="item in provinceArr" :key="item" :label="item" :value="item"></el-option>
              </el-select>
            </el-col>

            <!-- 城市 -->
            <el-col :span="6">
              <el-select v-model="form.city" placeholder="选择城市" style="width: 120%">
                <el-option v-for="item in cityArr" :key="item" :label="item" :value="item"></el-option>
              </el-select>
            </el-col>

            <!-- 地区 -->
            <el-col :span="6">
              <el-select v-model="form.area" placeholder="选择地区" style="width: 120%">
                <el-option v-for="item in areaArr" :key="item" :label="item" :value="item"></el-option>
              </el-select>
            </el-col>

            <!-- 详细地址 -->
            <el-col :span="6">
              <el-input v-model="form.detailArea" placeholder="输入详细地址" style="width: 350%"></el-input>
            </el-col>
          </el-row>
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
  </div>
</template>

<script setup>
import { ref, reactive, watch, computed } from 'vue'
import { useCategoryStore } from '@/store/sortCategory'
import areaObj from '@/../public/area.json'
import axios from 'axios'

const categoryStore = useCategoryStore()

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
    // 如果 imageURL 存在，将图片 URL 分割成数组并赋值给 imageList
    if (newVal.imageURL) {
      imageList.value = newVal.imageURL.split(',').map((url) => ({ url }))
    }
  },
  { immediate: true }
)

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
    console.warn('要删除的图片 URL 未找到:', urlToRemove)
  }
}

// 大图预览
const dialogImageUrl = ref('')
const picDialogVisible = ref(false)

const handlePictureCardPreview = (uploadFile) => {
  dialogImageUrl.value = uploadFile.url
  picDialogVisible.value = true
}

// 打开对话框
function openDialog() {
  dialogVisible.value = true
}

// 提交表单并触发更新事件
function submitForm() {
  // 更新图片URL，将文件列表的图片合并成逗号分隔的字符串
  form.imageURL = imageList.value.map((item) => item.url).join(',')
  emit('update:item', form) // 将更新的数据传递给父组件
  closeDialog() // 关闭对话框
}

// 关闭对话框
function closeDialog() {
  dialogVisible.value = false
}

// 重置表单数据
function resetForm() {
  Object.assign(form, originalData) // 恢复到打开对话框前的初始数据
  imageList.value = originalData.imageURL ? originalData.imageURL.split(',').map((url) => ({ url })) : []
}

const isShippingDisabled = ref(false)
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

// 地址数据的初始化和监控代码
const provinceArr = Object.keys(areaObj)
const province = ref(provinceArr[18])
const cityArr = computed(() => Object.keys(areaObj[province.value]))
const city = ref(cityArr.value[3])
const areaArr = computed(() => areaObj[province.value][city.value])
const area = ref(areaArr.value[0])

watch(province, (newVal) => {
  city.value = Object.keys(areaObj[newVal])[0]
  form.province = newVal
  form.city = city.value
  area.value = areaObj[province.value][city.value][0]
  form.area = area.value
})
watch(city, (newVal) => {
  area.value = areaObj[province.value][newVal][0]
  form.city = newVal
  form.area = area.value
})
watch(area, (newVal) => {
  form.area = newVal
})

const rules = {
  title: [{ required: true, message: '请输入物品标题', trigger: 'blur' }],
  description: [{ required: true, message: '请输入物品描述', trigger: 'blur' }],
  category: [{ required: true, message: '请选择物品类别', trigger: 'change' }],
  deliveryMethod: [{ required: true, message: '请选择配送方式', trigger: 'change' }],
  price: [{ required: true, type: 'number', message: '请输入售价', trigger: 'blur' }]
}
</script>

<style scoped lang="scss">
.btn {
  margin-top: 20px;
}
</style>
