import axios from '@ohos/axios'
import { ViewStateConstant } from '../constants/ViewStateConstant'
import { JsonUtils } from '../utils/JsonUtils'
type LoadStateResult = {
  promise: <T>(requestPromise: Promise<T>, showLoadingState?: boolean) => Promise<T>
}

export interface BaseResponse {
  //wanAndroid-API响应体
  errorCode: number
  errorMsg: string
  //拓展xxx-API响应体
}
export interface ApiResponse<T = any> extends BaseResponse {
  //wanAndroid-API响应体
  data: T | any;
  //拓展xxx-API响应体
}


const useRequestStatus = (stateCallback?: (state: string) => void, checkResult: boolean = false): LoadStateResult => {

  function updateViewState(state: string) {
    stateCallback?.(state)
  }

  function run<T>(requestPromise: Promise<T>, showLoadingState: boolean): Promise<T> {
    if (showLoadingState !== false) {
      updateViewState(ViewStateConstant.VIEW_STATE_LOADING)
    }
    return new Promise<T>((resolve, reject) => {
      requestPromise.then((res) => {
        const result = res as unknown as ApiResponse;
        const resultData = result.data;
        if (checkResult) {
          if (result.errorCode !== 0) {
            updateViewState(ViewStateConstant.VIEW_STATE_ERROR)
          } else if (Array.isArray(resultData) && resultData.length === 0) {
            updateViewState(ViewStateConstant.VIEW_STATE_EMPTY)
          } else {
            updateViewState(ViewStateConstant.VIEW_STATE_SUCCESS)
          }
        } else {
          updateViewState(ViewStateConstant.VIEW_STATE_SUCCESS)
        }
        resolve(resultData);
      }).catch((error) => {
        if (axios.isAxiosError(error)) {
          updateViewState(ViewStateConstant.VIEW_STATE_NETWORK_ERROR)
        } else {
          updateViewState(ViewStateConstant.VIEW_STATE_ERROR)
        }
        reject(error);
      })
    })
  }

  return { promise: run };
}

export default useRequestStatus;