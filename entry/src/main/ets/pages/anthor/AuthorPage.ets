import { StorageKeys } from '../../constants/StorageKeys'
import { ViewStateConstant } from '../../constants/ViewStateConstant'
import { CommonModel } from '../../model/CommonModel'
import { RoutePath } from '../../route/RoutePath'
import { BarUtils } from '../../utils/BarUtils'
import showToast from '../../utils/ToastUtils'
import authorViewModel from '../../viewmodel/AuthorViewModel'
import { ResultCallback } from '../../viewmodel/BaseViewMode'
import { ArticleItem } from '../home/component/ArticleItem'
import { ListComponent } from '../home/component/ListComponent'
@Component
@Preview
export struct AuthorPage {
  @State currentIndex: number = 0
  @State searchKey:string = ''
  @State curIndex:number = 0
  private authorId:number = 0

  @State authorList:CommonModel[] = []
  @State cacheIndex:boolean[] = []
  @State viewState: string = ViewStateConstant.VIEW_STATE_LOADING

  build() {
    Column() {
      Row() {
        Search()
          .onSubmit((v) => {
            if (v.trim() === '') {
              showToast("请输入搜索内容！")
            } else {
              authorViewModel.toPage(RoutePath.SearchPage, {
                'search_type': StorageKeys.SEARCH_TYPE_WX,
                'key': this.searchKey,
                'author_id': this.authorId
              })
            }
          })
          .searchButton("搜索")
          .onChange((v) => {
            this.searchKey = v
          })
      }.padding({ left: $r('app.float.size_10'), right: $r('app.float.size_10'),})
      Tabs() {
        ForEach(this.authorList,(author:CommonModel, index) => {
          //顶部导航栏内容
          TabContent() {
            if(this.currentIndex == index || this.cacheIndex[index]) {
              ListComponent({onReachEnd: (callback: ResultCallback) => {
                authorViewModel.wxAuthorArticleList(false,this.authorList[index].id,(result) => {
                  callback(result)
                })
              },onRefreshing:(callback:ResultCallback) => {
                authorViewModel.wxAuthorArticleList(true,this.authorList[index].id,(result) => {
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
        this.authorId = this.authorList[index].id
      })
      //设置导航栏（滚动）
      .barMode(BarMode.Scrollable)
    }.width('100%')
    .padding({top: BarUtils.getToolBarHeight() })
  }

  @Builder itemBuild(item:any) {
    ArticleItem({article: item})
  }

  aboutToAppear() {
    authorViewModel.observeState((state) => {
      this.viewState = state
    })

    authorViewModel.wxAuthorList((res) => {
      this.authorList = res
      let len = this.authorList.length
      if(len > 1) {
        this.cacheIndex = [...Array.from({ length: len }, (_, index) => index === 0)]
        this.authorId = this.authorList[0].id
      }
    })
  }
}