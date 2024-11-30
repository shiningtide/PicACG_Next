const BaseUrl = 'http://68.183.234.72/'
const Url = 'https://picaapi.picacomic.com/'
const NewChatUrl = 'https://live-server.bidobido.xyz/'
const SecretKey = '~d}$Q7$eIni=V)9\\RK/P.RM4;9[7|@/CA}b~OW!3?EV`:<>M7pddUBL5n|0/*Cn'
const ApiKey = 'C69BAF41DA5ABD1FFEDC6D2FEA56B'
const AppNonce = '1b509109-476d-3790-a5f0-0acfeace9a5b'
const AppUuid = 'defaultUuid'
const AppVersion = '2.2.1.3.3.4'
const BuildVersion = '45'
const Accept = 'application/vnd.picacomic.com.v1+json'
const Agent = 'okhttp/3.8.1'
const Platform = 'android'
// type ImageQuality = 'original' | 'low' | 'medium' | 'high'
enum ImageQuality {
  Original = '原图,original',
  high = '高画质,high',
  medium = '中画质,medium',
  low = '低画质,low',
}

// type AppChannel = '1' | '2' | '3'
enum AppChannel {
  One,
  Two,
  Three
}

export {
  BaseUrl,
  Url,
  NewChatUrl,
  SecretKey,
  ApiKey,
  AppChannel,
  AppNonce,
  AppUuid,
  AppVersion,
  BuildVersion,
  Accept,
  Agent,
  Platform,
  ImageQuality,
}