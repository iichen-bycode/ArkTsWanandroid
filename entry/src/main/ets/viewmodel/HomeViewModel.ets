import { collectArticle, getHomeArticle, getHomeBanner, getHotTopArticle, unCollectArticle } from '../http/api';
import { HomeArticleModel } from '../model/HomeArticleModel';
import { JsonUtils } from '../utils/JsonUtils';
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
      .promise(getHomeBanner())
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
          .promise(getHotTopArticle())
      }
      await this.request()
        .promise(getHomeArticle(this.page))
        .then((result) => {
          ++this.page
          this.articleModel = result
          callback([...hotTopArticle,...this.articleModel.datas])
        })
    }
  }

  /**
   * 文章和置顶文章拼接
   * @param callback
   */
  async getArticle(callback: ResultCallback) {


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
}

let homeViewModel = new HomeViewModel();

export default homeViewModel as HomeViewModel;