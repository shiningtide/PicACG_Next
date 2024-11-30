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
  @State animationDuration: number = 400
  pageStack: NavPathStack = new NavPathStack()
  tabController: TabsController = new TabsController()
  nav: NavItem[] = [
    new NavItem(0, $r("app.media.ic_public_home"), $r('app.media.ic_public_home_filled'), '首页'),
    new NavItem(1, $r('app.media.ic_public_category'), $r('app.media.ic_public_category_filled'), '分类'),
    new NavItem(2, $r('app.media.ic_public_user'), $r('app.media.ic_public_user_filled'), '我的')
  ]

  aboutToAppear(): void {
    // 判断当前是否登陆，token是否可用，否则跳转登陆页
    if (this.token) {
      profile().then(res => {
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
      Column() {
        Tabs({
          index: this.currentTabIndex,
          barPosition: BarPosition.End,
          controller: this.tabController
        }) {
          ForEach(this.nav, (item: NavItem) => {
            TabContent() {
              Column() {
                if (item.index === 0) {
                  Text(item.title).width('100%').height('100%').backgroundColor('#00CB87')
                } else if (item.index === 1) {
                  Text(item.title).width('100%').height('100%').backgroundColor('#007DFF')
                } else if (item.index === 2) {
                  Text(item.title).width('100%').height('100%').backgroundColor('#FFBF00')
                }
              }
            }
            .tabBar(
              this.TabBuilder(item.index, item.title, item.selectImg, item.unselected)
            )
          })
        }
        .vertical(false)
        .barMode(BarMode.Fixed)
        .divider({ strokeWidth: 1 })
        .scrollable(false)
        .animationDuration(this.animationDuration)
        .onChange((index) => {
          this.currentTabIndex = index
        })
        .onAnimationStart((index, targetIndex) => {
          // this.currentTabIndex = targetIndex
          LogUtil.info(`onAnimationStart: ${index}-${this.currentTabIndex}`)
        })
        .onAnimationEnd((index, targetIndex) => {
          LogUtil.info(`onAnimationEnd: ${index}-${this.currentTabIndex}`)
        })
      }
      .height('100%')
      .width('100%')
      .padding({ bottom: this.bottomRectHeight })
    }
    .backButtonIcon($r('app.media.ic_public_arrow_left'))
    .hideToolBar(true)
  }

  @Builder
  TabBuilder(index: number, name: string, selected: Resource, unselected: Resource) {
    Column() {
      Flex({
        direction: FlexDirection.Column,
        alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.Center
      }) {
        if (this.currentTabIndex === index) {
          Image(selected)
            .height(25)
            .draggable(false)
            .fillColor($r('app.color.common_button_background_weight'))
            .transition(TransitionEffect.OPACITY.animation({ duration: this.animationDuration }))

          Text(name)
            .fontSize(11)
            .margin(5)
            .fontColor($r('app.color.common_button_background_weight'))
            .transition(TransitionEffect.OPACITY.animation({ duration: this.animationDuration }))
        } else {
          Image(unselected).height(25)
            .draggable(false)
            .fillColor($r('app.color.common_button_background_light'))
            .transition(TransitionEffect.OPACITY.animation({ duration: this.animationDuration }))

          Text(name)
            .fontSize(11)
            .margin(5)
            .fontColor($r('app.color.common_button_background_light'))
            .transition(TransitionEffect.OPACITY.animation({ duration: this.animationDuration }))
        }
      }
    }
    .width('100%')
    .height("100%")
  }
}