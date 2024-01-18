import router from '@ohos.router'
import showToast from '../utils/ToastUtils';

export class Router {
  static push(url: string, params?: Object) {
    router.pushUrl({ url: url, params: params }, router.RouterMode.Standard, (err) => {
      if (err) {
        showToast(err.message)
        return;
      }
    })
  }
}