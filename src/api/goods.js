import httpInstance from "@/utils/https";

//获取分类
export function getCategoryAPI(){
    return httpInstance({
        url: '/home/category'
    })
}

//获取每一页的商品
export function getGoodsListApi(){
    return httpInstance({
        url: '/goods'
    })
}