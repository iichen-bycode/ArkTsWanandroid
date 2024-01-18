import { AxiosError, AxiosRequestHeaders } from '@ohos/axios';
import { StorageKeys } from '../constants/StorageKeys';
import { RoutePath } from '../route/RoutePath';
import { Router } from '../route/Router';
import { hideLoadingDialog, showLoadingDialog } from '../utils/DialogUtils';
import { StorageUtils } from '../utils/StorageUtils';
import showToast from '../utils/ToastUtils';
import AxiosHttpRequest, { errorHandler } from './request';
/**
 * 具体实例
 */
const axiosClient = new AxiosHttpRequest({
  baseURL: "https://www.wanandroid.com/",
  timeout: 10 * 1000,
  checkResultCode: false,
  headers: {
    'Content-Type': 'application/json'
  } as AxiosRequestHeaders,
  interceptorHooks: {
    requestInterceptor: async (config) => {
      axiosClient.config.showLoading = config.showLoading
      if (config.showLoading) {
        // 发送event
        showLoadingDialog("加载中...")
      }
      if (config.checkLoginState) {
        // @ts-ignore
        let hasLogin = await StorageUtils.get(StorageKeys.USER_LOGIN, false)
        if (hasLogin) {
          return config
        } else {
          if (config.needJumpToLogin) {
            Router.push(RoutePath.LoginPage)
          }
          throw new AxiosError("请登录")
        }
      }
      return config;
    },
    requestInterceptorCatch: (err) => {
      if (axiosClient.config.showLoading) {
        hideLoadingDialog()
      }
      return err;
    },
    responseInterceptor: (response) => {
      if (axiosClient.config.showLoading) {
        hideLoadingDialog()
      }
      if (response.status === 200) {
        // @ts-ignore
        const checkResultCode = response.config.checkResultCode
        if (checkResultCode && response.data.errorCode != 0) {
          showToast(response.data.errorMsg)
          return Promise.reject(response)
        }
        return Promise.resolve(response.data);
      } else {
        return Promise.reject(response);
      }
    },
    responseInterceptorCatch: (error) => {
      if (axiosClient.config.showLoading) {
        hideLoadingDialog()
      }
      errorHandler(error);
      return Promise.reject(error);
    },
  }
});

/**
 * 暴露
 */
export default axiosClient;
