//
//  NetFunc.h
//  YQS
//
//  Created by l on 3/14/15.
//  Copyright (c) 2015 l. All rights reserved.
/**
 *  <#Description#>
 */

#ifndef YQS_NetFunc_h
#define YQS_NetFunc_h

#define NET_FUNC_SYSTEM_APPUPDATE_CHECK_GET        @"system.appupdate.check.get"
#define NET_FUNC_SYSTEM_VALIDATECODE_ITEM_POST     @"system.validatecode.item.post"
#define NET_FUNC_SYSTEM_VALIDATECODE_CHECK_POST    @"system.validatecode.check.post"
#define NET_FUNC_SYSTEM_VALIDATECODE_CHECK_POST    @"system.validatecode.check.post"
#define NET_FUNC_SYSTEM_AUTHENTICATION_USER_POST   @"system.authentication.user.post"
#define NET_FUNC_user_socialaccount_binding_POST   @"user.socialaccount.binding.post"
#define NET_FUNC_USER_LIST_SEARCH_GET              @"user.list.search.get"
#define NET_FUNC_USER_IDENTIFY_RESULT_GET        @"user.identify.result.get"
#define NET_FUNC_USER_IDENTIFY_progress_get        @"user.identify.progress.get"
#define NET_FUNC_USER_IDENTIFY_detail_GET          @"user.identify.detail.get"
#define NET_FUNC_USER_IDENTIFY_action_post         @"user.identify.action.post"
#define NET_FUNC_USER_LICENSE_action_post         @"user.license.action.post"
#define NET_FUNC_USER_PROFILE_INFO_GET             @"user.profile.info.get"
#define NET_FUNC_USER_PROFILE_DETAIL_POST          @"user.profile.detail.post"
#define NET_FUNC_USER_PAYMENTGATEWAY_PASSWORD_POST @"user.paymentgateway.password.post"
#define NET_FUNC_CREDIT_ACCOUNT_CONTENT_GET        @"credit.account.content.get"
#define NET_FUNC_CREDIT_COMMON_ACTION_POST         @"credit.common.action.post"
#define NET_FUNC_CREDIT_USER_LIST_GET              @"credit.user.list.get"
#define NET_FUNC_CREDIT_USER_creditvals_GET        @"credit.user.creditvals.get"
#define NET_FUNC_CREDIT_USER_acquire_post          @"credit.user.acquire.post"
#define NET_FUNC_CREDIT_LOAN_LIST_GET              @"credit.loan.list.get"
#define NET_FUNC_LOAN_ORDER_LIST_GET               @"loan.order.list.get"
#define NET_FUNC_CREDIT_LOAN_DETAIL_GET            @"credit.loan.detail.get"
#define NET_FUNC_FLOW_BILL_DETAIL_GET              @"flow.bill.detail.get"
#define NET_FUNC_CREDIT_INVITE_LIST_GET            @"credit.invite.list.get"
#define NET_FUNC_FLOW_BILL_LIST_GET                @"flow.bill.list.get"
#define NET_FUNC_FLOW_BILL_DETAIL_GET              @"flow.bill.detail.get"
#define NET_FUNC_FLOW_BILL_LIST_GET                @"flow.bill.list.get"
#define NET_FUNC_FLOW_BILL_CASHADVANCE_POST        @"flow.bill.cashadvance.post"
#define NET_FUNC_FLOW_BILL_RECHARGE_POST           @"flow.bill.recharge.post"
#define NET_FUNC_FLOW_CACHEHISTORY_LIST_GET        @"flow.cachehistory.list.get"
#define NET_FUNC_LOAN_ORDER_ITEM_POST              @"loan.order.item.post"
#define NET_FUNC_LOAN_ORDER_DETAIL_GET             @"loan.order.detail.get"
#define NET_FUNC_LOAN_ORDER_LIST_GET               @"loan.order.list.get"
#define NET_FUNC_LOAN_ORDER_DETAIL_GET             @"loan.order.detail.get"
#define NET_FUNC_LOAN_WARRANTY_LIST_GET            @"loan.warranty.list.get"
#define NET_FUNC_LOAN_ATTACHMENT_LIST_GET          @"loan.attachment.list.get"
#define NET_FUNC_BET_ORDER_ITEM_POST               @"bet.order.item.post"
#define NET_FUNC_BET_ORDER_LIST_GET                @"bet.order.list.get"
#define NET_FUNC_IOU_ORDER_LIST_GET                @"iou.order.list.get"
#define NET_FUNC_IOU_ORDER_DETAIL_GET              @"iou.order.detail.get"
#define NET_FUNC_IOU_REPAYTYPE_LIST_GET            @"iou.repaytype.list.get"
#define NET_FUNC_LOAN_ORDER_DETAIL_GET             @"loan.order.detail.get"
#define NET_FUNC_LOAN_MYORDER_DETAIL_GET           @"loan.myorder.detail.get"
#define NET_FUNC_LOAN_ORDER_CALCVALS_GET           @"loan.order.calcvals.get"
#define NET_FUNC_BET_USER_LIST_GET                 @"bet.user.list.get"
#define NET_FUNC_BET_ORDER_DETAIL_GET              @"bet.order.detail.get"
#define NET_FUNC_user_visa_binding_post            @"user.visa.binding.post"
#define NET_FUNC_user_visa_list_get                @"user.visa.list.get"
#define NET_FUNC_user_license_detail_get           @"user.license.detail.get"
#define NET_FUNC_LOAN_ORDER_LIST_GET               @"loan.order.list.get"
#define NET_FUNC_LOAN_MYORDER_LIST_GET             @"loan.myorder.list.get"
#define NET_FUNC_REPAYMENT_ORDER_LIST_GET          @"repayment.order.list.get"
#define NET_FUNC_REPAYMENT_ORDER_ITEM_POST         @"repayment.order.item.post"
#define NET_FUNC_REPAYMENT_ORDER_ITEM_POST         @"repayment.order.item.post"
#define NET_FUNC_REPAYMENT_GUARANTEE_POST           @"loan.overdue.item.post"
#define NET_FUNC_NOTICE_COMMON_LIST_GET             @"notice.common.list.get"
#define NET_FUNC_NOTICE_ITEM_DETAIL_GET             @"notice.item.detail.get"
#define NET_FUNC_NOTICE_BILL_LIST_GET               @"notice.bill.list.get"
#define NET_FUNC_NOTICE_BILL_detail_GET             @"notice.bill.detail.get"
#define NET_FUNC_NOTICE_UPDATE_REMIND_GET           @"notice.update.remind.get"
#define NET_FUNC_credit_user_invitelist_get         @"credit.user.invitelist.get"
#define NET_FUNC_system_configure_info_get          @"system.configure.info.get"
#define NET_FUNC_system_options_list_get            @"system.options.list.get"
#define NET_FUNC_mortgage_constraint_check_get      @"mortgage.constraint.check.get"
#define NET_FUNC_user_transfer_history_get      @"user.transfer.history.get"
#define NET_FUNC_USERE_TRANSFER_DATA_GET         @"user.transfer.data.get"
#define NET_FUNC_LOAN_FRIENDS_LIST_GET         @"friends.bet.list.get"

#define NET_FUNC_user_visa_active_post  @"user.visa.active.post" //绑定银行卡激活，发送绑卡验证码
#define NET_FUNC_paymentway_validatecode_check_post @"paymentway.validatecode.check.post"
#define NET_FUNC_paymentway_bank_info_get @"paymentway.bank.info.get"
#define NET_FUNC_transfer_withdraw_action_post  @"transfer.withdraw.action.post"
#define NET_FUNC_user_transfer_action_post      @"user.transfer.action.post"

#define NET_FUNC_user_visa_unbinding_post @"user.visa.unbinding.post"
#define NET_KEY_visaid @"visaid"

#define NET_KEY_limiteverytrade @"limiteverytrade"
#define NET_KEY_limiteveryday @"limiteveryday"
#define NET_FUNC_user_identify_check_post @"user.identify.check.post"
#define NET_FUNC_transfer_recharge_action_post @"transfer.recharge.action.post"
#define NET_FUNC_loan_item_action_post @"loan.item.action.post"

#define NET_FUNC_BET_DATE_LIST_GET @"bet.date.list.get" 
#define NET_FUNC_CALENDAR_LIST_GET @"calendar.bet.list.get"

#define NET_KEY_optionname @"optionname"

#endif
