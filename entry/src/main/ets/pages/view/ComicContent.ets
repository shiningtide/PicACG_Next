@Builder
export function ComicContentBuilder(name: string, param: Object) {
  ComicContent()
}

@Component
export default struct ComicContent {
  @StorageProp('topRectHeight') topRectHeight: number = 0
  @Consume('pageStack') pageStack: NavPathStack

  build() {
    NavDestination() {
      Column() {
        Text('漫画阅读页')
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