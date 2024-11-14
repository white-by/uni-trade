import httpInstance from '@/utils/https'

/**
 * 获取评论列表
 * @param params
 * @returns
 */
export const getCommentListApi = (params) => {
  return httpInstance({
    url: '/admin/comment',
    params
  })
}

/**
 * 新增评论
 * @param commentData
 * @returns
 */
export const addCommentApi = (commentData) => {
  return httpInstance({
    url: '/admin/comment',
    method: 'POST',
    data: commentData
  })
}
/**
 * 编辑评论
 * @param commentData
 * @returns
 */
export const editCommentApi = (commentData) => {
  return httpInstance({
    url: `/admin/comment/${commentData.commentID}`,
    method: 'PUT',
    data: commentData
  })
}

/**
 * 编辑评论
 * @param commentData
 * @returns
 */
export const deleteCommentApi = (commentID) => {
  return httpInstance({
    url: `/admin/comment/${commentID}`,
    method: 'DELETE'
  })
}
