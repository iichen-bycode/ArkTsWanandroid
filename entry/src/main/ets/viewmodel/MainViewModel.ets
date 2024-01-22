import emitter from '@ohos.events.emitter'
import { StorageKeys } from '../constants/StorageKeys'
import { loginOut } from '../event/EventKeys'
import { StorageUtils } from '../utils/StorageUtils'
import showToast from '../utils/ToastUtils'
export class MainViewModel {
  // 框架支持cookie持久化后去除
  sessionId:string = ''


  /**
   * 首页底部Tab显示数据
   */
  tabTitle = [
    {
      index: 0,
      title: "首页",
      imageActivated: $r('app.media.icon_sel_home'),
      imageOriginal: $r('app.media.icon_unsel_home')
    },
    {
      index: 1,
      title: "公众号",
      imageActivated: $r('app.media.icon_sel_find'),
      imageOriginal: $r('app.media.icon_unsel_find')
    },
    {
      index: 2,
      title: "项目",
      imageActivated: $r('app.media.icon_sel_hot'),
      imageOriginal: $r('app.media.icon_unsel_hot')
    },
    {
      index: 3,
      title: "我的",
      imageActivated: $r('app.media.icon_sel_mine'),
      imageOriginal: $r('app.media.icon_unsel_mine')
    }
  ]

  logout() {
    this.sessionId = ''
    emitter.emit(loginOut,{})
    // 登录凭证cookie后续删除
    StorageUtils.put(StorageKeys.USER_INFO_KEY, "")
    // 是否之前登录的标识
    StorageUtils.put(StorageKeys.USER_LOGIN, false)
    showToast("注销成功~")
  }
}

let mainViewModel = new MainViewModel();

export default mainViewModel as MainViewModel;