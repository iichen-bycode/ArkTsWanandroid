import axios from '@ohos/axios'
import hilog from '@ohos.hilog'
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


const useRequestStatus = (stateCallback?: (state: string) => void, checkResult: boolean = false, useSource: boolean = false): LoadStateResult => {

  function updateViewState(state: string, showLoadingState: boolean = false) {
    if(showLoadingState)
      stateCallback?.(state)
  }

  function run<T>(requestPromise: Promise<T>, showLoadingState: boolean): Promise<T> {
    if (showLoadingState !== false) {
      updateViewState(ViewStateConstant.VIEW_STATE_LOADING,showLoadingState)
    }
    return new Promise<T>((resolve, reject) => {
      requestPromise.then((res) => {
        const result = res as unknown as ApiResponse;
        const resultData = result.data;
        if (checkResult) {
          if (result.errorCode !== 0) {
            updateViewState(ViewStateConstant.VIEW_STATE_ERROR,showLoadingState)
          } else if (Array.isArray(resultData) && resultData.length === 0) {
            updateViewState(ViewStateConstant.VIEW_STATE_EMPTY,showLoadingState)
          } else {
            updateViewState(ViewStateConstant.VIEW_STATE_SUCCESS,showLoadingState)
          }
        } else {
          updateViewState(ViewStateConstant.VIEW_STATE_SUCCESS,showLoadingState)
        }
        resolve(useSource ? res: resultData);
      }).catch((error) => {
        if (axios.isAxiosError(error)) {
          updateViewState(ViewStateConstant.VIEW_STATE_NETWORK_ERROR,showLoadingState)
        } else {
          updateViewState(ViewStateConstant.VIEW_STATE_ERROR,showLoadingState)
        }
        reject(error);
      })
    })
  }

  return { promise: run };
}

export default useRequestStatus;