import { http } from '../utils/http'

interface LoginRequest {
  email: string
  password: string
}

interface LoginResponse {
  token: string
}

export const UserLogin = (data: LoginRequest): Promise<LoginResponse> => {
  return http.post('/auth/sign-in', data)
}