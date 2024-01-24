import { MessageModel } from '../../../model/MessageModel'
import { BarUtils } from '../../../utils/BarUtils'
import showDialog from '../../../utils/DialogUtils'
import showToast from '../../../utils/ToastUtils'
import { CommonTopBar } from '../../../view/TopBar'
import { ResultCallback } from '../../../viewmodel/BaseViewMode'
import { MessageViewModel } from '../../../viewmodel/MessageViewModel'
import { ListComponent } from '../../home/component/ListComponent'
@Entry
@Component
struct MessagePage {
  private scroller: Scroller = new Scroller()
  private viewModel = new MessageViewModel()

  build() {
    Column() {
      CommonTopBar({title:"消息列表",onCallClick: () => {
        this.scroller.scrollEdge(Edge.Top)
      }})
      ListComponent({onReachEnd: (callback: ResultCallback) => {
        this.viewModel.getMessageList(false,(result) => {
          callback(result)
        })
      },onRefreshing:(callback:ResultCallback) => {
        this.viewModel.getMessageList(true,(result) => {
          callback(result)
        })
      },
        viewModel:this.viewModel,
        scroller: this.scroller,
        itemComponent:(item) => this.itemBuild(item)
      })
    }
    .padding({top: BarUtils.getToolBarHeight()})
    .height('100%')
  }

  @Builder itemBuild(item:MessageModel) {
    Column() {
      Row() {
        Text(item.tag)
          .fontSize($r('app.float.size_text_14'),)
          .fontColor($r('app.color.color_theme'))
          .borderWidth(1)
          .borderColor($r('app.color.color_theme'))
          .borderRadius($r('app.float.size_4'))
          .padding($r('app.float.size_2'))
          .margin({right: $r('app.float.size_5')})
        Text(`${item.fromUser}`)
          .fontColor('#3399EA')
          .fontWeight(FontWeight.Medium)
          .margin({left: $r('app.float.size_2')})
      }
      Text(item.title)
        .fontColor($r('app.color.color_666'))
        .fontSize($r('app.float.size_14'))
        .margin({top: $r('app.float.size_6')})
      Text(item.message)
        .fontColor($r('app.color.color_black'))
        .fontSize($r('app.float.size_16'))
        .margin({top: $r('app.float.size_5'),bottom: $r('app.float.size_5')})
      Row() {
        Text(item.niceDate)
          .fontColor($r('app.color.color_999'))
          .fontSize($r('app.float.size_14'))
        Text("删除")
          .fontColor($r('app.color.color_666'))
          .fontSize($r('app.float.size_14'))
          .decoration({
            type:TextDecorationType.Underline
          })
          .onClick(() => {
            showDialog({
              title:'提示',
              message:"确定删除吗？",
              onConfirm:() => {
                showToast("删除")
            }})
          })
      }.justifyContent(FlexAlign.SpaceBetween).width('100%')
    }
    .onClick(() => {
      this.viewModel.jumpToWebContent(item.fullLink,"问题详情")
    })
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .padding($r('app.float.size_10'))
  }
}