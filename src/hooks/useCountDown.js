/**
 * 支付结算页倒计时
 */

import { computed, onUnmounted, ref } from 'vue'

export const useCountDown = () => {
  // 1. 响应式的数据
  let timer = null
  const time = ref(0)
  const isRunning = ref(false) // 是否正在倒计时
  const endCallbacks = [] // 存储倒计时结束的回调函数

  // 格式化时间为 mm分ss秒
  const formatTime = computed(() => {
    const minutes = Math.floor(time.value / 60) // 获取分钟
    const seconds = time.value % 60 // 获取秒数
    return `${String(minutes).padStart(2, '0')}分${String(seconds).padStart(2, '0')}秒`
  })

  // 2. 开启倒计时的函数
  const start = (countdownTime) => {
    if (isRunning.value) {
      console.warn('倒计时已启动，避免重复启动')
      return
    }
    isRunning.value = true
    time.value = countdownTime
    timer = setInterval(() => {
      if (time.value > 0) {
        time.value--
      } else {
        clearInterval(timer) // 倒计时结束，清除定时器
        isRunning.value = false
        triggerEndCallbacks() // 触发倒计时结束回调
      }
    }, 1000)
  }

  // 注册倒计时结束的回调函数
  const onEnd = (callback) => {
    if (typeof callback === 'function') {
      endCallbacks.push(callback)
    } else {
      console.warn('onEnd 需要传入一个函数')
    }
  }

  // 触发所有注册的结束回调
  const triggerEndCallbacks = () => {
    endCallbacks.forEach((callback) => callback())
  }

  // 组件销毁时清除定时器
  onUnmounted(() => {
    if (timer) {
      clearInterval(timer)
    }
  })

  return {
    formatTime, // 格式化后的时间
    start, // 开始倒计时
    onEnd // 注册倒计时结束回调
  }
}
