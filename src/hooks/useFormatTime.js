/**
 * 时间格式化
 * 格式：yyyy-mm-dd hh:mm:ss
 * @returns
 */

export default function useFormatTime() {
  function formatTime(isoString) {
    if (!isoString) return ''

    try {
      const date = new Date(isoString)

      // 检查日期是否有效
      if (isNaN(date.getTime())) {
        return ''
      }

      // 直接格式化，不调整时区（因为数据已经包含时区信息）
      return date.toISOString().replace('T', ' ').slice(0, 19)
    } catch (error) {
      console.error('格式化时间出错:', error)
      return ''
    }
  }

  return { formatTime }
}
