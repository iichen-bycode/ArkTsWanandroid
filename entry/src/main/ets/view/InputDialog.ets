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

  @State status:boolean = false

  aboutToAppear() {
    this.value.length = this.inputConfig.length
  }

  build() {
    Column() {
      Text(this.title)
        .fontSize($r('app.float.size_text_15'))
        .margin({ top: $r('app.float.size_10'),bottom: $r('app.float.size_16') })

      ForEach(this.inputConfig,(config: InputDialogConfig,index:number) => {
        TextArea({placeholder:config.placeholder})
          .onChange((v) => {
            this.value[index] = v
            this.status = this.valid()
          })
          .padding({top: $r('app.float.size_15'),bottom: $r('app.float.size_15')})
          .margin({bottom: $r('app.float.size_15'),left: $r('app.float.size_10'),right: $r('app.float.size_10')})
      })
      Button(this.submitTip)
        .width('60%')
        .margin({ top: $r('app.float.size_10'),bottom: $r('app.float.size_10') })
        .enabled(this.status)
        .onClick(() => {
          if(this.valid()) {
            this.controller.close()
            this.onSubmit && this.onSubmit(this.value)
          } else {
            showToast("请填写完必填项哈！")
          }
        })
    }
    .padding($r('app.float.size_15'))
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r('app.color.color_white'))
    .border({ radius: $r('app.float.size_5') })
  }

  valid() : boolean {
    let result = true
    let len = this.value.length
    for (let i = 0; i < len; i++) {
      if(this.inputConfig[i].isRequire && (this.value[i] === "" || this.value[i] === undefined)) {
        result = false
        break
      }
    }
    return result
  }
}

export class InputDialogConfig {
  placeholder:string;
  isRequire:boolean;

  constructor(placeholder:string,isRequire:boolean) {
    this.placeholder = placeholder
    this.isRequire = isRequire
  }
}