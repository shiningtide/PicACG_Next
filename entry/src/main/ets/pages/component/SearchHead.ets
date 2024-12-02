import { keywords } from '../../api/comic';
import { StorageKey } from '../../utils/consts';
import { LengthUnit } from '@kit.ArkUI';
import { RandomUtil } from '@pura/harmony-utils';

@Component
export default struct SearchHead {
  @StorageLink(StorageKey.KEYWORDS) keywords: string[] = []
  @Consume('pageStack') pageStack: NavPathStack;
  @State showKey: string = ''
  @Link @Watch('onRefreshKeyword') refreshKeyword: boolean

  aboutToAppear(): void {
    keywords().then(res => {
      this.keywords = res.keywords
      this.changeShowKey()
    })
  }

  onRefreshKeyword() {
    this.changeShowKey()
  }

  changeShowKey() {
    if (this.keywords.length !== 0) {
      this.showKey = this.keywords[RandomUtil.getRandomNumber(0, this.keywords.length)]
    }
  }

  build() {
    Row() {
      Row() {
        Image($r('app.media.ic_public_search'))
          .fillColor(Color.Gray)
          .width(20)
          .height(20)

        Text(this.showKey)
          .margin({ left: 10 })
          .fontSize(16)
          .fontColor(Color.Gray)
      }
      .height(30)
      .width('85%')
      .padding(5)
      .margin({
        top: 5,
        bottom: 5,
        left: 10,
        right: 10
      })
      .borderWidth(1)
      .borderColor($r('app.color.custom_gray'))
      .borderRadius(50)
      .onClick(() => {
        this.pageStack.pushPath({ name: 'ComicSearch' })
      })

      Row() {
        Button() {
          Image($r('app.media.ic_public_settings'))
            .width(24)
            .height(24)
            .fillColor($r('app.color.common_button_background_weight'))
        }
        .width(30)
        .height(30)
        .stateEffect(false)
        .type(ButtonType.Circle)
        .buttonStyle(ButtonStyleMode.TEXTUAL)
        .clickEffect({ level: ClickEffectLevel.LIGHT, scale: 0.8 })
        .onClick(() => {
          this.pageStack.pushPath({ name: 'Settings' })
        })
      }
      .height(30)
      .width('15%')
    }
    .width('100%')
    .height('100%')
    .borderWidth({
      start: { value: 0, unit: LengthUnit.VP },
      end: { value: 0, unit: LengthUnit.VP },
      top: { value: 0, unit: LengthUnit.VP },
      bottom: { value: 1, unit: LengthUnit.VP },
    })
    .borderColor($r('app.color.custom_gray'))
  }
}