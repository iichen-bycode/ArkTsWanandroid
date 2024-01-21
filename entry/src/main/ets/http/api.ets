
import { AxiosRequestHeaders } from '@ohos/axios'
import { Banner } from '../model/BannerModel'
import axiosClient from './http'
import { HomeArticleModel } from '../model/HomeArticleModel'
import { Article } from '../model/ArticleModel'
import { HotSearchKeysModel } from '../model/HotSearchKeyModel'
import { CommonModel } from '../model/CommonModel'
import { SystemModel } from '../model/SystemModel'
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
 * 搜索热词
 * @param date
 * @returns
 */
export function getHotSearchKeys() {
  return axiosClient.get<HotSearchKeysModel[]>({
    url: `hotkey/json`,
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
    showLoading: page === 0
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
    needStorageSessionId:true
  })
}

/**
 * 搜索
 * @param date
 * @returns
 */
export function search(page:number,key:string) {
  return axiosClient.post<HomeArticleModel>({
    url: `article/query/${page}/json?k=${encodeURI(key)}`,
    showLoading:page === 0,
  })
}

/**
 * 公众号作者列表
 * @param date
 * @returns
 */
export function wxAuthorList() {
  return axiosClient.get<CommonModel[]>({
    url: `wxarticle/chapters/json`,
  })
}

/**
 * 公众号作者下的文章
 * @param date
 * @returns
 */
export function wxAuthorArticleList(id:number,page:number) {
  return axiosClient.get<HomeArticleModel>({
    url: `wxarticle/list/${id}/${page}/json`,
  })
}

/**
 * 公众号作者下的搜索文章
 * @param date
 * @returns
 */
export function wxAuthorSearchArticleList(id:number,page:number,key:string) {
  return axiosClient.get<HomeArticleModel>({
    url: `wxarticle/list/${id}/${page}/json?k=${key}`,
  })
}

/**
 * 项目分类
 * @param date
 * @returns
 */
export function projectCategory() {
  return axiosClient.get<CommonModel>({
    url: `project/tree/json`,
  })
}

/**
 * 项目分类下列表
 * @param date
 * @returns
 */
export function projectCategoryItemList(cid:number,page:number) {
  return axiosClient.get<HomeArticleModel>({
    url: `project/list/${page}/json?cid=${cid}`,
  })
}

/**
 * 体系分类
 * @param date
 * @returns
 */
export function systemCategory() {
  return axiosClient.get<SystemModel[]>({
    url: `tree/json`,
  })
}

/**
 * 体系分类下数据
 * @param date
 * @returns
 */
export function systemCategoryItemList(cid:number,page:number) {
  return axiosClient.get<HomeArticleModel>({
    url: `article/list/${page}/json?cid=${cid}`,
  })
}

/**********************************/

/**
 * 体系分类下数据
 * @param date
 * @returns
 */
export function getWenDa(page:number) {
  return axiosClient.get<HomeArticleModel>({
    url: `wenda/list/${page}/json`,
  })
}





