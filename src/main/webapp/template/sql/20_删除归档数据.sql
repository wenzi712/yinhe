--清除历史数据

print '----------开始删除数据-----------------'
go
if exists(select 1 from ydkh..历史现金产品余额 where 日期 =convert(char(8),DATEADD(day,1,convert(datetime,'__REPLACE_YEAR____REPLACE_MONTH____REPLACE_DAY__',112)),112 ))
   delete ydkh..历史现金产品余额 where 日期 =convert(char(8),DATEADD(day,1,convert(datetime,'__REPLACE_YEAR____REPLACE_MONTH____REPLACE_DAY__',112)),112 )
else if exists(select 1 from ydkh..历史现金产品余额 where 日期 =convert(char(8),DATEADD(day,2,convert(datetime,'__REPLACE_YEAR____REPLACE_MONTH____REPLACE_DAY__',112)),112 ))
   delete ydkh..历史现金产品余额 where 日期 =convert(char(8),DATEADD(day,2,convert(datetime,'__REPLACE_YEAR____REPLACE_MONTH____REPLACE_DAY__',112)),112 )
else if exists(select 1 from ydkh..历史现金产品余额 where 日期 =convert(char(8),DATEADD(day,3,convert(datetime,'__REPLACE_YEAR____REPLACE_MONTH____REPLACE_DAY__',112)),112 ))
   delete ydkh..历史现金产品余额 where 日期 =convert(char(8),DATEADD(day,3,convert(datetime,'__REPLACE_YEAR____REPLACE_MONTH____REPLACE_DAY__',112)),112 )
go
delete ydkh..历史成交cd where 成交日期 ='__REPLACE_YEAR____REPLACE_MONTH____REPLACE_DAY__'
delete ydkh..jqrzrq where 交收日期 ='__REPLACE_YEAR____REPLACE_MONTH____REPLACE_DAY__'
delete ydkh..总息费 where SYSDATE ='__REPLACE_YEAR____REPLACE_MONTH____REPLACE_DAY__'
delete ydkh..历史融资融券余额  where 清算日期 ='__REPLACE_YEAR____REPLACE_MONTH____REPLACE_DAY__'

delete ydkh..集中转账 where BIZDATE ='__REPLACE_YEAR____REPLACE_MONTH____REPLACE_DAY__'
delete ydkh..两融转账 where BIZDATE ='__REPLACE_YEAR____REPLACE_MONTH____REPLACE_DAY__'
delete ydkh..结息流水 where BIZDATE ='__REPLACE_YEAR____REPLACE_MONTH____REPLACE_DAY__'
delete ydkh..产品销售 where MATCHDATE ='__REPLACE_YEAR____REPLACE_MONTH____REPLACE_DAY__'

print '----------删除数据完成-----------------'