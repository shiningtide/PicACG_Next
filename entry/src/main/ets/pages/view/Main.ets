import { collections, otherRecommend } from '../../api/comic'
import { ComicCardInterface } from '../component/ComicCard'
import { LogUtil } from '@pura/harmony-utils'
import ComicCardScroll from '../component/ComicCardScroll'
import { PreferenceStorageKey } from '../../utils/preference'

@Component
export default struct Main {
  @StorageProp(PreferenceStorageKey.IMAGE_API) imageApi: string = ''
  @State recommend: ComicCardInterface[] = []
  @State collections: ComicCardInterface[] = []
  @State currentIndex: number = 0
  @State animationDuration: number = 300
  @State indicatorLeftMargin: number = 0
  @State indicatorWidth: number = 0
  private textInfos: [number, number][] = []

  aboutToAppear() {
    this.loadCollection()
    this.loadRecommend()
  }

  loadRecommend() {
    otherRecommend().then(res => {
      res.forEach((comic) => {
        this.recommend.push({
          id: comic.id,
          title: comic.title,
          image: comic.pic
        })
      })
      LogUtil.info(`随机推荐: ${res.length}`)
    }).catch((err: Error) => {
      LogUtil.error(`错误: ${err.message}`)
      LogUtil.error(err.stack)
    })
  }

  loadCollection() {
    collections().then(res => {
      res.collections.forEach((collection) => {
        LogUtil.info(`${collection.title}: ${collection.comics.length}`)
        collection.comics.forEach((comic) => {
          this.collections.push({
            id: comic._id,
            title: `${comic.title}（${comic.pagesCount}P）${comic.finished ? '（完）' : ''}`,
            image: `${this.imageApi}${comic.thumb.path}`
          })
        })
      })
    }).catch((err: Error) => {
      LogUtil.error(`错误: ${err.message}`)
      LogUtil.error(err.stack)
    })
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Column() {
        Column() {
          Text('本子妹推荐')
            .width('100%')
            .margin(10)
          ComicCardScroll({ comics: this.collections })
        }

        Column() {
          Text('随机推荐')
            .width('100%')
            .margin(10)
          ComicCardScroll({ comics: this.recommend, })
        }
      }
      .height('100%')
      .width('100%')
      .padding(10)
    }.width('100%')
  }

  @Builder
  tabBuilder(index: number, name: string) {
    Column() {
      Text(name)
        .fontColor(this.currentIndex === index ? $r('app.color.common_button_background_weight') : Color.Gray)
        .fontWeight(this.currentIndex === index ? FontWeight.Bold : FontWeight.Normal)
        .id(index.toString())
        .onAreaChange((_oldValue: Area, newValue: Area) => {
          this.textInfos[index] = [newValue.globalPosition.x as number, newValue.width as number]
        })
    }.width('100%')
  }
}