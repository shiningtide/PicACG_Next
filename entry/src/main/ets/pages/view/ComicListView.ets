@Builder
export function ComicListViewBuilder(name: string, param: Object) {
  ComicListView()
}

@Component
export default struct ComicListView {
  @StorageProp('topRectHeight') topRectHeight: number = 0
  @Consume('pageStack') pageStack: NavPathStack
  @State searchParam: ComicListOptions | undefined = undefined

  aboutToAppear(): void {
    this.searchParam = this.pageStack.getParamByIndex(0) as ComicListOptions
    if (this.searchParam.type === SearchType.Custom) {
      // 关键字查询
    } else if (this.searchParam.type === SearchType.Category) {
      // 分类查询
    } else {
      // 随机查询
    }
  }

  build() {
    NavDestination() {
      Column() {
        Text('漫画查询列表')
          .width('100%')
          .height('100%')
      }
      .width('100%')
      .height('100%')
      .padding({ top: this.topRectHeight })
      .backgroundColor(Color.Pink)
    }
    .mode(NavDestinationMode.STANDARD)
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.pageStack = context.pathStack
    })
  }
}

export interface ComicListOptions {
  type: SearchType
  key?: string
}

export enum SearchType {
  Random,
  Category,
  Custom
}