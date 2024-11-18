<template>
  <el-container>
    <el-main>
      <el-row style="height: 80%">
        <el-col :span="12" class="welcome-text">
          <p>欢迎</p>
          <p>广大师生</p>
          <p>使用<strong style="font-style: italic">校园二手交易站</strong></p>
        </el-col>
        <el-col :span="12" class="register-form">
          <div class="frosted-glass">
            <br />

            <el-form :model="form" :rules="rules" ref="formRef">
              <el-form-item prop="schoolName">
                <el-select v-model="form.schoolName" placeholder="请选择学校" size="large">
                  <el-option
                    v-for="(school, index) in schoolList"
                    :key="index"
                    :label="school"
                    :value="school"
                  ></el-option>
                </el-select>
              </el-form-item>
              <el-form-item prop="mail">
                <el-input placeholder="请输入邮箱前缀" v-model="mailPrefix" @input="updateMail">
                  <template #append>{{ schoolEmailSuffix }}</template>
                </el-input>
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
                <el-input v-model="form.password" :type="addPassFlag ? 'text' : 'password'" placeholder="请输入密码">
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
                  :type="addPassFlag ? 'text' : 'password'"
                  placeholder="请再次输入密码"
                >
                  <template #suffix>
                    <span @click="addPassFlag = !addPassFlag">
                      <el-icon v-if="addPassFlag"><View /></el-icon>
                      <el-icon v-else><Hide /></el-icon>
                    </span>
                  </template>
                </el-input>
              </el-form-item>

              <el-form-item>
                <el-button type="primary" @click="handleRegister" class="register-button">注册</el-button>
              </el-form-item>
            </el-form>
          </div>
        </el-col>
      </el-row>
    </el-main>
  </el-container>
</template>

<script setup>
import { ref, watch } from 'vue'
import { View, Hide } from '@element-plus/icons-vue'
import { ElMessage, ElNotification } from 'element-plus'
import schoolData from '@/../public/school.json'
import { useRouter } from 'vue-router'

import 'element-plus/theme-chalk/el-notification.css'

const router = useRouter()

let form = ref({
  schoolName: '',
  mail: '',
  verificationCode: '',
  password: '',
  confirmPassword: ''
})

// 获取学校列表
const schoolList = Object.keys(schoolData)
// 当前选中的学校
const selectedSchool = ref('') // 默认选中第一个学校
// 邮箱后缀
const schoolEmailSuffix = ref('@edu.cn') // 默认后缀
// 前缀
const mailPrefix = ref('')

// 动态更新邮箱前缀到 mail 字段中
const updateMail = () => {
  form.value.mail = `${mailPrefix.value}${schoolEmailSuffix.value}`
}
// 监听选中的学校变化
watch(
  () => form.value.schoolName, // 监听表单中学校的变化
  (newSchool) => {
    if (newSchool) {
      selectedSchool.value = newSchool // 同步更新 selectedSchool
      schoolEmailSuffix.value = schoolData[newSchool]
    }
  }
)

const addPassFlag = ref(false)
const isCounting = ref(false)
const countdown = ref(120)

const rules = ref({
  schoolName: [{ required: true, message: '请选择学校', trigger: 'change' }],
  mail: [{ required: true, message: '请输入邮箱前缀', trigger: 'blur' }],

  verificationCode: [{ required: true, message: '请输入验证码', trigger: 'blur' }],

  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    {
      min: 5,
      max: 20,
      message: '长度应为 5 到 20 位',
      trigger: 'blur'
    },
    {
      validator: (rule, value, callback) => {
        const regex = /^[A-Za-z0-9]+$/ // 只允许字母和数字
        if (value && !regex.test(value)) {
          callback(new Error('密码只能由字母和数字组成。'))
        } else {
          callback() // 验证通过
        }
      },
      trigger: 'blur'
    }
  ],

  confirmPassword: [
    { required: true, message: '请确认密码', trigger: 'blur' },
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

const sendVerificationCode = () => {
  // 这里添加发送验证码的逻辑
  console.log('Sending verification code to:', form.value.mail)
  // 启动倒计时
  isCounting.value = true
  countdown.value = 60
  const timer = setInterval(() => {
    countdown.value--
    if (countdown.value <= 0) {
      clearInterval(timer)
      isCounting.value = false
    }
  }, 1000)
  // 发送验证码的 API 调用
}

const formRef = ref(null) // 引用表单

const handleRegister = () => {
  // 调用表单验证
  formRef.value?.validate((valid) => {
    if (valid) {
      // 验证通过，执行注册逻辑
      const updatedMail = `${mailPrefix.value}${schoolEmailSuffix.value}`
      form.value.mail = updatedMail
      const newForm = ref({
        schoolName: form.value.schoolName,
        mail: form.value.mail,
        code: form.value.verificationCode,
        password: form.value.password
      })

      console.log('注册信息:', newForm.value)

      const returnCode = 1 //test用
      if (returnCode) {
        // 显示成功消息
        ElNotification({
          title: '注册成功',
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
          message: '注册失败',
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
  //color: rgb(255, 255, 255);
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

.register-form {
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

.link {
  color: $comColor;
  cursor: pointer;
  font-style: italic;
  font-size: 14px;
  margin-top: -10px;
}

.link:hover {
  color: coral; /* 悬停时更改颜色 */
}

.register-button {
  height: 40px;
  width: 100%; /* 登录按钮宽度填满 */
  margin-top: 10px; /* 增加顶部间距 */
}

.forgot-password-link {
  margin-left: 78%; /* 左侧间距 */
}
.register-link {
  display: block; /* 使链接占一整行 */
  text-align: center; /* 居中 */
  font-size: 14px; /* 调小字体 */
  // margin-top: 10px; /* 增加间距 */
}

.announcements {
  text-align: left;
  font-size: 20px;
  margin: 20px 0;
  padding-left: 12%; /* 确保文本与边缘对齐 */
  display: flex;
  flex-direction: column;
  justify-content: center; /* 垂直居中 */
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
</style>
