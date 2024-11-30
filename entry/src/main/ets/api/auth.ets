import { HttpUtil } from '../utils/http'

interface LoginRequest {
  email: string
  password: string
}

interface LoginResponse {
  token: string
}

export const UserLogin = (data: LoginRequest): Promise<LoginResponse> => {
  return HttpUtil.post('/auth/sign-in', data)
}