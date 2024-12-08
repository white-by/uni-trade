import httpInstance from "@/utils/https";

export const createOrderAPI = (Data) => {
  return httpInstance({
    url: '/createOrder',
    method: 'POST',
    data: Data
  })
}