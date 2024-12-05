<template>
  <div class="profile-container">
    <div class="nav">
      <ProfilesNav />
    </div>
    <div class="published-container">
      <div v-for="(product, index) in profilesStore.publishedProducts" :key="product.id" class="published-item">
        <img :src="getFirstImageURL(product.imageURL)" alt="商品图片" class="item-image" />
        <div class="item-info">
          <router-link class="product-name" :to="`/detail/${product.id}`"
            ><h3 class="item-title">{{ product.title }}</h3></router-link
          >
          <p class="item-price">￥{{ product.price }}</p>
          <span class="item-desc" :title="product.description">{{ product.description }}</span>
        </div>
        <!-- 使用 v-model:item 绑定数据 -->
        <EditBtn
          v-show="userStore.userInfo.userID == getIdFromUrl()"
          v-model:item="profilesStore.publishedProducts[index]"
          label="编辑"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import EditBtn from './components/EditBtn.vue'
import ProfilesNav from './components/ProfilesNav.vue'
import { useProfilesStore } from '@/store/profilesStore'
import { useUserStore } from '@/store/userStore'

const profilesStore = useProfilesStore()
const userStore = useUserStore()

const getIdFromUrl = () => {
  const url = window.location.pathname // 获取路径部分
  const segments = url.split('/') // 根据 / 分割路径
  return segments[2] // 假设 ID 是路径的第二个部分
}

// 获取第一张图片URL
const getFirstImageURL = (imageURL) => {
  return imageURL ? imageURL.split(',')[0] : ''
}
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
    display: block;
    word-break: keep-all;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    max-width: 400px; // 你可以根据实际需要调整宽度
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

.product-name:hover {
  color: $comColor;
}
</style>
