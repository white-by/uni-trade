
import httpInstance from '@/utils/https'

/**
 * 获取公告列表
 * @param params
 * @returns
 */
export const getAnnouncementListApi = (params) => {
  return httpInstance({
    url: '/announcement',
    params
  })
}

/**
 * 新增公告
 * @param announcementData
 * @returns
 */
export const addAnnouncementApi = (announcementData) => {
  return httpInstance({
    url: '/announcement',
    method: 'POST',
    data: announcementData
  })
}
/**
 * 编辑公告
 * @param announcementData
 * @returns
 */
export const editAnnouncementApi = (announcementData) => {
  return httpInstance({
    url: `/announcement/${announcementData.announcementID}`,
    method: 'PUT',
    data: announcementData
  })
}

/**
 * 编辑公告
 * @param commentData
 * @returns
 */
export const deleteAnnouncementApi = (announcementID) => {
  return httpInstance({
    url: `/announcement/${announcementID}`,
    method: 'DELETE'
  })
}
