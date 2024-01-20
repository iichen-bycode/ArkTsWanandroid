import router from '@ohos.router'
import { BarUtils } from '../../utils/BarUtils'
import { ResultCallback } from '../../viewmodel/BaseViewMode'
import searchViewModel from '../../viewmodel/SearchViewModel'
import { ListComponent } from '../home/component/ListComponent'
@Component
@Entry
export struct SearchPage {
  @State searchKey:string = router.getParams()['key']

  build() {
    Column(){
      // 列表
      ListComponent({onReachEnd: (callback: ResultCallback) => {
        searchViewModel.search(false,this.searchKey,(result) => {
          callback(result)
        })
      },onRefreshing:(callback:ResultCallback) => {
        searchViewModel.search(true,this.searchKey,(result) => {
          callback(result)
        })}
    })
   }.padding({top: BarUtils.getToolBarHeight()})
  }
}