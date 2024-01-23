/**
 *             {
 "category": 1,
 "date": 1692869633000,
 "fromUser": "daniel.chen",
 "fromUserId": 123015,
 "fullLink": "https://wanandroid.com/wenda/show/23479",
 "id": 766718,
 "isRead": 1,
 "link": "/wenda/show/23479",
 "message": "你这个不就是Leaker canary早期版本的原理吗？开双进程，发signal来通知子进程dump出日志。你看我理解的应该没错？",
 "niceDate": "2023-08-24 17:33",
 "tag": "评论回复",
 "title": "回复了@pika",
 "userId": 81826
 },
 */
import { CommonPageModel } from './CommonPageModel'
export class MessageWrapModel {
  curPage: number
  offset: number
  pageCount: number
  size: number
  total: number
  over: boolean = false
  datas: MessageModel[]
}

export class MessageModel extends CommonPageModel{
  category:number
  fromUser:string
  fromUserId:number
  userId:number
  id:number
  fullLink:string
  link:string
  message:string
  tag:string
  title:string
  niceDate:string
}
