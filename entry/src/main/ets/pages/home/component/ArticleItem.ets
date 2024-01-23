import { Article, Tags } from '../../../model/ArticleModel'
import homeViewModel from '../../../viewmodel/HomeViewModel'
@Component
export struct ArticleItem {
  @State article:Article = new Article()
  isCollectList:boolean = false
  @State icon:Resource = $r('app.media.icon_unfavorite')

  onChangeCollect() : Resource{
    return this.icon = this.article.collect ? $r('app.media.icon_favorite') : $r('app.media.icon_unfavorite')
  }

  aboutToAppear() {
    this.onChangeCollect()
  }

  splitByEmTag(inputString: string): string[] {
    // 使用正则表达式匹配 <em> 标签内的文本
    const emMatches = inputString.split(/(<em[^>]*>.*?<\/em>)/);

    // 过滤掉可能的空字符串
    const nonEmptyMatches = emMatches.filter(Boolean);

    // 创建结果数组
    const resultArray: string[] = [];

    // 根据 <em> 标签的存在与否组织数组
    for (let i = 0; i < nonEmptyMatches.length; i++) {
      if (nonEmptyMatches[i].startsWith("<em")) {
        // 如果是 <em> 包裹的内容，创建新数组并放入结果数组
        const innerEmContent = nonEmptyMatches[i].replace(/<\/?em[^>]*>/g, '');
        resultArray.push("<em>"+innerEmContent);
      } else {
        // 如果不是 <em> 包裹的内容，直接放入结果数组
        resultArray.push(nonEmptyMatches[i]);
      }
    }
    return resultArray;
  }


  build() {
    Column() {
      Row() {
        Row() {
          ForEach(this.article.tags ||  [],(tag:Tags, index:number) => {
            Text(tag.name)
              .fontSize($r('app.float.size_text_14'),)
              .fontColor(homeViewModel.tagColor[index % homeViewModel.tagColor.length])
              .borderWidth(1)
              .borderColor(homeViewModel.tagColor[index % homeViewModel.tagColor.length])
              .borderRadius($r('app.float.size_4'))
              .padding($r('app.float.size_2'))
              .margin({right: $r('app.float.size_5')})
          })
          Text(`${(this.article.author == '' ? this.article.shareUser : this.article.author) || '匿名'}`)
            .fontSize($r('app.float.size_text_14'),)
            .fontColor($r('app.color.color_999'))
            .textAlign(TextAlign.Center)
            .margin({right: $r('app.float.size_8')})
        }
        Text(this.article.niceDate === '未知时间' ? `${this.article.niceShareDate}` : this.article.niceDate)
          .fontSize($r('app.float.size_text_14'),)
          .fontColor($r('app.color.color_999'))
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      Text() {
        ForEach(this.splitByEmTag(this.article.title),(title:string) => {
          Span(title.includes("<em>") ? title.split("<em>")[1] : title)
            .fontColor(title.includes("<em>") ? $r('app.color.color_red') : $r('app.color.color_333'))
            .fontSize($r('app.float.size_text_16'),)
        })
      }
        .textOverflow({overflow: TextOverflow.Ellipsis})
        .maxLines(1).padding({right: $r('app.float.size_20')})
        .margin({top: $r('app.float.size_8')})
      Row() {
        Text() {
          if(this.article.superChapterName != undefined) {
            Span(`分类：${this.article.superChapterName}/`)
              .fontSize($r('app.float.size_text_14'),)
              .fontColor($r('app.color.color_999'))
          }
          Span(`${this.article.chapterName}`)
            .fontSize($r('app.float.size_text_14'),)
            .fontColor($r('app.color.color_999'))
        }
        Image(this.icon)
          .width($r('app.float.size_20'))
          .height($r('app.float.size_20'))
          .margin({right: $r('app.float.size_12')}).onClick(() => {
          if(this.article.collect) {
            homeViewModel.unCollectArticle(this.article.id,(res) => {
              this.article.collect = false
              this.onChangeCollect()
            },{
              isCollectList:this.isCollectList,
              originId:this.article.originId
            })
          } else {
            homeViewModel.collectArticle(
                (this.article.originId !== undefined && this.article.originId !== -1) ? this.article.originId : this.article.id
              ,(res) => {
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