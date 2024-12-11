<template>
  <div class="profile-container">
    <div class="nav">
      <ProfilesNav />
    </div>
    <div class="published-container">
      <h1>暂无商品</h1>
      <div v-for="item in profilesStore.finishedProducts" :key="item.id" class="published-item">
        <img :src="getFirstImageURL(item.imageUrl)" alt="商品图片" class="item-image" />

        <div class="item-info">
          <router-link class="product-name" :to="`/detail/${item.id}`"
            ><h3 class="item-title">{{ item.title }}</h3></router-link
          >

          <p class="item-price">￥{{ item.price }}</p>
          <span class="item-desc" :title="item.description">{{ item.description }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import ProfilesNav from './components/ProfilesNav.vue'
import { useProfilesStore } from '@/store/profilesStore'

const profilesStore = useProfilesStore()

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

  h1 {
    margin: 50px 0;
    text-align: center;
    color: dimgray;
    font-size: 24px;
    font-weight: 400;
  }
}

.product-name:hover {
  color: $comColor;
}
</style>
