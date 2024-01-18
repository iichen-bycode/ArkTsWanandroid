import { Banner } from '../../model/BannerModel'
import { BaseDataSourceWrapper } from '../../model/BaseDataSourceWrapper'
import showToast from '../../utils/ToastUtils'
import homeViewModel from '../../viewmodel/HomeViewModel'
@Component
export struct HomePage {
  @State bannerList: Banner[] = []

  build() {
    Column() {
      // 头部
      Row() {
        Image($r('app.media.app_icon')).height(25)
        Search().width('70%')
        Text($r('app.string.search')).fontColor($r('app.color.color_red'))
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
        }, item => item)
      }
      .index(0)
      .autoPlay(true)
      .interval(1500)
      .indicator(true)
      .loop(false)
      .duration(2000)
      .curve(Curve.Linear)
      .indicatorStyle({ color: $r('app.color.color_red'), selectedColor: $r('app.color.color_red') })
      .onChange((index: number) => {

      })

      // 列表
      // List()
    }
    .height('100%')
    .justifyContent(FlexAlign.Start)
  }

  aboutToAppear() {
    homeViewModel.getHomeBanner((result) => {
      this.bannerList = result
      showToast(`长度：${this.bannerList.length}`)
    })
  }
}