import { systemCategory } from '../http/api';
import { BaseViewModel, ResultCallback } from './BaseViewMode';
export class SystemCategoryViewModel extends BaseViewModel {

  async systemCategory(callback: ResultCallback) {
    await this.request()
      .promise(systemCategory(),true)
      .then((res) => {
        callback(res)
      })
  }
}

let systemCategoryViewModel = new SystemCategoryViewModel()
export default systemCategoryViewModel as SystemCategoryViewModel