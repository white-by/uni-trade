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
        <el-select v-model="selectedCity" placeholder="选择城市" style="width: 230%">
          <el-option v-for="item in cityArr" :key="item" :label="item" :value="item"></el-option>
        </el-select>
      </el-col>
      <!-- 地区 -->
      <el-col :span="8">
        <el-select v-model="selectedArea" placeholder="选择地区" style="width: 230%">
          <el-option v-for="item in areaArr" :key="item" :label="item" :value="item"></el-option>
        </el-select>
      </el-col>
    </el-row>
  </el-form-item>
</template>

<script setup>
import { ref, computed, watch } from 'vue'
import areaObj from '../../public/area.json'

const selectedProvince = ref('')
const selectedCity = ref('')
const selectedArea = ref('')

const provinceArr = Object.keys(areaObj)
const emit = defineEmits(['updateProvince', 'updateCity', 'updateArea'])

watch(selectedProvince, (newVal) => {
  emit('updateProvince', newVal)
})
watch(selectedCity, (newVal) => {
  emit('updateCity', newVal)
})
watch(selectedArea, (newVal) => {
  emit('updateArea', newVal)
})

// 动态计算城市列表
const cityArr = computed(() => (selectedProvince.value ? Object.keys(areaObj[selectedProvince.value]) : []))

// 动态计算地区列表
const areaArr = computed(() =>
  selectedProvince.value && selectedCity.value ? areaObj[selectedProvince.value][selectedCity.value] : []
)

// 监听选择变化，自动更新值
watch(selectedProvince, () => {
  selectedCity.value = ''
  selectedArea.value = ''
})

watch(selectedCity, () => {
  selectedArea.value = ''
})

const resetAddress = () => {
  selectedProvince.value = ''
  selectedCity.value = ''
  selectedArea.value = ''
}

defineExpose({ resetAddress })
</script>
