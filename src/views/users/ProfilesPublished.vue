<script setup>
import ProfilesNav from './components/ProfilesNav.vue'
</script>

<template>
  <div class="profile-container">
    <div class="nav">
      <ProfilesNav />
    </div>
    <div class="published-container">
      <h1>published</h1>
    </div>
  </div>
</template>

<style scoped lang="scss">
.profile-container {
  background-color: #f9f9f9; /* 空白背景 */
  width: 70%;
  min-height: 50vh;
  margin: 0 auto; /* 水平居中 */

  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); /* 阴影效果 */
  margin-top: 1%;
  margin-bottom: 3%;
}

.published-container {
  padding: 20px; /* 内边距 */
}
</style>
