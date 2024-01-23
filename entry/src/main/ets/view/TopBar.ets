/**
 * 自定义App顶部Topbar
 */
import router from '@ohos.router'
import showToast from '../utils/ToastUtils'

@Builder function empty(){}

@Component
export struct CommonTopBar {
  @Prop title: string
  showLine: boolean = true
  private titleAlignment: TextAlign = TextAlign.Center
  private backButton: boolean = true
  private onBackClick?: () => void
  private onCallClick?: () => void

  @BuilderParam endComponent: () => void = empty

  build() {
    Column() {
      Row() {
        if (this.backButton) {
          Stack() {
            Image($r('app.media.icon_back'))
              .height($r('app.float.size_16'))
              .width($r('app.float.size_16'))
              .align(Alignment.Center)
          }
          .height($r('app.float.size_50'))
          .width($r('app.float.size_50'))
          .onClick(() => {
            this.onBackClick?.()
            router.back();
          })
        }

        Row() {
          Scroll() {
            Text(this.title)
              .textAlign(this.titleAlignment)
              .fontColor($r('app.color.color_black'))
              .fontSize($r('app.float.size_text_16'))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          this.endComponent()
        }.justifyContent(FlexAlign.SpaceBetween).flexGrow(1)
      }
      .onClick(() => {
        this.onCallClick?.()
      })
      .height($r('app.float.size_50'))
      .width("100%")
      if(this.showLine)
        Line().backgroundColor($r('app.color.divider')).width('100%').height($r('app.float.size_1'))
    }

  }
}