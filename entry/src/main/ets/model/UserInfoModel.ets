/**
 * {
 "coinCount": 3159,
 "level": 32,
 "nickname": "",
 "rank": "983",
 "userId": 81826,
 "username": "i**hen"
 }
 */
import { CommonPageModel } from './CommonPageModel';
export class UserInfoModel extends CommonPageModel{
  coinCount:number;
  level:number;
  nickname:string;
  rank:string;
  userId:number;
  username:string;
}