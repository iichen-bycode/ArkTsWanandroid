import { StatusBarManager } from './StatusBarManager';
export class BarUtils {
  static getToolBarHeight() {
    return px2vp(StatusBarManager.get().getSystemBarOffset());
  }
}
