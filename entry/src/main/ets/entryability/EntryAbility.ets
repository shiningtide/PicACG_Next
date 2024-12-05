import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit'
import { hilog } from '@kit.PerformanceAnalysisKit'
import { display, window } from '@kit.ArkUI'
import { BusinessError } from '@ohos.base'
import { AppUtil, LogUtil } from '@pura/harmony-utils'
import { StorageKey } from '../common/Consts'
import { PreferenceManager } from '../utils/Preference'
import { ImageKnife } from '@ohos/imageknife'

export default class EntryAbility extends UIAbility {
  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    hilog.info(0x0000, 'PicaAbilityLog', '%{public}s', 'Ability onCreate')
    AppUtil.init(this.context)
    LogUtil.init(0x0000, 'PicaLog', true)
    await ImageKnife.getInstance().initFileCache(this.context, 256, 256 * 1024 * 1024)
  }

  onDestroy(): void {
    hilog.info(0x0000, 'PicaAbilityLog', '%{public}s', 'Ability onDestroy')
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'PicaAbilityLog', '%{public}s', 'Ability onWindowStageCreate')

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'PicaAbilityLog', 'Failed to load the content. Cause: %{public}s',
          JSON.stringify(err) ?? '')
        return
      }
      hilog.info(0x0000, 'PicaAbilityLog', 'Succeeded in loading the content.')
      // 初始化变量
      PersistentStorage.persistProp(StorageKey.TOKEN, '')
      PreferenceManager.init()
    })

    // 全屏
    windowStage.getMainWindow((err, windowClass) => {
      if (err.code) {
        hilog.error(0x0000, 'PicaAbilityLog', 'Failed to load the content. Cause: %{public}s',
          JSON.stringify(err) ?? '')
        return
      }

      //全屏
      windowClass.setWindowLayoutFullScreen(true)
        .then(() => {
          LogUtil.info('Succeeded in setting the window layout to full-screen mode.')
        })
        .catch((err: BusinessError) => {
          LogUtil.error('Failed to set the window layout to full-screen mode. Cause:' + JSON.stringify(err))
        })
      //获取上下遮挡区域
      let type = window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR //导航栏
      let avoidArea = windowClass.getWindowAvoidArea(type)
      let bottomRectHeight = avoidArea.bottomRect.height
      AppStorage.setOrCreate('bottomRectHeight', px2vp(bottomRectHeight))

      // 2. 获取导航栏避让遮挡的区域
      type = window.AvoidAreaType.TYPE_SYSTEM // 状态栏
      avoidArea = windowClass.getWindowAvoidArea(type)
      let topRectHeight = avoidArea.topRect.height
      AppStorage.setOrCreate('topRectHeight', px2vp(topRectHeight))

      //手机屏幕高度和宽度
      let defaultDisplay = display.getDefaultDisplaySync()
      let WindowHeight = defaultDisplay.height
      let WindowWidth = defaultDisplay.width

      AppStorage.setOrCreate('WindowHeight', px2vp(WindowHeight))
      AppStorage.setOrCreate('WindowWidth', px2vp(WindowWidth))

      let avoidAreaSys = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
      let navi = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR)
      let total = avoidAreaSys.topRect.height + navi.bottomRect.height
      AppStorage.setOrCreate('avoidHeight', total)
      AppStorage.setOrCreate('stateHeight', px2vp(avoidAreaSys.topRect.height))
    })
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'PicaAbilityLog', '%{public}s', 'Ability onWindowStageDestroy')
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'PicaAbilityLog', '%{public}s', 'Ability onForeground')
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'PicaAbilityLog', '%{public}s', 'Ability onBackground')
  }
}
