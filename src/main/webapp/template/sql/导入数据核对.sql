update 月度考核 set 有效覆盖系数 = 1, 重大任务系数1 = 1, 重大任务系数权重1=1

--select * from sysobjects where   type ='U'

--核对当前数据
select count(*) from crmcd
select count(*) from 天天利
select count(*) from 现金产品余额
select count(*) from 产品销售tt 

select count(*) from 结息流水tt
select count(*) from 集中转帐tt
select count(*) from 当月成交cd
select count(*) from 两融余额

select count(*) from 当月息费
select count(*) from 两融成交
select count(*) from 两融转帐tt
select count(*) from 两融开户


--select count(*) from 产品明细2014
--select count(*) from 维持cdtt
--select count(*) from 流失客户CRM



select count(*) from  降佣流水2015

--核对历史数据
select SUM(convert(money,基金余额)),count(*) from 历史现金产品余额 where left(convert(char(8),convert(int,日期)),6) ='201604'
select SUM(convert(money,FEE_JSXF)),count(*) from 历史成交cd where left(convert(char(8),convert(int,成交日期)),6) ='201604'
select SUM(convert(money,净手续费)),count(*) from jqrzrq where left(convert(char(8),convert(int,交收日期)),6) ='201604'
select SUM(convert(money,FUNDEFFECT)),count(*) from 总息费 where left(convert(char(8),convert(int,SYSDATE)),6) ='201604'
select SUM(convert(money,总负债)),count(*) from 历史融资融券余额  where left(convert(char(8),convert(int,清算日期)),6) ='201604'

select count(*) from 集中转账 where left(convert(char(8),convert(int,BIZDATE)),6) ='201604'
select count(*) from 两融转账 where left(convert(char(8),convert(int,BIZDATE)),6) ='201604'
select count(*) from 结息流水 where left(convert(char(8),convert(int,BIZDATE)),6) ='201604'



--核对历史数据当日
select '历史现金产品余额',SUM(convert(money,基金余额)),count(*) from 历史现金产品余额 where 日期 ='20160426'
select '历史成交cd',SUM(convert(money,FEE_JSXF)),count(*) from 历史成交cd where 成交日期 ='20160425'
select 'jqrzrq',SUM(convert(money,净手续费)),count(*) from jqrzrq where 交收日期 ='20160425'
select '总息费',SUM(convert(money,FUNDEFFECT)),count(*) from 总息费 where SYSDATE ='20160425'
select '历史融资融券余额',SUM(convert(money,总负债)),count(*) from 历史融资融券余额  where 清算日期 ='20160425'

select '集中转账',count(*) from 集中转账 where BIZDATE ='20160425'
select '两融转账',count(*) from 两融转账 where BIZDATE ='20160425'
select '结息流水',count(*) from 结息流水 where BIZDATE ='20160425'
select '产品销售', COUNT(*) from 产品销售 where MATCHDATE='20160425'



--清除历史数据
delete ydkh..历史现金产品余额 where  日期 ='20160426'
delete ydkh..历史成交cd where 成交日期 ='20160425'
delete ydkh..jqrzrq where 交收日期 ='20160425'
delete ydkh..总息费 where SYSDATE ='20160425'
delete 历史融资融券余额  where 清算日期 ='20160425'

delete ydkh..集中转账 where BIZDATE ='20160425'
delete ydkh..两融转账 where BIZDATE ='20160425'
delete ydkh..结息流水 where BIZDATE ='20160425'
delete ydkh..产品销售 where MATCHDATE='20160425'