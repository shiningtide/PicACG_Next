type RequestMethod = 'GET' | 'POST'

class StorageKey {
  static readonly TOKEN: string = 'authorization'
  static readonly HISTORY: string = 'history'
  static readonly CATEGORY: string = 'category'
  static readonly KEYWORDS: string = 'keywords'
}

const Ok = 200
const BadRequest = 400
const Unauthorized = 401
const Timeout = 'timeout'

export {
  RequestMethod, StorageKey, Ok, BadRequest, Unauthorized, Timeout
}