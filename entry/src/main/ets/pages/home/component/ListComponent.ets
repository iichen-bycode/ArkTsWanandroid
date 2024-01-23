import { Article } from '../../../model/ArticleModel'
import { CommonPageModel } from '../../../model/CommonPageModel'
import { ComponentRef } from '../../../utils/ComponentRef'
import { RefreshFooter } from '../../../view/RefreshFooter'
import { StateComponent } from '../../../view/ViewStateComponent'
import { ResultCallback } from '../../../viewmodel/BaseViewMode'
import homeViewModel from '../../../viewmodel/HomeViewModel'
import { ArticleItem } from './ArticleItem'

@Builder function empty(){}

@Component
export struct ListComponent {
  @State modelList: CommonPageModel[] = []
  @State refresh:boolean = false
  @State showEmpty:boolean = false
  @State showLoading:boolean = false
  @Prop viewState: string

  // 外部回调调用组件方法
  ref: ComponentRef<{ change: (Article) => {} }>

  scroller?: Scroller

  onReachEnd: (callback: ResultCallback) => void
  onRefreshing: (callback: ResultCallback) => void

  @Builder itemBuild(model: any,index:number) {}
  @BuilderParam itemComponent: (model: any,index:number) => void = this.itemBuild

  build() {
    StateComponent({viewState: this.viewState,retryCallback: () => this.refreshArticle()}) {
      Refresh({refreshing: $$this.refresh}) {
        List({scroller:this.scroller}) {
          ForEach(this.modelList,(item,index) => {
            ListItem(){
              this.itemComponent(item,index)
            }.shadow({
              radius: $r('app.float.size_4'),
              offsetX: $r('app.float.size_1'),
              offsetY: $r('app.float.size_1'),
              color: $r('app.color.color_999')})
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
                this.modelList = [...this.modelList,...result]
              }
            })
          }
        })
      }
      .onRefreshing(() => this.refreshArticle())
    }
  }

  aboutToAppear() {
    this.refreshArticle()
    this.ref?.export(this.hook())
  }

  hook() {
    return {
      change: (article) => this.modelList = [article,...this.modelList]
    }
  }

  refreshArticle() {
    this.onRefreshing((result) => {
      this.modelList = result
      this.refresh = false
      this.showEmpty = false
      this.showLoading = false
    })
  }
}