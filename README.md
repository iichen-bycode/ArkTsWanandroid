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

    
