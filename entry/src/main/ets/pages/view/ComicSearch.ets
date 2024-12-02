import { StorageKey } from '../../utils/consts';

@Builder
export function ComicSearchBuilder(name: string, param: Object) {
  ComicSearch()
}

@Component
export default struct ComicSearch {
  @StorageProp('topRectHeight') topRectHeight: number = 0
  @StorageProp(StorageKey.KEYWORDS) keywords: string[] = []
  @Consume('pageStack') pageStack: NavPathStack

  build() {
    NavDestination() {
      Column() {
        Text('漫画查询页面')
          .width('100%')

        ForEach(this.keywords, (item: string) => {
          Text(item)
            .width('100%')
        })
      }
      .width('100%')
      .height('100%')
      .padding({ top: this.topRectHeight })
      .backgroundColor(Color.Orange)
    }
    .mode(NavDestinationMode.STANDARD)
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.pageStack = context.pathStack
    })
  }
}