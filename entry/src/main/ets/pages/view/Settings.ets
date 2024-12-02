import { Api, ImageApi, ImageQuality } from '../../utils/config'
import { PreferenceStorageKey } from '../../utils/preference'

@Builder
export function SettingsBuilder(name: string, param: Object) {
  Settings()
}

@Component
export default struct Settings {
  @StorageProp('topRectHeight') topRectHeight: number = 0
  @StorageProp(PreferenceStorageKey.API) api: Api = Api.Origin
  @StorageProp(PreferenceStorageKey.IMAGE_API) imageApi: ImageApi = ImageApi.TriageOne
  @StorageProp(PreferenceStorageKey.IMAGE_QUALITY) imageQuality: ImageQuality = ImageQuality.Original
  @StorageProp(PreferenceStorageKey.PRIVACY_MODE) privacyMode: boolean = false
  @Consume('pageStack') pageStack: NavPathStack

  build() {
    NavDestination() {
      Column() {
        Text('设置')
          .width('100%')
          .height('100%')
      }
      .width('100%')
      .height('100%')
      .padding({ top: this.topRectHeight })
      .backgroundColor(Color.Brown)
    }
    .mode(NavDestinationMode.STANDARD)
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.pageStack = context.pathStack
    })
  }
}