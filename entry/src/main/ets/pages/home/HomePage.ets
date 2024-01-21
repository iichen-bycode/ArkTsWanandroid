import emitter from '@ohos.events.emitter'
import { ViewStateConstant } from '../../constants/ViewStateConstant'
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
  @State searchByUserKey:string = ''
  @State viewState: string = ViewStateConstant.VIEW_STATE_LOADING

  build() {
    Column() {
      // 头部
      Row() {
        Image($r('app.media.app_icon')).height(25)
        Search({placeholder:this.searchKey})
          .onSubmit((v) => {
            homeViewModel.toPage(RoutePath.SearchPage,{key:this.getSearchKey()})
          })
          .onChange((v) => {
            this.searchByUserKey = v
          })
          .width('70%')
        Text($r('app.string.search')).fontColor($r('app.color.color_red')).onClick(() => {
          homeViewModel.toPage(RoutePath.SearchPage,{key:this.getSearchKey()})
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
      .indicator(this.bannerList.length > 1)
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
        })},viewState:this.viewState
      })
    }
    .height('100%')
    .justifyContent(FlexAlign.Start)
  }

  getSearchKey() : string{
    return this.searchByUserKey === '' ? this.searchKey : this.searchByUserKey
  }

  aboutToAppear() {
    homeViewModel.observeState((state) => {
      this.viewState = state
    })

    homeViewModel.getHomeBanner((result) => {
      this.bannerList = result
    })

    homeViewModel.getHotSearchKeyArray().then(() => {
      this.searchKey = homeViewModel.getHotSearchKey()
    })

    emitter.on(mainPageShow,(_) => {
      if(this.searchByUserKey === '') {
        this.searchKey = homeViewModel.getHotSearchKey()
      }
    })
  }
}