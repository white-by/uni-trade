<template>
  <div>
    <!-- 发布物品按钮 -->
    <el-button type="primary" @click="dialogVisible = true" round size="large">发布闲置</el-button>

    <!-- 弹出表单对话框 -->
    <el-dialog title="发布闲置" v-model="dialogVisible" width="50%" align-center center>
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
        <el-form-item label="物品图片">
          <el-upload
            class="upload-demo"
            drag
            action="https://run.mocky.io/v3/9d059bf9-4660-45f2-925d-ce80ad6c4d15"
            multiple
            style="width: auto"
          >
            <el-icon class="el-icon--upload"><upload-filled /></el-icon>
            <div class="el-upload__text">将文件拖到此处或<em>点击上传</em></div>
            <template #tip>
              <div class="el-upload__tip">jpg/png 文件，大小应小于 500kb</div>
            </template>
          </el-upload>
        </el-form-item>

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
                <!-- <el-option label="电子产品" value="电子产品"></el-option>
                <el-option label="服装" value="服装"></el-option>
                <el-option label="家具" value="家具"></el-option> -->
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
            <el-form-item label="售价 ￥" prop="price">
              <el-input-number v-model="form.price" :precision="2" :step="1" :min="0" :max="99">
                <template #prefix>
                  <span>￥</span>
                </template>
              </el-input-number>
            </el-form-item>
          </el-col>

          <!-- 运费 -->
          <el-col :span="8" :offset="6">
            <el-form-item label="运费 ￥">
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
import { ref, reactive, watch, computed } from 'vue'
import areaObj from '../../public/area.json'
import { UploadFilled } from '@element-plus/icons-vue'
import { useCategoryStore } from '@/store/sortCategory'

const categoryStore = useCategoryStore()
// 表单可见状态
const dialogVisible = ref(false)
// 表单数据
let form = reactive({
  title: '',
  description: '',
  category: '',
  price: 0,

  province: '广东省',
  city: '珠海市',
  area: '香洲区',
  detailArea: '',
  deliveryMethod: '',
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
  price: [{ required: true, type: 'number', message: '请输入售价', trigger: 'blur' }]
}

// 表单引用
const formRef = ref(null)

// 提交表单
function submitForm() {
  formRef.value.validate((valid) => {
    if (valid) {
      console.log('提交的表单数据:', form)
      dialogVisible.value = false // 关闭对话框
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
