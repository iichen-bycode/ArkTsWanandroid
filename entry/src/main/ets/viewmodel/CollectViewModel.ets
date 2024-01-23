import { addCollect, getCollectList } from '../http/api';
import { HomeArticleModel } from '../model/HomeArticleModel';
import { BaseViewModel, ResultCallback } from './BaseViewMode';
export class CollectViewModel extends BaseViewModel {
  collectModel:HomeArticleModel = new HomeArticleModel()

  private page:number = 0
  async getCollectList(isRefresh:boolean,callback: ResultCallback) {
    if(isRefresh) {
      this.page = 0
      this.collectModel.over = false
    }
    if(this.collectModel.over && false) {
      callback([])
    } else {
      await this.request()
        .promise(getCollectList(this.page),isRefresh)
        .then((result) => {
          ++this.page
          this.collectModel = result
          this.collectModel.datas.forEach((model) => model.collect = true)
          callback(this.collectModel.datas)
        })
    }
  }

  async addCollect(params: {title:string,author:string,link:string},callback: ResultCallback) {
    await this.request()
      .promise(addCollect(params),false)
      .then((result) => {
        callback(result)
      })
  }


}

let collectViewModel = new CollectViewModel();

export default collectViewModel as CollectViewModel;