# 首页
    >>> banner
    >>> 置顶文章塞到文章列表前面
    >>> 搜索热词放在搜索框

# 公众号

# 问答 两个tab
    广场 => 添加
    问答 => 添加

# 我的
    积分展示 => 点击查查看积分榜 和 明细
    消息 => 
    收藏 => 
    体系 => 
    项目 => 

```
    import { BaseViewModel } from './BaseViewMode';
    export class RankViewModel extends BaseViewModel{
    
    }
    
    let rankViewModel = new RankViewModel();
    
    export default rankViewModel as RankViewModel;
    
    
  private page:number = 0
  private articleModel: HomeArticleModel = new HomeArticleModel()
  async getSquareData(isRefresh:boolean,callback: ResultCallback) {
    if(isRefresh) {
      this.page = 0
      this.articleModel.over = false
    }
    if(this.articleModel.over && false) {
      callback([])
    } else {
      await this.request()
        .promise(getSquareData(this.page),isRefresh)
        .then((result) => {
          ++this.page
          this.articleModel = result
          callback(this.articleModel.datas)
        })
    }
  }
```

    git config --global http.proxy http://127.0.0.1:1080
    git config --global https.proxy http://127.0.0.1:1080
    
    git config --global --unset http.proxy
    git config --global --unset https.proxy


# 分页模板代码
```
    import { ViewStateConstant } from '../../../constants/ViewStateConstant'
    import { BarUtils } from '../../../utils/BarUtils'
    import { CommonTopBar } from '../../../view/TopBar'
    import { ResultCallback } from '../../../viewmodel/BaseViewMode'
    import messageViewModel from '../../../viewmodel/MessageViewModel'
    import { ListComponent } from '../../home/component/ListComponent'
    @Entry
    @Component
    struct MessagePage {
      @State viewState: string = ViewStateConstant.VIEW_STATE_LOADING
      private scroller: Scroller = new Scroller()
    
      build() {
        Column() {
          CommonTopBar({title:"我的收藏",onCallClick: () => {
            this.scroller.scrollEdge(Edge.Top)
          }})
          ListComponent({onReachEnd: (callback: ResultCallback) => {
            // collectViewModel.getCollectList(false,(result) => {
            //   callback(result)
            // })
          },onRefreshing:(callback:ResultCallback) => {
            // collectViewModel.getCollectList(true,(result) => {
            //   callback(result)
            // })
          },
            viewState:this.viewState,
            scroller: this.scroller,
            itemComponent:(item) => this.itemBuild(item)
          })
        }
        .padding({top: BarUtils.getToolBarHeight()})
        .height('100%')
      }
    
    
      aboutToAppear() {
        messageViewModel.observeState((state) => {
          this.viewState = state
        })
      }
    
      @Builder itemBuild(item:any) {
    
      }
    }
```
