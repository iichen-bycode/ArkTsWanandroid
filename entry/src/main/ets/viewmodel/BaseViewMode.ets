import useRequestStatus from '../http/run'
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

  jumpToWebContent() {

  }
}

let baseViewModel = new BaseViewModel()
export default baseViewModel as BaseViewModel

