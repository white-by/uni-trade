<template>
  <div style="display: flex; gap: 30px; padding: 50px">
    <!-- 左侧商品展示卡片 -->
    <div style="width: 50%">
      <img class="product-image" :src="product.image" alt="商品图片" />
    </div>
    <!-- 右侧详情表单 -->
    <el-form
      label-width="100px"
      class="custom-form"
      style="flex: 1; margin-right: 90px; display: flex; flex-direction: column; justify-content: space-between"
    >
      <div class="product-info">
        <p class="product-price">
          <span>{{ product.price }}</span>
        </p>
        <h3 class="product-title" style="padding-top: 5px">{{ product.name }}</h3>
      </div>

      <!-- 商品描述 -->
      <p class="describe" style="padding-left: 50px; padding-top: 10px">
        {{ product.describe }}
      </p>

      <div class="product-detail">
        <!-- 发布者 -->
        <el-row :gutter="10">
          <el-col :span="10"
            ><el-form-item label="卖家">
              <p>
                {{ product.userName }}
              </p>
            </el-form-item></el-col
          >
          <el-col :span="10"
            ><el-form-item label="发布时间">
              <p>
                {{ product.postTime }}
              </p>
            </el-form-item></el-col
          >
        </el-row>

        <el-row :gutter="10">
          <el-col :span="10">
            <el-form-item label="地址">
              <p class="address">
                {{ product.address }}
              </p>
            </el-form-item>
          </el-col>
          <el-col :span="14">
            <el-form-item label="发货方式">
              <el-button-group>
                <el-button
                  :type="product.deliveryMethod === '邮寄' ? 'primary' : ''"
                  :style="
                    product.deliveryMethod === '邮寄'
                      ? 'color: white; background-color: #9587e3;'
                      : 'color: #9587e3; background-color: white;'
                  "
                  :disabled="true"
                  >邮寄</el-button
                >
                <el-button
                  :type="product.deliveryMethod === '自提' ? 'primary' : ''"
                  :style="
                    product.deliveryMethod === '自提'
                      ? 'color: white; background-color: #9587e3;'
                      : 'color: #9587e3; background-color: white;'
                  "
                  :disabled="true"
                  >自提</el-button
                >
                <el-button
                  :type="product.deliveryMethod === '无需快递' ? 'primary' : ''"
                  :style="
                    product.deliveryMethod === '无需快递'
                      ? 'color: white; background-color: #9587e3;'
                      : 'color: #9587e3; background-color: white;'
                  "
                  :disabled="true"
                  >无需快递</el-button
                >
              </el-button-group>
            </el-form-item></el-col
          >
        </el-row>

        <el-form-item label="邮费">
          <p>
            <span style="margin-left: 5px">￥{{ product.shippingCost }}</span>
          </p>
        </el-form-item>

        <el-row>
          <el-col :gutter="10" :span="9"
            ><el-form-item label="浏览">{{ product.views }}</el-form-item></el-col
          >
          <el-col :span="10">
            <el-form-item label="收藏">{{ product.stars }}</el-form-item></el-col
          >
        </el-row>
      </div>

      <div class="btn-group">
        <el-button type="primary" size="large" style="font-size: 16px; width: 140px">购买</el-button>
        <el-button type="primary" plain size="large" circle style="margin-left: 300px" @click="toggleStarred">
          <i :class="isStarred ? 'iconfont icon-starred' : 'iconfont icon-star'"></i>
        </el-button>
        <el-button type="primary" plain size="large" circle><i class="iconfont icon-chat"></i></el-button>
      </div>
    </el-form>
  </div>
</template>

<script setup>
import { getDetail } from '@/api/detail'
import { onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import 'element-plus/theme-chalk/el-message.css'
import { ElMessage } from 'element-plus'

const product = ref({})
const route = useRoute()
const getProducts = async () => {
  const res = await getDetail(route.params.id)
  product.value = res.data.data
  //console.log('测试: ', product.value)
}
onMounted(() => getProducts())

// 收藏
const isStarred = ref(false)
let isThrottled = false // 用于控制节流状态

const toggleStarred = () => {
  if (isThrottled) return // 如果正在节流，直接返回

  isThrottled = true
  isStarred.value = !isStarred.value

  if (isStarred.value) {
    ElMessage({
      type: 'success',
      message: '已收藏'
    })
  } else {
    ElMessage({
      type: 'success',
      message: '取消收藏'
    })
  }

  setTimeout(() => {
    isThrottled = false // 一秒后解除节流状态
  }, 1000)
}
</script>

<style scoped>
.custom-form {
  border-radius: 8px;
  background-color: white;
}

.product-info {
  padding-top: 50px;
  padding-left: 50px;
}

.product-detail {
  margin-top: 50px;
}

.btn-group {
  display: flex;
  justify-content: flex-start;
  margin-left: 60px;
  margin-right: 60px;
  margin-top: auto;
  margin-bottom: 50px;
}

.product-image {
  width: 700px;
  height: 700px;
  border-radius: 8px;
  padding: 10px;
  margin-left: 50px;
  object-fit: cover;
}

.product-price {
  font-size: 34px;
  color: #ff4c4c;
  font-weight: bold;
  &::before {
    content: '¥';
    font-size: 28px;
  }
}
.product-title {
  flex-grow: 1;
  font-size: 28px;
  font-weight: bold;
  margin: 0;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  width: 200%;
}
.no-disabled-style.el-button:disabled {
  color: inherit !important;
  background-color: white !important;
}

.describe {
  font-size: 20px;
  width: 560px;
  height: auto;
}
</style>
