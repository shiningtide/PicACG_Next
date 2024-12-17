import axios, { AxiosResponse } from '@ohos/axios'
import { MD5, RandomUtil } from '@pura/harmony-utils'
import { HttpUtil } from '../utils/Http'
import { PicaPage } from '../common/Model'
import { Category, Chapter, ComicDetailInfo, ComicEp, ComicSimpleInfo, SortType } from './models'
import { ComicActionResponse, CommentResponse } from './profile'

export interface CollectionResponse {
  collections: Collection[]
}

export interface Collection {
  title: string
  comics: ComicSimpleInfo[]
}

export interface RecommendResponse {
  comics: ComicDetailInfo[]
}

export interface DetailResponse {
  comic: ComicDetailInfo
}

export interface Recommend {
  id: string
  pic: string
  title: string
}

export interface CategoryResponse {
  categories: Category[]
}

export interface ComicResponse {
  comics: PicaPage<ComicDetailInfo>
}

export interface EpsResponse {
  eps: PicaPage<ComicEp>
}

export interface RandomResponse {
  comics: ComicDetailInfo[]
}

export interface KeywordResponse {
  keywords: string[]
}

export interface ChapterResponse {
  ep: ComicEp,
  pages: PicaPage<Chapter>
}

/**另一个推荐接口: 其他人还在看(不需要认证)*/
export const otherRecommend = (_id?: string) => {
  if (!_id) {
    _id = MD5.digestSync(RandomUtil.getRandomNumber(Number.MIN_VALUE, Number.MAX_VALUE).toString()).substring(0, 24)
  }
  return new Promise<Recommend[]>((resolve, reject) => {
    axios.get('https://recommend.go2778.com/pic/recommend/get/?c=' + _id)
      .then((res: AxiosResponse<Recommend[]>) => {
        resolve(res.data)
      })
      .catch((err: Error) => {
        reject(err)
      })
  })
}

/**本子妹推荐*/
export const collections = (): Promise<CollectionResponse> => {
  return HttpUtil.get('/collections')
}

/**相关推荐*/
export const recommendation = (comicId: string): Promise<RecommendResponse> => {
  return HttpUtil.get(`/comics/${comicId}/recommendation`)
}

/**漫画详细信息*/
export const detail = (comicId?: string): Promise<DetailResponse> => {
  return HttpUtil.get(`/comics/${comicId}`)
}

/**漫画目录*/
export const eps = (comicId: string, page: number = 1): Promise<EpsResponse> => {
  return HttpUtil.get(`/comics/${comicId}/eps`, { page })
}

/**分类*/
export const categories = (): Promise<CategoryResponse> => {
  return HttpUtil.get('categories')
}

/**
 * 漫画分页列表（c和ca二选一，同时传入以c为优先）
 * @param page 页码
 * @param s 排序
 * @param c 分类名称
 * @param ca 上传者id
 * */
export const comics =
  (page: number = 1, s: SortType = SortType.Newest, c?: string, ca?: string): Promise<ComicResponse> => {
    if (c) {
      return HttpUtil.get('/comics', {
        page,
        s,
        c,
      })
    } else if (ca) {
      return HttpUtil.get('/comics', {
        page,
        s,
        ca
      })
    } else {
      return HttpUtil.get('/comics', {
        page,
        s,
      })
    }
  }

/**关键字查询分页列表*/
export const search = (page: number = 1, s: SortType = SortType.Newest, keyword?: string, categories?: string[]):
  Promise<ComicResponse> => {
  return HttpUtil.request('POST', '/comics/advanced-search', {
    params: { page, s },
    data: {
      categories,
      keyword,
      sort: s
    }
  })
}

/**随机本子*/
export const random = (): Promise<RandomResponse> => {
  return HttpUtil.get('/comics/random')
}

/**大家都在搜*/
export const keywords = (): Promise<KeywordResponse> => {
  return HttpUtil.get('/keywords')
}

/**漫画评论*/
export const comments = (page: number = 1, comicId: string): Promise<CommentResponse> => {
  return HttpUtil.get(`/comics/${comicId}/comments`, { page })
}

/**评论点赞*/
export const commentLike = (commentId: string): Promise<ComicActionResponse> => {
  return HttpUtil.post(`/comments/${commentId}/like`)
}

/**漫画楼中楼*/
export const commentsChildren = (page: number = 1, commentId: string): Promise<CommentResponse> => {
  return HttpUtil.get(`/comments/${commentId}/childrens`, { page })
}

/**漫画章节内容*/
export const chapter = (comicId: string, order: number = 1, page: number = 1): Promise<ChapterResponse> => {
  return HttpUtil.get(`/comics/${comicId}/order/${order}/pages`, { page })
}
