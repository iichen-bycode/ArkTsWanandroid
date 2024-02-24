import router from '@ohos.router'
import web_webview from '@ohos.web.webview'
import { BarUtils } from '../utils/BarUtils'
import showToast from '../utils/ToastUtils'
import { CommonTopBar } from '../view/TopBar'
@Component
@Entry
export struct WebPage {
  @State src:string = router.getParams()['src']
  @State title:string = '详情'
  @State progress:number = 0
// @ts-ignore
  controller:WebviewController = new web_webview.WebviewController()

   javascript = "var myimg,oldwidth;" +
      "var maxwidth = document.body.clientWidth;" +
      "for(i=0;i <document.images.length;i++){" +
        "myimg = document.images[i];" +
        "if(myimg.width > maxwidth){" +
          "oldwidth = myimg.width;" +
          "myimg.width = maxwidth;" +
        "}" +
      "}";

  testObj = {
    test: (data) => {
      this.javascript
      console.log('Web Component test');
      return "ArkUI Web Component";
    },
    toString: () => {
      console.log('Web Component toString');
    }
  }


  build() {
    Column() {
      CommonTopBar({title: this.title,onCallClick: () => {
        // this.controller.registerJavaScriptProxy(this.testObj, "objName", ["test", "toString"]);
        // this.controller.refresh()
        this.controller.zoom(100)
      }})
      Progress({ value: 0, total: 100, type: ProgressType.Linear })
        .color($r('app.color.color_red'))
        .value(this.progress)
        .width('100%')
        .height($r('app.float.size_2'))
        .margin({left: $r('app.float.size_8'),right: $r('app.float.size_8')})
        .visibility(this.progress >= 100 ? Visibility.Hidden : Visibility.Visible)
      Web({src: this.src,controller: this.controller}).height('100%')
        .onProgressChange((v) => {
          this.progress = v.newProgress
        })
        .onPageEnd(() => {
          this.title = this.controller.getTitle() || this.title
        })
        .zoomAccess(true)
        .javaScriptAccess(true)
    }.height('100%').padding({top: BarUtils.getToolBarHeight()})
  }
}