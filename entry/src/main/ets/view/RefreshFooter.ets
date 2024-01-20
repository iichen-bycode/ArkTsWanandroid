@Component
export struct RefreshFooter {
  @Prop showFooter: boolean
  @Prop showEmpty: boolean

  build() {
    if(this.showEmpty) {
      Row() {
        Text("数据加载中，请稍后...").fontColor($r('app.color.color_333')).fontSize($r('app.float.size_text_15'))
      }
      .width("100%")
      .height($r('app.float.size_50'))
      .backgroundColor($r('app.color.color_f8f8f8'))
      .visibility(this.showFooter ? Visibility.Visible : Visibility.None)
      .justifyContent(FlexAlign.Center)
    } else {
      Row() {
        Text("~ 我也是有底线的 ~").fontColor($r('app.color.color_333')).fontSize($r('app.float.size_text_15'))
      }
      .width("100%")
      .height($r('app.float.size_50'))
      .backgroundColor($r('app.color.color_white'))
      .visibility(Visibility.Visible)
      .justifyContent(FlexAlign.Center)
    }
  }
}