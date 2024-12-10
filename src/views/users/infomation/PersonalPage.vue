<template>
  <UserNav />
  <div class="content">
    <br /><br />
    <el-form :model="tempUser" :rules="rules" ref="formRef" label-width="60px" class="form" style="max-width: 600px">
      <div class="avatar-container" @click="selectAvatar">
        <el-avatar :size="130" :src="tempUser.picture" />
        <input type="file" ref="fileInput" @change="onFileChange" style="display: none" accept="image/*" />
      </div>

      <el-form-item label="ID">
        <el-input v-model="tempUser.userID" disabled />
      </el-form-item>

      <el-form-item label="昵称" prop="userName">
        <el-input v-model="tempUser.userName" />
      </el-form-item>

      <el-form-item label="密码" prop="password">
        <el-input v-model="tempUser.password" :type="addPassFlag ? 'text' : 'password'">
          <template #suffix>
            <span @click="addPassFlag = !addPassFlag">
              <el-icon v-if="addPassFlag"><View /></el-icon>
              <el-icon v-else><Hide /></el-icon>
            </span>
          </template>
        </el-input>
      </el-form-item>

      <el-form-item label="性别">
        <el-select v-model="tempUser.gender" size="large">
          <el-option label="女" :value="0" />
          <el-option label="男" :value="1" />
        </el-select>
      </el-form-item>

      <el-form-item label="学校">
        <el-input v-model="tempUser.schoolName" disabled />
      </el-form-item>

      <el-form-item label="邮箱">
        <el-input v-model="tempUser.mail" disabled />
      </el-form-item>

      <el-form-item label="电话" prop="tel">
        <el-input v-model="tempUser.tel" />
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
import { ref, reactive, watchEffect } from 'vue'
import { View, Hide } from '@element-plus/icons-vue'
import UserFooter from '@/components/UserFooter.vue'
import { ElMessage } from 'element-plus'
import { editUserInfoAPI } from '@/api/profiles'
import { useUserStore } from '@/store/userStore'
import useASE from '@/hooks/useASE'
import useThrottle from '@/hooks/useThrottle.js'

const { encrypt, decrypt } = useASE()
const { throttled } = useThrottle()

const userStore = useUserStore()
// 创建一个临时变量来存储修改后的数据
const tempUser = reactive({ ...userStore.userInfo })

// 创建原始数据备份
const originalUser = reactive({ ...userStore.userInfo })

// 表单引用
const formRef = ref(null)

// 解密密码字段，渲染时显示明文密码
watchEffect(() => {
  if (userStore.userInfo.password) {
    tempUser.password = decrypt(userStore.userInfo.password)
    originalUser.password = decrypt(userStore.userInfo.password) // 同步解密到备份
  }
})

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

const addPassFlag = ref(false)

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

    ElMessage({
      message: '头像上传中，请耐心等候！',
      type: 'info',
      plain: true
    })

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
        tempUser.picture = result.data.url
        ElMessage.success('头像上传成功')
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
      // 提交之前对密码进行加密
      tempUser.password = encrypt(tempUser.password)

      // console.log('修改后的数据：', tempUser)

      const res = await editUserInfoAPI(tempUser)
      if (res.data.code === 1) {
        ElMessage.success('修改成功')
        // 更新 Pinia 中的数据
        userStore.userInfo = { ...tempUser }

        Object.assign(originalUser, tempUser) // 更新备份数据
      } else {
        // 提交失败
        ElMessage.error('用户昵称已存在')

        Object.assign(tempUser, originalUser) // 回滚所有数据
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
