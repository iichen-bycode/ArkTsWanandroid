import { ViewStateConstant } from '../../constants/ViewStateConstant'
import { BarUtils } from '../../utils/BarUtils'
import { InputDialog, InputDialogConfig } from '../../view/InputDialog'
import { ResultCallback } from '../../viewmodel/BaseViewMode'
import squareViewModel from '../../viewmodel/SquareViewModel'
import wenDaViewModel from '../../viewmodel/WendaViewModel'
import { ArticleItem } from '../home/component/ArticleItem'
import { ListComponent } from '../home/component/ListComponent'
@Component
@Entry
export struct HotPage {
  @State currentIndex: number = 0
  controller = new TabsController()

  @State squareViewState: string = ViewStateConstant.VIEW_STATE_LOADING
  @State wendaViewState: string = ViewStateConstant.VIEW_STATE_SUCCESS

  private title: string[] = ['分享文章','提出问题']
  private submitTip: string[] = ['分享','提交']
  private inputConfig:InputDialogConfig[][] = [
    [
      new InputDialogConfig("文章标题(必填)",true),
      new InputDialogConfig("文章链接(必填)",true)
    ],
    [
      new InputDialogConfig("问题描述(必填)",true),
    ],
  ]

  dialogController: CustomDialogController = new CustomDialogController({
    builder: InputDialog({
      title: this.title[this.currentIndex],
      submitTip: this.submitTip[this.currentIndex],
      inputConfig: this.inputConfig[this.currentIndex],
      onSubmit: (value) => {
        if(this.currentIndex == 0) {
          squareViewModel.shareArticle(value[0],value[1])
        } else {
          wenDaViewModel.askQuestion(value[0])
        }
      }
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    gridCount: 4,
    customStyle: false
  })

  aboutToDisappear() {
    this.dialogController.close()
    this.dialogController = null
  }

  @Builder tab(index: number, name: string) {
    Row() {
      Text(name)
        .fontColor(this.currentIndex===index?$r('app.color.color_theme'):$r('app.color.color_747c83'))
        .fontSize($r('app.float.size_18'))
        .onClick(()=>{
          this.controller.changeIndex(index)
        })
    }.margin({right: $r('app.float.size_30')})
  }

  build() {
    Column(){
      Row(){
        Row() {
          this.tab(0,"广场")
          this.tab(1,"问答")
        }
        Image($r('app.media.icon_add'))
          .width($r('app.float.size_22')).onClick(() => {
          this.dialogController.open()
        })
      }.justifyContent(FlexAlign.SpaceBetween)
      .padding($r('app.float.size_12'))
      .margin({bottom:$r('app.float.size_10')})
      .width('100%')
      Tabs({ controller: this.controller, barPosition: BarPosition.Start }) {
        TabContent() {
          ListComponent({onReachEnd: (callback: ResultCallback) => {
            squareViewModel.getSquareData(false,(result) => {
              callback(result)
            })
          },onRefreshing:(callback:ResultCallback) => {
            squareViewModel.getSquareData(true,(result) => {
              callback(result)
            })},viewState: this.squareViewState,itemComponent:(item) => this.itemBuild(item)
          })
        }
        TabContent() {
          ListComponent({onReachEnd: (callback: ResultCallback) => {
            wenDaViewModel.getWendaData(false,(result) => {
              callback(result)
            })
          },onRefreshing:(callback:ResultCallback) => {
            wenDaViewModel.getWendaData(true,(result) => {
              callback(result)
            })},viewState: this.wendaViewState,itemComponent:(item) => this.itemBuild(item)
          })
        }
      }
      .barWidth(0)
      .barHeight(0)
      .barMode(BarMode.Fixed)
      .onChange(index => {
        this.currentIndex = index
      })
    }.width('100%').height('100%')
    .padding({top: BarUtils.getToolBarHeight()})
  }

  @Builder itemBuild(item:any) {
    ArticleItem({article: item})
  }


  aboutToAppear() {
    squareViewModel.observeState((state) => {
      this.squareViewState = state
    })
  }
}