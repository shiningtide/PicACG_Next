import { AppUtil, DialogUtil, LogUtil } from '@pura/harmony-utils'
import { UserLogin } from '../api/auth'
import { TOKEN_KEY } from '../utils/consts'
import router from '@ohos.router';

@Entry
@Component
struct Login {
  pageStack: NavPathStack = new NavPathStack()
  @StorageLink(TOKEN_KEY) token: string = ''
  @State message: string = '登录'
  @State username: string = ''
  @State password: string = ''

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

        Button('登陆')
          .onClick(() => {
            LogUtil.info('登陆')
          })
          .backgroundColor($r('app.color.common_button_background_light'))
          .margin({ bottom: 10 })
          .width('30%')
          .onClick(() => {
            if (this.username && this.password) {
              UserLogin({ email: this.username, password: this.password })
                .then(res => {
                  LogUtil.info('登陆成功')
                  this.token = res.token
                  router.replaceUrl({url:'pages/Index'})
                }).catch((err: Error) => {
                if ('1004: invalid email or password' === err.message) {
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
                    message: `登陆异常: ${err.message}`,
                    confirm: '确定',
                  })
                }
              })
            } else {
              DialogUtil.showConfirmDialog({
                title: '提示',
                message: '请输入用户名密码！',
                confirm: '确定',
              })
            }
          })
      }
    }
    .width('100%')
  }
}