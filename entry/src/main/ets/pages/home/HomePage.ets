import { Banner } from '../../model/BannerModel'
import showToast from '../../utils/ToastUtils'
import homeViewModel from '../../viewmodel/HomeViewModel'
import { ListComponent } from './component/ListComponent'
@Component
export struct HomePage {
  @State bannerList: Banner[] = []

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
      ListComponent()
    }
    .height('100%')
    .justifyContent(FlexAlign.Start)
  }

  aboutToAppear() {
    homeViewModel.getHomeBanner((result) => {
      this.bannerList = result
    })
  }
}