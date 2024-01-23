import router from '@ohos.router'
import { ViewStateConstant } from '../../../constants/ViewStateConstant'
import { Article } from '../../../model/ArticleModel'
import { CommonModel } from '../../../model/CommonModel'
import { SystemModel } from '../../../model/SystemModel'
import { BarUtils } from '../../../utils/BarUtils'
import { CommonTopBar } from '../../../view/TopBar'
import { ResultCallback } from '../../../viewmodel/BaseViewMode'
import systemViewModel from '../../../viewmodel/SystemViewModel'
import { ArticleItem } from '../../home/component/ArticleItem'
import { ListComponent } from '../../home/component/ListComponent'
@Entry
@Component
struct SystemPage {
  @State currentIndex: number = 0
  @State curIndex:number = 0

  @State authorList:SystemModel[] = router.getParams()['category_list'] || []
  @State title:string = router.getParams()['category_title'] || ''
  @State cacheIndex:boolean[] = []
  @State viewState: string = ViewStateConstant.VIEW_STATE_LOADING

  private scroller: Scroller = new Scroller()

  aboutToAppear() {
    systemViewModel.observeState((state) => {
      this.viewState = state
    })

    let len = this.authorList.length
    if(len > 1) {
      this.cacheIndex = [...Array.from({ length: len }, (_, index) => index === 0)]
    }
  }

  build() {
    Column() {
      CommonTopBar({title:this.title,onCallClick: () => {
        this.scroller.scrollEdge(Edge.Top)
      }})
      Tabs() {
        ForEach(this.authorList,(author:CommonModel, index) => {
          //顶部导航栏内容
          TabContent() {
            if(this.currentIndex == index || this.cacheIndex[index]) {
              ListComponent({onReachEnd: (callback: ResultCallback) => {
                systemViewModel.systemCategoryItemList(false,this.authorList[index].id,(result) => {
                  callback(result)
                })
              },onRefreshing:(callback:ResultCallback) => {
                systemViewModel.systemCategoryItemList(true,this.authorList[index].id,(result) => {
                  callback(result)
                })},viewState: this.viewState,
                itemComponent:(item) => this.itemBuild(item)
              })
            }
          }.tabBar(`${author.name}`)
        })
      }
      .onChange((index) => {
        this.currentIndex = index
        this.cacheIndex[index]= true
      })
      //设置导航栏（滚动）
      .barMode(BarMode.Scrollable)
    }.width('100%')
    .height('100%')
    .padding({top: BarUtils.getToolBarHeight() })
  }

  @Builder itemBuild(item:Article) {
    ArticleItem({ article:item })
  }
}