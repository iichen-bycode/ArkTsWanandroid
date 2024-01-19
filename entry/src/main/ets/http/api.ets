
import { AxiosRequestHeaders } from '@ohos/axios'
import { Banner } from '../model/BannerModel'
import axiosClient from './http'
import { HomeArticleModel } from '../model/HomeArticleModel'
import { Article } from '../model/ArticleModel'
/**
 * 请求首页Banner
 * @param date
 * @returns
 */
export function getHomeBanner() {
  return axiosClient.get<Banner[]>({
    url: "banner/json",
  })
}


/**
 * 置顶文章
 * @param date
 * @returns
 */
export function getHotTopArticle() {
  return axiosClient.get<Article[]>({
    url: "article/top/json",
  })
}

/**
 * 首页文章文章
 * @param date
 * @returns
 */
export function getHomeArticle(page: number) {
  return axiosClient.get<HomeArticleModel>({
    url: `article/list/${page}/json`,
  })
}

/**
 * 收藏文章
 * @param date
 * @returns
 */
export function collectArticle(id: number) {
  return axiosClient.post<any>({
    url: `lg/collect/${id}/json`,
    checkResultCode: true,
    checkLoginState: true,
    needJumpToLogin: true
  })
}

/**
 * 取消收藏文章
 * @param date
 * @returns
 */
export function unCollectArticle(id: number) {
  return axiosClient.post<any>({
    url: `lg/uncollect_originId/${id}/json`,
    checkResultCode: true,
    checkLoginState: true,
    needJumpToLogin: true
  })
}


/**
 * 取消收藏列表文章
 * @param date
 * @returns
 */
export function uhCollectListArticle(id: number) {
  return axiosClient.post<any>({
    url: `lg/uncollect/${id}/json`,
    checkResultCode: true,
    checkLoginState: true,
    needJumpToLogin: true
  })
}

/**
 * 登录
 * @param date
 * @returns
 */
export function login(params:{username:string,password:string}) {
  return axiosClient.post<any>({
    url: `user/login`,
    params:params,
  })
}







