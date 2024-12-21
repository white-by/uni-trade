/**
 * 节流
 */

import { ref } from 'vue'

// 节流时间间隔
const delay = 1000

export default function useThrottle() {
  // 上一次调用的时间
  const lastCallTime = ref(0)

  // 节流函数
  function throttled(fn) {
    return (...args) => {
      const now = Date.now()
      if (now - lastCallTime.value >= delay) {
        lastCallTime.value = now
        fn(...args)
      }
    }
  }

  return { throttled }
}
