import { LogUtil } from '@pura/harmony-utils';
import { profile } from '../api/profile';
import { StorageKey, Unauthorized } from '../utils/consts';
import router from '@ohos.router';
import { NavItem } from '../utils/types';

@Entry
@Component
struct Index {
  @StorageProp('topRectHeight') topRectHeight: number = 0
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0
  @StorageProp('WindowHeight') WindowHeight: number = 0
  @StorageProp('WindowWidth') WindowWidth: number = 0
  @StorageProp(StorageKey.TOKEN) token: string = ''
  @State currentTabIndex: number = 0
  pageStack: NavPathStack = new NavPathStack()
  nav: NavItem[] = [
    new NavItem(0, $r("app.media.ic_public_home"), $r('app.media.ic_public_home_filled'), '首页'),
    new NavItem(1, $r('app.media.ic_public_category'), $r('app.media.ic_public_category_filled'), '分类'),
    new NavItem(2, $r('app.media.ic_public_user'), $r('app.media.ic_public_user_filled'), '我的')
  ]

  aboutToAppear(): void {
    // 判断当前是否登陆，token是否可用，否则跳转登陆页
    if (this.token) {
      profile().then(() => {
        LogUtil.info('token: 正常');
      }).catch((err: Error) => {
        if (`${Unauthorized}` === err.message) {
          LogUtil.error('token: 401 Unauthorized');
        } else {
          LogUtil.error(`其他错误: ${err.message}`);
          LogUtil.error(err.stack);
        }
        router.replaceUrl({ url: 'pages/Login' })
        // this.pageStack.replacePathByName('pages/Login', null)
      })
    } else {
      LogUtil.error('token: 不存在');
      router.replaceUrl({ url: 'pages/Login' })
      // this.pageStack.replacePathByName('pages/Login', null)
    }
  }

  build() {
    Navigation(this.pageStack) {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor(Color.Pink)
    }
    .backButtonIcon($r('app.media.ic_public_arrow_left'))
    .margin({ bottom: this.bottomRectHeight })
    .toolbarConfiguration(this.tab(), { backgroundBlurStyle: BlurStyle.Thin })
  }

  @Builder
  tab() {
    Row() {
      ForEach(this.nav, (item: NavItem) => {
        Button({ type: ButtonType.Normal, buttonStyle: ButtonStyleMode.TEXTUAL }) {
          Column() {
            Image(this.currentTabIndex === item.index ? item.selectedImg : item.unselectedImg)
              .width(24)
              .height(24)
              .fillColor(this.currentTabIndex === item.index ? $r('app.color.common_button_background_light') :
              Color.Gray)

            Text(item.title)
              .fontSize(10)
              .fontColor(this.currentTabIndex === item.index ? $r('app.color.common_button_background_light') :
              Color.Gray)
          }
        }
        .width('33%')
        .borderRadius(5)
        .stateEffect(false)
        .clickEffect({ level: ClickEffectLevel.LIGHT, scale: 0.75 })
        .onClick(() => {
          this.currentTabIndex = item.index
        })
      })
    }
    .padding({
      left: 10,
      right: 10,
    })
  }
}