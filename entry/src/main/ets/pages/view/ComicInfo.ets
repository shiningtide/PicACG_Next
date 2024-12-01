import { ComicCardInterface } from '../component/ComicCard'

@Builder
export function ComicInfoBuilder(name: string, param: Object) {
  ComicInfo()
}

@Component
export default struct ComicInfo {
  @StorageProp('topRectHeight') topRectHeight: number = 0
  @Consume('pageStack') pageStack: NavPathStack
  @State comic: ComicCardInterface | undefined = undefined

  aboutToAppear(): void {
    this.comic = this.pageStack.getParamByIndex(0) as ComicCardInterface
  }

  build() {
    NavDestination() {
      Column() {
        Text(this.comic?.title)
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