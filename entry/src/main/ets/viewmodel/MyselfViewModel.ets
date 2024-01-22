import { getUnRead, getUserInfo } from '../http/api'
import { UserInfoModel } from '../model/UserInfoModel'
import { BaseViewModel, ResultCallback } from './BaseViewMode'
export class MyViewModel extends BaseViewModel{
  userInfoModel:UserInfoModel = new UserInfoModel()

  async getUserInfo(callback: ResultCallback) {
    await this.request()
      .promise(getUserInfo())
      .then(async (res) => {
        this.userInfoModel = res
        callback(res)
      })
  }

  async getUnRead(callback: ResultCallback) {
    await this.request()
      .promise(getUnRead())
      .then(async (res) => {
        callback(res)
      })
  }
}

let myViewModel = new MyViewModel();

export default myViewModel as MyViewModel;