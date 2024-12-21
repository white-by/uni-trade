<!--省市区自动匹配下拉框-->

<template>
  <el-form-item>
    <el-row :gutter="75">
      <!-- 省份 -->
      <el-col :span="8">
        <el-select v-model="selectedProvince" placeholder="选择省份" style="width: 230%">
          <el-option v-for="item in provinceArr" :key="item" :label="item" :value="item"></el-option>
        </el-select>
      </el-col>
      <!-- 城市 -->
      <el-col :span="8">
        <el-select v-model="selectedCity" placeholder="选择城市" style="width: 230%" no-data-text="请先选择省份">
          <el-option v-for="item in cityArr" :key="item" :label="item" :value="item"></el-option>
        </el-select>
      </el-col>
      <!-- 地区 -->
      <el-col :span="8">
        <el-select v-model="selectedArea" placeholder="选择地区" style="width: 230%" no-data-text="请先选择城市">
          <el-option v-for="item in areaArr" :key="item" :label="item" :value="item"></el-option>
        </el-select>
      </el-col>
    </el-row>
  </el-form-item>
</template>

<script setup>
import { ref, computed, watch, nextTick } from 'vue'
import areaObj from '../../public/area.json'

const selectedProvince = ref('')
const selectedCity = ref('')
const selectedArea = ref('')

const provinceArr = Object.keys(areaObj)
const emit = defineEmits(['updateProvince', 'updateCity', 'updateArea'])

// 监听省份
watch(selectedProvince, (newVal) => {
  emit('updateProvince', newVal)
})
// 监听市
watch(selectedCity, (newVal) => {
  emit('updateCity', newVal)
})
// 监听区
watch(selectedArea, (newVal) => {
  emit('updateArea', newVal)
})

// 动态计算城市列表
const cityArr = computed(() => (selectedProvince.value ? Object.keys(areaObj[selectedProvince.value]) : []))

// 动态计算地区列表
const areaArr = computed(() =>
  selectedProvince.value && selectedCity.value ? areaObj[selectedProvince.value][selectedCity.value] : []
)

// 监听省变化
watch(selectedProvince, () => {
  selectedCity.value = ''
  selectedArea.value = ''
})

// 监听市变化
watch(selectedCity, () => {
  selectedArea.value = ''
})

// 重置地址
const resetAddress = () => {
  selectedProvince.value = ''
  selectedCity.value = ''
  selectedArea.value = ''
}

// 设置地址
const setAddress = async (province, city, area) => {
  selectedProvince.value = province
  nextTick(() => {
    selectedCity.value = city
    nextTick(() => {
      selectedArea.value = area
    })
  })
}

defineExpose({ resetAddress, setAddress })
</script>
