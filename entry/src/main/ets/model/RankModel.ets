/**
 * {
 "curPage": 2,
 "datas": [

 ],
 "offset": 20,
 "over": false,
 "pageCount": 754,
 "size": 20,
 "total": 15067
 }
 */
import { UserInfoModel } from './UserInfoModel'
export class RankModel {
  curPage: number
  offset: number
  pageCount: number
  size: number
  total: number
  over: boolean = false
  datas: UserInfoModel[]
}