import { Article, Tags } from '../../../model/ArticleModel'
import homeViewModel from '../../../viewmodel/HomeViewModel'
@Component
export struct ArticleItem {
  @State article:Article = new Article()
  @State icon:Resource = $r('app.media.icon_unfavorite')

  onChangeCollect() : Resource{
    return this.icon = this.article.collect ? $r('app.media.icon_favorite') : $r('app.media.icon_unfavorite')
  }

  aboutToAppear() {
    this.onChangeCollect()
  }

  build() {
    Column() {
      Row() {
        Row() {
          ForEach(this.article.tags,(tag:Tags, index:number) => {
            Text(tag.name)
              .fontSize($r('app.float.size_text_14'),)
              .fontColor(homeViewModel.tagColor[index % homeViewModel.tagColor.length])
              .borderWidth(1)
              .borderColor(homeViewModel.tagColor[index % homeViewModel.tagColor.length])
              .borderRadius($r('app.float.size_4'))
              .padding($r('app.float.size_2'))
              .margin({right: $r('app.float.size_5')})
          })
          Text(`${this.article.author == '' ? this.article.shareUser : this.article.author}`)
            .fontSize($r('app.float.size_text_14'),)
            .fontColor($r('app.color.color_999'))
            .textAlign(TextAlign.Center)
            .margin({right: $r('app.float.size_8')})
        }
        Text(`${this.article.niceShareDate}`)
          .fontSize($r('app.float.size_text_14'),)
          .fontColor($r('app.color.color_999'))
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      Text(this.article.title)
        .fontColor($r('app.color.color_333'))
        .fontSize($r('app.float.size_text_16'),)
        .textOverflow({overflow: TextOverflow.Ellipsis})
        .maxLines(1).padding({right: $r('app.float.size_20')})
        .margin({top: $r('app.float.size_8')})
      Row() {
        Text(`分类：${this.article.superChapterName}/${this.article.chapterName}`)
          .fontSize($r('app.float.size_text_14'),)
          .fontColor($r('app.color.color_999'))
        Image(this.icon)
          .width($r('app.float.size_20'))
          .height($r('app.float.size_20'))
          .margin({right: $r('app.float.size_12')}).onClick(() => {
          if(this.article.collect) {
            homeViewModel.unCollectArticle(this.article.id,(res) => {
              this.article.collect = false
              this.onChangeCollect()
            })
          } else {
            homeViewModel.collectArticle(this.article.id,(res) => {
              this.article.collect = true
              this.onChangeCollect()
            })
          }
        })
      }
      .margin({top: $r('app.float.size_8')})
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
    }.alignItems(HorizontalAlign.Start).width('100%')
  }
}