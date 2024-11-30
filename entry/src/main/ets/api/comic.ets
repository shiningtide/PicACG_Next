import axios, { AxiosResponse } from '@ohos/axios'
import { RandomUtil } from '@pura/harmony-utils'
import { HttpUtil } from '../utils/http'
import { PicaPage } from '../utils/model'
import { ComicDetailInfo, ComicEp, ComicSimpleInfo } from './models'

export interface CollectionResponse {
  collections: Collection[]
}

export interface Collection {
  title: string
  comics: ComicSimpleInfo[]
}

export interface RecommendResponse {
  comics: ComicSimpleInfo[]
}

export interface DetailResponse {
  comic: ComicDetailInfo
}

export interface Recommend {
  id: string
  pic: string
  title: string
}

/**另一个推荐接口: 其他人还在看(不需要认证)*/
export const otherRecommend = (_id: string = RandomUtil.generateUUID32().replace('-', '').substring(0, 24)) => {
  return new Promise<Recommend[]>((resolve, reject) => {
    axios.get('/pic/recommend/get/', {
      params: { c: _id }
    }).then((res: AxiosResponse<Recommend[]>) => {
      resolve(res.data)
    }).catch((err: Error) => {
      reject(err)
    })
  })
}

/**本子妹推荐*/
export const collections = (): Promise<CollectionResponse> => {
  return HttpUtil.get('/collections')
}

/**相关推荐*/
export const recommend = (_id: string): Promise<RecommendResponse> => {
  return HttpUtil.get(`/comics/${_id}/recommendation`)
}

/**漫画详细信息*/
export const detail = (_id: string): Promise<ComicDetailInfo> => {
  return HttpUtil.get(`/comics/${_id}`)
}

/**漫画目录*/
export const eps = (_id: string, page: number = 1): Promise<PicaPage<ComicEp>> => {
  return HttpUtil.get(`/comics/${_id}/eps`, { page })
}