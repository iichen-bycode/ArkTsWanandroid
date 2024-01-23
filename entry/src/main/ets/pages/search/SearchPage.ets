import router from '@ohos.router'
import { StorageKeys } from '../../constants/StorageKeys'
import { ViewStateConstant } from '../../constants/ViewStateConstant'
import { BarUtils } from '../../utils/BarUtils'
import { CommonTopBar } from '../../view/TopBar'
import { ResultCallback } from '../../viewmodel/BaseViewMode'
import searchViewModel from '../../viewmodel/SearchViewModel'
import { ArticleItem } from '../home/component/ArticleItem'
import { ListComponent } from '../home/component/ListComponent'

@Component
@Entry
export struct SearchPage {
  @State searchKey:string = router.getParams()['key']
  @State authorId:number = router.getParams()['author_id']
  @State viewState: string = ViewStateConstant.VIEW_STATE_LOADING
  @State searchType: string = router.getParams()['search_type'] || StorageKeys.SEARCH_TYPE_HOME

  aboutToAppear() {
    searchViewModel.observeState((state) => {
      this.viewState = state
    })
  }

  build() {
    Column(){
      CommonTopBar({title:'搜索'})
      // 列表
      ListComponent({onReachEnd: (callback: ResultCallback) => {
        searchViewModel.search(false,this.searchKey,(result) => {
          callback(result)
        },this.searchType,this.authorId)
      },onRefreshing:(callback:ResultCallback) => {
        searchViewModel.search(true,this.searchKey,(result) => {
          callback(result)
        },this.searchType,this.authorId)},viewState: this.viewState,itemComponent:(item) => this.itemBuild(item)
    }).margin({top: $r('app.float.size_12'),right: $r('app.float.size_8'),left: $r('app.float.size_8')})
   }.padding({top: BarUtils.getToolBarHeight()})
  }

  @Builder itemBuild(item:any) {
    ArticleItem({article: item})
  }
}