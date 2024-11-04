<template>
  <div>
    <!-- 编辑物品按钮 -->
    <el-button type="primary" @click="openDialog" round size="large">编辑</el-button>

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
          <div @click="selectAvatar">
            <el-image style="width: 200px; height: 200px" :src="form.imageUrl" />
            <input type="file" ref="fileInput" @change="onFileChange" style="display: none" accept="image/*" />
          </div>
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
import { ref, reactive, watch, onMounted, computed } from 'vue'
// import { UploadFilled } from '@element-plus/icons-vue'
import { useCategoryStore } from '@/store/sortCategory'
import areaObj from '@/../public/area.json'

const categoryStore = useCategoryStore()

onMounted(() => {
  categoryStore.getCategory()
})

const props = defineProps({
  item: Object // 通过 v-model:item 传递的商品数据
})
const emit = defineEmits(['update:item']) // 用于触发更新事件

// 表单可见状态
const dialogVisible = ref(false)

// 表单数据
const form = reactive({ ...props.item })

// 监听 item 的变化以更新表单数据
watch(
  () => props.item,
  (newVal) => {
    Object.assign(form, newVal)
  }
)

// 打开对话框
function openDialog() {
  dialogVisible.value = true
}

// 提交表单并触发更新事件
function submitForm() {
  emit('update:item', form) // 将更新的数据传递给父组件
  closeDialog() // 关闭对话框
}

// 关闭对话框
function closeDialog() {
  dialogVisible.value = false
  // console.log(form)
}

function onFileChange(event) {
  const file = event.target.files[0]
  if (file) {
    const reader = new FileReader()
    reader.onload = (e) => {
      form.imageUrl = e.target.result
      // user.value.avatarUrl = e.target.result // 更新头像 URL
    }
    reader.readAsDataURL(file) // 将文件转换为 Data URL
  }
}
const fileInput = ref(null)
function selectAvatar() {
  fileInput.value.click() // 点击文件输入框
}

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
