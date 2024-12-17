/**
 * 时间格式化
 * 格式：yyyy-mm-dd hh:mm:ss
 * @returns
 */

// export default function useFormatTime() {
//   function formatTime(isoString) {
//     // 创建日期对象并强制将其解析为 UTC 时间
//     const date = new Date(isoString)

//     // 手动调整时区
//     const offset = 8 * 60 // 的时区偏移（单位为分钟）
//     const localTime = new Date(date.getTime() - offset * 60 * 1000)

//     // 使用 `Intl.DateTimeFormat` 格式化为 yyyy-MM-dd HH:mm:ss 格式
//     const formatter = new Intl.DateTimeFormat('zh-CN', {
//       year: 'numeric',
//       month: '2-digit',
//       day: '2-digit',
//       hour: '2-digit',
//       minute: '2-digit',
//       second: '2-digit',
//       hour12: false // 24小时制
//     })

//     // 格式化并替换斜杠为短横线
//     const formattedDate = formatter.format(localTime)
//     return formattedDate.replace(/\//g, '-') // 将 / 替换为 -，符合你的需求
//   }

//   return { formatTime }
// }

export default function useFormatTime() {
  function formatTime(isoString) {
    // 创建日期对象，并强制将其解析
    const date = new Date(isoString)

    // 不用将时间转换为中国标准时间
    date.setHours(date.getHours() + 8)

    // 格式化为 yyyy-MM-dd HH:mm:ss 格式
    const formattedDate = date.toISOString().replace('T', ' ').slice(0, 19)

    return formattedDate
  }

  return { formatTime }
}
