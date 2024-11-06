import httpInstance from '@/utils/https'

//没有token前这个接口写不了，先放着

export function getAddressListAPI() {
    const token = localStorage.getItem('token'); // 从 localStorage 获取 token, 目前还没有localStorage
    return httpInstance({
        url: '/member/address',
        method: 'get', 
        headers: {
            Authorization: `Bearer ${token}`  // 在请求头中附加 token
        }
    });
}