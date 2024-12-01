import { HttpUtil } from '../utils/http'
import { PicaPage } from '../utils/model'
import { ComicSimpleInfo, Comment, User } from './models'

export interface ProfileResponse {
  user: User
}

export interface FavouriteResponse {
  comics: PicaPage<ComicSimpleInfo>
}

export interface CommentResponse {
  comments: PicaPage<Comment>
}

/**个人信息*/
export const profile = (): Promise<ProfileResponse> => {
  return HttpUtil.get('/users/profile')
}

/**我的最爱*/
export const favourite = (page: number = 1): Promise<FavouriteResponse> => {
  return HttpUtil.get('/users/favourite', { page })
}

/**我的评论*/
export const comments = (page: number = 1): Promise<CommentResponse> => {
  return HttpUtil.get('/users/my-comments', { page })
}