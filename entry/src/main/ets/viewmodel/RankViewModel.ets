import { getRankList } from '../http/api';
import { RankModel } from '../model/RankModel';
import { BaseViewModel, ResultCallback } from './BaseViewMode';
export class RankViewModel extends BaseViewModel {
  rankModel:RankModel = new RankModel()

  private page:number = 1
  async getRankList(isRefresh:boolean,callback: ResultCallback) {
    if(isRefresh) {
      this.page = 1
      this.rankModel.over = false
    }
    if(this.rankModel.over && false) {
      callback([])
    } else {
      await this.request()
        .promise(getRankList(this.page),isRefresh)
        .then((result) => {
          ++this.page
          this.rankModel = result
          callback(this.rankModel.datas)
        })
    }
  }
}

let rankViewModel = new RankViewModel();

export default rankViewModel as RankViewModel;