
import httpInstance from '@/utils/https'

/**
 * 获取公告列表
 * @param params
 * @returns
 */
export const getAnnouncementListApi = (params) => {
  return httpInstance({
    url: '/admin/announcement',
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
    url: '/admin/announcement',
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
    url: `/admin/announcement/${announcementData.announcementID}`,
    method: 'PUT',
    data: announcementData
  })
}

/**
 * 删除公告
 * @param announcementID
 * @returns
 */
export const deleteAnnouncementApi = (announcementID) => {
  return httpInstance({
    url: `/admin/announcement/${announcementID}`,
    method: 'DELETE'
  })
}
