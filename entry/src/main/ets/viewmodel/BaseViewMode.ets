import useRequestStatus from '../http/run'
import { RoutePath } from '../route/RoutePath'
import { Router } from '../route/Router'
import { LoadingDialog } from '../view/LoadingDialog'
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
    return useRequestStatus(state => {
      this.dispatchViewState(state)
    }, value?.checkResult,value?.useSource)
  }

  jumpToWebContent(src:string,title:string) {
    Router.push(RoutePath.WebPage,{
      'src': src,
      'title': title
    })
  }

  loadingTips:string = '加载中...'
  loadingDialogController: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({ loadingTips: this.loadingTips }),
    autoCancel: false,
    gridCount: 2,
  })


  toPage(url:string,params?:{}) {
    Router.push(url,params)
  }
}

let baseViewModel = new BaseViewModel()
export default baseViewModel as BaseViewModel

