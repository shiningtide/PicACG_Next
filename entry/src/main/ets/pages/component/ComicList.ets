import { LogUtil, ToastUtil } from '@pura/harmony-utils';
import { ComicResponse } from '../../api/comic';
import { ComicSimpleInfo, SortType } from '../../api/models';
import { favouriteAction } from '../../api/profile';
import { HistoryUtil } from '../../utils/History';
import { PreferenceStorageKey } from '../../utils/Preference';
import ComicListItem from './ComicListItem';

@Component
export default struct ComicList {
  @StorageProp(PreferenceStorageKey.IMAGE_API) imageApi: string = ''
  @State comics: ComicSimpleInfo[] = []
  @State isRefreshing: boolean = true
  @State isLoading: boolean = false;
  @State isEnd: boolean = false;
  @State maxPage: number = 1
  @State page: number = 1
  @Prop sort: SortType = SortType.Newest
  @Prop param1: string = ''
  @Prop param2: string[] = []
  @Prop func: ComicListFunction
  private scroll: Scroller = new Scroller()

  loadComics() {
    if (this.func.type === 'history') {
      LogUtil.debug('加载浏览历史')
      setTimeout(() => {
        animateTo({ duration: 500 }, () => {
          this.comics = HistoryUtil.get()
          this.isRefreshing = false
        })
      }, 500)
    } else if (this.func.type === 'remote') {
      LogUtil.debug('加载远程数据')
      if (this.func.api !== undefined) {
        this.func.api(this.page, this.sort, this.param1, this.param2)
          .then(res => {
            animateTo({ duration: 500 }, () => {
              if (this.page === 1) {
                this.comics = res.comics.docs
              } else {
                this.comics.push(...res.comics.docs)
              }
            })
            LogUtil.debug(`加载第${this.page}页，共${res.comics.docs.length}条`)
            this.page = res.comics.page
            this.maxPage = res.comics.pages
          })
          .finally(() => {
            animateTo({ duration: 500 }, () => {
              this.isRefreshing = false
              this.isLoading = false
            })
          })
      }
    }
  }

  build() {
    Column() {
      Refresh({ refreshing: $$this.isRefreshing }) {
        List({ space: 5, scroller: this.scroll }) {
          ForEach(this.comics, (comic: ComicSimpleInfo) => {
            ListItem() {
              ComicListItem({
                image: `${this.imageApi}${comic.thumb.path}`,
                title: comic.title,
                pagesCount: comic.pagesCount,
                finished: comic.finished,
                author: comic.author,
                categories: comic.categories,
                likesCount: comic.totalLikes,
                viewCount: comic.totalViews,
                epsCount: comic.epsCount
              })
            }
            .layoutWeight(1)
            .height(undefined)
            .borderRadius(30)
            .transition(TransitionEffect.OPACITY)
            .swipeAction({
              end: {
                builder: () => {
                  this.itemEnd(comic)
                },
                onAction: () => {
                  LogUtil.info('onAction:触发删除操作')
                  this.operateFavourite(comic)
                },
                actionAreaDistance: 56,
              }
            })
          }, (item: ComicSimpleInfo) => {
            return item._id
          })

          if (this.comics.length === 0 || this.page === this.maxPage) {
            ListItem() {
              Row() {
                Text('没有更多了')
              }.width("100%")
              .height(64)
              .justifyContent(FlexAlign.Center)
            }
          }

          if (this.isLoading) {
            ListItem() {
              Row() {
                LoadingProgress().height(32).width(48)
              }.width("100%")
              .height(64)
              .justifyContent(FlexAlign.Center)
            }
          }
        }
        .width('100%')
        .height('100%')
        .layoutWeight(1)
        .divider({
          strokeWidth: 1,
          color: $r('app.color.custom_gray'),
          startMargin: 20,
          endMargin: 20
        })
        .scrollBar(BarState.Off)
        .onReachEnd(() => {
          if (this.isEnd && this.page < this.maxPage) {
            LogUtil.info('onReachEnd到底辣！！！要加载更多')
            this.page += 1
            animateTo({ duration: 500 }, () => {
              this.isLoading = true
              this.loadComics()
            })
          }
        })
        .onScrollIndex((start: number, end: number) => {
          this.isEnd = end + 1 === this.comics.length
        })
      }
      .onRefreshing(() => {
        LogUtil.info('刷新！！！！')
        this.page = 1
        animateTo({ duration: 500 }, () => {
          this.loadComics()
        })
      })
      .layoutWeight(1)
      .refreshOffset(64)
      .pullToRefresh(true)
    }
    .layoutWeight(1)
  }

  @Builder
  itemEnd(comic: ComicSimpleInfo) {
    Row() {
      Button({ type: ButtonType.Circle, stateEffect: false, buttonStyle: ButtonStyleMode.TEXTUAL }) {
        Image($r('app.media.ic_public_delete'))
          .width(24)
          .fillColor(Color.White)
      }
      .width(40)
      .height(40)
      .margin(5)
      .type(ButtonType.Circle)
      .backgroundColor(Color.Red)
      .clickEffect({ level: ClickEffectLevel.LIGHT, scale: 0.8 })
      .onClick(() => this.operateFavourite(comic))
    }
    .padding(4)
    .justifyContent(FlexAlign.SpaceEvenly)
  }

  operateFavourite(comic: ComicSimpleInfo) {
    favouriteAction(comic._id)
      .then(res => {
        if (res.action === 'un_favourite') {
          animateTo({ duration: 500 }, () => {
            this.comics = this.comics.filter(c => c._id !== comic._id)
          })
          ToastUtil.showToast('已取消收藏')
        }
      })

  }
}

interface ComicListFunction {
  type: 'history' | 'remote',
  api?: (page: number, s: SortType, p3: string, p4: string[]) => Promise<ComicResponse>
}