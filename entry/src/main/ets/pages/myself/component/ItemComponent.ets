import { UserInfoModel } from '../../../model/UserInfoModel'
import { RoutePath } from '../../../route/RoutePath'
import { Router } from '../../../route/Router'
import showToast from '../../../utils/ToastUtils'
import mainViewModel from '../../../viewmodel/MainViewModel'
@Component
export struct ItemComponent {
  @Prop unRead:number
  @Consume userInfoModel:UserInfoModel

  private moduleList:Item[] = [
    {
      tip: "消息",
      icon: $r('app.media.icon_message')
    },
    {
      tip: "收藏",
      icon: $r('app.media.icon_collect')
    },
    {
      tip: "体系",
      icon: $r('app.media.icon_category')
    },
    {
      tip: "项目",
      icon: $r('app.media.icon_project')
    },
    {
      tip: "注销",
      icon: $r('app.media.icon_logout')
    },
  ]

  build() {
    Column() {
      ForEach(this.moduleList,(module:Item,index:number) => {
        Row() {
          Row() {
            Image(module.icon)
              .width($r('app.float.size_28'))
              .height($r('app.float.size_22'))
              .margin({right: $r('app.float.size_10')})
            Text(module.tip).fontSize($r('app.float.size_16'))
          }
          Row() {
            Stack(){
              Circle()
                .width(20)
                .height(20)
                .fill(Color.Red)
              Text(`${this.unRead || 0}`)
                .fontSize($r('app.float.size_12'))
                .padding($r('app.float.size_4'))
                .fontColor($r('app.color.color_white'))
            }.visibility((index === 0 && (this.unRead || 0 > 0)) ? Visibility.Visible : Visibility.Hidden)
            Image($r('app.media.icon_arrow'))
              .width($r('app.float.size_20'))
              .height($r('app.float.size_22'))
          }
        }.justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
        .margin({bottom: $r('app.float.size_16')})
        .backgroundColor($r('app.color.color_white'))
        .padding($r('app.float.size_12'))
        .borderRadius($r('app.float.size_12'))
        .shadow({
          radius: $r('app.float.size_6'),
          offsetY: $r('app.float.size_1'),
          color: $r('app.color.color_e0e0e0')})
        .onClick(() => {
          switch (index) {
            case 0: {
              this.toJump(RoutePath.MessagePage);
            }break;
            case 1: {
              this.toJump(RoutePath.CollectPage);
            }break;
            case 2: {

            }break;
            case 3: {

            }break;
            case 4: {
              if(this.userInfoModel.userId !== undefined) {
                mainViewModel.logout()
              }
            }break;
          }
        })
      })
    }
  }

  toJump(router:string) {
    if(this.userInfoModel.userId === undefined) {
      showToast("请登录后查看~")
      setTimeout(() => {
        Router.push(RoutePath.LoginPage)
      },1200)
    } else {
      Router.push(router)
    }
  }
}
class Item {
  tip: string;
  icon:Resource
}