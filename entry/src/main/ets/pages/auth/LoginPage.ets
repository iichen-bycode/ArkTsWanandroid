import { BarUtils } from '../../utils/BarUtils'
import showToast from '../../utils/ToastUtils'
import { CommonTopBar } from '../../view/TopBar'
import loginViewModel from '../../viewmodel/LoginViewModel'
@Component
@Entry
struct LoginPage {
  @State nickName: string = ''
  @State passwd: string = ''
  /**
   *  $r('app.float.size_12')
   */
  build() {
    Column() {
      CommonTopBar({title:"登录"})
      Column() {
        Image($r('app.media.app_icon'))
          .width($r('app.float.size_150'))
          .margin({bottom: $r('app.float.size_20')})

        TextInput({placeholder:"输入用户名称"})
          .margin({bottom: $r('app.float.size_12')})
          .maxLength(10)
          .fontSize($r('app.float.size_20'))
          .padding({top: $r('app.float.size_15'),bottom: $r('app.float.size_15')})
          .enterKeyType(EnterKeyType.Next)
          .onChange((v) => {
            this.nickName = v
          })

        TextInput({placeholder:"请输入密码"})
          .margin({bottom: $r('app.float.size_30')})
          .type(InputType.Password)
          .maxLength(20)
          .padding({top: $r('app.float.size_15'),bottom: $r('app.float.size_15')})
          .enterKeyType(EnterKeyType.Go)
          .onSubmit(() => {
            this.login()
          })
          .onChange((v) => {
            this.passwd = v
          })

        Button("登录").onClick(() => {
          this.login()
        }).width('40%')
      }.margin($r('app.float.size_12'))
    }
    .padding({top: BarUtils.getToolBarHeight()})
    .height('100%')
  }

  login() {
    if(this.nickName.trim() != '' && this.passwd.trim() != '' ) {
      loginViewModel.login({
        username: this.nickName,
        password: this.passwd
      })
    } else {
      showToast("请输入账号或密码！")
    }
  }
}