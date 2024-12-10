
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

const FilterTags: string[] = ['偽娘', '耽美', '扶他', 'WEBTOON', '純愛', '重口', '生肉']

const GetColorByTag = (tag: string): ResourceColor => {
  if (tag === '偽娘' || tag === '耽美' || tag === '扶他') {
    return '#5AC6FF';
  } else if (tag === 'WEBTOON') {
    return '#FA6600';
  } else if (tag === '純愛') {
    return '#FF5F69';
  } else if (tag === '重口') {
    return '#A77EEF';
  } else if (tag === '生肉') {
    return '#ABF597';
  }
  return ''
}

export {
  RequestMethod, StorageKey, Ok, BadRequest, Unauthorized, Timeout, FilterTags, GetColorByTag
}