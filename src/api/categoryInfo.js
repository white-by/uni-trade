import httpInstance from '@/utils/https'

/**
 * 获取分类列表
 * @param params
 * @returns
 */
export const getCategoryListApi = (params) => {
  return httpInstance({
    url: '/admin/category',
    params
  })
}

/**
 * 新增分类
 * @param categoryData
 * @returns
 */
export const addCategoryApi = (categoryData) => {
  return httpInstance({
    url: '/admin/category',
    method: 'POST',
    data: categoryData
  })
}

/**
 * 编辑分类
 * @param categoryData
 * @returns
 */
export const editCategoryApi = (categoryData) => {
  return httpInstance({
    url: `/admin/category/${categoryData.categoryID}`,
    method: 'PUT',
    data: categoryData
  })
}

/**
 * 删除分类
 * @param categoryData
 * @returns
 */
export const deleteCategoryApi = (categoryID) => {
  return httpInstance({
    url: `/admin/category/${categoryID}`,
    method: 'DELETE'
  })
}
