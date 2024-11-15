<template>
  <UserNav />
  <div class="content">
    <br /><br />
    <el-form :model="userInfo" label-width="40px" class="form" style="max-width: 600px">
      <div class="avatar-container" @click="selectAvatar">
        <el-avatar :size="130" :src="userInfo.picture" />
        <input type="file" ref="fileInput" @change="onFileChange" style="display: none" accept="image/*" />
      </div>

      <el-form-item label="ID">
        <el-input v-model="userInfo.userID" disabled />
      </el-form-item>

      <el-form-item label="昵称">
        <el-input v-model="userInfo.userName" />
      </el-form-item>

      <el-form-item label="密码">
        <el-input v-model="userInfo.password" :type="addPassFlag ? 'text' : 'password'">
          <template #suffix>
            <span @click="addPassFlag = !addPassFlag">
              <el-icon v-if="addPassFlag"><View /></el-icon>
              <el-icon v-else><Hide /></el-icon>
            </span>
          </template>
        </el-input>
      </el-form-item>

      <el-form-item label="性别">
        <el-select v-model="userInfo.gender" size="large">
          <el-option label="女" :value="0" />
          <el-option label="男" :value="1" />
        </el-select>
      </el-form-item>

      <el-form-item label="学校">
        <el-input v-model="userInfo.schoolName" disabled />
      </el-form-item>

      <el-form-item label="邮箱">
        <el-input v-model="userInfo.mail" disabled />
      </el-form-item>

      <el-form-item label="电话">
        <el-input v-model="userInfo.tel" />
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
import { ref, onMounted } from 'vue'
import { View, Hide } from '@element-plus/icons-vue'
import UserFooter from '@/components/UserFooter.vue'
import axios from 'axios'
import { ElMessage } from 'element-plus'
import { getUserInfoAPI, editUserInfoAPI } from '@/api/profiles'
import useASE from '@/hooks/useASE'

const { encrypt, decrypt } = useASE()

// 从接口获取数据
const userInfo = ref({})
const getUserInfo = async () => {
  const res = await getUserInfoAPI()
  // console.log('getUserInfoAPI响应：', res.data)
  res.data.data.password = decrypt(res.data.data.password)
  // console.log('解密后：', res.data.data.password)
  userInfo.value = res.data.data
  fetchAvatar()
}

onMounted(() => {
  getUserInfo()
})

const addPassFlag = ref(false)

async function fetchAvatar() {
  try {
    //const response = await axios.get('https://dog.ceo/api/breeds/image/random')
    //userInfo.value.picture = response.data.message // 更新头像 URL
    const response = await axios.get('https://api.thecatapi.com/v1/images/search')
    userInfo.value.picture = response.data[0].url // 更新头像 URL
  } catch (error) {
    userInfo.value.picture = 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'
    console.error('获取头像失败:', error)
  }
}

function onFileChange(event) {
  const file = event.target.files[0]
  if (file) {
    const reader = new FileReader()
    reader.onload = (e) => {
      userInfo.value.picture = e.target.result // 更新头像 URL
    }
    reader.readAsDataURL(file) // 将文件转换为 Data URL
  }
}
const fileInput = ref(null)
function selectAvatar() {
  fileInput.value.click() // 点击文件输入框
}

// 提交修改
const onSubmit = async () => {
  const updatedData = {
    userID: userInfo.value.userID,
    userName: userInfo.value.userName,
    password: encrypt(userInfo.value.password),
    picture: userInfo.value.picture,
    gender: userInfo.value.gender,
    tel: userInfo.value.tel
  }
  console.log('更新的数据：', updatedData)
  const res = await editUserInfoAPI(updatedData)
  if (res.data.code === 1) {
    ElMessage({
      type: 'success',
      message: '修改成功'
    })
  } else ElMessage.error('修改失败')
}
</script>

<style scoped lang="scss">
.content {
  display: flex;
  flex-direction: column;
  align-items: center; /* 居中 */
  background-image: url('/src/assets/images/background3.svg');
}

.avatar-container {
  display: flex;
  justify-content: center; /* 水平居中 */
  margin-bottom: 10%; /* 调整头像和表单之间的间距 */
}

.form {
  margin-top: 5%;
  margin-bottom: 2%;
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
  font-weight: 600;
}
</style>
