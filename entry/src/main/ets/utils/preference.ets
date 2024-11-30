import { Api, AppChannel, ImageQuality } from './config';
import { HttpUtil } from './http';

export interface PreferenceItem {
  name: string
  value: string,
  key: string
}

export class PreferenceStorageKey {
  static readonly APP_CHANNEL: string = 'channel'
  static readonly Api: string = 'api'
  static readonly IMAGE_QUALITY: string = 'quality'
  static readonly PRIVACY_MODE: string = 'privacy'
}

export class PreferenceManager {
  static readonly ApiItem: PreferenceItem[] = [
    { name: '官方线路', value: Api.Origin, key: 'Origin' },
    { name: '代理线路', value: Api.Proxy, key: 'Proxy' },
  ]
  static readonly ImageQualityItem: PreferenceItem[] = [
    { name: '原画质', value: ImageQuality.Original, key: 'Original' },
    { name: '高画质', value: ImageQuality.High, key: 'High' },
    { name: '中画质', value: ImageQuality.Medium, key: 'Medium' },
    { name: '低画质', value: ImageQuality.Low, key: 'Low' },
  ]
  static readonly ChannelItem: PreferenceItem[] = [
    { name: '线路一', value: AppChannel.One, key: 'One' },
    { name: '线路二', value: AppChannel.Two, key: 'Two' },
    { name: '线路三', value: AppChannel.Three, key: 'Three' },
  ]

  static init() {
    // Api地址
    PersistentStorage.persistProp<Api>(PreferenceStorageKey.Api, Api.Origin);
    HttpUtil.init();
    // 画质
    PersistentStorage.persistProp<ImageQuality>(PreferenceStorageKey.IMAGE_QUALITY, ImageQuality.Original)
    // 分流
    PersistentStorage.persistProp<AppChannel>(PreferenceStorageKey.APP_CHANNEL, AppChannel.One)
    // 隐私模式
    PersistentStorage.persistProp<boolean>(PreferenceStorageKey.PRIVACY_MODE, false)
  }

  static setApi(api: Api) {
    AppStorage.setOrCreate<Api>(PreferenceStorageKey.Api, api)
    HttpUtil.init();
  }

  static setQuality(quality: ImageQuality) {
    AppStorage.setOrCreate<ImageQuality>(PreferenceStorageKey.IMAGE_QUALITY, quality)
  }

  static setChannel(channel: AppChannel) {
    AppStorage.setOrCreate<AppChannel>(PreferenceStorageKey.APP_CHANNEL, channel)
  }

  static setPrivacyMode(mode: boolean) {
    AppStorage.setOrCreate<boolean>(PreferenceStorageKey.PRIVACY_MODE, mode)
  }
}