import emitter from '@ohos.events.emitter'
import { mainPageShow } from '../../event/EventKeys'
import { Banner } from '../../model/BannerModel'
import { RoutePath } from '../../route/RoutePath'
import { ResultCallback } from '../../viewmodel/BaseViewMode'
import homeViewModel from '../../viewmodel/HomeViewModel'
import { ListComponent } from './component/ListComponent'
@Component
export struct HomePage {
  @State bannerList: Banner[] = []
  @State searchKey:string = ''

  build() {
    Column() {
      // 头部
      Row() {
        Image($r('app.media.app_icon')).height(25)
        Search({placeholder:this.searchKey})
          .onSubmit((v) => {
            homeViewModel.toPage(RoutePath.SearchPage,{key:this.searchKey})
          })
          .width('70%')
        Text($r('app.string.search')).fontColor($r('app.color.color_red')).onClick(() => {
          homeViewModel.toPage(RoutePath.SearchPage,{key:this.searchKey})
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
      ListComponent({onReachEnd: (callback: ResultCallback) => {
        homeViewModel.getHomeArticle(false,(result) => {
          callback(result)
        })
      },onRefreshing:(callback:ResultCallback) => {
        homeViewModel.getHomeArticle(true,(result) => {
          callback(result)
        })}
      })
    }
    .height('100%')
    .justifyContent(FlexAlign.Start)
  }

  aboutToAppear() {
    homeViewModel.getHomeBanner((result) => {
      this.bannerList = result
    })

    homeViewModel.getHotSearchKeyArray().then(() => {
      this.searchKey = homeViewModel.getHotSearchKey()
    })

    emitter.on(mainPageShow,(_) => {
      this.searchKey = homeViewModel.getHotSearchKey()
    })
  }
}