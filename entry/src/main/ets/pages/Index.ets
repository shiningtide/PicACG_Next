import { NavItem } from '../utils/types'
import Home from './view/Home'
import Main from './view/Main'
import Categories from './view/Categories'
import SearchHead from './component/SearchHead'

@Entry
@Component
struct Index {
  @StorageProp('topRectHeight') topRectHeight: number = 0
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0
  @Provide('pageStack') pageStack: NavPathStack = new NavPathStack()
  @State currentTabIndex: number = 0
  @State refreshKeyword: boolean = false
  tabController: TabsController = new TabsController()
  navItem: NavItem[] = [
    new NavItem(0, $r('app.media.ic_public_home'), $r('app.media.ic_public_home_filled'), '首页'),
    new NavItem(1, $r('app.media.ic_public_category'), $r('app.media.ic_public_category_filled'), '分类'),
    new NavItem(2, $r('app.media.ic_public_user'), $r('app.media.ic_public_user_filled'), '我的')
  ]

  build() {
    Navigation(this.pageStack) {
      Column() {
        SearchHead({ refreshKeyword: this.refreshKeyword })
          .width('100%')
          .height(50)

        Tabs({
          index: this.currentTabIndex,
          barPosition: BarPosition.End,
          controller: this.tabController
        }) {
          ForEach(this.navItem, (item: NavItem) => {
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
        .layoutWeight(1)
        .vertical(false)
        .barMode(BarMode.Fixed)
        .divider({ strokeWidth: 1 })
        .onChange((index) => {
          this.currentTabIndex = index
        })
      }
      .height('100%')
      .width('100%')
      .padding({ top: this.topRectHeight, bottom: this.bottomRectHeight })
    }
    .hideToolBar(true)
    .onNavBarStateChange((isVisible) => {
      // 刷新顶部搜索框关键词
      if (isVisible) {
        this.refreshKeyword = !this.refreshKeyword
      }
    })
  }

  @Builder
  TabBuilder(navItem: NavItem) {
    Column() {
      Flex({
        direction: FlexDirection.Column,
        alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.Center
      }) {
        Image(this.currentTabIndex === navItem.index ? navItem.selectedImg : navItem.unselectedImg)
          .height(25)
          .draggable(false)
          .fillColor(this.currentTabIndex === navItem.index ? $r('app.color.common_button_background_light') :
          Color.Gray)

        Text(navItem.title)
          .fontSize(11)
          .margin(5)
          .fontColor(this.currentTabIndex === navItem.index ? $r('app.color.common_button_background_light') :
          Color.Gray)
      }
    }
    .width('100%')
    .height("100%")
  }
}