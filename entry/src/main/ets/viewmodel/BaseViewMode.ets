import useRequestStatus from '../http/run'
import { RoutePath } from '../route/RoutePath'
import { Router } from '../route/Router'
export type StateCallback = (state: string) => void

export type ResultCallback = (result: any) => void

export class BaseViewModel {
  private stateCallback?: StateCallback

  observeState(stateCallback: StateCallback) {
    this.stateCallback = stateCallback
  }

  dispatchViewState(state: string) {
    this.stateCallback?.(state)
  }

  request(value?: {checkResult?: boolean,useSource?: boolean}) {
    return useRequestStatus(state => this.dispatchViewState(state), value?.checkResult,value?.useSource)
  }

  jumpToWebContent(src:string,title:string) {
    Router.push(RoutePath.WebPage,{
      'src': src,
      'title': title
    })
  }
}

let baseViewModel = new BaseViewModel()
export default baseViewModel as BaseViewModel

