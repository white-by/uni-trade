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
          <el-row :gutter="30">
            <!-- 省份 -->
            <el-col :span="6">
              <el-select v-model="province" placeholder="选择省份" style="width: 120%">
                <el-option v-for="item in provinceArr" :key="item" :label="item" :value="item"></el-option>
              </el-select>
            </el-col>

            <!-- 城市 -->
            <el-col :span="6">
              <el-select v-model="city" placeholder="选择城市" style="width: 120%">
                <el-option v-for="item in cityArr" :key="item" :label="item" :value="item"></el-option>
              </el-select>
            </el-col>

            <!-- 地区 -->
            <el-col :span="6">
              <el-select v-model="area" placeholder="选择地区" style="width: 120%">
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
          <el-col :span="3">
            <el-button type="primary" @click="submitForm" style="width: 100%">提交</el-button>
          </el-col>
          <el-col :span="3">
            <el-button @click="dialogVisible = false" style="width: 100%">取消</el-button>
          </el-col>
        </el-row>
      </el-form>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, watch, computed, nextTick } from 'vue'
import areaObj from '../../public/area.json'
import { useCategoryStore } from '@/store/sortCategory'
import axios from 'axios'
import { postProductAPI } from '@/api/products'
import { ElMessage } from 'element-plus'

const categoryStore = useCategoryStore()

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
  province: '广东省',
  city: '珠海市',
  area: '香洲区',
  detailArea: '',
  deliveryMethod: null,
  shippingCost: 0
})

// 省
const provinceArr = Object.keys(areaObj)
const province = ref(provinceArr[18])
// 市
const cityArr = computed(() => {
  return Object.keys(areaObj[province.value])
})
const city = ref(cityArr.value[3])
// 监听省份变化
watch(province, (newVal) => {
  city.value = Object.keys(areaObj[newVal])[0]
  form.province = newVal // 更新表单里的省份
  form.city = city.value // 同步市
  area.value = areaObj[province.value][city.value][0]
  form.area = area.value // 同步区
})
// 区
const areaArr = computed(() => {
  return areaObj[province.value][city.value]
})
const area = ref(areaArr.value[0])
// 监听市变化
watch(city, (newVal) => {
  area.value = areaObj[province.value][newVal][0]
  form.city = newVal // 更新表单里的城市
  form.area = area.value // 同步区
})
// 监听区变化
watch(area, (newVal) => {
  form.area = newVal // 更新表单里的地区
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
  form.province = '广东省'
  form.city = '珠海市'
  form.area = '香洲区'
  form.detailArea = ''
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
      const res = await postProductAPI(form)
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
</style>
