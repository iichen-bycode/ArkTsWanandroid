import { ViewStateConstant } from '../../../constants/ViewStateConstant'
import { UserInfoModel } from '../../../model/UserInfoModel'
import { BarUtils } from '../../../utils/BarUtils'
import showToast from '../../../utils/ToastUtils'
import { RefreshFooter } from '../../../view/RefreshFooter'
import { CommonTopBar } from '../../../view/TopBar'
import { StateComponent } from '../../../view/ViewStateComponent'
import { ResultCallback } from '../../../viewmodel/BaseViewMode'
import RankViewModel from '../../../viewmodel/RankViewModel'
import { ListComponent } from '../../home/component/ListComponent'
@Component
@Entry
export struct RankPage {
  @State viewState: string = ViewStateConstant.VIEW_STATE_LOADING
  private scroller: Scroller = new Scroller()

  aboutToAppear() {
    RankViewModel.observeState((state) => {
      this.viewState = state
    })
  }

  getIcon(index:number) {
    if(index == 0)
      return $r('app.media.icon_first')
    if(index == 1)
      return $r('app.media.icon_second')
    return $r('app.media.icon_third')
  }

  build() {
    Column() {
      CommonTopBar({title:"全站积分排行榜",onCallClick: () => {
        this.scroller.scrollEdge(Edge.Top)
      }})
      ListComponent({onReachEnd: (callback: ResultCallback) => {
        RankViewModel.getRankList(false,(result) => {
          callback(result)
        })
      },onRefreshing:(callback:ResultCallback) => {
        RankViewModel.getRankList(true,(result) => {
          callback(result)
        })},
        viewState:this.viewState,
        scroller: this.scroller,
        itemComponent:(item,index) => this.itemBuild(item,index)
      })
    }.padding({top: BarUtils.getToolBarHeight()})
  }


  @Builder itemBuild(item:UserInfoModel,index:number) {
    Row() {
      Row() {
        if(index < 3) {
          Image(this.getIcon(index)).width(24).height(24)
        } else {
          Row() {
            Text(`${index}`).align(Alignment.Center).fontColor($r('app.color.color_999'))
          }.width(24).justifyContent(FlexAlign.Center)
        }
        Text(item.username).padding({left: 10})
      }
      Text(`${item.coinCount}`)
        .fontColor($r('app.color.color_theme'))
        .fontSize($r('app.float.size_14'))
    }.width('100%').justifyContent(FlexAlign.SpaceBetween)

  }
}