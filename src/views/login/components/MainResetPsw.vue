<template>
  <el-container>
    <el-main>
      <el-row style="height: 80%">
        <el-col :span="12" class="welcome-text">
          <p>欢迎</p>
          <p>同学们</p>
          <p>使用<strong style="font-style: italic">校园二手交易站</strong></p>
        </el-col>
        <el-col :span="12" class="reset-password-form">
          <div class="frosted-glass">
            <br />
            <el-form :model="form" :rules="rules" ref="formRef">
              <el-form-item prop="mail">
                <el-input placeholder="请输入邮箱" v-model="form.mail" />
              </el-form-item>

              <el-form-item prop="verificationCode">
                <el-row :gutter="8">
                  <el-col :span="16">
                    <el-input
                      placeholder="请输入邮箱验证码"
                      v-model="form.verificationCode"
                      class="verification-code-input"
                    />
                  </el-col>
                  <el-col :span="8">
                    <el-button
                      type="primary"
                      @click="sendVerificationCode"
                      :disabled="isCounting"
                      class="verification-code-button"
                    >
                      {{ isCounting ? `重发验证 ${countdown}s` : '发送验证码' }}
                    </el-button>
                  </el-col>
                </el-row>
              </el-form-item>

              <el-form-item prop="password">
                <el-input v-model="form.password" :type="addPassFlag ? 'text' : 'password'" placeholder="请输入新密码">
                  <template #suffix>
                    <span @click="addPassFlag = !addPassFlag">
                      <el-icon v-if="addPassFlag"><View /></el-icon>
                      <el-icon v-else><Hide /></el-icon>
                    </span>
                  </template>
                </el-input>
              </el-form-item>

              <el-form-item prop="confirmPassword">
                <el-input
                  v-model="form.confirmPassword"
                  :type="addPassFlag1 ? 'text' : 'password'"
                  placeholder="请再次输入新密码"
                >
                  <template #suffix>
                    <span @click="addPassFlag1 = !addPassFlag1">
                      <el-icon v-if="addPassFlag1"><View /></el-icon>
                      <el-icon v-else><Hide /></el-icon>
                    </span>
                  </template>
                </el-input>
              </el-form-item>

              <el-form-item>
                <el-button type="primary" @click="handleResetPassword" class="reset-password-button">
                  重置密码
                </el-button>
              </el-form-item>
            </el-form>
          </div>
        </el-col>
      </el-row>
    </el-main>
  </el-container>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { View, Hide } from '@element-plus/icons-vue'
import { ElMessage, ElNotification } from 'element-plus'
import { useRouter } from 'vue-router'

import 'element-plus/theme-chalk/el-notification.css'

const router = useRouter()

let form = ref({
  mail: '',
  verificationCode: '',
  password: '',
  confirmPassword: ''
})

const addPassFlag = ref(false)
const addPassFlag1 = ref(false)
const isCounting = ref(false)
const countdown = ref(60)

const rules = ref({
  mail: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入有效的邮箱地址', trigger: ['blur', 'change'] },
    { min: 5, max: 50, message: '长度应为 5 到 50 位', trigger: 'blur' }
  ],

  verificationCode: [{ required: true, message: '请输入验证码', trigger: 'blur' }],

  password: [
    { required: true, message: '请输入新密码', trigger: 'blur' },
    {
      min: 6,
      max: 16,
      message: '长度应为 6 到 16 位',
      trigger: 'blur'
    },
    {
      validator: (rule, value, callback) => {
        const regex = /^[a-zA-Z0-9_]{6,16}$/
        if (value && !regex.test(value)) {
          callback(new Error('密码只能由字母、数字和下划线组成。'))
        } else {
          callback() // 验证通过
        }
      },
      trigger: 'blur'
    }
  ],

  confirmPassword: [
    { required: true, message: '请确认新密码', trigger: 'blur' },
    {
      validator: (rule, value, callback) => {
        if (value !== form.value.password) {
          callback(new Error('两次输入的密码不一致。'))
        } else {
          callback() // 验证通过
        }
      },
      trigger: 'blur'
    }
  ]
})

const initializeCountdown = () => {
  const savedTargetTime = localStorage.getItem('verificationCountdownPsw')
  if (savedTargetTime) {
    const remainingTime = Math.floor((parseInt(savedTargetTime) - Date.now()) / 1000)
    if (remainingTime > 0) {
      countdown.value = remainingTime
      startCountdown()
    }
  }
}

const startCountdown = () => {
  const now = Date.now()
  const targetTime = now + countdown.value * 1000
  localStorage.setItem('verificationCountdownPsw', targetTime.toString())

  isCounting.value = true
  const timer = setInterval(() => {
    const remainingTime = Math.floor((targetTime - Date.now()) / 1000)
    if (remainingTime <= 0) {
      clearInterval(timer)
      isCounting.value = false
      countdown.value = 120
      localStorage.removeItem('verificationCountdownPsw')
    } else {
      countdown.value = remainingTime
    }
  }, 1000)
}

onMounted(() => {
  initializeCountdown()
})

const formRef = ref(null)

const sendVerificationCode = () => {
  formRef.value.validateField('mail', (valid) => {
    if (valid) {
      startCountdown()
    }
  })
}

const handleResetPassword = () => {
  // 调用表单验证
  formRef.value?.validate((valid) => {
    if (valid) {
      // 验证通过，执行重置密码逻辑

      console.log('重置密码信息:', form.value)

      const returnCode = 1 //test用
      if (returnCode) {
        // 显示成功消息
        ElNotification({
          title: '重置密码成功',
          message: '3秒后返回登录页',
          type: 'success',
          duration: 3000 // 消息持续时间为3秒
        })

        // 3秒后跳转到登录页
        setTimeout(() => {
          // 使用 Vue Router 跳转
          router.replace('/login')
        }, 3000)
      } else {
        ElMessage({
          message: '重置密码失败',
          type: 'error'
        })
      }
    } else {
      console.log('表单验证失败')
    }
  })
}
</script>

<style scoped lang="scss">
.el-container {
  height: 100vh; /* 使容器高度占满整个视口 */
  background-image: url('/src/assets/images/background4.svg');
  background-size: cover;
}

.welcome-text {
  text-align: left;
  font-size: 60px;
  margin: 20px 0;
  padding-left: 12%; /* 确保文本与边缘对齐 */
  display: flex;
  flex-direction: column;
  justify-content: center; /* 垂直居中 */
}

.el-input {
  flex-grow: 1;
  height: 40px;
}

.reset-password-form {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
  padding-right: 12%;
}

.frosted-glass {
  background: rgba(255, 255, 255, 0.5);
  backdrop-filter: blur(10px);
  padding: 40px; /* 增加内边距 */
  border-radius: 10px;
  width: 400px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1); /* 添加阴影 */
}

.verification-code-input {
  width: 200px;
}

.verification-code-button {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
  width: 105px;
}

.reset-password-button {
  height: 40px;
  width: 100%; /* 按钮宽度填满 */
  margin-top: 10px; /* 增加顶部间距 */
}
</style>
