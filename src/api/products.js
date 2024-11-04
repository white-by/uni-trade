import httpInstance from "@/utils/https";

/**
 * 获取分类
 * @returns 
 */
export function getCategoryAPI(){
    return httpInstance({
        url: '/home/category'
    })
}

/**
 * 获取商品列表
 * @param {商品的分类号码} category 
 * @param {当前页数} page 
 * @param {每页最大商品数 默认为12} limit 
 * @returns 
 */
export function getProductsListAPI(category, page, limit){
    return httpInstance({
        url: '/products',
        params: {
            category,
            page,
            limit
        }
    })
}

//根据筛选条件筛选商品
export function getFilteredProductsAPI({
    category = 0,
    area = "",
    city = "",
    deliveryMethod = "",
    priceMax = 0,
    priceMin = 0,
    province = "",
    publishDate = [],
    shippingCost = 0,
    page = 1,
    limit = 12
} = {}) {
    return httpInstance({
        url: '/products',
        params: {
            category: category || undefined,
            area: area || undefined, 
            city: city || undefined,
            deliveryMethod: deliveryMethod || undefined,
            priceMax: priceMax > 0 ? priceMax : undefined, // 仅在大于0时发送
            priceMin: priceMin > 0 ? priceMin : undefined,
            province: province || undefined,
            publishDate: publishDate || undefined,
            shippingCost: shippingCost > 0 ? priceMax : undefined,
            page,
            limit
        }
    });
}