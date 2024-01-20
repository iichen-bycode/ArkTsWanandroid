import { Article } from '../../../model/ArticleModel'
import { RefreshFooter } from '../../../view/RefreshFooter'
import { ResultCallback } from '../../../viewmodel/BaseViewMode'
import homeViewModel from '../../../viewmodel/HomeViewModel'
import { ArticleItem } from './ArticleItem'

@Component
export struct ListComponent {
  @State articleList: Article[] = []
  @State refresh:boolean = false
  @State showEmpty:boolean = false
  @State showLoading:boolean = false

  onReachEnd: (callback: ResultCallback) => void
  onRefreshing: (callback: ResultCallback) => void

  build() {
    Refresh({refreshing: $$this.refresh}) {
      List() {
        ForEach(this.articleList,(item: Article,index:number) => {
          ListItem(){
            ArticleItem({article: item})
          }.shadow({
            radius: $r('app.float.size_2'),
            offsetX: $r('app.float.size_1'),
            offsetY: $r('app.float.size_2'),
            color: $r('app.color.color_666')})
          .backgroundColor($r('app.color.color_white'))
          .borderRadius($r('app.float.size_8'))
          .padding($r('app.float.size_12'))
          .margin({bottom: $r('app.float.size_8'),right: $r('app.float.size_8'),left: $r('app.float.size_8')})
          .onClick(() => {
            homeViewModel.jumpToWebContent(item.link,item.title)
          })
        })
        ListItem() {
          RefreshFooter({ showFooter: this.showLoading,showEmpty: this.showEmpty})
        }
      }
      .listDirection(Axis.Vertical)
      .onReachEnd(() => {
        if(!this.showEmpty) {
          this.showLoading = true
          this.onReachEnd((result) => {
            if(result.length == 0) {
              this.showEmpty = true
            } else {
              this.articleList = [...this.articleList,...result]
            }
          })
        }
      })
    }
    .onRefreshing(() => {
      this.onRefreshing((result) => {
        this.articleList = result
        this.refresh = false
        this.showLoading = false
      })
    })
  }
}