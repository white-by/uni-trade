<script setup>
import UserNav from '@/components/UserNav.vue'
import UserFooter from '@/components/UserFooter.vue'
import { useRouter } from 'vue-router'

const router = useRouter()

const toHome = () => {
  router.replace('/')
}
</script>

<template>
  <UserNav />
  <div class="pay-page">
    <div class="container">
      <!-- 支付结果 -->
      <div class="pay-result">
        <span class="iconfont icon-chenggong green"></span>
        <span class="iconfont icon-jingshi red"></span>
        <p class="tit">支付成功</p>
        <p class="tip">感谢您的支持，若有任何问题请随时联系我们！</p>
        <p>支付方式：<span>支付宝</span></p>
        <p>支付金额：<span>¥200.00</span></p>
        <div class="btn">
          <el-button type="primary" style="margin-right: 20px">查看订单</el-button>
          <el-button @click="toHome">进入首页</el-button>
        </div>
        <p class="alert">
          <span class="iconfont icon-tip"></span>
          温馨提示：我们不会以订单异常、系统升级为由要求您点击任何网址链接进行退款操作，保护资产、谨慎操作。
        </p>
      </div>
    </div>
  </div>
  <UserFooter />
</template>

<style scoped lang="scss">
.pay-page {
  margin-top: 40px;
  margin-bottom: 80px;
}

.pay-result {
  padding: 100px 0;
  background: #fff;
  text-align: center;
  margin-top: 20px;
  border-radius: 3px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);

  > .iconfont {
    font-size: 100px;
  }

  .green {
    color: #1dc779;
  }

  .red {
    color: #ff5e41;
  }

  .tit {
    font-size: 24px;
  }

  .tip {
    color: #999;
  }

  p {
    line-height: 40px;
    font-size: 16px;
  }

  .btn {
    margin-top: 50px;
  }

  .alert {
    font-size: 12px;
    color: #999;
    margin-top: 50px;
  }
}
</style>
