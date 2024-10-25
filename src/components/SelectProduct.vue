<template>
  <el-button size="large" type="primary" plain round @click="selector = true">筛选</el-button>
  <el-drawer v-model="selector" title="筛选条件" :before-close="handleClose">
    <div class="filter-container">
      <el-col
        ><el-form-item label="价格区间">
          <el-input-number
            v-model="form.priceMin"
            placeholder="最小值"
            :precision="2"
            :step="1"
            :min="0"
            :max="999"
            style="margin-right: 10px"
          >
            <template #prefix>
              <span>￥</span>
            </template>
          </el-input-number>
          <span style="margin-right: 10px"> ~ </span>
          <el-input-number v-model="form.priceMax" placeholder="最大值" :precision="2" :step="1" :min="0" :max="99999">
            <template #prefix>
              <span>￥</span>
            </template>
          </el-input-number>
        </el-form-item></el-col
      >

      <el-col :span="21"
        ><el-form-item label="发布时间">
          <el-date-picker
            v-model="form.publishDate"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            style="width: 50%"
          /> </el-form-item
      ></el-col>

      <el-row :gutter="10">
        <el-col :span="9"
          ><el-form-item label="配送方式">
            <el-select v-model="form.deliveryMethod" placeholder="请选择">
              <el-option label="邮寄" value="邮寄"></el-option>
              <el-option label="自提" value="自提"></el-option>
              <el-option label="无需快递" value="无需快递"></el-option>
            </el-select> </el-form-item
        ></el-col>
      </el-row>
      <el-col :span="12"
        ><el-form-item label="运费上限">
          <el-input-number
            v-model="form.shippingCost"
            :precision="2"
            :step="1"
            :min="0"
            :max="99"
            :disabled="isShippingDisabled"
          >
            <template #prefix>
              <span>￥</span>
            </template>
          </el-input-number>
        </el-form-item></el-col
      >
      <el-form-item label="发货地址">
        <el-row :gutter="75">
          <!-- 省份 -->
          <el-col :span="8">
            <el-select v-model="province" placeholder="选择省份" style="width: 230%">
              <el-option v-for="item in provinceArr" :key="item" :label="item" :value="item"></el-option>
            </el-select>
          </el-col>

          <!-- 城市 -->
          <el-col :span="8">
            <el-select v-model="city" placeholder="选择城市" style="width: 230%">
              <el-option v-for="item in cityArr" :key="item" :label="item" :value="item"></el-option>
            </el-select>
          </el-col>

          <!-- 地区 -->
          <el-col :span="8">
            <el-select v-model="area" placeholder="选择地区" style="width: 230%">
              <el-option v-for="item in areaArr" :key="item" :label="item" :value="item"></el-option>
            </el-select>
          </el-col>
        </el-row>
      </el-form-item>
    </div>
    <template #footer>
      <el-row justify="center" style="margin-top: 20px">
        <el-button type="primary" @click="applyFilter">{{ loading ? '提交中 ...' : '应用' }}</el-button>
        <el-button @click="resetFilter">重置</el-button>
      </el-row></template
    >
  </el-drawer>
</template>

<script setup>
import { ref, reactive, watch, computed } from 'vue'
import 'element-plus/theme-chalk/el-message-box.css'
import 'element-plus/theme-chalk/el-message.css'
import { ElMessageBox, ElMessage } from 'element-plus'
import areaObj from '../../public/area.json'
import { getFilteredProductsAPI } from '@/api/products'

const selector = ref(false)

let form = reactive({
  priceMin: 0,
  priceMax: 0,
  province: '',
  city: '',
  area: '',
  deliveryMethod: '',
  shippingCost: 0,
  publishDate: []
})

// 监听价格最小值
watch(
  () => form.priceMin,
  (newMin) => {
    if (form.priceMax <= newMin) {
      form.priceMax = newMin
    }
  }
)

// 监听价格最大值
watch(
  () => form.priceMax,
  (newMax) => {
    if (newMax <= form.priceMin) {
      form.priceMin = newMax
    }
  }
)

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

const provinceArr = Object.keys(areaObj)
const province = ref(null)
const city = ref(null)
const area = ref(null)

// 市的计算属性
const cityArr = computed(() => {
  return province.value ? Object.keys(areaObj[province.value]) : []
})

// 区的计算属性
const areaArr = computed(() => {
  return province.value && city.value ? areaObj[province.value][city.value] : []
})

// 监听省份变化
watch(province, (newVal) => {
  form.province = newVal || '' // 更新表单里的省份
  city.value = null // 省份改变时清空城市和地区
  area.value = null
})

// 监听城市变化
watch(city, (newVal) => {
  form.city = newVal || '' // 更新表单里的城市
  area.value = null // 城市改变时清空地区
})

// 监听地区变化
watch(area, (newVal) => {
  form.area = newVal || '' // 更新表单里的地区
})

let timer
const dialog = ref(false)
const loading = ref(false)

const applyFilter = async () => {
  console.log('提交的筛选数据:', form)

  // 设置加载状态
  loading.value = true

  // 调用接口
  try {
    // 通过解构传递 form 中的相关参数
    const response = await getFilteredProductsAPI({
      area: form.area,
      city: form.city,
      deliveryMethod: form.deliveryMethod,
      priceMax: form.priceMax,
      priceMin: form.priceMin,
      province: form.province,
      publishDate: form.publishDate,
      shippingCost: form.shippingCost,
      page: 1, // 如果需要，可以设置当前页码
      limit: 12 // 如果需要，可以设置每页条目数量
    })
    console.log('成功发送请求')
    // 处理成功响应
    console.log('接口返回的数据:', response.data)
    ElMessage({
      type: 'success',
      message: '修改成功'
    })
  } catch (error) {
    // 处理错误
    console.error('接口调用失败:', error)
    ElMessage({
      type: 'error',
      message: '提交失败，请重试'
    })
  } finally {
    // 无论成功与否都关闭加载状态和抽屉
    loading.value = false
    selector.value = false // 关闭筛选抽屉
  }
}

const handleClose = (done) => {
  if (loading.value) {
    return
  }
  ElMessageBox.confirm('确认应用并退出吗?')
    .then(() => {
      console.log('提交的筛选数据:', form)
      //   接口调用

      loading.value = true
      timer = setTimeout(() => {
        done()
        setTimeout(() => {
          loading.value = false
        }, 400)
      }, 1000)

      ElMessage({
        type: 'success',
        message: '修改成功'
      })
    })
    .catch(() => {
      // catch error
    })
}

//重置
const resetFilter = () => {
  loading.value = false
  dialog.value = false
  clearTimeout(timer)

  form.priceMin = 0
  form.priceMax = 0
  form.deliveryMethod = ''
  form.shippingCost = 0
  form.publishDate = []
  province.value = null
  city.value = null
  area.value = null

  form.province = ''
  form.city = ''
  form.area = ''
}
</script>

<style scoped lang="scss"></style>
