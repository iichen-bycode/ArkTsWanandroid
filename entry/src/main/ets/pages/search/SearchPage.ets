import router from '@ohos.router'
import { StorageKeys } from '../../constants/StorageKeys'
import { BarUtils } from '../../utils/BarUtils'
import { CommonTopBar } from '../../view/TopBar'
import { ResultCallback } from '../../viewmodel/BaseViewMode'
import { SearchViewModel } from '../../viewmodel/SearchViewModel'
import { ArticleItem } from '../home/component/ArticleItem'
import { ListComponent } from '../home/component/ListComponent'

@Component
@Entry
export struct SearchPage {
  @State searchKey:string = router.getParams()['key']
  @State authorId:number = router.getParams()['author_id']
  @State searchType: string = router.getParams()['search_type'] || StorageKeys.SEARCH_TYPE_HOME

  private viewModel = new SearchViewModel()

  build() {
    Column(){
      CommonTopBar({title:'搜索'})
      // 列表
      ListComponent({onReachEnd: (callback: ResultCallback) => {
        this.viewModel.search(false,this.searchKey,(result) => {
          callback(result)
        },this.searchType,this.authorId)
      },onRefreshing:(callback:ResultCallback) => {
        this.viewModel.search(true,this.searchKey,(result) => {
          callback(result)
        },this.searchType,this.authorId)},viewModel:this.viewModel,itemComponent:(item) => this.itemBuild(item)
    }).margin({top: $r('app.float.size_12'),right: $r('app.float.size_8'),left: $r('app.float.size_8')})
   }.padding({top: BarUtils.getToolBarHeight()})
  }

  @Builder itemBuild(item:any) {
    ArticleItem({article: item})
  }
}