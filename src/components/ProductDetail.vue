<template>
  <div style="display: flex; gap: 30px; padding: 50px">
    <!-- 左侧商品展示卡片 -->
    <div style="width: 50%">
      <el-carousel :interval="5000" height="550px" indicator-position="outside">
        <el-carousel-item v-for="(image, index) in imageList" :key="index">
          <img class="product-image" :src="image" alt="商品图片" />
        </el-carousel-item>
      </el-carousel>
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
        <h3 class="product-title" style="padding-top: 5px">{{ product.title }}</h3>
      </div>

      <!-- 商品描述 -->
      <p class="description" style="padding-left: 50px; padding-top: 10px">
        {{ product.description }}
      </p>

      <div class="product-detail">
        <!-- 发布者 -->
        <el-row :gutter="10">
          <el-col :span="10"
            ><el-form-item label="卖家">
              <router-link class="seller" :to="`/profiles/${product.userID}`">
                {{ product.userName }}
              </router-link>
            </el-form-item></el-col
          >
          <el-col :span="10"
            ><el-form-item label="发布时间">
              <p>
                {{ product.postTime }}
              </p>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="10">
          <el-col :span="10">
            <el-form-item label="地址">
              <p class="address">{{ product.province }}{{ product.city }}{{ product.area }}{{ product.detailArea }}</p>
              <p v-if="!product.province">暂无地址信息</p>
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
            <span style="margin-left: 0px">￥{{ product.shippingCost }}</span>
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

      <div class="btn-group" v-if="product.isSold == 0 && userStore.userInfo.userID != product.userID">
        <el-button type="primary" size="large" style="font-size: 16px; width: 140px" @click="goToCheckout()"
          >购买</el-button
        >
        <el-button type="primary" plain size="large" circle style="margin-left: 300px" @click="throttleToggleStarred">
          <i :class="isStarred ? 'iconfont icon-starred' : 'iconfont icon-star'"></i>
        </el-button>
        <el-button type="primary" plain size="large" circle><i class="iconfont icon-chat"></i></el-button>
      </div>
      <div v-else style="height: 50px"></div>
    </el-form>
  </div>
</template>

<script setup>
import { getDetail, updateIsStarred } from '@/api/detail'
import { onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import 'element-plus/theme-chalk/el-message.css'
import { ElMessage } from 'element-plus'
import { useUserStore } from '@/store/userStore'
import { useCartStore } from '@/store/cartStore'
import { useRouter } from 'vue-router'
import useThrottle from '@/hooks/useThrottle'

const cartStore = useCartStore()
const router = useRouter()
const { throttled } = useThrottle()
const userStore = useUserStore()

const product = ref({})
const imageList = ref([])
const route = useRoute()
const isStarred = ref(false)
const getProducts = async () => {
  const res = await getDetail(route.params.id)
  product.value = res.data.data
  isStarred.value = product.value.isStarred
  // 将 product.image 按逗号分割成数组并赋值给 imageList
  imageList.value = product.value.imageUrl ? product.value.imageUrl.split(',') : []
}
onMounted(() => getProducts())

const toggleStarred = async () => {
  isStarred.value = !isStarred.value
  product.value.isStarred = isStarred.value
  console.log('product.value.isStarred:', product.value.isStarred)
  const res = await updateIsStarred(product.value.id, { isStarred: isStarred.value })

  if (res.data.code === 1) {
    if (isStarred.value) {
      ElMessage.success('已收藏')
    } else {
      ElMessage.success('取消收藏')
    }
  } else {
    if (isStarred.value) {
      ElMessage.success('收藏失败')
    } else {
      ElMessage.success('取消收藏失败')
    }
  }
}
// 节流
const throttleToggleStarred = throttled(toggleStarred, 1000)

// 点击“购买”按钮时保存数据并跳转
const goToCheckout = () => {
  cartStore.setSelectedProduct(product)
  console.log('商品详情：', cartStore.selectedProduct.value)
  router.push('/checkout')
}
</script>

<style scoped lang="scss">
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

.description {
  font-size: 20px;
  width: 560px;
  height: auto;
}

.seller:hover {
  color: $comColor;
}
</style>
