import router from '@ohos.router';
import hilog from '@ohos.hilog';
import { StorageKeys } from '../constants/StorageKeys';
import { login } from '../http/api';
import { StorageUtils } from '../utils/StorageUtils';
import showToast from '../utils/ToastUtils';
import { BaseViewModel } from './BaseViewMode';

export class LoginViewModel extends BaseViewModel{
  async login(params:{username:string,password:string}) {
    await this.request({useSource: true})
      .promise(login(params))
      .then(async (res) => {
        if(res.errorCode == 0) {
          await StorageUtils.put(StorageKeys.USER_LOGIN, true)
          showToast("登录成功！")
          router.back()
        }
      })
  }
}

let loginViewModel = new LoginViewModel();

export default loginViewModel as LoginViewModel;