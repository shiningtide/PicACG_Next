@Builder
export function ComicContentBuilder(name: string, param: Object) {
  ComicContent()
}

@Component
export default struct ComicContent {
  @Consume('NavPathStack') pageStack: NavPathStack;

  build() {
    NavDestination() {
      Column() {
        Text('漫画阅读页')
          .width('100%')
          .height('100%')
      }
    }
    .mode(NavDestinationMode.STANDARD)
    .onReady((context: NavDestinationContext) => {
      this.pageStack = context.pathStack;
    })
  }
}