<template>
  <el-container>
    <el-main>
      <el-row style="height: 80%">
        <el-col :span="12" class="welcome-text">
          <p>欢迎</p>
          <p>广大师生</p>
          <p>使用<strong style="font-style: italic">校园二手交易站</strong></p>
        </el-col>
        <el-col :span="12" class="login-form">
          <div class="frosted-glass">
            <br />
            <el-form ref="formRef" :model="form" :rules="rules">
              <el-form-item prop="email">
                <el-input placeholder="请输入邮箱" v-model="form.mail" />
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

              <el-form-item>
                <el-link class="link forgot-password-link" @click="handleResetPassword" :underline="false"
                  >忘记密码？</el-link
                >
              </el-form-item>
              <el-form-item>
                <el-button type="primary" @click="handleLogin" class="login-button">登录</el-button>
              </el-form-item>
              <el-form-item>
                <el-link class="link register-link" @click="handleRegister" :underline="false"
                  >没有账号？去注册</el-link
                >
              </el-form-item>
            </el-form>
          </div>
        </el-col>
      </el-row>

      <!-- <div class="announcements">
        <p>请遵守校园交易规则。</p>
        <ol>
          <li>真实可靠：交易双方应保证发布信息的真实性，禁止发布虚假、夸大或含有误导性的商品信息</li>
          <li>物品合规：仅允许发布校园内符合使用规定的物品。严禁发布违禁物品、非法物品或校园禁止携带的物品。</li>
          <li>信守承诺：交易达成后，买卖双方应按约定进行交易，避免无故放弃交易或随意更改交易条款。</li>
          <li>良好沟通：交易双方应保持良好的沟通，及时沟通商品状态、付款方式和交付细节，确保交易顺利完成。</li>
        </ol>
      </div> -->
    </el-main>
  </el-container>
</template>

<script setup>
import { ref } from 'vue'
import { View, Hide } from '@element-plus/icons-vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { useUserStore } from '@/store/userStore'
import useASE from '@/hooks/useASE'

const router = useRouter()
let form = ref({
  mail: '',
  password: ''
})

const addPassFlag = ref(false)
const userStore = useUserStore()
const rules = ref({
  mail: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入有效的邮箱地址', trigger: ['blur', 'change'] }
  ],

  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
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
  ]
})

const { encrypt } = useASE()

const formRef = ref(null)
const handleLogin = () => {
  formRef.value.validate(async (valid, fields) => {
    console.log('加密前：', form.value.password)
    const password = encrypt(form.value.password)
    console.log('加密后：', password)
    // 添加 fields 参数
    const { mail } = form.value
    if (valid) {
      await userStore.getUserInfo({ mail, password })
      ElMessage({
        type: 'success',
        message: '登录成功'
      })
      router.replace('/')
    } else {
      console.log('error submit!', fields)
      return false
    }
  })
}

const handleResetPassword = () => {
  // 跳转到忘记密码页面
  router.push('/reset-psw')
}

const handleRegister = () => {
  // 跳转到注册页面
  router.push('/register')
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

.login-form {
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
