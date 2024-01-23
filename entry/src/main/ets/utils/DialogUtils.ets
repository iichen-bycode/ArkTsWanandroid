import promptAction from '@ohos.promptAction'

export default function showDialog(params?:{title?:string, message?: string,cancelText?:string,confirmText?:string,onCancel?:() => void,onConfirm?: () => void}) {
  try {
    promptAction.showDialog({
      title: params?.title,
      message: params?.message,
      buttons: [
        {
          text: params?.cancelText || '取消',
          color: '#888888'
        },
        {
          text: params?.confirmText || '确定',
          color: $r('app.color.color_theme'),
        }
      ],
    }).then(data => {
      if(data.index == 0)
        params?.onCancel?.()
      if(data.index == 1)
        params?.onConfirm?.()
    }).catch(err => {
      console.info('showDialog error: ' + err);
    })
  } catch (error) {
    console.error(`showToast args error code is ${error.code}, message is ${error.message}`);
  }
}
