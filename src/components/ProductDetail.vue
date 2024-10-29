<template>
  <div style="display: flex; gap: 30px; padding: 50px">
    <!-- 左侧商品展示卡片 -->
    <div style="width: 50%">
      <img class="product-image" :src="product.image" alt="商品图片" />
      <div class="product-info">
        <p class="product-price">
          <span>{{ product.price }}</span>
        </p>

        <h3 class="product-title">{{ product.name }}</h3>
      </div>
      <div style="display: flex; justify-content: flex-start; margin-top: 30px; margin-left: 60px; margin-right: 60px">
        <el-button type="primary" size="large" style="font-size: 16px; width: 140px">购买</el-button>
        <el-button size="large" style="width: 80px; margin-left: auto">收藏</el-button>
        <el-button size="large" style="width: 80px">去聊聊</el-button>
      </div>
    </div>
    <!-- 右侧详情表单 -->
    <el-form label-width="100px" class="custom-form" style="flex: 1; margin-right: 50px">
      <!-- 商品描述 -->
      <el-form-item label="商品描述">
        <p class="describe">
          {{ product.describe }}
        </p>
      </el-form-item>

      <!-- 地址 -->
      <el-form-item label="地址">
        <p class="address">
          {{ product.address }}
        </p>
      </el-form-item>

      <!-- 发货方式 -->
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
      </el-form-item>

      <!-- 邮费 -->
      <el-form-item label="邮费">
        <p style="border: 1px solid #e0e0e0; width: 60px; height: 35px; border-radius: 2px; background-color: white">
          <span style="margin-left: 5px">￥{{ product.shippingCost }}</span>
        </p>
      </el-form-item>

      <!-- 发布者 -->
      <el-form-item label="发布者">
        <p>
          {{ product.userName }}
        </p>
      </el-form-item>

      <!-- 发布时间 -->
      <el-form-item label="发布时间">
        <p>
          {{ product.postTime }}
        </p>
      </el-form-item>

      <!-- 浏览量和收藏量 -->
      <div style="text-align: right; margin-top: 10px">
        <span>浏览量：{{ product.views }}</span>
        <span style="margin-left: 40px">收藏量：{{ product.stars }}</span>
      </div>
    </el-form>
  </div>
</template>

<script setup>
import { getDetail } from '@/api/detail'
import { onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
const product = ref({})
const route = useRoute()
const getProducts = async () => {
  const res = await getDetail(route.params.id)
  product.value = res.data.data
  console.log('测试: ', product.value)
}
onMounted(() => getProducts())
</script>

<style scoped>
.product-card {
  border: 1px solid #eee;
  padding: 20px;
}
.product-image {
  width: 700px;
  height: 400px;
  border-radius: 8px;
  padding: 10px;
  margin-left: 50px;
  object-fit: cover;
}
.product-info {
  display: flex;
  align-items: center;
  gap: 20px;
  justify-content: flex-start;
  margin-top: 30px;
  margin-left: 60px;
}
.product-price {
  font-size: 28px;
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
.address {
  border: 1px solid #e0e0e0;
  border-radius: 2px;
  background-color: white;
  width: 360px;
  height: 35px;
  padding-left: 8px;
}
.describe {
  border: 1px solid #e0e0e0;
  border-radius: 2px;
  background-color: white;
  width: 560px;
  height: 130px;
  padding-left: 8px;
}
</style>
