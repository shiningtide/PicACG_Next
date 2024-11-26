export interface PicaResponse<T = ESObject> {
  code: number
  message: string
  error?: string
  detail?: string
  data?: T
}

export const TOKEN_KEY = 'authorization'

export type RequestMethod = 'GET' | 'POST'

export const Ok = 200

export const Unauthorized = 401