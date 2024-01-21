import { wxAuthorArticleList, wxAuthorList, wxAuthorSearchArticleList } from '../http/api';
import { HomeArticleModel } from '../model/HomeArticleModel';
import { BaseViewModel, ResultCallback } from './BaseViewMode';
export class AuthorViewModel extends BaseViewModel {
  async wxAuthorList(callback: ResultCallback) {
    await this.request()
      .promise(wxAuthorList(),true)
      .then((res) => {
        callback(res)
      })
  }

  private page:number = 0
  private articleModel: HomeArticleModel = new HomeArticleModel()
  async wxAuthorArticleList(isRefresh:boolean,id:number,callback: ResultCallback) {
    if(isRefresh) {
      this.page = 0
      this.articleModel.over = false
    }
    if(this.articleModel.over && false) {
      callback([])
    } else {
      await this.request()
        .promise(wxAuthorArticleList(id,this.page),false)
        .then((result) => {
          ++this.page
          this.articleModel = result
          callback(this.articleModel.datas)
        })
    }
  }
}

let authorViewModel = new AuthorViewModel()
export default authorViewModel as AuthorViewModel