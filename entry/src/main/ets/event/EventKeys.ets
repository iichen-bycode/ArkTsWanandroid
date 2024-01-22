/**
 * 事件的EventNum
 */
export class EventKeys {
  //展示loading的事件处理EventID
  static readonly LOADING_DIALOG_EVENT = 0x10000
  static readonly ON_MAIN_PAGE_HIDE = 0x10001
  static readonly ON_MAIN_PAGE_SHOW = 0x10002
  static readonly LOGIN_OUT = 0x10003
  static readonly LOGIN_IN = 0x10004
}

/**
 * 对应的事件
 */
export const loadingEvent = {
  eventId: EventKeys.LOADING_DIALOG_EVENT
}

export const mainPageShow = {
  eventId: EventKeys.ON_MAIN_PAGE_SHOW,
}

export const mainPageHide = {
  eventId: EventKeys.ON_MAIN_PAGE_HIDE,
}

export const loginOut = {
  eventId: EventKeys.LOGIN_OUT,
}

export const loginIn = {
  eventId: EventKeys.LOGIN_IN,
}

