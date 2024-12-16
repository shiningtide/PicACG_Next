@Component
export default struct SettingsItem {
  @Prop group: Array<SettingsItemAttribute[]>

  build() {
    Scroll(new Scroller()) {
      Column() {
        ForEach(this.group, (items: SettingsItemAttribute[]) => {
          Column() {
            ForEach(items, (item: SettingsItemAttribute, index) => {
              Row() {
                Text(item.name)
                  .padding({ left: 10 })
                  .width(item.type === 'Switch' ? '87%' : '90%')

                if (item.type === 'Switch') {
                  Toggle({ type: ToggleType.Switch, isOn: item.switchVal })
                    .selectedColor($r('app.color.common_button_background_light'))
                    .onChange(item.onChange)
                } else {
                  Image($r('app.media.ic_public_arrow_right'))
                    .width(20)
                    .height(20)
                    .fillColor($r('app.color.common_button_background_light'))
                    .align(Alignment.End)
                    .onClick(item.onClick)
                }
              }
              .width('90%')
              .height(50)
              .backgroundColor(Color.White)
              .visibility(item.show === false ? Visibility.None : Visibility.Visible)
              .onClick(item.onClick)

              Divider()
                .width('90%')
                .visibility(index >= items.length - 1 ? Visibility.None : Visibility.Visible)
            })
          }
          .margin({ top: 15 })
          .borderRadius(10)
        })
      }.width('100%')
    }
    .width('100%')
    .scrollBar(BarState.Off)
  }
}

interface SettingsItemAttribute {
  name: string,
  type?: 'Normal' | 'Switch'
  onClick?: () => void
  switchVal?: boolean
  onChange?: (isOn: boolean) => void
  show?: boolean
}