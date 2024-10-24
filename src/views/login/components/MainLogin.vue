<template>
  <el-container>
    <el-main>
      <el-row style="height: 80%">
        <el-col :span="12" class="welcome-text">
          <p>欢迎</p>
          <p>广大师生</p>
          <p>使用<strong>校园二手交易站</strong></p>
        </el-col>
        <el-col :span="12" class="login-form">
          <div class="frosted-glass">
            <br />
            <el-form :model="form" :rules="rules">
              <el-form-item prop="email">
                <el-input placeholder="请输入邮箱" v-model="form.email" />
              </el-form-item>

              <el-form-item prop="password">
                <el-icon size="20" class="svg-container"><Lock /></el-icon>
                <el-input v-model="form.password" :type="addPassFlag ? 'text' : 'password'" placeholder="请输入密码">
                  <template #suffix>
                    <span @click="addPassFlag = !addPassFlag">
                      <el-icon v-if="addPassFlag"><View /></el-icon>
                      <el-icon v-else><Hide /></el-icon>
                    </span>
                  </template>
                </el-input>
              </el-form-item>

              <el-form-item>
                <el-link class="link forgot-password-link" @click="handleForgotPassword" :underline="false">忘记密码？</el-link>
              </el-form-item>
              <el-form-item>
                <el-button type="primary" @click="handleLogin" class="login-button">登录</el-button>
              </el-form-item>
              <el-form-item>
                <el-link class="link register-link" @click="handleRegister" :underline="false">没有账号？去注册</el-link>
              </el-form-item>
            </el-form>
          </div>
        </el-col>
      </el-row>

      <div class="announcements">
        <p>请遵守校园交易规则。</p>
        <ol>
          <li>xxx</li>
          <li>xxx</li>
        </ol>
      </div>
    </el-main>
  </el-container>
</template>

<script setup>
import { ref } from 'vue'
import { View, Hide } from '@element-plus/icons-vue'
import { useRouter } from 'vue-router'

const router = useRouter()
let form = ref({
  email: '',
  password: ''
})

const addPassFlag = ref(false)

const rules = ref({
  email: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入有效的邮箱地址', trigger: ['blur', 'change'] },
    { min: 5, max: 20, message: '长度应为 5 到 20 位', trigger: 'blur' }
  ],

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
  ]
})

const handleLogin = async (formData) => {
  // 这里放置你的登录逻辑
  console.log('Logging in with:', formData)
}

const handleForgotPassword = () => {
  // 跳转到忘记密码页面
  router.push('/forgot-password')
}

const handleRegister = () => {
  // 跳转到注册页面
  router.push('/register')
}
</script>

<style scoped lang="scss">
.el-container {
  height: 100vh; /* 使容器高度占满整个视口 */
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

.svg-container {
  padding: 6px 5px 6px 15px;
  // color: $dark_gray;
  vertical-align: middle;
  display: inline-block;
}

.el-input {
  flex-grow: 1;
  height: 40px;
  margin-top: -10px;
}

.login-form {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
  padding-right: 12%;
}

.frosted-glass {
  background: rgba(255, 255, 255, 0.7);
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

.login-button {
  height: 40px;
  width: 100%; /* 登录按钮宽度填满 */
  // margin-top: 10px; /* 增加顶部间距 */
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
</style>
