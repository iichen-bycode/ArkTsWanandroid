import emitter from '@ohos.events.emitter'
import { StorageKeys } from '../constants/StorageKeys'
import { EventKeys, loadingEvent, mainPageShow } from '../event/EventKeys'
import { TabItem } from '../model/TabItem'
import { BarUtils } from '../utils/BarUtils'
import { StorageUtils } from '../utils/StorageUtils'
import { LoadingDialog } from '../view/LoadingDialog'
import mainViewModel from '../viewmodel/MainViewModel'
import { AuthorPage } from './anthor/AuthorPage'
import { HomePage } from './home/HomePage'
import { QuestionPage } from './question/Question'
import { SquarePage } from './square/Square'
@Entry
@Component
struct MainPage {
  @State selectedIndex: number = 0
  @State loadingShow: boolean = false
  @State loadingTips: string = "加载中..."

  loadingDialogController: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({ loadingTips: this.loadingTips }),
    autoCancel: false,
    gridCount: 2,
    cancel: () => {
      this.loadingShow = false
    }
  })

  aboutToAppear() {
    // 框架支持cookie持久化后去除
    StorageUtils.get(StorageKeys.USER_INFO_KEY, '').then((v) => {
      mainViewModel.sessionId = v.toString()
    })

    emitter.on(loadingEvent, (event) => {
      if (event.data.showLoading == true && !this.loadingShow) {
        this.loadingShow = true
        this.loadingTips = event.data.loadingTips
        this.loadingDialogController.open()
      } else if (event.data.showLoading == false) {
        this.loadingDialogController.close()
        this.loadingShow = false
      }
    })
  }

  aboutToDisappear() {
    this.loadingDialogController = null
    emitter.off(EventKeys.LOADING_DIALOG_EVENT)
  }

  onPageShow() {
    emitter.emit(mainPageShow, {  })
  }

  build() {
    Column() {
      Tabs({
        index: this.selectedIndex,
        barPosition: BarPosition.End,
      }) {
        TabContent() {
          HomePage()
        }
        .tabBar(this.TabBottom(mainViewModel.tabTitle[0], 0))

        TabContent() {
          AuthorPage()
        }
        .tabBar(this.TabBottom(mainViewModel.tabTitle[1], 1))

        TabContent() {
          QuestionPage()
        }
        .tabBar(this.TabBottom(mainViewModel.tabTitle[2], 2))

        TabContent() {
          SquarePage()
        }
        .tabBar(this.TabBottom(mainViewModel.tabTitle[3], 3))
      }
      .barMode(BarMode.Fixed)
      .barWidth('100%')
      .scrollable(false)
      .barHeight($r('app.float.tab_bar_height'))
      .onChange((index: number) => {
        this.selectedIndex = index;
      })
    }.padding({top: BarUtils.getToolBarHeight()})
  }

  @Builder TabBottom(item: TabItem, index: number) {
    Column() {
      Image(this.selectedIndex == index ? item.imageActivated : item.imageOriginal)
        .height($r('app.float.tab_image_size'))
        .width($r('app.float.tab_image_size'))
        .margin({
          top: $r('app.float.tab_margin_top'),
          bottom: $r('app.float.tab_margin_bottom')
        })
      Text(item.title)
        .width("100%")
        .height($r('app.float.tab_text_height'))
        .fontSize($r('app.float.tab_text_font_size'))
        .fontWeight(500)
        .fontColor(this.selectedIndex === index ? $r('app.color.color_red') : Color.Gray)
        .textAlign(TextAlign.Center)
        .margin({
          bottom: $r('app.float.tab_text_margin_bottom')
        })
    }
    .justifyContent(FlexAlign.Center)
    .height("100%")
    .width("100%")
    .backgroundColor($r("app.color.color_f5f5f5"))
  }
}