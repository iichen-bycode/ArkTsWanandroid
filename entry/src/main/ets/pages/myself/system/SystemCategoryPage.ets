import { SystemModel } from '../../../model/SystemModel'
import { RoutePath } from '../../../route/RoutePath'
import { Router } from '../../../route/Router'
import { BarUtils } from '../../../utils/BarUtils'
import { CommonTopBar } from '../../../view/TopBar'
import systemCategoryViewModel from '../../../viewmodel/SystemCategoryViewModel'
@Entry
@Component
struct SystemCategoryPage {
  private scroller: Scroller = new Scroller()
  @State systemModel:SystemModel[] = []

  aboutToAppear() {
    systemCategoryViewModel.systemCategory((res) => {
      this.systemModel = res || []
    })
  }

  build() {
    Column() {
      CommonTopBar({title:"体系",onCallClick: () => {
        this.scroller.scrollEdge(Edge.Top)
      }})
      List({space: 10}) {
        ForEach(this.systemModel,(parent:SystemModel,_) => {
          ListItem() {
            Column() {
              Row() {
                Column() {
                  Text(parent.name)
                    .fontSize(16)
                  Flex({wrap: FlexWrap.Wrap}) {
                    ForEach(parent.children,(model:SystemModel,_) => {
                      Text(model.name)
                        .fontSize(12)
                        .fontColor($r('app.color.color_666'))
                        .margin({right: 8,bottom:2})
                    })
                  }.constraintSize({
                    maxWidth: '85%'
                  })
                  .margin({top: 6})
                }.flexGrow(1)
                .alignItems(HorizontalAlign.Start)
                Image($r('app.media.icon_arrow')).width(18)
              }
              Line()
                .margin({top: 8})
                .backgroundColor($r('app.color.color_e0e0e0'))
                .width('100%')
                .height($r('app.float.size_1'))
            }
          }.onClick(() => {
            systemCategoryViewModel.toPage(RoutePath.SystemPage,{
              'category_list':parent.children,
              'category_title':parent.name
            })
          })
        })
      }.padding({ top: 12 })
    }
    .padding({top: BarUtils.getToolBarHeight()})
    .height('100%')
  }
}