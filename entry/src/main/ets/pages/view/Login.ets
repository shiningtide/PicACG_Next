@Entry
@Component
struct Login {
  @State message: string = '登录'

  build() {
    Row() {
      Column() {
        Image($r("app.media.login_bg"))

        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}