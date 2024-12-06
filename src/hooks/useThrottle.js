// hooks/useThrottle.js
import { ref } from 'vue'

const delay = 1000

export default function useThrottle() {
  const lastCallTime = ref(0)

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
