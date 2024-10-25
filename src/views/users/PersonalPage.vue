<template>
  <UserNav />
  <div class="content">
    <el-form :model="user" label-width="auto" class="form" style="max-width: 600px">
      <div class="avatar-container">
        <el-avatar :size="100" :src="user.avatarUrl" />
      </div>

      <el-form-item label="ID">
        <el-input v-model="user.userID" disabled />
      </el-form-item>

      <el-form-item label="昵称">
        <el-input v-model="user.userName" />
      </el-form-item>

      <el-form-item label="密码">
        <el-input v-model="user.password" :type="addPassFlag ? 'text' : 'password'">
          <template #suffix>
            <span @click="addPassFlag = !addPassFlag">
              <el-icon v-if="addPassFlag"><View /></el-icon>
              <el-icon v-else><Hide /></el-icon>
            </span>
          </template>
        </el-input>
      </el-form-item>

      <el-form-item label="性别">
        <el-select v-model="user.gender" size="large">
          <el-option label="女" value="0" />
          <el-option label="男" value="1" />
        </el-select>
      </el-form-item>

      <el-form-item label="学校">
        <el-input v-model="user.school" disabled />
      </el-form-item>

      <el-form-item label="邮箱">
        <el-input v-model="user.email" disabled />
      </el-form-item>

      <el-form-item label="电话">
        <el-input v-model="user.tel" />
      </el-form-item>

      <el-form-item>
        <el-button type="primary" @click="onSubmit" class="submit-button">保存</el-button>
      </el-form-item>
    </el-form>
  </div>
  <UserFooter />
</template>

<script setup>
import UserNav from '@/components/UserNav.vue'
import { ref } from 'vue'
import { View, Hide } from '@element-plus/icons-vue'
import UserFooter from '@/components/UserFooter.vue'

const user = ref({
  avatarUrl: 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png',
  userID: '123',
  userName: 'name',
  password: '123456',
  gender: '0',
  school: '中山大学',
  email: '123@123.com',
  tel: '123456789'
})

const addPassFlag = ref(false)

function onSubmit() {
  console.log('更改信息')
  alert('success')
}
</script>

<style scoped lang="scss">
.content {
  display: flex;
  flex-direction: column;
  align-items: center; /* 居中 */
  margin-top: 2%;
}

.avatar-container {
  display: flex;
  justify-content: center; /* 水平居中 */
  margin-bottom: 10%; /* 调整头像和表单之间的间距 */
}

.form {
  margin-top: 3%;
  width: 30%;
}

.el-input {
  flex-grow: 1;
  height: 40px;
}

.submit-button {
  margin-top: 20px; /* 调整按钮和表单之间的间距 */
  margin-left: auto;
  margin-right: auto; /* 居中按钮 */
  margin-bottom: 3%;
}
</style>
