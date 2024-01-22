import { ViewStateConstant } from '../../../constants/ViewStateConstant'
import { UserInfoModel } from '../../../model/UserInfoModel'
import { BarUtils } from '../../../utils/BarUtils'
import showToast from '../../../utils/ToastUtils'
import { RefreshFooter } from '../../../view/RefreshFooter'
import { CommonTopBar } from '../../../view/TopBar'
import { StateComponent } from '../../../view/ViewStateComponent'
import RankViewModel from '../../../viewmodel/RankViewModel'
@Component
@Entry
export struct RankPage {
  @State viewState: string = ViewStateConstant.VIEW_STATE_LOADING
  @State rankModelList:UserInfoModel[] = []

  @State refresh:boolean = false
  @State showEmpty:boolean = false
  @State showLoading:boolean = false

  aboutToAppear() {
    RankViewModel.getRankList(true,(res) => {
      this.rankModelList = res
    })
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
      CommonTopBar({title:"全站积分排行榜"})
      StateComponent({viewState: this.viewState,retryCallback: () => {
        RankViewModel.getRankList(true,(res) => {
          this.rankModelList = res
        })
      }}) {
        Column() {
          Refresh({refreshing: $$this.refresh}) {
            List() {
              ForEach(this.rankModelList,(item: UserInfoModel,index:number) => {
                ListItem(){
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
                }.shadow({
                  radius: $r('app.float.size_4'),
                  offsetX: $r('app.float.size_1'),
                  offsetY: $r('app.float.size_1'),
                  color: $r('app.color.color_999')})
                .backgroundColor($r('app.color.color_white'))
                .borderRadius($r('app.float.size_8'))
                .padding($r('app.float.size_12'))
                .margin({bottom: $r('app.float.size_8'),right: $r('app.float.size_8'),left: $r('app.float.size_8')})
              })
              ListItem() {
                RefreshFooter({ showFooter: this.showLoading,showEmpty: this.showEmpty})
              }
            }
            .listDirection(Axis.Vertical)
            .onReachEnd(() => {
              if(!this.showEmpty) {
                this.showLoading = true
                RankViewModel.getRankList(false,(result) => {
                  if(result.length == 0) {
                    this.showEmpty = true
                  } else {
                    this.rankModelList = [...this.rankModelList,...result]
                  }
                })
              }
            })
          }
          .onRefreshing(() => {
            RankViewModel.getRankList(true,(result) => {
              this.rankModelList = result
              this.refresh = false
              this.showEmpty = false
              this.showLoading = false
            })
          })
        }
      }
    }.padding({top: BarUtils.getToolBarHeight()})
  }
}