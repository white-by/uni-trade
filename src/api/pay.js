import httpInstance from "@/utils/https";

export const createOrderAPI = (Data) => {
  return httpInstance({
    url: '/createorder',
    method: 'POST',
    data: Data
  })
}