import { search } from '../http/api';
import { HomeArticleModel } from '../model/HomeArticleModel';
import { BaseViewModel, ResultCallback } from './BaseViewMode';
export class SearchViewModel extends BaseViewModel {
  private page:number = 0
  private articleModel: HomeArticleModel = new HomeArticleModel()
  /**
   * 搜索
   * @param callback
   */
  async search(isRefresh:boolean,key:string,callback: ResultCallback) {
    if(isRefresh) {
      this.page = 0
      this.articleModel.over = false
    }
    if(this.articleModel.over && false) {
      callback([])
    } else {
      await this.request()
        .promise(search(this.page,key),isRefresh)
        .then((result) => {
          ++this.page
          this.articleModel = result
          callback(this.articleModel.datas)
        })
    }
  }
}
let searchViewModel = new SearchViewModel();
export default searchViewModel as SearchViewModel