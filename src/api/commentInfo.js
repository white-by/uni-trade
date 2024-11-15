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
 * 删除评论
 * @param commentData
 * @returns
 */
export const deleteCommentApi = (commentID) => {
  return httpInstance({
    url: `/admin/comment/${commentID}`,
    method: 'DELETE'
  })
}
