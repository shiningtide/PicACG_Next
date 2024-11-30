import { Api } from '../../utils/config';
import { PreferenceItem, PreferenceManager, PreferenceStorageKey } from '../../utils/preference';

@CustomDialog
export default struct ApiSelectionDialog {
  @StorageProp(PreferenceStorageKey.Api) api: Api = Api.Origin
  private controller: CustomDialogController; // 定义controller

  build() {
    Column() {
      Text('修改线路')
        .fontSize(20)
        .margin({ bottom: 10 })

      Column() {
        ForEach(PreferenceManager.ApiItem, (item: PreferenceItem) => {
          Row() {
            Radio({ value: item.value, group: 'api' })
              .checked(item.value === this.api)
              .onChange((isChecked: boolean) => {
                if (isChecked) {
                  PreferenceManager.setApi(Api[item.key])
                }
              })
            Text(item.name)
              .onClick(() => {
                PreferenceManager.setApi(Api[item.key])
              })
          }
        })
      }
      .width('100%')

      Row() {
        Button("完成", { buttonStyle: ButtonStyleMode.TEXTUAL })
          .height("100%")
          .layoutWeight(1)
          .clickEffect({ level: ClickEffectLevel.LIGHT })
          .onClick(() => {
            this.controller.close(); // 关闭弹窗
          })
      }
      .height(45)
      .width('100%')
    }
    .padding(10)
  }
}