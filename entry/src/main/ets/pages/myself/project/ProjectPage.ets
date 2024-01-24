import { Article } from '../../../model/ArticleModel'
import { CommonModel } from '../../../model/CommonModel'
import { BarUtils } from '../../../utils/BarUtils'
import { CommonTopBar } from '../../../view/TopBar'
import { ResultCallback } from '../../../viewmodel/BaseViewMode'
import projectViewModel, { ProjectViewModel } from '../../../viewmodel/ProjectViewModel'
import { ListComponent } from '../../home/component/ListComponent'
import { ItemComponent } from './ItemComponent'
@Entry
@Component
struct ProjectPage {
  @State currentIndex: number = 0
  @State curIndex:number = 0

  @State authorList:CommonModel[] = []
  @State cacheIndex:boolean[] = []

  private scroller: Scroller = new Scroller()

  aboutToAppear() {
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
              ListComponent({onReachEnd: (callback: ResultCallback,viewModel:ProjectViewModel) => {
                viewModel.projectCategoryItemList(false,this.authorList[index].id,(result) => {
                  callback(result)
                })
              },onRefreshing:(callback:ResultCallback,viewModel:ProjectViewModel) => {
                viewModel.projectCategoryItemList(true,this.authorList[index].id,(result) => {
                  callback(result)
                })},viewModel: new ProjectViewModel(),
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