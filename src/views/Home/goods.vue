<template>
    <div class="product-container">
        <el-row :gutter="20" class="product-row">
            <el-col :span="4" v-for="product in products" :key="product.id">
              <el-card shadow="hover" class="product-card">
                <img :src="product.image" class="product-image" />
                <div class="product-info">
                  <h3 class="product-title">{{ product.title }}</h3>
                  <p class="product-price">￥{{ product.price }}</p>
                </div>
              </el-card>
            </el-col>
          </el-row>
    </div>
  </template>
  
  <script setup>
  import { ref } from 'vue';
  
  const products = ref([
    { id: 1, title: 'Product 1', price: 100, image: 'https://via.placeholder.com/150' },
    { id: 2, title: 'Product 2', price: 200, image: 'https://via.placeholder.com/150' },
    { id: 3, title: 'Product 3', price: 300, image: 'https://via.placeholder.com/150' },
    { id: 4, title: 'Product 4', price: 400, image: 'https://via.placeholder.com/150' },
    { id: 5, title: 'Product 5', price: 500, image: 'https://via.placeholder.com/150' },
    { id: 6, title: 'Product 6', price: 600, image: 'https://via.placeholder.com/150' },
    { id: 7, title: 'Product 7', price: 700, image: 'https://via.placeholder.com/150' },
    { id: 8, title: 'Product 8', price: 800, image: 'https://via.placeholder.com/150' },
    { id: 9, title: 'Product 9', price: 900, image: 'https://via.placeholder.com/150' },
    { id: 10, title: 'Product 10', price: 1000, image: 'https://via.placeholder.com/150' },
    { id: 11, title: 'Product 11', price: 1100, image: 'https://via.placeholder.com/150' },
    { id: 12, title: 'Product 12', price: 1200, image: 'https://via.placeholder.com/150' },
  ]);
  </script>
  
  <style scoped>

  .product-container {
    padding-left: 60px; 
    padding-right: 60px; 
  }

  .product-card {
    text-align: center;
    padding: 10px;
    margin-top: 20px;
    margin-bottom: 20px;
    margin-left: 10px;
    margin-right: 10px;
  }
  
  .product-image {
    width: 100%;
    height: 150px;
    object-fit: cover;
  }
  
  .product-info {
    margin-top: 10px;
  }
  
  .product-title {
    font-size: 16px;
    margin: 5px 0;
  }
  
  .product-price {
    font-size: 18px;
    color: #f56c6c;
  }
  </style>
  