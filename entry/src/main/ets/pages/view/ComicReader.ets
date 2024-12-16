import { SymbolGlyphModifier, window } from '@kit.ArkUI'
import { ImageKnifeComponent, ImageKnifeRequest } from '@ohos/imageknife'
import { AppUtil, LogUtil } from '@pura/harmony-utils'
import { chapter, eps } from '../../api/comic'
import { ComicEp } from '../../api/models'
import { PreferenceItem, PreferenceManager, PreferenceStorageKey } from '../../utils/Preference'
import { BackType, TitleBar, TitleType } from '../component/TitleBar'
import { ImageQuality } from '../../common/Config'
import { HistoryUtil } from '../../utils/History'

@Builder
export function ComicReaderBuilder(name: string, param: Object) {
  ComicReader()
}

@Component
export default struct ComicReader {
  @StorageProp('topRectHeight') topRectHeight: number = 0
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0
  @StorageProp('WindowWidth') windowWidth: number = 0
  @StorageProp('WindowHeight') windowHeight: number = 0
  @StorageProp(PreferenceStorageKey.IMAGE_API) imageApi: string = ''
  @StorageProp(PreferenceStorageKey.IMAGE_QUALITY) imageQuality: string = ''
  @Consume('pageStack') pageStack: NavPathStack
  @Prop chapter: ComicChapterInterface = {
    comicId: "",
    order: 1,
  }
  @State eps: ComicEp[] = []
  @State page: number = 1
  @State maxPage: number = 1
  @State images: string[] = []
  @State title: string = ''
  @State isEnd: boolean = false
  @State showToolbar: boolean = false
  @State showEps: boolean = false
  @State disappear: TransitionEffect = TransitionEffect.move(TransitionEdge.START)
  @State scaleValue: number = 1
  @State pinchValue: number = 1;
  @State offsetX: number = 0;
  @State offsetY: number = 0;
  @State positionX: number = 0;
  @State positionY: number = 0;
  private scroll: Scroller = new Scroller()
  private scrollIndexStart: number = 1
  private scrollIndexEnd: number = 1
  private inPan: boolean = false

