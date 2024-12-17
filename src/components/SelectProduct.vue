<template>
  <el-button size="large" type="primary" plain round @click="selector = true">筛选</el-button>
  <el-drawer v-model="selector" title="筛选条件" :show-close="false" :before-close="handleClose">
    <template #header>
      <div style="display: flex; justify-content: space-between; align-items: center">
        <span>筛选条件</span>
        <i @click="cancelForm" class="iconfont icon-cancel"></i>
      </div>
    </template>
    <div class="filter-container">
      <el-col :span="11">
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
              <el-option label="包邮" value="包邮"></el-option>
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

      <!-- 发货地址 -->
      <el-form-item label="发货地址">
        <AreaComponets
          ref="areaComponentRef"
          @updateProvince="form.province = $event"
          @updateCity="form.city = $event"
          @updateArea="form.area = $event"
        />
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
import { ref, reactive, watch } from 'vue'
import 'element-plus/theme-chalk/el-message-box.css'
import 'element-plus/theme-chalk/el-message.css'
import { ElMessageBox, ElMessage } from 'element-plus'
import { getFilteredProductsAPI } from '@/api/products'
import { useCategoryStore } from '@/store/sortCategory'
import AreaComponets from '@/components/AreaComponets.vue'
import { useSearchStore } from '@/store/searchStore'
import { useSelectStore } from '@/store/selectStore'

const categoryStore = useCategoryStore()
const selector = ref(false)
const areaComponentRef = ref(null)

const searchStore = useSearchStore() // 搜索
const selectStore = useSelectStore()

let form = reactive({
  category: '',
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
    if (newValue === '自提' || newValue === '无需快递' || newValue === '包邮') {
      isShippingDisabled.value = true
      form.shippingCost = 0 // 禁用时，自动设置运费为 0
    } else {
      isShippingDisabled.value = false
    }
  }
)

//处理筛选
const dialog = ref(false)
const loading = ref(false)

  // 提交筛选
  const applyFilter = async () => {
    loading.value = true

    try {
      // 通过 categoryName 查找对应的 categoryID
      const selectedCategory = categoryStore.categoryList.data.find(
        (item) => item.categoryName === form.category
      )
      const categoryID = selectedCategory ? selectedCategory.categoryID : undefined 

      // 构建参数对象
      const params = {
        categoryID: categoryID, // 使用查找到的 categoryID
        area: form.area,
        city: form.city,
        deliveryMethod: form.deliveryMethod && form.deliveryMethod !== '包邮' ? form.deliveryMethod : undefined, // 处理包邮逻辑
        priceMax: form.priceMax,
        priceMin: form.priceMin,
        province: form.province,
        publishDate: form.publishDate,
        shippingCost: form.shippingCost,
        page: 1,
        limit: 12,
        searchQuery: searchStore.searchQuery
      }

      const res = await getFilteredProductsAPI(params)

      // 处理成功响应
      selectStore.selectData = res.data.data
      if (res.data.data == null) {
        ElMessage.warning("没有符合条件的商品！")
      } else {
        ElMessage.success("筛选成功")
      }
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
      selector.value = false
    }
  }


//点击界外时对应用筛选与否的二次确认
const handleClose = () => {
  if (loading.value) {
    return
  }
  ElMessageBox.confirm('确认应用并退出吗?')
    .then(async () => {
      // console.log('提交的筛选数据:', form)
      loading.value = true

       try {
        // 通过 categoryName 查找对应的 categoryID
        const selectedCategory = categoryStore.categoryList.data.find(
          (item) => item.categoryName === form.category
        )
        const categoryID = selectedCategory ? selectedCategory.categoryID : undefined
        
        // 构建参数对象
        const params = {
          categoryID: categoryID, // 使用查找到的 categoryID
          area: form.area,
          city: form.city,
          deliveryMethod: form.deliveryMethod && form.deliveryMethod !== '包邮' ? form.deliveryMethod : undefined, // 处理包邮逻辑
          priceMax: form.priceMax,
          priceMin: form.priceMin,
          province: form.province,
          publishDate: form.publishDate,
          shippingCost: form.shippingCost,
          page: 1,
          limit: 12,
          searchQuery: searchStore.searchQuery
        }

        const res = await getFilteredProductsAPI(params)

        // 处理成功响应
        selectStore.selectData = res.data.data
        if (res.data.data == null) {
          ElMessage.warning("没有符合条件的商品！")
        } else {
          ElMessage.success("筛选成功")
        }
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
        selector.value = false
      }
    })
    .catch(() => {
      // catch error
    })
}

//重置筛选
const resetFilter = () => {
  loading.value = false
  dialog.value = false
  form.category = null
  form.priceMin = 0
  form.priceMax = 0
  form.deliveryMethod = ''
  form.shippingCost = 0
  form.publishDate = []
  form.province = ''
  form.city = ''
  form.area = ''
  if (areaComponentRef.value) {
    areaComponentRef.value.resetAddress()
  }
}

//强制关闭筛选（右上角叉叉
const cancelForm = () => {
  loading.value = false
  dialog.value = false
  selector.value = false
}
</script>

<style scoped lang="scss"></style>
