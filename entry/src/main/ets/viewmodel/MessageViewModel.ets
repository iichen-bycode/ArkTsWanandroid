import { getMessageList } from '../http/api';
import { MessageWrapModel } from '../model/MessageModel';
import { BaseViewModel, ResultCallback } from './BaseViewMode';
export class MessageViewModel extends BaseViewModel {
  private page:number = 1
  private messageModel: MessageWrapModel = new MessageWrapModel()
  async getMessageList(isRefresh:boolean,callback: ResultCallback) {
    if(isRefresh) {
      this.page = 1
      this.messageModel.over = false
    }
    if(this.messageModel.over && false) {
      callback([])
    } else {
      await this.request()
        .promise(getMessageList(this.page),isRefresh)
        .then((result) => {
          ++this.page
          this.messageModel = result
          callback(this.messageModel.datas)
        })
    }
  }
}

let messageViewModel = new MessageViewModel()
export default messageViewModel as MessageViewModel