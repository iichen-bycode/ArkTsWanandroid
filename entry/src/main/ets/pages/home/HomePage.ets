import { Article, Tags } from '../../model/ArticleModel'
import { Banner } from '../../model/BannerModel'
import { BaseDataSourceWrapper } from '../../model/BaseDataSourceWrapper'
import { HomeArticleModel } from '../../model/HomeArticleModel'
import showToast from '../../utils/ToastUtils'
import { RefreshFooter } from '../../view/RefreshFooter'
import homeViewModel from '../../viewmodel/HomeViewModel'
@Component
export struct HomePage {
  @State bannerList: Banner[] = []
  @State articleList: Article[] = []
  @State refresh:boolean = false
  @State showLoading:boolean = false
  private articleModel: HomeArticleModel = new HomeArticleModel()

  build() {
    Column() {
      // 头部
      Row() {
        Image($r('app.media.app_icon')).height(25)
        Search().width('70%')
        Text($r('app.string.search')).fontColor($r('app.color.color_red')).onClick(() => {
          showToast("搜索")
          homeViewModel.getHomeBanner((result) => {
            this.bannerList = result
          })
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
      .margin({bottom: 8,top: 8})
      // swiper
      Swiper() {
        ForEach(this.bannerList, (item: Banner) => {
          Image(item.imagePath)
            .width('100%')
            .height($r('app.float.size_200'))
            .border({ radius: $r('app.float.size_5') })
        })
      }
      .index(0)
      .autoPlay(true)
      .interval(2500)
      .indicator(true)
      .loop(this.bannerList.length > 1)
      .duration(400)
      .curve(Curve.Linear)
      .indicatorStyle({ color: $r('app.color.color_red'), selectedColor: $r('app.color.color_red') })
      .onChange((index: number) => {

      }).margin({bottom:  $r('app.float.size_8')})
      // 列表
      Refresh({refreshing: this.refresh}) {
        List() {
          ForEach(this.articleList,(item: Article,index:number) => {
            ListItem() {
              Column() {
                  Row() {
                    Row() {
                      ForEach(item.tags,(tag:Tags,index:number) => {
                        Text(tag.name)
                          .fontSize($r('app.float.size_text_14'),)
                          .fontColor(homeViewModel.tagColor[index % homeViewModel.tagColor.length])
                          .borderWidth(1)
                          .borderColor(homeViewModel.tagColor[index % homeViewModel.tagColor.length])
                          .borderRadius($r('app.float.size_4'))
                          .padding($r('app.float.size_2'))
                          .margin({right: $r('app.float.size_5')})
                      })
                      Text(`${item.author == '' ? item.shareUser : item.author}`)
                        .fontSize($r('app.float.size_text_14'),)
                        .fontColor($r('app.color.color_999'))
                        .textAlign(TextAlign.Center)
                        .margin({right: $r('app.float.size_8')})
                    }
                    Text(`${item.niceShareDate}`)
                      .fontSize($r('app.float.size_text_14'),)
                      .fontColor($r('app.color.color_999'))
                  } 
                  .justifyContent(FlexAlign.SpaceBetween)
                  .width('100%')
                  Text(item.title)
                    .fontColor($r('app.color.color_333'))
                    .fontSize($r('app.float.size_text_16'),)
                    .textOverflow({overflow: TextOverflow.Ellipsis})
                    .maxLines(1).padding({right: $r('app.float.size_20')})
                    .margin({top: $r('app.float.size_8')})
                  Row() {
                    Text(`分类：${item.superChapterName}/${item.chapterName}`)
                      .fontSize($r('app.float.size_text_14'),)
                      .fontColor($r('app.color.color_999'))
                    Image($r('app.media.icon_unfavorite'))
                      .width($r('app.float.size_20'))
                      .height($r('app.float.size_20'))
                      .margin({right: $r('app.float.size_12')})
                  }
                  .margin({top: $r('app.float.size_8')})
                  .justifyContent(FlexAlign.SpaceBetween)
                  .width('100%')
                }.alignItems(HorizontalAlign.Start).width('100%')
            }.shadow({
              radius: $r('app.float.size_2'),
              offsetX: $r('app.float.size_1'),
              offsetY: $r('app.float.size_2'),
              color: $r('app.color.color_666')})
            .backgroundColor($r('app.color.color_white'))
            .borderRadius($r('app.float.size_8'))
            .padding($r('app.float.size_12'))
            .margin({bottom: $r('app.float.size_8'),right: $r('app.float.size_8'),left: $r('app.float.size_8')})
            .onClick(() => {
              if(item.collect) {
                homeViewModel.collectArticle(item.id,(res) => {
                  item.collect = !item.collect
                })
              } else {
                homeViewModel.collectArticle(item.id,(res) => {
                  item.collect = !item.collect
                })
              }
            })
          })
          ListItem() {
            RefreshFooter({ showFooter: this.showLoading })
          }
        }
        .listDirection(Axis.Vertical)
        .onReachEnd(() => {
          if(!this.articleModel.over) {
            this.showLoading = true
            homeViewModel.getHomeArticle((result) => {
              this.articleModel = result
              this.articleList = [...this.articleList,...this.articleModel.datas]
            })
          }
        })
      }

    }
    .height('100%')
    .justifyContent(FlexAlign.Start)
  }

  aboutToAppear() {
    homeViewModel.getHomeBanner((result) => {
      this.bannerList = result
    })
    homeViewModel.getArticle((result) => {
      this.articleList = result
    })
  }
}