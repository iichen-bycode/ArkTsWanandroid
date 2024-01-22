import axios, { AxiosError, AxiosRequestHeaders } from '@ohos/axios';
import hilog from '@ohos.hilog';
import { StorageKeys } from '../constants/StorageKeys';
import { RoutePath } from '../route/RoutePath';
import { Router } from '../route/Router';
import { hideLoadingDialog, showLoadingDialog } from '../utils/DialogUtils';
import { StorageUtils } from '../utils/StorageUtils';
import showToast from '../utils/ToastUtils';
import AxiosHttpRequest, { errorHandler } from './request';
import { JsonUtils } from '../utils/JsonUtils';
import mainViewModel from '../viewmodel/MainViewModel';

/**
 * 具体实例
 */
const axiosClient = new AxiosHttpRequest({
  baseURL: "https://www.wanandroid.com/",
  timeout: 10 * 1000,
  checkResultCode: false,
  headers: {
    'Content-Type': 'application/json'
    // 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
  } as AxiosRequestHeaders,
  interceptorHooks: {
    requestInterceptor: async (config) => {
      // 在发送请求之前做一些处理，例如打印请求信息
      config.headers['Cookie'] = mainViewModel.sessionId
      hilog.debug(0x001,"iichen_tag",'%{public}s, %{public}s','网络请求Request 请求方法:', `${config.method}`);
      hilog.debug(0x001,"iichen_tag",'%{public}s, %{public}s','网络请求Request 请求链接:', `${config.url}`);
      hilog.debug(0x001,"iichen_tag",'%{public}s, %{public}s','网络请求Request Params:', `\n${JsonUtils.stringify(config.params)}`);
      hilog.debug(0x001,"iichen_tag",'%{public}s, %{public}s','网络请求Request Data:', `${JsonUtils.stringify(config.data)}`);
      axiosClient.config.showLoading = config.showLoading
      axiosClient.config.needStorageSessionId = config.needStorageSessionId

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
    responseInterceptor: async (response) => {
      if(axiosClient.config.needStorageSessionId) {
        // 定义正则表达式模式
        const jsessionIdRegex = /JSESSIONID\s+([^\s]+)/;
        // 在字符串中查找匹配项
        const match = response.cookies.match(jsessionIdRegex);
        // 提取 JSESSIONID
        const jsessionId = match ? match[1] : null;
        mainViewModel.sessionId = `JSESSIONID=${jsessionId}`
        StorageUtils.put(StorageKeys.USER_INFO_KEY, mainViewModel.sessionId)
      }
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
        showToast(response.data.errorMsg)
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
  },
});

/**
 * 暴露
 */
export default axiosClient;
