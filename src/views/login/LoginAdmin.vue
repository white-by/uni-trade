<template>
  <div class="login-container">
    <el-form ref="formRef" :model="form" class="login-form" :rules="rules">
      <div class="title-container">
        <h3 class="title">LoginAdmin</h3>
      </div>

      <el-form-item prop="username">
        <el-icon size="20" class="svg-container"><Edit /></el-icon>
        <span>请输入用户名</span>
        <el-input v-model="form.username"> </el-input>
      </el-form-item>

      <el-form-item prop="password">
        <el-icon size="20" class="svg-container"><Lock /></el-icon>
        <span>请输入密码</span>
        <el-input v-model="form.password"></el-input>
      </el-form-item>

      <div class="button-container">
        <el-button type="primary" class="login-button" @click="handleLogin"
          >登录</el-button
        >
      </div>
    </el-form>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { Edit, Lock } from '@element-plus/icons-vue'
const form = ref({
  username: '',
  password: ''
})

const login = async (formData) => {
  // 这里放置你的登录逻辑
  console.log('Logging in with:', formData)
}

const rules = ref({
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 8, message: '长度应为 3 到 8 位', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    {
      min: 6,
      message: '密码至少 6 位',
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

const formRef = ref(null)
const handleLogin = () => {
  formRef.value.validate((valid, fields) => {
    // 添加 fields 参数
    if (valid) {
      login(form.value)
      // alert('submit')
      // console.log('submit!')
    } else {
      console.log('error submit!', fields) // 现在 fields 已经定义了
      return false
    }
  })
}
</script>

<style scoped>
.login-container {
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: rgba(255, 255, 255, 0.8); /* 浅色背景 */
}

.login-form {
  width: 100%;
  max-width: 400px; /* 最大宽度 */
  padding: 40px;
  border-radius: 8px;
  backdrop-filter: blur(10px); /* 毛玻璃效果 */
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3); /* 添加阴影 */
  background-color: rgba(255, 255, 255, 0.2); /* 毛玻璃背景 */
}

.el-form-item {
  margin-bottom: 20px; /* 增加下边距 */
  display: flex;
  align-items: center; /* 垂直居中图标和输入框 */
}

.svg-container {
  margin-right: 10px; /* 图标和输入框之间的间距 */
  color: #555; /* 图标颜色 */
}

.el-input {
  flex-grow: 1; /* 输入框占满剩余空间 */
  height: 40px; /* 增加高度 */
}

.el-input input {
  background: transparent;
  border: 1px solid rgba(255, 255, 255, 0.3); /* 添加边框 */
  border-radius: 5px; /* 添加圆角 */
  padding: 12px 15px; /* 增加内边距 */
  color: #333; /* 输入框文字颜色 */
  height: 100%; /* 使输入框高度与 el-input 相同 */
}

.login-button {
  height: 50px; /* 增加按钮高度 */
  margin-top: 20px; /* 增加上边距 */
  border-radius: 5px; /* 添加圆角 */
  background-color: #409eff; /* 按钮颜色 */
  color: #fff; /* 按钮文字颜色 */
  width: 100%;
}

.button-container {
  display: flex;
  justify-content: center;
  margin-top: 20px; /* 可选，增加按钮与输入框之间的间距 */
}

.title-container {
  text-align: center; /* 居中对齐 */
  margin-bottom: 20px; /* 增加下边距 */
}

.title {
  font-size: 28px; /* 增加标题字体大小 */
  color: #333; /* 标题颜色 */
  font-weight: bold;
}
</style>
