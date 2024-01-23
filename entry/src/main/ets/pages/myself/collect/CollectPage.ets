import { ViewStateConstant } from '../../../constants/ViewStateConstant'
import { Article } from '../../../model/ArticleModel'
import { BarUtils } from '../../../utils/BarUtils'
import { ComponentRef } from '../../../utils/ComponentRef'
import { InputDialog, InputDialogConfig } from '../../../view/InputDialog'
import { CommonTopBar } from '../../../view/TopBar'
import { ResultCallback } from '../../../viewmodel/BaseViewMode'
import collectViewModel from '../../../viewmodel/CollectViewModel'
import { ArticleItem } from '../../home/component/ArticleItem'
import { ListComponent } from '../../home/component/ListComponent'
@Entry
@Component
struct CollectPage {
  @State viewState: string = ViewStateConstant.VIEW_STATE_LOADING

  private scroller: Scroller = new Scroller()

  ref = ComponentRef.useRef<{ change: (Article) => {} }>();

  dialogController: CustomDialogController = new CustomDialogController({
    builder: InputDialog({
      title: "新增收藏",
      submitTip: "保存",
      inputConfig: [
        new InputDialogConfig("请输入标题(必填)",true),
        new InputDialogConfig("请输入作者(非必填)",false),
        new InputDialogConfig("请输入链接地址(必填)",true)
      ],
      onSubmit: (value) => {
        collectViewModel.addCollect({
          title:value[0],
          author:value[1] || '',
          link:value[2],
        },(res) => {
          if(res !== undefined) {
            (res as Article).collect = true
            this.ref.value?.change(res)
          }
        })
      }
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    gridCount: 4,
    customStyle: false,
  })

  aboutToDisappear() {
    this.dialogController.close()
    this.dialogController = null
  }

  build() {
    Column() {
      CommonTopBar({title:"我的收藏",onCallClick: () => {
        this.scroller.scrollEdge(Edge.Top)
      }}) {
        Image($r('app.media.icon_add'))
          .width(20)
          .height(20)
          .margin({right:10})
          .onClick(() => {
            this.dialogController.open()
          })
      }
      ListComponent({onReachEnd: (callback: ResultCallback) => {
        collectViewModel.getCollectList(false,(result) => {
          callback(result)
        })
      },onRefreshing:(callback:ResultCallback) => {
        collectViewModel.getCollectList(true,(result) => {
          callback(result)
        })},
        viewState:this.viewState,
        scroller: this.scroller,
        ref:this.ref,
        itemComponent:(item) => this.itemBuild(item)
      })
    }
    .padding({top: BarUtils.getToolBarHeight()})
    .height('100%')
  }

  @Builder itemBuild(item:any) {
    ArticleItem({article: item,isCollectList: true})
  }

  aboutToAppear() {
    collectViewModel.observeState((state) => {
      this.viewState = state
    })
  }
}

