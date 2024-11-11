import httpInstance from '@/utils/https'

export function getAddressListAPI() {
    return httpInstance({
        url: '/member/address',
        method: 'get', 
        headers: {
            Authorization: `Bearer ${localStorage.getItem('token')}`, 
        }
    });
}