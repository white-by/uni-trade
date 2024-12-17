<!-- 支付页 -->

<script setup>
import UserNav from '@/components/UserNav.vue'
import UserFooter from '@/components/UserFooter.vue'
import { getOrderApi } from '@/api/pay'
import { onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { config } from '@/config/config'
import { useCountDown } from '@/hooks/useCountDown'
import { ElMessage } from 'element-plus'
const { formatTime, start, onEnd } = useCountDown()

const route = useRoute()
const router = useRouter()

const payInfo = ref({})
const cost = ref(0)
const getPayInfo = async () => {
  const res = await getOrderApi(route.query.id)
  if (res.data.data.countdown === -1) {
    ElMessage.error({
      message: '订单超时！',
      duration: 1500 // 显示时间为 1.5 秒
    })
    setTimeout(() => {
      router.push(`/detail/${res.data.data.goodsID}`)
    }, 1500) // 延迟 1.5 秒跳转
    return
  }
  payInfo.value = res.data.data
  console.log('payInfo:', payInfo.value)
  cost.value = payInfo.value.price + payInfo.value.shippingCost
  // 初始化倒计时秒数
  start(res.data.data.countdown)
}

onMounted(
  () => getPayInfo(),
  // 倒计时结束处理
  onEnd(() => {
    ElMessage.error({
      message: '订单超时！',
      duration: 1500
    })
    setTimeout(() => {
      router.push(`/detail/${payInfo.value.goodsID || ''}`)
    }, 1500)
  })
)

// 跳转支付
// 携带订单id以及回调地址跳转到支付地址（get）
// 支付地址
const baseURL = config.baseURL
const backURL = 'http://localhost:5173/paycallback'
const redirectUrl = encodeURIComponent(backURL)
const payUrl = `${baseURL}/pay/aliPay?orderId=${route.query.id}&redirect=${redirectUrl}`
</script>

<template>
  <UserNav />

  <div class="pay-page">
    <div class="container">
      <!-- 付款信息 -->
      <div class="pay-info">
        <span class="icon iconfont icon-queren2"></span>
        <div class="tip">
          <p>订单提交成功！请尽快完成支付。</p>
          <p>
            支付还剩 <span>{{ formatTime }}</span>
          </p>
          <p>支付完成前请不要离开, 否则将视作放弃</p>
        </div>
        <div class="amount">
          <span>应付总额：</span>
          <span>¥{{ cost?.toFixed(2) }}</span>
        </div>
      </div>
      <!-- 付款方式 -->
      <div class="pay-type">
        <p class="head">请选择支付方式</p>
        <div class="item">
          <p>支付平台</p>
          <a class="btn alipay" :href="payUrl"></a>
        </div>
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

.pay-info {
  background: #fff;
  display: flex;
  align-items: center;
  height: 240px;
  padding: 0 80px;
  border-radius: 3px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);

  .icon {
    font-size: 80px;
    color: #1dc779;
  }

  .tip {
    padding-left: 10px;
    flex: 1;

    p {
      &:first-child {
        font-size: 20px;
        margin-bottom: 5px;
      }
      &:nth-child(2),
      &:nth-child(3) {
        color: #999;
        font-size: 16px;
      }
    }
  }

  .amount {
    margin-right: 20px;
    span {
      &:first-child {
        font-size: 16px;
        color: #999;
      }

      &:last-child {
        color: $priceColor;
        font-size: 20px;
      }
    }
  }
}

.pay-type {
  margin-top: 40px;
  background-color: #fff;
  padding-bottom: 70px;
  border-radius: 3px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);

  p {
    line-height: 70px;
    height: 70px;
    padding-left: 30px;
    font-size: 16px;
    padding-left: 60px;

    &.head {
      border-bottom: 1px solid #f5f5f5;
    }
  }

  .btn {
    width: 150px;
    height: 50px;
    border: 1px solid #e4e4e4;
    text-align: center;
    line-height: 48px;
    margin-left: 30px;
    color: #666666;
    display: inline-block;
    margin-left: 60px;

    &.active,
    &:hover {
      border-color: $comColor;
    }

    &.alipay {
      background: url('@/assets/images/alipay.png') no-repeat center / contain;
    }
  }
}
</style>
