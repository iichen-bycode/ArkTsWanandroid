import { askQuestion, getWendaData } from '../http/api';
import { HomeArticleModel } from '../model/HomeArticleModel';
import { BaseViewModel, ResultCallback } from './BaseViewMode';
export class WenDaViewModel extends BaseViewModel {
  private page:number = 1
  private articleModel: HomeArticleModel = new HomeArticleModel()
  async getWendaData(isRefresh:boolean,callback: ResultCallback) {
    if(isRefresh) {
      this.page = 1
      this.articleModel.over = false
    }
    if(this.articleModel.over && false) {
      callback([])
    } else {
      await this.request()
        .promise(getWendaData(this.page),isRefresh)
        .then((result) => {
          ++this.page
          this.articleModel = result
          callback(this.articleModel.datas)
        })
    }
  }

  async askQuestion(content:string) {
    await this.request()
      .promise(askQuestion(content),false)
  }
}

let wenDaViewModel = new WenDaViewModel()
export default wenDaViewModel as WenDaViewModel