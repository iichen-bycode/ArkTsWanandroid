import { systemCategoryItemList } from '../http/api';
import { HomeArticleModel } from '../model/HomeArticleModel';
import { BaseViewModel, ResultCallback } from './BaseViewMode';
export class SystemViewModel extends BaseViewModel {
  private page:number = 0
  private articleModel: HomeArticleModel = new HomeArticleModel()
  async systemCategoryItemList(isRefresh:boolean,id:number,callback: ResultCallback) {
    if(isRefresh) {
      this.page = 0
      this.articleModel.over = false
    }
    if(this.articleModel.over && false) {
      callback([])
    } else {
      await this.request()
        .promise(systemCategoryItemList(id,this.page),isRefresh)
        .then((result) => {
          ++this.page
          this.articleModel = result
          callback(this.articleModel.datas)
        })
    }
  }
}

let systemViewModel = new SystemViewModel()
export default systemViewModel as SystemViewModel