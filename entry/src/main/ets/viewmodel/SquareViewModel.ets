import { getSquareData, shareArticle, wxAuthorArticleList, wxAuthorList, wxAuthorSearchArticleList } from '../http/api';
import { HomeArticleModel } from '../model/HomeArticleModel';
import { BaseViewModel, ResultCallback } from './BaseViewMode';
export class SquareViewModel extends BaseViewModel {
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

  async shareArticle(title:string,link:string) {
    await this.request()
      .promise(shareArticle(title,link),false)
  }
}

let squareViewModel = new SquareViewModel()
export default squareViewModel as SquareViewModel