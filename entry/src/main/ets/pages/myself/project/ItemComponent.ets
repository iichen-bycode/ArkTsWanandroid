import { Article } from '../../../model/ArticleModel'
import homeViewModel from '../../../viewmodel/HomeViewModel'
@Component
export struct ItemComponent {
  @State item:Article = new Article()

  @State icon:Resource = $r('app.media.icon_unfavorite')

  onChangeCollect() : Resource{
    return this.icon = this.item.collect ? $r('app.media.icon_favorite') : $r('app.media.icon_unfavorite')
  }

  aboutToAppear() {
    this.onChangeCollect()
  }

  build() {
    Row() {
      Image(this.item.envelopePic)
        .width('30%')
        .borderRadius(8)
        .aspectRatio(0.7)
        .flexShrink(1)
      Column() {
        Text(this.item.title)
          .fontSize(16)
          .fontColor($r('app.color.color_black'))
          .maxLines(1)
          .textOverflow({overflow:TextOverflow.Ellipsis})
        Text(this.item.desc)
          .fontColor($r('app.color.color_666'))
          .fontSize(14)
          .maxLines(3)
          .textOverflow({overflow:TextOverflow.Ellipsis})
          .margin({top: 10,bottom: 10})
        Row() {
          Row() {
            Text(`${this.item.author}  `)
              .fontColor($r('app.color.color_333'))
              .fontSize(12)
            Text(this.item.niceDate)
              .fontColor($r('app.color.color_666'))
              .fontSize(12)
          }
          Image(this.icon).width(20).onClick(() => {
            if(this.item.collect) {
              homeViewModel.unCollectArticle(this.item.id,(res) => {
                this.item.collect = false
                this.onChangeCollect()
              },{
                isCollectList:false,
                originId:this.item.originId
              })
            } else {
              homeViewModel.collectArticle(this.item.id,(res) => {
                this.item.collect = true
                this.onChangeCollect()
              })
            }
          })
        }.justifyContent(FlexAlign.SpaceBetween).width('100%')
      }.width('70%')
      .margin({left: 6})
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(HorizontalAlign.Start)
    }.width('100%')
  }
}