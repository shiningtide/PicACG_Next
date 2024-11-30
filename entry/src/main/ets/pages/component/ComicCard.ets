@Component
export default struct ComicCard {
  @Prop comicId: string
  @Prop image: string
  @Prop name: string

  build() {
    Column() {
      Image(this.image)
        .height(160)
        .borderRadius(6)

      Text(this.name)
        .textAlign(TextAlign.Center)
        .margin({ top: 6 })
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
        .fontColor('#db547c')
        .fontWeight(500)
        .copyOption(CopyOptions.LocalDevice)
    }
    .width(150)
    .height(200)
    .padding(8)
  }
}