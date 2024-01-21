import { ViewStateConstant } from '../constants/ViewStateConstant';

@Component
export struct StateComponent {
  @Prop viewState: string;
  //页面内容区域组件
  @BuilderParam viewContent: () => void
  //重试的回调方法
  retryCallback?: () => void
  //是否骨架屏幕
  private showSkeleton: boolean = false

  build() {
    Stack() {
      if (this.viewState != ViewStateConstant.VIEW_STATE_SUCCESS) {
        this.holdContent()
      } else {
        this.viewContent()
      }
    }
  }

  /**
   * 占位组件
   */
  @Builder
  holdContent() {
    if (this.showSkeleton && this.viewState == ViewStateConstant.VIEW_STATE_LOADING) {
      Column()
    } else {
      Column() {
        if (this.viewState != ViewStateConstant.VIEW_STATE_LOADING) {
          Image(this.convertImage())
            .width($r('app.float.size_100'))
            .height($r('app.float.size_100'))
          Text(this.convertValue())
            .fontSize($r('app.float.size_text_15'))
            .fontColor($r("app.color.color_666"))
            .margin($r('app.float.size_10'))
            Button($r('app.string.press_retry'))
              .width($r('app.float.size_120'))
              .height($r('app.float.size_35'))
              .backgroundColor($r('app.color.color_red'))
              .fontColor($r('app.color.color_fff'))
              .onClick(() => {
                this.retryCallback?.()
              })
        }
      }
    }

  }

  /**
   * 转换文案
   * @returns
   */
  convertValue() {
    switch (this.viewState) {
      case ViewStateConstant.VIEW_STATE_LOADING:
        return $r('app.string.loading')
        break;
      case ViewStateConstant.VIEW_STATE_ERROR:
        return $r('app.string.load_error')
        break;
      case ViewStateConstant.VIEW_STATE_NETWORK_ERROR:
        return $r('app.string.net_error')
        break;
      case ViewStateConstant.VIEW_STATE_EMPTY:
        return $r('app.string.load_emtpy')
        break;
      default:
        return $r('app.string.load_success')
        break;
    }
  }

  /**
   * 转换图片
   * @returns
   */
  convertImage() {
    switch (this.viewState) {
      case ViewStateConstant.VIEW_STATE_LOADING:
        return $r('app.media.loading')
        break;
      case ViewStateConstant.VIEW_STATE_ERROR:
        return $r('app.media.icon_net_error')
        break;
      case ViewStateConstant.VIEW_STATE_NETWORK_ERROR:
        return $r('app.media.icon_time_out')
        break;
      case ViewStateConstant.VIEW_STATE_EMPTY:
        return $r('app.media.icon_empty')
        break;
      default:
        return $r('app.media.loading')
        break;
    }
  }
}



