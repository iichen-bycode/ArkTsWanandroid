import { TabItem } from '../model/TabItem'
import { BarUtils } from '../utils/BarUtils'
import { StatusBarManager } from '../utils/StatusBarManager'
import MainViewModel from '../viewmodel/MainViewModel'
import { AuthorPage } from './anthor/AuthorPage'
import { HomePage } from './home/HomePage'
import { QuestionPage } from './question/Question'
import { SquarePage } from './square/Square'
@Entry
@Component
struct MainPage {
  @State selectedIndex: number = 0

  build() {
    Column() {
      Tabs({
        index: this.selectedIndex,
        barPosition: BarPosition.End,
      }) {
        TabContent() {
          HomePage()
        }
        .tabBar(this.TabBottom(MainViewModel.tabTitle[0], 0))

        TabContent() {
          AuthorPage()
        }
        .tabBar(this.TabBottom(MainViewModel.tabTitle[1], 1))

        TabContent() {
          QuestionPage()
        }
        .tabBar(this.TabBottom(MainViewModel.tabTitle[2], 2))

        TabContent() {
          SquarePage()
        }
        .tabBar(this.TabBottom(MainViewModel.tabTitle[3], 3))
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