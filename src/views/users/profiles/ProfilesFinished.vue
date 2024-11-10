<template>
  <div class="profile-container">
    <div class="nav">
      <ProfilesNav />
    </div>
    <div class="published-container">
      <div v-for="item in publishedItems" :key="item.id" class="published-item">
        <img :src="item.imageUrl" alt="商品图片" class="item-image" />
        <router-link :to="`/detail/${item.id}`">
          <div class="item-info">
            <h3 class="item-title">{{ item.title }}</h3>

            <p class="item-price">￥{{ item.price }}</p>
            <span class="item-desc" :title="item.description">{{ item.description }}</span>
          </div></router-link
        >
      </div>
    </div>
  </div>
</template>

<script setup>
import { reactive, onMounted } from 'vue'
import ProfilesNav from './components/ProfilesNav.vue'
import { useCategoryStore } from '@/store/sortCategory'

const categoryStore = useCategoryStore()
onMounted(() => {
  categoryStore.getCategory()
})

// 示例商品数据
const publishedItems = reactive([
  {
    id: 99,
    title: '商品标题1',
    price: 50.0,
    description:
      '非常好物品，使我的卡牌旋转。\n以下为测试；以下为测试；以下为测试；以下为测试；以下为测试；以下为测试；以下为测试；以下为测试；',
    category: '日常用品',
    province: '广东省',
    city: '珠海市',
    area: '香洲区',
    detailArea: '中山大学',
    deliveryMethod: '邮寄',
    shippingCost: 8,
    imageUrl: 'https://via.placeholder.com/400'
  },

  {
    id: 99,
    title: '商品标题2',
    price: 30.0,
    imageUrl: 'https://via.placeholder.com/400'
  }
])
</script>

<style scoped lang="scss">
.profile-container {
  background-color: #ffffff;
  width: 70%;
  min-height: 50vh;
  margin: 0 auto;
  border-radius: 10px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  margin-top: 1%;
  margin-bottom: 3%;
}

.published-item {
  display: flex;
  align-items: center;
  padding: 10px;
  margin-bottom: 15px;
  border-radius: 10px;
  // box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.item-image {
  width: 100px;
  object-fit: cover;
  border-radius: 5px;
  margin-right: 20px;
}

.item-info {
  flex: 1;
  margin-left: 15px;

  .item-title {
    font-size: 1.2em;
    font-weight: bold;
    margin-bottom: 5px;
    margin-top: -20px;
  }
  .item-price {
    font-size: 1em;
    color: #e91e63;
    margin-bottom: 10px;
  }
  .item-desc {
    display: block;
    word-break: keep-all;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    max-width: 500px; // 你可以根据实际需要调整宽度
  }
}

.published-container {
  padding: 20px; /* 内边距 */
}
</style>
