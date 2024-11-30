import ComicCard from './ComicCard'

@Component
export default struct ComicCardScroll {
  @Prop comicIds: string[]
  @Prop images: string[]
  @Prop titles: string[]

  build() {
    Column() {
      List({ space: 16 }) {
        ForEach(this.comicIds, (item: string, index: number) => {
          ListItem() {
            ComicCard({
              comicId: item,
              image: `${this.images[index]}`,
              name: `${this.titles[index]})`
            })
          }
        })
      }.listDirection(Axis.Horizontal)
      .width('100%')
      .height(220)
    }
  }
}