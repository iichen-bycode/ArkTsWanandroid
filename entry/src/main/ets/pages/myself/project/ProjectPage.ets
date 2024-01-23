import { ViewStateConstant } from '../../../constants/ViewStateConstant'
import { Article } from '../../../model/ArticleModel'
import { CommonModel } from '../../../model/CommonModel'
import { BarUtils } from '../../../utils/BarUtils'
import { CommonTopBar } from '../../../view/TopBar'
import { ResultCallback } from '../../../viewmodel/BaseViewMode'
import projectViewModel from '../../../viewmodel/ProjectViewModel'
import { ListComponent } from '../../home/component/ListComponent'
import { ItemComponent } from './ItemComponent'
@Entry
@Component
struct ProjectPage {
  @State currentIndex: number = 0
  @State curIndex:number = 0

  @State authorList:CommonModel[] = []
  @State cacheIndex:boolean[] = []
  @State viewState: string = ViewStateConstant.VIEW_STATE_LOADING

  private scroller: Scroller = new Scroller()

  aboutToAppear() {
    projectViewModel.observeState((state) => {
      this.viewState = state
    })

    projectViewModel.projectCategory((res) => {
      this.authorList = res
      let len = this.authorList.length
      if(len > 1) {
        this.cacheIndex = [...Array.from({ length: len }, (_, index) => index === 0)]
      }
    })
  }

  build() {
    Column() {
      CommonTopBar({title:"项目",onCallClick: () => {
        this.scroller.scrollEdge(Edge.Top)
      }})
      Tabs() {
        ForEach(this.authorList,(author:CommonModel, index) => {
          //顶部导航栏内容
          TabContent() {
            if(this.currentIndex == index || this.cacheIndex[index]) {
              ListComponent({onReachEnd: (callback: ResultCallback) => {
                projectViewModel.projectCategoryItemList(false,this.authorList[index].id,(result) => {
                  callback(result)
                })
              },onRefreshing:(callback:ResultCallback) => {
                projectViewModel.projectCategoryItemList(true,this.authorList[index].id,(result) => {
                  callback(result)
                })},viewState: this.viewState,
                itemComponent:(item) => this.itemBuild(item)
              })
            }
          }.tabBar(author.name)
        })
      }
      .onChange((index) => {
        this.currentIndex = index
        this.cacheIndex[index]= true
      })
      //设置导航栏（滚动）
      .barMode(BarMode.Scrollable)
    }.width('100%')
    .padding({top: BarUtils.getToolBarHeight() })
  }

  @Builder itemBuild(item:Article) {
    ItemComponent({item: item})
  }
}