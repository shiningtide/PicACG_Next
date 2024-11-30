@Builder
export function ComicInfoBuilder(name: string, param: Object) {
  ComicInfo()
}

@Component
export default struct ComicInfo {
  @Consume('NavPathStack') pageStack: NavPathStack;

  build() {
    NavDestination() {
      Column() {
        Text('漫画信息页')
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