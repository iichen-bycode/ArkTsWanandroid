import axios, {
AxiosError,
  AxiosInstance,
  AxiosRequestHeaders,
  AxiosResponse,
  InternalAxiosRequestConfig
} from "@ohos/axios";
import { StorageKeys } from '../constants/StorageKeys';
import { StorageUtils } from '../utils/StorageUtils';
import showToast from '../utils/ToastUtils';

class AxiosHttpRequest {
  config: HttpRequestConfig;
  interceptorHooks?: InterceptorHooks;
  instance: AxiosInstance;

  constructor(options: HttpRequestConfig) {
    this.config = options;
    this.interceptorHooks = options.interceptorHooks;
    this.instance = axios.create(this.config);
    this.setupInterceptor()
  }

  setupInterceptor(): void {
    this.instance.defaults.headers
    this.instance.interceptors.request.use(
      //这里主要是高版本的axios中设置拦截器的时候里面的Config属性必须是InternalAxiosRequestConfig，但是InternalAxiosRequestConfig里面的headers是必传，所以在实现的子类我设置成非必传会报错，加了个忽略注解
      // @ts-ignore
      this.interceptorHooks?.requestInterceptor,
      this.interceptorHooks?.requestInterceptorCatch,
    );
    this.instance.interceptors.response.use(
      this.interceptorHooks?.responseInterceptor,
      this.interceptorHooks?.responseInterceptorCatch,
    );
  }

  // 类型参数的作用，T决定AxiosResponse实例中data的类型
  request<T = any>(config: HttpRequestConfig): Promise<T> {
    return new Promise<T>((resolve, reject) => {
      this.instance
        .request<any, T>(config)
        .then(res => {
          resolve(res);
        })
        .catch((err) => {
          errorHandler(err)
          if (err) {
            reject(err);
          }
        });
    });
  }

  get<T = any>(config: HttpRequestConfig): Promise<T> {
    return this.request({ ...config, method: 'GET' });
  }

  post<T = any>(config: HttpRequestConfig): Promise<T> {
    return this.request({ ...config, method: 'POST' });
  }

  delete<T = any>(config: HttpRequestConfig): Promise<T> {
    return this.request({ ...config, method: 'DELETE' });
  }

  patch<T = any>(config: HttpRequestConfig): Promise<T> {
    return this.request({ ...config, method: 'PATCH' });
  }
}


/******************************************附加配置信息*********************************************/
// @ts-ignore
interface HttpRequestConfig extends InternalAxiosRequestConfig {
  showLoading?: boolean; //是否展示请求loading
  checkResultCode?: boolean; //是否检验响应结果码
  checkLoginState?: boolean //校验用户登陆状态
  needJumpToLogin?: boolean //是否需要跳转到登陆页面
  needStorageSessionId?: boolean //是否需要设置SessionId,后续框架支持cookie持久化后去除
  interceptorHooks?: InterceptorHooks
  headers?: AxiosRequestHeaders
}

/**
 * 基础响应体
 */
export interface BaseResponse {
  errorCode: number
  errorMsg: string
}

/**
 * 拦截器
 */
interface InterceptorHooks {
  requestInterceptor?: (config: HttpRequestConfig) => Promise<HttpRequestConfig>;
  requestInterceptorCatch?: (error: any) => any;
  responseInterceptor?: (response: AxiosResponse) => AxiosResponse | Promise<AxiosResponse>;
  responseInterceptorCatch?: (error: any) => any;
}
/**
 * 错误码处理
 */
export function errorHandler(error: any) {
  if (error instanceof AxiosError) {
    showToast(error.message)
  } else if (error != undefined && error.response != undefined && error.response.status) {
    switch (error.response.status) {
    // 401: 未登录
      case 401:
        StorageUtils.put(StorageKeys.USER_INFO_KEY, "")
        showToast("登录过期，请重新登录")
        break;
      case 403:
        StorageUtils.put(StorageKeys.USER_INFO_KEY, "")
        showToast("登录过期，请重新登录")
        break;
      case 404:
        showToast("网络请求不存在")
        break;
    // 其他错误，直接抛出错误提示
      default:
        showToast(error.response.data.message)
    }
  }
}
/**
 * 暴露
 */
export default AxiosHttpRequest
