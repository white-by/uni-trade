<template>
  <div class="profile-container">
    <div class="nav">
      <ProfilesNav />
    </div>
    <div class="published-container">
      <div v-for="item in profilesStore.finishedProducts" :key="item.id" class="published-item">
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
import ProfilesNav from './components/ProfilesNav.vue'
import { useProfilesStore } from '@/store/profilesStore'

const profilesStore = useProfilesStore()
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
</style>
