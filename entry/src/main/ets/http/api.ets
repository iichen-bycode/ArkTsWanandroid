
import { AxiosRequestHeaders } from '@ohos/axios'
import { Banner } from '../model/BannerModel'
import axiosClient from './http'
import { HomeArticleModel } from '../model/HomeArticleModel'
import { Article } from '../model/ArticleModel'
import { HotSearchKeysModel } from '../model/HotSearchKeyModel'
import { CommonModel } from '../model/CommonModel'
import { SystemModel } from '../model/SystemModel'
import { UserInfoModel } from '../model/UserInfoModel'
import { RankModel } from '../model/RankModel'
import { MessageWrapModel } from '../model/MessageModel'
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
export function unCollectListArticle(id: number,originId:number) {
  return axiosClient.post<any>({
    url: `lg/uncollect/${id}/json`,
    params: {
      originId:originId || -1
    },
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
    showLoading: page == 0
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
    showLoading:true
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
    showLoading:true
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
    showLoading:true
  })
}

/**
 * 广场数据
 * @param date
 * @returns
 */
export function getSquareData(page:number) {
  return axiosClient.get<HomeArticleModel>({
    url: `user_article/list/${page}/json`,
    showLoading:true
  })
}

/**
 * 问答数据
 * @param date
 * @returns
 */
export function getWendaData(page:number) {
  return axiosClient.get<HomeArticleModel>({
    url: `wenda/list/${page}/json`,
  })
}

/**
 * 分享文章
 * @param date
 * @returns
 */
export function shareArticle(title:string,link:string) {
  return axiosClient.post<any>({
    url: `lg/user_article/add/json`,
    checkResultCode:true,
    needJumpToLogin:true,
    checkLoginState:true,
    params: {
      'title':title,
      'link':link,
    }
  })
}


/**
 * 提出问答问题
 * @param date
 * @returns
 */
export function askQuestion(content:string) {
  return axiosClient.post<any>({
    url: `comment/lg/add`,
    checkResultCode:true,
    needJumpToLogin:true,
    checkLoginState:true,
    params: {
      'articleId':8857,
      'content':content,
    }
  })
}

/**
 * 个人信息
 * @param date
 * @returns
 */
export function getUserInfo() {
  return axiosClient.get<UserInfoModel>({
    url: `lg/coin/userinfo/json`,
    checkLoginState: true,
  })
}

/**
 * 未读消息数量
 * @param date
 * @returns
 */
export function getUnRead() {
  return axiosClient.get<number>({
    url: `message/lg/count_unread/json`,
    checkLoginState: true,
  })
}

/**
 * 未读消息数量
 * @param date
 * @returns
 */
export function getRankList(page:number) {
  return axiosClient.get<RankModel>({
    url: `coin/rank/${page}/json`,
    showLoading:true
  })
}

/**
 * 收藏列表
 * @param date
 * @returns
 */
export function getCollectList(page:number) {
  return axiosClient.get<HomeArticleModel>({
    url: `lg/collect/list/${page}/json`,
    showLoading:true
  })
}

/**
 * 新增收藏
 * @param date
 * @returns
 */
export function addCollect(params: {
  title:string,author:string,link:string
}) {
  return axiosClient.post<Article>({
    url: `lg/collect/add/json`,
    params:params,
    checkResultCode:true,
    needJumpToLogin:true,
    showLoading:true,
    checkLoginState:true
  })
}


/**
 * 消息列表
 * @param date
 * @returns
 */
export function getMessageList(page:number) {
  return axiosClient.post<MessageWrapModel>({
    url: `message/lg/readed_list/${page}/json`,
    checkResultCode:true,
    showLoading:true,
  })
}






