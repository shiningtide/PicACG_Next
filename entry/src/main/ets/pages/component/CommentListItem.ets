import { ImageKnifeComponent } from '@ohos/imageknife'
import { DateUtil } from '@pura/harmony-utils'
import { PreferenceStorageKey } from '../../utils/Preference'
import { ComicCardInterface } from './ComicCard'

@Component
export default struct CommentListItem {
  @StorageProp(PreferenceStorageKey.IMAGE_API) imageApi: string = ''
  @Consume('pageStack') pageStack: NavPathStack;
  @Prop _id: string
  @Prop content: string
  @Prop likesCount: number
  @Prop commentsCount: number
  @Prop createTime: string
  @Prop comicTitle: string
  @Prop comicId: string
  @Prop avatar: string
  @Prop name: string = ''
  @Prop slogan: string

  build() {
    Row() {
      Column() {
        ImageKnifeComponent({
          imageKnifeOption: {
            loadSrc: this.imageApi + this.avatar,
            border: {
              radius: 50,
              width: 2,
              color: $r('app.color.custom_pink')
            }
          }
        })
          .width(60)
          .height(60)
      }
      .width(72)
      .height(72)
      .padding({ left: 8, top: 8 })
      .margin({ right: 14 })

      Column() {
        Row() {
          Text(`${this.name}`)
            .fontWeight(FontWeight.Bold)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .width('70%')

          Text(DateUtil.getTipDateStr(new Date(this.createTime)))
            .fontColor(Color.Gray)
            .fontSize(14)
            .textAlign(TextAlign.End)
            .width('30%')
        }

        Row() {
          Text(`${this.content}`)
            .width('100%')
        }
        .margin({ top: 5, bottom: 10 })

        Row() {
          Row() {
            Image($r('app.media.ic_public_heart'))
              .width(14)
            Text(`${this.likesCount}`)
              .fontSize(14)
              .margin({ left: 5 })
          }

          Row() {
            Image($r('app.media.ic_public_comments'))
              .width(13)
            Text(`${this.commentsCount}`)
              .fontSize(14)
              .margin({ left: 5 })
          }
          .margin({ left: 15 })
        }
        .width('100%')

        if (this.comicId && this.comicTitle) {
          Row() {
            Text(`>>> ${this.comicTitle}`)
              .width('100%')
              .fontColor($r('app.color.common_button_background_light'))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .onClick(() => {
                this.pageStack.pushPath({
                  name: 'ComicInfo',
                  param: { id: this.comicId, title: this.comicTitle } as ComicCardInterface
                })
              })
          }
          .width('100%')
        }
      }
      .width('100%')
      .height('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height(100)
    .constraintSize({ minHeight: 100, maxHeight: '100%' })
    .padding({ top: 10 })
    .layoutWeight(1)
  }
}