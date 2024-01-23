import emitter from '@ohos.events.emitter'
import { loginIn, loginOut, mainPageShow } from '../../event/EventKeys'
import { UserInfoModel } from '../../model/UserInfoModel'
import { RoutePath } from '../../route/RoutePath'
import { BarUtils } from '../../utils/BarUtils'
import showToast from '../../utils/ToastUtils'
import myViewModel from '../../viewmodel/MyselfViewModel'
import { ItemComponent } from './component/ItemComponent'
@Component
@Entry
export struct MyselfPage {
  @Provide userInfoModel:UserInfoModel = new UserInfoModel()
  @State unRead:number = 0

  aboutToAppear() {
    this.getUserInfo()
    emitter.on(loginIn,(_) => {
      this.getUserInfo()
    })
    emitter.on(loginOut,(_) => {
      this.userInfoModel = new UserInfoModel()
      myViewModel.userInfoModel = new UserInfoModel()
    })

  }
  private getUserInfo() {
    myViewModel.getUserInfo((res) => {
      this.userInfoModel = res
    })
    myViewModel.getUnRead((res) => {
      this.unRead = res
    })

  }

  build() {
    Stack({alignContent: Alignment.Top}) {
      Image($r('app.media.header')).height((BarUtils.getToolBarHeight() || 0) + 200).width('100%').objectFit(ImageFit.Fill)
      Column() {
        Row() {
          Image($r('app.media.icon_rank'))
            .width($r('app.float.size_20'))
            .onClick(() => {
              if(this.userInfoModel.userId === undefined) {
                showToast("请登录后查看~")
                myViewModel.toPageDelay(RoutePath.LoginPage)
              } else {
                myViewModel.toPage(RoutePath.RankPage)
              }
            })
        }
        .margin({top: BarUtils.getToolBarHeight()})
        .justifyContent(FlexAlign.End).width('100%')
        Image($r('app.media.icon_avatar'))
          .width($r('app.float.size_130'))
        Text(){
          Span(`积分:${this.userInfoModel.coinCount || '未登录'}`)
            .fontColor($r('app.color.color_f5f5f5'))
            .fontSize($r('app.float.size_12'))
          Span(`  等级:${this.userInfoModel.level || '未登录'}`)
            .fontColor($r('app.color.color_f5f5f5'))
            .fontSize($r('app.float.size_12'))
        }
        ItemComponent({unRead: this.unRead }).margin({top: $r('app.float.size_50')})
      }
      .padding($r('app.float.size_12'))
      .width('100%').height('100%')
      .alignItems(HorizontalAlign.Center)
    }.width('100%').height('100%').backgroundColor($r('app.color.color_f6f6f6'))
  }
}