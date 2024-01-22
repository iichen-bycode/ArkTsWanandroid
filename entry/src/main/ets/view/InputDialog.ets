import showToast from '../utils/ToastUtils'
@CustomDialog
@Entry
export struct InputDialog {
  title: string = ''
  submitTip: string = ''
  //弹窗控制器
  controller: CustomDialogController

  inputConfig:InputDialogConfig[] = []
  private value:string[] = []
  onSubmit? : (value:string[]) => void

  aboutToAppear() {
    this.value.length = this.inputConfig.length
  }

  build() {
    Column() {
      Text(this.title)
        .fontSize($r('app.float.size_text_15'))
        .margin({ top: $r('app.float.size_10'),bottom: $r('app.float.size_10') })

      ForEach(this.inputConfig,(config: InputDialogConfig,index:number) => {
        TextArea({placeholder:config.placeholder})
          .onChange((v) => {
            this.value[index] = v
          })
          .margin({bottom: $r('app.float.size_text_15')})
      })
      Button(this.submitTip).width('60%').margin({ top: $r('app.float.size_10'),bottom: $r('app.float.size_10') })
        .onClick(() => {
          const isEmpty = this.value.every(str => str.trim() === '');
          if(isEmpty) {
            showToast("请填写完整哈！")
          } else {
            this.controller.close()
            this.onSubmit && this.onSubmit(this.value)
          }
        })
    }
    .padding($r('app.float.size_text_15'))
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r('app.color.color_white'))
    .border({ radius: $r('app.float.size_5') })
  }
}

export class InputDialogConfig {
  placeholder:string;

  constructor(placeholder:string) {
    this.placeholder = placeholder
  }
}