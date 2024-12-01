import { DialogUtil, LogUtil } from '@pura/harmony-utils'
import { UserLogin } from '../api/auth'
import { StorageKey, Timeout } from '../utils/consts'
import router from '@ohos.router'
import ApiSelectionDialog from './dialog/ApiSelectionDialog'

@Entry
@Component
struct Login {
  @StorageLink(StorageKey.TOKEN) token: string = ''
  @State username: string = ''
  @State password: string = ''
  @State inLogin: boolean = false
  pageStack: NavPathStack = new NavPathStack()
  dialog: CustomDialogController = new CustomDialogController({
    builder: ApiSelectionDialog(), // 弹框的构造器
    autoCancel: true, // 允许点击蒙层关闭弹窗
    cancel: () => {
      LogUtil.info('cancel')
    }
  })

  build() {
    Column() {
      Row() {
        Image($r('app.media.login_bg'))
          .objectFit(ImageFit.Contain)
          .width('80%')
      }.height('70%')

      Column() {
        TextInput({ placeholder: '用户名', text: this.username })
          .type(InputType.USER_NAME)
          .width('80%')
          .margin({ bottom: 10 })
          .onChange(val => {
            this.username = val
          })

        TextInput({ placeholder: '密码', text: this.password })
          .type(InputType.NEW_PASSWORD)
          .width('80%')
          .margin({ bottom: 10 })
          .onChange(val => {
            this.password = val
          })

        Button({ type: this.inLogin ? ButtonType.Circle : ButtonType.Capsule }) {
          Row() {
            if (this.inLogin) {
              LoadingProgress().width(30).height(30).color(Color.White)
            } else {
              Text('登录').fontColor(Color.White).textAlign(TextAlign.Center)
            }
          }.height(40)
        }
        .width('30%')
        .margin({ bottom: 10 })
        .backgroundColor($r('app.color.common_button_background_light'))
        .enabled(!this.inLogin)
        .clickEffect({ level: ClickEffectLevel.LIGHT })
        .onClick(() => {
          if (this.username && this.password) {
            animateTo({ duration: 300 }, () => {
              this.inLogin = true
            })
            UserLogin({ email: this.username, password: this.password })
              .then(res => {
                LogUtil.info('登陆成功')
                this.token = res.token
                router.replaceUrl({ url: 'pages/Index' })
              })
              .catch((err: Error) => {
                if (Timeout === err.message) {
                  DialogUtil.showConfirmDialog({
                    title: '提示',
                    message: '连接超时！',
                    confirm: '确定',
                  })
                } else if ('1004: invalid email or password' === err.message) {
                  LogUtil.error('登陆失败: 用户名或密码错误')
                  DialogUtil.showConfirmDialog({
                    title: '提示',
                    message: '用户名或密码错误！',
                    confirm: '确定',
                  })
                } else {
                  LogUtil.error(`登陆异常: ${err.name}`)
                  LogUtil.error(`登陆异常: ${err.message}`)
                  LogUtil.error(`登陆异常: ${err.stack}`)
                  DialogUtil.showConfirmDialog({
                    title: '提示',
                    message: `接口异常`,
                    confirm: '确定',
                  })
                }
              })
              .finally(() => {
                animateTo({ duration: 300 }, () => {
                  this.inLogin = false
                })
              })
          } else {
            DialogUtil.showConfirmDialog({
              title: '提示',
              message: '请输入用户名密码！',
              confirm: '确定',
            })
          }
        })

        Button({ type: ButtonType.Circle, buttonStyle: ButtonStyleMode.TEXTUAL }) {
          Row() {
            Image($r('app.media.ic_public_settings'))
              .width(30)
              .height(30)
              .fillColor($r('app.color.common_button_background_light'))
          }.height(40)
        }
        .width('30%')
        .margin({ bottom: 10 })
        .clickEffect({ level: ClickEffectLevel.LIGHT })
        .onClick(() => {
          this.dialog.open()
        })
      }
    }
    .width('100%')
  }
}