import { DialogUtil, LogUtil } from '@pura/harmony-utils'
import { Api, ImageApi, ImageQuality } from '../common/Config'
import { StorageKey } from '../common/Consts'
import { PreferenceItem, PreferenceManager, PreferenceStorageKey } from '../utils/Preference'
import { BackType, TitleBar, TitleType } from './component/TitleBar'
import { router } from '@kit.ArkUI'
import { DialogAction } from '@pura/harmony-utils/src/main/ets/entity/constraint'

@Entry
@Component
struct Settings {
  @StorageProp('topRectHeight') topRectHeight: number = 0
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0
  @StorageLink(PreferenceStorageKey.API) api: Api = Api.Origin
  @StorageLink(PreferenceStorageKey.IMAGE_API) imageApi: ImageApi = ImageApi.TriageOne
  @StorageLink(PreferenceStorageKey.IMAGE_QUALITY) imageQuality: ImageQuality = ImageQuality.Original
  @StorageLink(PreferenceStorageKey.PRIVACY_MODE) privacyMode: boolean = false
  @StorageProp(StorageKey.TOKEN) token: string = ''
  @State showSetting: boolean = false
  @State showSettingType: 'Api' | 'Image' = 'Api'
  @State latency: number[] = []

  openApiChannelChange() {
    LogUtil.info('切换接口线路')
    this.showSettingType = 'Api'
    this.showSetting = true
  }

  openImageChannelChange() {
    LogUtil.info('切换图片线路')
    this.showSettingType = 'Image'
    this.showSetting = true
  }

  logout() {
    DialogUtil.showConfirmDialog({
      title: '提示',
      message: '连接超时！',
      confirm: '确定',
      onAction: (action: number) => {
        if (action === DialogAction.TWO) {
          router.replaceUrl({ url: 'pages/Login' })
            .then(() => {
              AppStorage.setOrCreate<string>(StorageKey.TOKEN, '')
            })
        }
      }
    })
  }

  build() {
    Column() {
      TitleBar({
        titleBarColor: Color.White,
        statusBarColor: Color.White,
        centerType: TitleType.TEXT,
        centerText: "设置",
        centerTextColor: $r('app.color.common_button_background_light'),
        leftBackType: BackType.ROUTER,
        leftBackFillColor: $r('app.color.common_button_background_light'),
      })

      Column() {
        Row() {
          Text('接口线路')
            .padding({ left: 10 })
            .width('90%')

          Image($r('app.media.ic_public_arrow_right'))
            .width(20)
            .height(20)
            .fillColor($r('app.color.common_button_background_light'))
            .align(Alignment.End)
        }
        .width('90%')
        .height(50)
        .backgroundColor(Color.White)
        .onClick(() => {
          this.openApiChannelChange()
        })

        Divider().width('90%')

        Row() {
          Text('图源线路')
            .padding({ left: 10 })
            .width('90%')

          Image($r('app.media.ic_public_arrow_right'))
            .width(20)
            .height(20)
            .fillColor($r('app.color.common_button_background_light'))
            .align(Alignment.End)
        }
        .width('90%')
        .height(50)
        .backgroundColor(Color.White)
        .onClick(() => {
          this.openImageChannelChange()
        })
      }
      .margin({ top: 15 })
      .borderRadius(10)

      Column() {
        Row() {
          Text('隐私模式')
            .padding({ left: 10 })
            .width('87%')

          Toggle({ type: ToggleType.Switch, isOn: this.privacyMode })
            .selectedColor($r('app.color.common_button_background_light'))
            .onChange((isOn: boolean) => {
              this.privacyMode = isOn
            })
        }
        .width('90%')
        .height(50)
        .backgroundColor(Color.White)
        .onClick(() => {
          this.openApiChannelChange()
        })
      }
      .margin({ top: 15 })
      .borderRadius(10)

      if (this.token) {
        Column() {
          Row() {
            Text('退出登陆')
              .padding({ left: 10 })
              .width('90%')

            Image($r('app.media.ic_public_arrow_right'))
              .width(20)
              .height(20)
              .fillColor($r('app.color.common_button_background_light'))
              .align(Alignment.End)
          }
          .width('90%')
          .height(50)
          .backgroundColor(Color.White)
          .onClick(() => {
            this.logout()
          })

          Divider().width('90%')
        }
        .margin({ top: 15 })
        .borderRadius(10)
      }

      Flex()
        .width(0)
        .height(0)
        .borderRadius({ topRight: 30, bottomRight: 30 })
        .bindSheet(this.showSetting, this.settings(), {
          title: {
            title: '设置',
            subtitle: this.showSettingType === 'Api' ? '接口线路' : '图源线路'
          },
          height: SheetSize.FIT_CONTENT,
          showClose: false,
          dragBar: false,
          blurStyle: BlurStyle.COMPONENT_ULTRA_THIN,
          onDisappear: () => {
            this.showSetting = false
          },
        })
    }
    .width('100%')
    .height('100%')
    .layoutWeight(1)
    .backgroundColor('#fafbfd')
  }

  @Builder
  settings() {
    if (this.showSettingType === 'Api') {
      this.ChannelSetting(PreferenceManager.ApiItem, this.api, Api, PreferenceManager.setApi)
    } else if (this.showSettingType = 'Image') {
      this.ChannelSetting(PreferenceManager.ImageApiItem, this.imageApi, ImageApi, PreferenceManager.setImageApi)
    }
  }

  @Builder
  ChannelSetting(channels: PreferenceItem[], currentVal: string, apiEnum: ESObject, set: (v: ESObject) => void) {
    Column() {
      ForEach(channels, (item: PreferenceItem, index: number) => {
        Row() {
          Radio({ value: item.value, group: 'api' })
            .checked(item.value === currentVal)
            .onChange((isChecked: boolean) => {
              if (isChecked) {
                set(apiEnum[item.key])
              }
            })

          Text(item.name)
            .onClick(() => {
              set(apiEnum[item.key])
            })
        }
        .width('100%')
        .height(38)
      }, (item: PreferenceItem, index: number) => {
        this.latency[index] = -1;
        return item.name
      })
    }
    .width('100%')
    .padding({ left: 20, right: 20, bottom: this.bottomRectHeight })
  }
}