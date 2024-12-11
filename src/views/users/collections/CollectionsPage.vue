<template>
  <UserNav />
  <el-card class="collection-contain">
    <el-row style="margin-bottom: 50px; color: dimgray"><h3>我的收藏</h3></el-row>
    <div v-if="collectionList != null">
      <div v-for="item in collectionList" :key="item.id" class="published-item">
        <img :src="item.imageUrl" alt="商品图片" class="item-image" />

        <div class="item-info">
          <router-link class="product-name" :to="`/detail/${item.id}`">
            <h3 class="item-title">{{ item.title }}</h3>
          </router-link>
          <p class="item-price">￥{{ item.price }}</p>
          <span class="item-desc" :title="item.description">{{ item.description }}</span>
        </div>
      </div>
      <!-- 分页 -->
      <div>
        <el-pagination
          size="small"
          style="justify-content: center; margin-top: 20px"
          layout="prev, pager, next"
          :current-page="pageNum"
          :page-size="pageSize"
          :total="total"
          @current-change="handlePageChange"
        />
      </div>
    </div>
    <div v-else class="no-product-container">
      <img src="@/assets/images/none/暂无数据.png" alt="暂无数据" />
    </div>
  </el-card>

  <UserFooter />
</template>

<script setup>
import UserNav from '@/components/UserNav.vue'
import UserFooter from '@/components/UserFooter.vue'
import { onMounted, ref } from 'vue'
import { getCollectionListAPI } from '@/api/collection'

let pageNum = ref(1) //表格页码
let pageSize = ref(5) //每页最大展示条数
const total = ref(0)
const collectionList = ref([])
const getCollectionList = async () => {
  const res = await getCollectionListAPI(pageNum.value, pageSize.value)
  // console.log('getCollectionListAPI返回数据', res.data.data)
  collectionList.value = res.data.data.collectionList
  total.value = res.data.data.total
}

// 页码变化处理
const handlePageChange = (pageNum) => {
  pageNum.value = pageNum
  getCollectionList() // 页码变化时重新获取数据
}

onMounted(() => {
  getCollectionList()
})
</script>

<style scoped lang="scss">
.no-product-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 450px;
}

.product-name:hover {
  color: $comColor;
}

.collection-contain {
  width: 70%;
  margin: 0 auto;
  margin-top: 3%;
  margin-bottom: 3%;
}

.published-item {
  display: flex;
  align-items: center;
  padding: 10px;
  margin-bottom: 40px;
  border-radius: 10px;
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
    max-width: 400px;
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
    max-width: 500px;
  }
}
</style>
