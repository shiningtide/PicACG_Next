import { LogUtil } from '@pura/harmony-utils';
import { Comment } from '../../api/models';
import { myComments } from '../../api/profile';
import { PreferenceStorageKey } from '../../utils/Preference';
import CommentListItem from './CommentListItem';

@Component
export default struct CommentList {
  @StorageProp(PreferenceStorageKey.IMAGE_API) imageApi: string = ''
  @State comments: Comment[] = []
  @State isRefreshing: boolean = true
  @State isLoading: boolean = false;
  @State isEnd: boolean = false;
  @State maxPage: number = 1
  @State page: number = 1
  @Prop avatar: string | undefined = undefined
  private scroll: Scroller = new Scroller()

  loadComments() {
    myComments(this.page)
      .then(res => {
        LogUtil.info('avatar: ', this.imageApi, this.avatar)
        animateTo({ duration: 500 }, () => {
          if (this.page === 1) {
            this.comments = res.comments.docs
          } else {
            this.comments.push(...res.comments.docs)
          }
        })
        this.page = res.comments.page
        this.maxPage = res.comments.pages
      })
      .finally(() => {
        animateTo({ duration: 500 }, () => {
          this.isRefreshing = false
          this.isLoading = false
        })
      })
  }

  build() {
    Column() {
      Refresh({ refreshing: $$this.isRefreshing }) {
        List({ space: 5, scroller: this.scroll }) {
          ForEach(this.comments, (comment: Comment) => {
            ListItem() {
              CommentListItem({
                _id: comment._id,
                content: comment.content,
                likesCount: comment.likesCount,
                commentsCount: comment.commentsCount,
                createTime: comment.created_at,
                comicTitle: comment._comic.title,
                comicId: comment._comic._id,
                avatar: `${this.imageApi}${this.avatar ? this.avatar : comment._user.avatar.path}`
              })
            }
            .layoutWeight(1)
            .transition(TransitionEffect.OPACITY)
          }, (item: Comment) => {
            return item._id
          })

          if (this.comments.length === 0 || this.page === this.maxPage) {
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
              this.loadComments()
            })
          }
        })
        .onScrollIndex((start: number, end: number) => {
          this.isEnd = end + 1 === this.comments.length
        })
      }
      .onRefreshing(() => {
        LogUtil.info('刷新！！！！')
        this.page = 1
        animateTo({ duration: 500 }, () => {
          this.loadComments()
        })
      })
      .layoutWeight(1)
      .refreshOffset(64)
      .pullToRefresh(true)
    }
    .layoutWeight(1)
  }
}