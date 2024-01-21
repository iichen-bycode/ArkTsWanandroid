import { collectArticle, getHomeArticle, getHomeBanner, getHotSearchKeys, getHotTopArticle, search, unCollectArticle } from '../http/api';
import { HomeArticleModel } from '../model/HomeArticleModel';
import { HotSearchKeysModel } from '../model/HotSearchKeyModel';
import { Router } from '../route/Router';
import showToast from '../utils/ToastUtils';
import { BaseViewModel, ResultCallback } from './BaseViewMode';

export class HomeViewModel extends BaseViewModel{
  private page: number = 0
  private articleModel: HomeArticleModel = new HomeArticleModel()


  tagColor: Color[] = [
    Color.Green,
    Color.Red,
    Color.Blue,
    Color.Orange,
    Color.Yellow,
    Color.Brown
  ]

  async getHomeBanner(callback: ResultCallback) {
    await this.request()
      .promise(getHomeBanner(),false)
      .then((result) => {
        callback(result)
      })
  }

  /**
   * 分页获取文章
   * @param callback
   */
  async getHomeArticle(isRefresh:boolean = false,callback: ResultCallback) {
    if(isRefresh) {
      this.page = 0
      this.articleModel.over = false
    }
    if(this.articleModel.over && false) {
      callback([])
    } else {
      let hotTopArticle = []
      if(this.page == 0) {
        hotTopArticle = await this.request()
          .promise(getHotTopArticle(),false)
      }
      await this.request()
        .promise(getHomeArticle(this.page),isRefresh)
        .then((result) => {
          ++this.page
          this.articleModel = result
          callback([...hotTopArticle,...this.articleModel.datas])
        })
    }
  }

  /**
   * 收藏文章
   * @param callback
   */
  async collectArticle(id:number,callback: ResultCallback) {
    await this.request({useSource: true})
      .promise(collectArticle(id))
      .then((res) => {
        if(res.errorCode == 0) {
          showToast("收藏成功！")
          callback(true)
        }
      })
  }

  /**
   * 取消收藏文章
   * @param callback
   */
  async unCollectArticle(id:number,callback: ResultCallback) {
    await this.request({useSource: true})
      .promise(unCollectArticle(id))
      .then((res) => {
        if(res.errorCode == 0) {
          callback(true)
          showToast("取消收藏成功！")
        }
      })
  }


  hotSearchKeyIndex:number = 0
  getHotSearchKey() : string {
    const len = this.hotSearchKeys.length
    if(len == 0)
      return ''
    ++this.hotSearchKeyIndex
    if(this.hotSearchKeyIndex >= len) {
      this.hotSearchKeyIndex = 0
    }
    return this.hotSearchKeys[this.hotSearchKeyIndex].name
  }
  hotSearchKeys: HotSearchKeysModel[] = []
  /**
   * 搜索热词
   * @param callback
   */
  async getHotSearchKeyArray() {
    await this.request()
      .promise(getHotSearchKeys(),false)
      .then((result) => {
        this.hotSearchKeys = result
      })
  }

  toPage(url:string,params?:{}) {
    Router.push(url,params)
  }
}

let homeViewModel = new HomeViewModel();

export default homeViewModel as HomeViewModel;