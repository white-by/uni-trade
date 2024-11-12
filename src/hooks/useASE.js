import CryptoJS from 'crypto-js'

export default function () {
  // 密钥：16 字符（128 位）密钥，确保密钥长度为 16 字节
  const key = CryptoJS.enc.Utf8.parse('1234567890123456') // 16 字符
  // 固定的 IV
  const iv = CryptoJS.enc.Utf8.parse('1234567890123456') // 16 字符

  // 加密
  function encrypt(text) {
    return CryptoJS.AES.encrypt(text, key, { iv: iv, mode: CryptoJS.mode.CBC, padding: CryptoJS.pad.Pkcs7 }).toString()
  }

  // 解密
  function decrypt(cipherText) {
    try {
      const bytes = CryptoJS.AES.decrypt(cipherText, key, {
        iv: iv,
        mode: CryptoJS.mode.CBC,
        padding: CryptoJS.pad.Pkcs7
      })
      // 将解密结果转换为 UTF-8 字符串
      const decryptedText = bytes.toString(CryptoJS.enc.Utf8)

      // 检查解密结果是否为空
      if (!decryptedText) {
        console.error('解密失败，返回空字符串')
        return '解密失败' // 可以返回一个友好的提示
      }

      return decryptedText
    } catch (error) {
      console.error('解密过程中出现错误:', error)
      return '解密失败'
    }
  }

  return {
    encrypt,
    decrypt
  }
}
