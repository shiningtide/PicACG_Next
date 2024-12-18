import CommentList from '../component/CommentList'
import { BackType, TitleBar, TitleType } from '../component/TitleBar'

@Builder
export function CommentsBuilder(name: string, param: Object) {
  Comments()
}

@Component
export default struct Comments {
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0
  @Consume('pageStack') pageStack: NavPathStack

  build() {
    NavDestination() {
      Column() {
        TitleBar({
          titleBarColor: Color.White,
          statusBarColor: Color.White,
          centerType: TitleType.TEXT,
          centerText: '哔咔留言板',
          centerTextColor: $r('app.color.common_button_background_light'),
          leftBackType: BackType.NONE,
          leftBackFillColor: $r('app.color.common_button_background_light'),
          leftOnClick: () => {
            this.pageStack.pop()
          },
        })
        CommentList({ comicId: '5822a6e3ad7ede654696e482' })
          .margin({ top: 10 })
          .layoutWeight(1)
      }
      .height('100%')
      .width('100%')
      .padding({
        bottom: this.bottomRectHeight,
        left: 10,
        right: 10
      })
    }
    .mode(NavDestinationMode.STANDARD)
    .hideTitleBar(true)
  }
}