import { getHomeBanner } from '../http/api';
import { BaseViewModel, ResultCallback } from './BaseViewMode';

export class HomeViewModel extends BaseViewModel{
  async getHomeBanner(callback: ResultCallback) {
    await this.request()
      .promise(getHomeBanner())
      .then((result) => {
        callback(result)
      })
  }
}

let homeViewModel = new HomeViewModel();

export default homeViewModel as HomeViewModel;