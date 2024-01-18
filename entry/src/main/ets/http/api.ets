
import { AxiosRequestHeaders } from '@ohos/axios'
import { BannerModel } from '../model/BannerModel'
import axiosClient from './http'
/**
 * 请求首页Banner
 * @param date
 * @returns
 */
export function getHomeBanner() {
  return axiosClient.get<BannerModel>({
    url: "banner/json",
  })
}






