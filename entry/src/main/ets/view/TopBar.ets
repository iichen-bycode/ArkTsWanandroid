/**
 * 自定义App顶部Topbar
 */
import router from '@ohos.router'

@Component
export struct CommonTopBar {
  @Prop title: string
  private titleAlignment: TextAlign = TextAlign.Center
  private backButton: boolean = true
  private onBackClick?: () => void

  build() {
    Column() {
      Stack({ alignContent: Alignment.Start }) {
        Text(this.title)
          .flexGrow(1)
          .textAlign(this.titleAlignment)
          .fontColor($r('app.color.color_black'))
          .fontSize($r('app.float.size_text_16'))
          .align(Alignment.Center)
          .maxLines(1)
          .width('100%')
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        if (this.backButton) {
          Stack() {
            Image($r('app.media.icon_back'))
              .height($r('app.float.size_16'))
              .width($r('app.float.size_16'))
              .align(Alignment.Center)
              .onClick(() => {
                this.onBackClick?.()
                router.back();
              })
          }
          .height($r('app.float.size_50'))
          .width($r('app.float.size_50'))
        }
      }
      .height($r('app.float.size_50'))
      .width("100%")
    }

  }
}