  build() {
    NavDestination() {
      Stack() {
        List({ scroller: this.scroll }) {
          ForEach(this.images, (img: string, index: number) => {
            ImageKnifeComponent({
              imageKnifeOption: {
                loadSrc: img,
                placeholderSrc: $r('app.media.loading'),
                objectFit: ImageFit.Auto,
                onLoadListener: {
                  onLoadFailed: (err: string, req?: ImageKnifeRequest) => {
                    LogUtil.error('图片加载失败：', err, ' - ', img)
                    LogUtil.error(JSON.stringify(req))
                  }
                }
              },
            })
              .width('100%')
              .transition(TransitionEffect.asymmetric(TransitionEffect.move(TransitionEdge.BOTTOM), this.disappear))
          })
        }
        .width('100%')
        .height('100%')
        .contentStartOffset(this.topRectHeight)
        .scrollBar(BarState.Off)
        .scale({ x: this.scaleValue, y: this.scaleValue, z: 1 })
        .offset({ x: this.offsetX, y: this.offsetY })
        .onScrollIndex((start: number, end: number) => {
          this.scrollIndexStart = start
          this.scrollIndexEnd = end
          LogUtil.info(`currentIndex: ${start} - ${end}`)
          this.isEnd = end + 5 >= this.images.length
          if (this.isEnd && this.page < this.maxPage) {
            LogUtil.info('onReachEnd到底辣！！！要加载更多')
            this.page++
            animateTo({ duration: 500 }, () => {
              this.load()
            })
          }
        })
        .onWillScroll((scrollOffset) => {
          if (this.inPan) {
            return { offsetRemain: 0 }
          }
          return { offsetRemain: scrollOffset }
        })
        .gesture(GestureGroup(GestureMode.Exclusive,
          // 双指缩放
          PinchGesture({ fingers: 2 }).onActionStart(e => {
            LogUtil.info('双指缩放开始，当前缩放倍率：', this.scaleValue.toString());
          }).onActionUpdate(e => {
            if (e) {
              this.scaleValue = this.pinchValue * e.scale;
              LogUtil.info('正在执行缩放，当前缩放倍率：', this.scaleValue.toString());
            }
          }).onActionEnd(e => {
            animateTo({ duration: 300 }, () => {
              if (this.scaleValue < 1) {
                this.scaleValue = 1
                this.offsetX = 0
                this.offsetY = 0
              } else if (this.scaleValue > 3) {
                this.scaleValue = 3
              }
            })
            this.pinchValue = this.scaleValue;
            LogUtil.info('双指缩放结束，当前缩放倍率：', this.scaleValue.toString());
          }),
          // 拖动平移
          PanGesture().onActionStart((event: GestureEvent | undefined) => {
            LogUtil.info(`拖动开始，当前偏移：${this.offsetX} ${this.offsetY}`);
            this.inPan = true
          }).onActionUpdate((event: GestureEvent | undefined) => {
            if (event && this.scaleValue > 1) {
              // 动态计算缩放后的组件宽高
              const scaledWidth = this.windowWidth * this.scaleValue;
              const scaledHeight = this.windowHeight * this.scaleValue;
              // 容器的边界
              const containerLeft = 0;
              const containerRight = this.windowWidth;
              const containerTop = 0;
              const containerBottom = this.windowHeight;
              // 组件的边界（拖动后不能超过容器的范围）
              const minX = containerLeft - (scaledWidth - this.windowWidth) / 2;
              const maxX = containerRight - this.windowWidth + (scaledWidth - this.windowWidth) / 2;
              const minY = containerTop - (scaledHeight - this.windowHeight) / 2;
              const maxY = containerBottom - this.windowHeight + (scaledHeight - this.windowHeight) / 2;
              // 更新偏移量，并限制在边界内
              const newOffsetX = this.positionX + event.offsetX * 5;
              const newOffsetY = this.positionY + event.offsetY * 5;

              this.offsetX = Math.min(Math.max(newOffsetX, minX), maxX);
              this.offsetY = Math.min(Math.max(newOffsetY, minY), maxY);
              LogUtil.info(`正在拖动，当前偏移：${this.offsetX} ${this.offsetY}`);
            }
          }).onActionEnd(() => {
            animateTo({ duration: 300 }, () => {
              if (this.scaleValue === 1) {
                this.offsetX = 0
                this.offsetY = 0
              }
            })
            this.positionX = this.offsetX;
            this.positionY = this.offsetY;
            LogUtil.info(`拖动结束，当前偏移：${this.offsetX} ${this.offsetY}`);
            this.inPan = false
          }),
          // 单击
          TapGesture({ count: 1, fingers: 1 }).onAction((event) => {
            LogUtil.info('触发单击')
            let x = event.fingerList[0].globalX
            let y = event.fingerList[0].globalY
            if (x < this.windowWidth * 0.34 || y < this.windowHeight * 0.3) {
              LogUtil.info('点击上一页')
              animateTo({ duration: 500 }, () => {
                // this.scroll.scrollPage({ next: false })
                this.scroll.scrollToIndex(this.scrollIndexStart, true)
              })
            } else if (x > this.windowWidth * 0.66 || y > this.windowHeight * 0.7) {
              LogUtil.info('点击下一页')
              animateTo({ duration: 500 }, () => {
                // this.scroll.scrollPage({ next: true })
                this.scroll.scrollToIndex(this.scrollIndexEnd, true)
              })
            } else {
              LogUtil.info('点击中间')
              animateTo({ duration: 300 }, () => {
                this.showToolbar = true
                this.showSystemBar(true)
              })
            }
          }),
        ))

        if (this.showToolbar) {
          Column() {
            TitleBar({
              titleBarColor: Color.White,
              statusBarColor: Color.White,
              centerType: TitleType.TEXT,
              centerText: this.title,
              centerTextColor: $r('app.color.common_button_background_light'),
              leftBackType: BackType.NONE,
              leftBackFillColor: $r('app.color.common_button_background_light'),
              leftOnClick: () => {
                this.pageStack.pop()
              },
              rightType: TitleType.CUSTOM,
              rightCustomView: () => {
                this.rightBuilder()
              },
              bottomLineColor: Color.Gray
            })
              .transition(TransitionEffect.move(TransitionEdge.TOP))

            Column()
              .width('100%')
              .height('100%')
              .layoutWeight(1)
              .onClick(() => {
                animateTo({ duration: 300 }, () => {
                  this.showToolbar = false
                  this.showSystemBar(false)
                })
              })

            Row() {
              Button() {
                Row() {
                  Image($r('app.media.ic_public_arrow_left'))
                    .width(24)
                    .fillColor($r('app.color.common_button_background_light'))
                  Text('上一章')
                    .fontColor($r('app.color.common_button_background_light'))
                    .margin({ left: 10 })
                }
              }
              .width('34%')
              .height('100%')
              .stateEffect(false)
              .buttonStyle(ButtonStyleMode.TEXTUAL)
              .type(ButtonType.Normal)
              .enabled(this.chapter.order > 1)
              .onClick(() => {
                LogUtil.info('点击上一章')
                this.goToEp(this.chapter.order - 1)
              })

              Button() {
                Row() {
                  Text('目录')
                    .fontColor($r('app.color.common_button_background_light'))
                    .margin({ left: 10 })
                }
              }
              .width('32%')
              .height('100%')
              .stateEffect(false)
              .buttonStyle(ButtonStyleMode.TEXTUAL)
              .type(ButtonType.Normal)
              // .enabled(!this.showEps)
              .onClick(() => {
                animateTo({ duration: 500 }, () => {
                  this.showEps = !this.showEps
                  LogUtil.info('目录', this.eps[0]?.title)
                })
              })

              Button() {
                Row() {
                  Text('下一章')
                    .fontColor($r('app.color.common_button_background_light'))
                  Image($r('app.media.ic_public_arrow_right'))
                    .width(24)
                    .fillColor($r('app.color.common_button_background_light'))
                    .margin({ left: 10 })
                }
              }
              .width('34%')
              .height('100%')
              .stateEffect(false)
              .buttonStyle(ButtonStyleMode.TEXTUAL)
              .type(ButtonType.Normal)
              .enabled(this.chapter.order < this.eps.length)
              .onClick(() => {
                LogUtil.info('点击下一章')
                this.goToEp(this.chapter.order + 1)
              })
            }
            .width('100%')
            .height(56 + this.bottomRectHeight)
            .backgroundColor(Color.White)
            .transition(TransitionEffect.move(TransitionEdge.BOTTOM))
            .borderWidth({ top: 1 })
            .borderColor(Color.Gray)
          }
          .width('100%')
          .height('100%')
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Black)

      Flex()
        .width(0)
        .height(0)
        .borderRadius({ topRight: 30, bottomRight: 30 })
        .bindSheet(this.showEps, this.epsBuilder(), {
          title: {
            title: '目录',
          },
          height: SheetSize.MEDIUM,
          showClose: false,
          dragBar: false,
          blurStyle: BlurStyle.COMPONENT_ULTRA_THIN,
          onDisappear: () => {
            animateTo({ duration: 500 }, () => {
              this.showEps = false
            })
          },
        })
        .layoutWeight(1)
    }
    .mode(NavDestinationMode.STANDARD)
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.chapter = context.pathInfo.param as ComicChapterInterface
      this.load()
      this.loadEps(1)
      // 进入沉浸模式
      this.showSystemBar(false)
    })
    .onDisAppear(() => {
      // 退出沉浸模式
      this.showSystemBar(true)
    })
    .onBackPressed(() => {
      LogUtil.info('返回了')
      if (this.showToolbar) {
        LogUtil.info(`this.showToolbar ${this.showToolbar}`)
        animateTo({ duration: 300 }, () => {
          this.showToolbar = false
        })
        return true
      } else {
        return false
      }
    })
  }

  /**
   * 右侧自定义视图
   */
  @Builder
  rightBuilder() {
    Row() {
      Image($r('app.media.ic_public_settings_filled'))
        .height(20)
        .fillColor($r('app.color.common_button_background_light'))
        .bindMenu(this.qualityMenu)
    }
  }

  @Builder
  qualityMenu() {
    Menu() {
      ForEach(PreferenceManager.ImageQualityItem, ((item: PreferenceItem) => {
        MenuItem({
          content: item.name,
        })
          .contentFont({ size: 16 })
          .selected(this.imageQuality === item.value)
          .selectIcon(new SymbolGlyphModifier($r('sys.symbol.checkmark'))
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor([$r('app.color.common_button_background_light')])
          )
          .onChange(selected => {
            if (selected) {
              this.imageQuality = ImageQuality[item.key]
            }
          })
      }))
    }
    .width(120)
  }

  @Builder
  epsBuilder() {
    Column() {
      List({ scroller: new Scroller() }) {
        ForEach(this.eps.reverse(), (ep: ComicEp) => {
          ListItem() {
            Text(ep.title)
              .width('100%')
              .height(50)
              .minFontSize(16)
              .maxFontSize(20)
              .maxLines(1)
              .fontColor(this.chapter.order === ep.order ? $r('app.color.common_button_background_weight') :
              Color.Black)
              .fontWeight(this.chapter.order === ep.order ? FontWeight.Bold : FontWeight.Normal)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .heightAdaptivePolicy(TextHeightAdaptivePolicy.MAX_LINES_FIRST)
              .onClick(() => {
                this.goToEp(ep.order)
              })
          }
          .width('100%')
          .height(50)
          .margin({ left: 20, right: 20 })
        })
      }
      .width('100%')
      .height('100%')
      .divider({
        strokeWidth: 1,
        color: $r('app.color.custom_gray'),
        startMargin: 20,
        endMargin: 20
      })
    }
    .width('100%')
    .margin({ bottom: this.bottomRectHeight })
  }

  load() {
    HistoryUtil.get()
    chapter(this.chapter.comicId, this.chapter.order, this.page).then(res => {
      animateTo({ duration: 200 }, () => {
        this.title = res.ep.title
        this.maxPage = res.pages.pages
        res.pages.docs.forEach((c, i) => {
          this.images.push(`${this.imageApi}${c.media.path}`)
        })
      })
    })
  }

  loadEps(page: number) {
    eps(this.chapter.comicId, page).then(res => {
      animateTo({ duration: 300 }, () => {
        this.eps.push(...res.eps.docs)
        if (page < res.eps.pages) {
          LogUtil.info(`递归加载所有章节：${page + 1}-${res.eps.pages}`)
          this.loadEps(page + 1)
        } else {
          LogUtil.info(`所有章节加载结束：${this.eps.length}`)
          this.eps = this.eps.reverse()
        }
      })
    })
  }

  showSystemBar(show: boolean) {
    let windowClass: window.Window = AppUtil.getContext().windowStage.getMainWindowSync()
    windowClass.setSpecificSystemBarEnabled('status', show, true)
    windowClass.setSpecificSystemBarEnabled('navigation', show, true)
    windowClass.setSpecificSystemBarEnabled('navigationIndicator', show, true)
  }

  goToEp(order: number) {
    this.disappear = this.chapter.order < order ? TransitionEffect.move(TransitionEdge.START) :
    TransitionEffect.move(TransitionEdge.END)
    HistoryUtil.setRead(this.chapter.comicId, order)
    animateTo({ duration: 500 }, () => {
      this.scroll.scrollToIndex(0, true)
      this.chapter.order = order
      this.page = 1
      this.maxPage = 1
      this.images = []
      this.load()
      // this.eps = []
      // this.loadEps(1)
    })
  }
}

export interface ComicChapterInterface {
  comicId: string
  order: number
}