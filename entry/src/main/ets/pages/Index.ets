import { NavItem } from '../utils/types'
import Home from './view/Home'
import Main from './view/Main'
import Categories from './view/Categories'

@Entry
@Component
struct Index {
  @StorageProp('topRectHeight') topRectHeight: number = 0
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0
  @Provide('pageStack') pageStack: NavPathStack = new NavPathStack()
  @State currentTabIndex: number = 0
  tabController: TabsController = new TabsController()
  nav: NavItem[] = [
    new NavItem(0, $r('app.media.ic_public_home'), $r('app.media.ic_public_home_filled'), '首页'),
    new NavItem(1, $r('app.media.ic_public_category'), $r('app.media.ic_public_category_filled'), '分类'),
    new NavItem(2, $r('app.media.ic_public_user'), $r('app.media.ic_public_user_filled'), '我的')
  ]

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
                  Main()
                } else if (item.index === 1) {
                  Categories()
                } else if (item.index === 2) {
                  Home()
                }
              }
            }
            .tabBar(
              this.TabBuilder(item)
            )
          })
        }
        .vertical(false)
        .barMode(BarMode.Fixed)
        .divider({ strokeWidth: 1 })
        .onChange((index) => {
          this.currentTabIndex = index
        })
      }
      .height('100%')
      .width('100%')
      .padding({ bottom: this.bottomRectHeight, top: this.topRectHeight })
    }
    .hideToolBar(true)
  }

  @Builder
  TabBuilder(nav: NavItem) {
    Column() {
      Flex({
        direction: FlexDirection.Column,
        alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.Center
      }) {
        Image(this.currentTabIndex === nav.index ? nav.selectedImg : nav.unselectedImg)
          .height(25)
          .draggable(false)
          .fillColor(this.currentTabIndex === nav.index ? $r('app.color.common_button_background_light') : Color.Gray)

        Text(nav.title)
          .fontSize(11)
          .margin(5)
          .fontColor(this.currentTabIndex === nav.index ? $r('app.color.common_button_background_light') : Color.Gray)
      }
    }
    .width('100%')
    .height("100%")
  }
}