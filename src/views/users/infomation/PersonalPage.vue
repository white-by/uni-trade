<template>
  <UserNav />
  <div class="content">
    <br /><br />
    <el-form
      :model="userStore.userInfo"
      :rules="rules"
      ref="formRef"
      label-width="60px"
      class="form"
      style="max-width: 600px"
    >
      <div class="avatar-container" @click="selectAvatar">
        <el-avatar :size="130" :src="userStore.userInfo.picture" />
        <input type="file" ref="fileInput" @change="onFileChange" style="display: none" accept="image/*" />
      </div>

      <el-form-item label="ID">
        <el-input v-model="userStore.userInfo.userID" disabled />
      </el-form-item>

      <el-form-item label="昵称" prop="userName">
        <el-input v-model="userStore.userInfo.userName" />
      </el-form-item>

      <el-form-item label="密码" prop="password">
        <el-input v-model="userStore.userInfo.password" :type="addPassFlag ? 'text' : 'password'">
          <template #suffix>
            <span @click="addPassFlag = !addPassFlag">
              <el-icon v-if="addPassFlag"><View /></el-icon>
              <el-icon v-else><Hide /></el-icon>
            </span>
          </template>
        </el-input>
      </el-form-item>

      <el-form-item label="性别">
        <el-select v-model="userStore.userInfo.gender" size="large">
          <el-option label="女" :value="0" />
          <el-option label="男" :value="1" />
        </el-select>
      </el-form-item>

      <el-form-item label="学校">
        <el-input v-model="userStore.userInfo.schoolName" disabled />
      </el-form-item>

      <el-form-item label="邮箱">
        <el-input v-model="userStore.userInfo.mail" disabled />
      </el-form-item>

      <el-form-item label="电话" prop="tel">
        <el-input v-model="userStore.userInfo.tel" />
      </el-form-item>

      <el-form-item>
        <el-button type="primary" @click="throttledOnSubmit" class="submit-button">保存</el-button>
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
import { editUserInfoAPI } from '@/api/profiles'
import { useUserStore } from '@/store/userStore'
import useASE from '@/hooks/useASE'
import useThrottle from '@/hooks/useThrottle.js'

const userStore = useUserStore()

const { encrypt } = useASE()
const { throttled } = useThrottle()

// 表单引用
const formRef = ref(null)

// 表单验证规则
const rules = {
  userName: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  tel: [
    { required: true, message: '请输入电话', trigger: 'blur' },
    { pattern: /^[0-9]{11}$/, message: '请输入有效的电话号码', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { pattern: /^[a-zA-Z0-9_]{6,16}$/, message: '密码只能包含数字、字母和下划线，长度为6-16位', trigger: 'blur' }
  ]
}

onMounted(() => {
  fetchAvatar()
})

const addPassFlag = ref(false)

async function fetchAvatar() {
  try {
    const response = await axios.get('https://api.thecatapi.com/v1/images/search')
    userStore.userInfo.picture = response.data[0].url // 更新头像 URL
  } catch (error) {
    userStore.userInfo.picture = 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'
    console.error('获取头像失败:', error)
  }
}

// 头像上传
const fileInput = ref(null)

// 点击文件输入框
function selectAvatar() {
  fileInput.value.click()
}

// 上传至图床
async function onFileChange(event) {
  const file = event.target.files[0]
  if (file) {
    const formData = new FormData()
    formData.append('smfile', file)

    try {
      const response = await fetch('/api/v2/upload', {
        method: 'POST',
        headers: {
          Authorization: 'OeXXrpbZISBaCBiL2g74WNPweSZkwODK'
        },
        body: formData
      })

      const result = await response.json()

      if (result.success) {
        // 上传成功，更新头像 URL
        userStore.userInfo.picture = result.data.url
        console.log('头像上传成功:', result.data.url)
      } else {
        console.error('头像上传失败:', result.message)
      }
    } catch (error) {
      console.error('头像上传出错:', error)
    }
  }
}

// 提交修改
const onSubmit = async () => {
  formRef.value.validate(async (valid) => {
    if (valid) {
      const updatedData = {
        userID: userStore.userInfo.userID,
        userName: userStore.userInfo.userName,
        password: encrypt(userStore.userInfo.password),
        picture: userStore.userInfo.picture,
        gender: userStore.userInfo.gender,
        tel: userStore.userInfo.tel
      }
      console.log('修改后的数据：', updatedData)
      const res = await editUserInfoAPI(updatedData)
      if (res.data.code === 1) {
        await userStore.fetchUserInfo() // 更新数据
        ElMessage.success('修改成功')
      } else {
        ElMessage.error('修改失败')
      }
    } else {
      console.log('表单校验失败')
      return false
    }
  })
}
// 节流处理：限制每秒响应一次
const throttledOnSubmit = throttled(onSubmit, 1000)
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
