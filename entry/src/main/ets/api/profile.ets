import { HttpUtil } from '../utils/Http'
import { PicaPage } from '../common/Model'
import { Comment, PunchIn, SortType, User } from './models'
import { ComicResponse } from './comic'

export interface ProfileResponse {
  user: User
}

export interface CommentResponse {
  comments: PicaPage<Comment>
  topComments: Comment[] // 格式存疑待验证
}

export interface FavouriteActionResponse {
  action: 'favourite' | 'un_favourite'
}

export interface PunchInResponse {
  res: PunchIn
}

/**个人信息*/
export const profile = (): Promise<ProfileResponse> => {
  return HttpUtil.get('/users/profile')
}

/**我的最爱*/
export const favourite = (page: number = 1, s: SortType = SortType.Newest): Promise<ComicResponse> => {
  return HttpUtil.get('/users/favourite', { page, s })
}

/**收藏操作，未收藏漫画调用后进入收藏，已收藏漫画调用后删除收藏*/
export const favouriteAction = (id: string): Promise<FavouriteActionResponse> => {
  return HttpUtil.post(`/comics/${id}/favourite`)
}

/**我的评论*/
export const myComments = (page: number = 1): Promise<CommentResponse> => {
  return HttpUtil.get('/users/my-comments', { page })
}

export const punchIn = (): Promise<PunchInResponse> => {
  return HttpUtil.post('/users/punch-in')
}