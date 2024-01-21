@Component
export struct RefreshFooter {
  @Prop showFooter: boolean
  @Prop showEmpty: boolean

  buildTip() : string {
    if(this.showEmpty) {
      return  "~ 没有更多啦 ~"
    }
    return "数据加载中，请稍后..."
  }

  build() {
    Row() {
      Text(this.buildTip()).fontColor($r('app.color.color_333')).fontSize($r('app.float.size_text_15'))
    }
    .width("100%")
    .height($r('app.float.size_50'))
    .backgroundColor($r('app.color.color_white'))
    .visibility((this.showFooter || this.showEmpty) ? Visibility.Visible : Visibility.None)
    .justifyContent(FlexAlign.Center)
  }
}