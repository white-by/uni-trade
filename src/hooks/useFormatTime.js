/**
 * 时间格式化
 * 格式：yyyy-mm-dd hh:mm:ss
 * @returns
 */

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
