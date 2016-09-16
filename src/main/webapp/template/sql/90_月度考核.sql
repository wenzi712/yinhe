USE ydkh
GO

-----计算开始----------------------------------------------------------------------------
----基期收入市占率
UPDATE 营业部基本客户库 SET 新服务人 = '', 总资产 = 0
GO
UPDATE 营业部基本客户库 SET 新服务人 = b.服务人, 总资产 = b.zzc FROM 营业部基本客户库 a, crmcd b WHERE a.柜台客户代码 = b.柜台客户代码
GO
UPDATE 月度考核 SET 客户数 = 0, 总资产 = 0, 收入市占率13 = 0, 全市场收入13 = 0, 净佣13 = 0, 两融净佣13 = 0, 利差13 = 0, 息费13 = 0, 天天利13 = 0, 水星一13 = 0, 水星二13 = 0
GO
DROP TABLE kkk
GO
SELECT  新服务人,  COUNT(*)   AS num,  SUM(总资产)  AS zzc,  SUM(净佣13) AS 净佣, SUM(两融净佣13)  AS 两融净佣,  SUM(利差13) AS 利差,  SUM(两融息费13) AS 息费,
  SUM(天天利积数13) / 365  AS 天天利,  SUM(水星1号积数13) / 365 AS 水星1,  SUM(水星2号积数13) / 365 AS 水星2 INTO kkk FROM 营业部基本客户库 GROUP BY 新服务人
GO
UPDATE 月度考核 
SET 客户数 = b.num, 总资产 = b.zzc / 10000, 净佣13 = b.净佣, 两融净佣13 = b.两融净佣, 利差13 = b.利差, 息费13 = b.息费, 天天利13 = b.天天利, 水星一13 = b.水星1, 水星二13 = b.水星2
FROM 月度考核 a, kkk b WHERE a.姓名 = b.新服务人
GO
UPDATE 月度考核 SET 天天利13 = 天天利13 * 分段标识1, 水星一13 = 水星一13 * 分段标识2, 水星二13 = 水星二13 * 分段标识2 
 FROM 月度考核 a, 积分参数表 b WHERE 参数名称 = '增收系数系数'
GO
UPDATE 月度考核 SET 全市场收入13=分段标识1 FROM 月度考核 a, 积分参数表 b  WHERE 参数名称 = '全市场收入'

UPDATE 月度考核 SET 收入市占率13 = (净佣13 + 两融净佣13 + 利差13 + 息费13 + 天天利13 + 水星一13 + 水星二13) / 全市场收入13 / 10000
---------------------------------------------------------------------------------
-------------------临时增加
--导出降佣名单 110810,110811
--融资融券调佣摘要,110310,110312,120159
--select * from digest where digestname like '%特殊%' 查抄摘要
--select distinct operdate,name,custid,right(remark,10) from his..h_loguser where  operdate>'20140101'  and operdate<'20140401'
--and digestid in ('110810','110811')  order by operdate
--go
------------------本期收入市占率
---------------******开始计算本期量化考核数据******--------------------
UPDATE 月度考核
SET 客户数 = 0, 总资产 = 0, 新增资产 = 0,  利差 = 0, 息费 = 0, 收入市占差值 = 0, 流失客户数 = 0, 流失资产 = 0, 流失年佣金 = 0,两融开户=0,
  降佣损失  = 0, 流失佣金收入 = 0, 流失资产收入 = 0, 隐形流失资产 = 0, 流失佣金基数 = 0, 流失资产基数 = 0, 净佣 = 0, 两融净佣 = 0, 天天利 = 0, 水星1 = 0, 水星2 = 0, 水星3 = 0, 水星5 = 0, 产品销售收入 = 0
GO
UPDATE 月度考核 SET 新开户 = 0, 新开户1w = 0, 新开户10w = 0, 新开户50w = 0, 权益产品 = 0, 固定产品 = 0, 服务奖金发放值=0,服务奖金计算值=0

UPDATE 月度考核 SET 本期市场收入 = 0, 收入合计 = 0, 可提成基数 = 0, 提成基数 = 0, 达标客户 = 0, 资产贡献度 = 0, 本期目标创收额 = 0, 收入市占率 = 0, 增收系数 = 0

UPDATE 月度考核 SET  部门调整额 = 0,部门调整备注='', 服务奖金预发放值=0,上月末余额=0,上月末余额市占率=0,本月末余额=0,本月末余额市占率=0 , 续做固定产品=0, 降佣客户=0

UPDATE 月度考核 SET 重大任务系数权重1 = 分段标识1, 重大任务系数权重2 = 分段标识2, 重大任务系数权重3 = 参数1, 重大任务系数权重4 = 参数2, 重大任务系数权重5 = 参数3
FROM 月度考核 a, 积分参数表 b WHERE 参数名称 = '重大考核任务权重'

UPDATE 月度考核 SET 本期市场收入=参数1 FROM 月度考核 a, 积分参数表 b  WHERE 参数名称 = '全市场收入'

--update crmcd set 服务人=b.员工姓名 from crmcd a, 异地客户组 b where a.柜台客户代码=b.资金账号
--update 营业部基本客户库 set 新服务人=b.员工姓名 from 营业部基本客户库 a, 异地客户组 b where a.柜台客户代码=b.资金账号
go

----------------------------计算积分----------------------------------
--服务客户数,总资产
DROP TABLE ttt
GO
SELECT  服务人,  COUNT(*) AS num,  SUM(zzc) AS zzc INTO ttt FROM crmcd GROUP BY 服务人
GO
GO
UPDATE 月度考核 SET 客户数 = b.num, 总资产 = b.zzc / 10000 FROM 月度考核 a, ttt b WHERE a.姓名 = b.服务人
GO

---权益产品销售
DROP TABLE tttt
GO
SELECT 销售人, SUM(CAST(金额 AS MONEY)) / 10000 AS num INTO tttt  FROM 产品明细2014
  WHERE 交易类型 = '权益类' AND LEFT(CONVERT(CHAR(8), CONVERT(INT, 日期)), 6) IN ('__REPLACE_YEAR____REPLACE_MONTH__') GROUP BY 销售人
GO
UPDATE 月度考核 SET 权益产品 = b.num FROM 月度考核 a, tttt b WHERE a.姓名 = b.销售人
GO

---固定产品销售
DROP TABLE tttt
GO
SELECT 销售人, SUM(CAST(金额 AS MONEY)) / 10000 AS num INTO tttt FROM 产品明细2014
WHERE 交易类型 = '固定类' AND LEFT(CONVERT(CHAR(8), CONVERT(INT, 日期)), 6) IN ('__REPLACE_YEAR____REPLACE_MONTH__') 
and 客户代码 not in (  select 客户代码 from 产品明细2014 where 日期 < convert(char(8),convert(datetime,'__REPLACE_YEAR____REPLACE_MONTH__'+'01',112),112 )
                   and  日期> = convert(char(8),DATEADD(month,-3,convert(datetime,'__REPLACE_YEAR____REPLACE_MONTH__'+'01',112)),112 )
                   and 交易类型 = '固定类' )
GROUP BY 销售人
GO
UPDATE 月度考核 SET 固定产品 = b.num FROM 月度考核 a, tttt b WHERE a.姓名 = b.销售人
GO

---续做固定产品销售
DROP TABLE tttt
GO
SELECT 销售人, SUM(CAST(金额 AS MONEY)) / 10000 AS num INTO tttt FROM 产品明细2014
WHERE 交易类型 = '固定类' AND LEFT(CONVERT(CHAR(8), CONVERT(INT, 日期)), 6) IN ('__REPLACE_YEAR____REPLACE_MONTH__') 
and 客户代码 in (  select 客户代码 from 产品明细2014 where 日期 < convert(char(8),convert(datetime,'__REPLACE_YEAR____REPLACE_MONTH__'+'01',112),112 )
                   and  日期> = convert(char(8),DATEADD(month,-3,convert(datetime,'__REPLACE_YEAR____REPLACE_MONTH__'+'01',112)),112 )
                   and 交易类型 = '固定类' )
GROUP BY 销售人
GO
UPDATE 月度考核 SET 续做固定产品 = b.num FROM 月度考核 a, tttt b WHERE a.姓名 = b.销售人
GO

--产品销售收入
DROP TABLE tttt
GO
SELECT 销售人, SUM(CAST(销售收入 AS MONEY)) AS num INTO tttt FROM 产品明细2014 
 WHERE LEFT(CONVERT(CHAR(8), CONVERT(INT, 日期)), 6) IN ('__REPLACE_YEAR____REPLACE_MONTH__') GROUP BY 销售人
GO
UPDATE 月度考核 SET 产品销售收入 = b.num FROM 月度考核 a, tttt b WHERE a.姓名 = b.销售人
GO

---新开户,新增资产
DROP TABLE tttt
GO
SELECT 开发人,COUNT(*) AS num INTO tttt FROM crmcd
WHERE LEFT(开户日期, 6) IN ('__REPLACE_YEAR____REPLACE_MONTH__') AND zzc >= 500000  AND 开户营业部 LIKE '%建设%' GROUP BY 开发人
GO
UPDATE 月度考核 SET 新开户50w = b.num FROM 月度考核 a, tttt b WHERE a.姓名 = b.开发人
GO

DROP TABLE tttt
GO
SELECT 开发人, COUNT(*) AS num INTO tttt FROM crmcd WHERE LEFT(开户日期, 6) IN ('__REPLACE_YEAR____REPLACE_MONTH__') 
  AND zzc >= 100000 AND zzc < 500000       AND 开户营业部 LIKE '%建设%' GROUP BY 开发人
GO
UPDATE 月度考核 SET 新开户10w = b.num FROM 月度考核 a, tttt b WHERE a.姓名 = b.开发人
GO

DROP TABLE tttt
GO
SELECT 开发人,COUNT(*) AS num INTO tttt FROM crmcd
WHERE LEFT(开户日期, 6) IN ('__REPLACE_YEAR____REPLACE_MONTH__') AND zzc >= 10000 AND zzc < 100000 AND 开户营业部 LIKE '%建设%' GROUP BY 开发人
GO
UPDATE 月度考核 SET 新开户1w = b.num FROM 月度考核 a, tttt b WHERE a.姓名 = b.开发人
GO

DROP TABLE tttt
GO
SELECT 开发人, COUNT(*) AS num INTO tttt FROM crmcd
WHERE LEFT(开户日期, 6) IN ('__REPLACE_YEAR____REPLACE_MONTH__') AND zzc < 10000 AND 开户营业部 LIKE '%建设%' GROUP BY 开发人
GO
UPDATE 月度考核 SET 新开户 = b.num FROM 月度考核 a, tttt b WHERE a.姓名 = b.开发人
GO

DROP TABLE tttt
GO
SELECT 开发人,SUM(zzc) / 10000 AS zzc INTO tttt FROM crmcd WHERE LEFT(开户日期, 6) IN ('__REPLACE_YEAR____REPLACE_MONTH__') 
  AND 开户营业部 LIKE '%建设%' GROUP BY 开发人
GO
UPDATE 月度考核 SET 新增资产 = b.zzc FROM 月度考核 a, tttt b WHERE a.姓名 = b.开发人
GO


---两融新开户
DROP TABLE tttt
GO
SELECT 服务人, COUNT(*) AS num INTO tttt FROM crmcd 
  WHERE 柜台客户代码 IN (SELECT 客户代码 FROM 两融开户  WHERE LEFT(CONVERT(CHAR(8), CONVERT(INT, 开户日期)), 6) IN ('__REPLACE_YEAR____REPLACE_MONTH__'))
GROUP BY 服务人
GO
UPDATE 月度考核 SET 两融开户 = b.num FROM 月度考核 a, tttt b WHERE a.姓名 = b.服务人
GO

--特殊修改20160316
--上月末余额
drop table ttt
go
select * into ttt from 历史融资融券余额
 where left(convert(char(8),convert(int,清算日期)),6)=left(convert(char(8),DATEADD(month,-1,convert(datetime,'__REPLACE_YEAR____REPLACE_MONTH__'+'01',112)),112 ),6)
-- where left(convert(char(8),convert(int,清算日期)),6)=left(convert(char(8),DATEADD(month,-1,convert(datetime,'201602'+'01',112)),112 ),6)
go
ALTER TABLE  ttt ADD 服务人 char(20)
go
update ttt set 服务人=''
go
update ttt set 服务人=b.服务人 from ttt a,crmcd b where a.客户代码=b.柜台客户代码
go
drop table tttt
go
select 服务人,sum(总负债)/10000 as zzc into tttt from ttt where 清算日期 in ( select max(清算日期) from ttt)  group by 服务人
go
update 月度考核 set 上月末余额=b.zzc from 月度考核 a,tttt b where a.姓名=b.服务人
go

--本月末余额
drop table ttt
go
select * into ttt from 历史融资融券余额 where left(convert(char(8),convert(int,清算日期)),6) in ('__REPLACE_YEAR____REPLACE_MONTH__')
--select * into ttt from 历史融资融券余额 where left(convert(char(8),convert(int,清算日期)),6) in ('20602')
go
ALTER TABLE  ttt ADD 服务人 char(20)
go
update ttt set 服务人=''
go
update ttt set 服务人=b.服务人 from ttt a,crmcd b where a.客户代码=b.柜台客户代码
go
drop table tttt
go
select 服务人,sum(总负债)/10000 as zzc into tttt from ttt where 清算日期 in ( select max(清算日期) from ttt)  group by 服务人
go
update 月度考核 set 本月末余额=b.zzc from 月度考核 a,tttt b where a.姓名=b.服务人
go


------------------------------------------
--------------流失客户------------
DROP TABLE 客户流失4
GO
SELECT 开户营业部, 柜台客户代码, 客户姓名,销户日期,服务人, CONVERT(MONEY, 本年净佣金) AS jsxf INTO 客户流失4
FROM crmcd WHERE 销户日期 >= '__REPLACE_YEAR__0101'  AND 柜台客户代码 NOT IN (SELECT 客户代码 FROM 非流失客户) and 客户状态='销户'
GO
ALTER TABLE 客户流失4 ADD 资产 MONEY
GO
UPDATE 客户流失4 SET 资产 = 0
GO

--流失佣金
DECLARE @CUSTID CHAR(12), @jsxf MONEY, @operdate CHAR(8)

DECLARE dxsql CURSOR FOR SELECT DISTINCT 柜台客户代码,销户日期 FROM 客户流失4  WHERE 开户营业部 = '成都建设路营业部'
OPEN dxsql
FETCH dxsql INTO @CUSTID, @operdate
WHILE @@FETCH_STATUS = 0
BEGIN
  SELECT @jsxf = SUM(FEE_JSXF) FROM 历史成交cd
  WHERE 成交日期 > CONVERT(CHAR(8), DATEADD(MONTH, -12, CONVERT(DATETIME, @operdate, 112)), 112) AND FUNDID = @CUSTID
  UPDATE 客户流失4   SET jsxf = @jsxf  WHERE 柜台客户代码 = @CUSTID
  SELECT @jsxf = 0
  FETCH dxsql INTO @CUSTID, @operdate
END
CLOSE dxsql
DEALLOCATE dxsql
GO

--流失资产
DECLARE @CUSTID CHAR(12), @zc MONEY, @operdate CHAR(8)

DECLARE dxsql CURSOR FOR SELECT DISTINCT 柜台客户代码, 销户日期 FROM 客户流失4
OPEN dxsql
FETCH dxsql INTO @CUSTID, @operdate
WHILE @@FETCH_STATUS = 0
BEGIN
  --    select @zc=max(资产峰值) from 流失客户crmcd2013  where 资金账号=@CUSTID
  SELECT @zc = max(资产峰值)  FROM 流失客户CRM  WHERE 资金账号 = @CUSTID
        AND 统计月份 > LEFT(CONVERT(CHAR(8), DATEADD(MONTH, -7, CONVERT(DATETIME, @operdate, 112)), 112), 6)
  UPDATE 客户流失4   SET 资产 = @zc  WHERE 柜台客户代码 = @CUSTID
  SELECT @zc = 0
  FETCH dxsql INTO @CUSTID, @operdate
END
CLOSE dxsql
DEALLOCATE dxsql
GO

----------
ALTER TABLE 客户流失4 ADD 系数 MONEY
GO
UPDATE 客户流失4 SET 系数 = 0
GO
UPDATE 客户流失4 SET 系数 = 1 WHERE jsxf <= 3000
UPDATE 客户流失4 SET 系数 = jsxf / 3000 WHERE jsxf > 3000
GO
UPDATE 客户流失4 SET 系数 = 5 WHERE 系数 > 5
GO

--删除卫星营业部内转客户
DELETE 客户流失4 WHERE 柜台客户代码 IN (SELECT 客户代码建设  FROM 卫星营业部月度考核)
GO

--统计本年累计流失客户佣金收入,资产收入
DROP TABLE ttt
GO
SELECT 服务人, SUM(jsxf / 12 * (系数)) AS 流失佣金收入,  SUM(资产) * 0.005 AS 流失资产收入 INTO ttt  FROM 客户流失4
WHERE 销户日期 < CONVERT(CHAR(8), DATEADD(MONTH, 1, CONVERT(DATETIME, '__REPLACE_YEAR____REPLACE_MONTH__' + '01', 112)), 112) GROUP BY 服务人
GO
UPDATE 月度考核 SET 流失佣金收入 = isnull(b.流失佣金收入,0) , 流失资产收入 = isnull(b.流失资产收入,0) FROM 月度考核 a, ttt b WHERE 姓名 = 服务人
GO

--统计当月流失客户佣金,资产;流失佣金基数,流失资产基数
DROP TABLE ttt
GO
SELECT   服务人, isnull(SUM(jsxf),0)  AS lssxf积分, COUNT(*) AS lskhs积分, isnull(SUM(资产)/10000,0)  AS lszc积分, isnull(SUM(jsxf / 12) * 3,0) AS 流失佣金收入基数,
  isnull(SUM(资产) * 0.003,0) AS 流失资产收入基数 INTO ttt FROM 客户流失4
-- WHERE LEFT(销户日期, 6) IN ('__REPLACE_YEAR____REPLACE_MONTH__')
 --修改20160620
 WHERE 销户日期 > = convert(char(8),DATEADD(month,-3,convert(datetime,'__REPLACE_YEAR____REPLACE_MONTH__'+'01',112)),112 )
 GROUP BY 服务人
GO
UPDATE 月度考核 SET 流失年佣金 = b.lssxf积分, 流失客户数 = isnull(b.lskhs积分,0), 流失资产 = b.lszc积分, 
                   流失佣金基数 =b.流失佣金收入基数, 流失资产基数 = b.流失资产收入基数
  FROM 月度考核 a, ttt b WHERE 姓名 = 服务人
GO

--------疑似流失客户考核考核------
update 疑似流失客户考核 set 年净佣=0,系数=0
go
--流失佣金
declare @CUSTID char(12), @jsxf money

declare dxsql cursor for select distinct 柜台客户代码 from ydkh..疑似流失客户考核
open dxsql
fetch dxsql into @CUSTID
WHILE @@FETCH_STATUS = 0
begin      
       select @jsxf=sum(FEE_JSXF) from ydkh..历史成交cd
         where 成交日期 > convert(char(8),DATEADD(month,-12,convert(datetime,'__REPLACE_YEAR____REPLACE_MONTH__' + '01',112)),112 ) and FUNDID=@CUSTID
    update  ydkh..疑似流失客户考核 set 年净佣= @jsxf where 柜台客户代码=@CUSTID
   select @jsxf=0
   fetch dxsql into @CUSTID
end
close dxsql
deallocate dxsql         
go
----------
update 疑似流失客户考核 set 系数=1 where CAST(年净佣 AS MONEY)<=3000
update 疑似流失客户考核 set 系数= CAST(年净佣 AS MONEY)/3000 where  CAST(年净佣 AS MONEY)>3000
go
update 疑似流失客户考核 set 系数=5  where  CAST(系数 AS MONEY)>5
go
drop table ttt
go
select 服务人, sum( CAST(年净佣 AS MONEY)) as 年净佣, sum(CAST(年净佣 AS MONEY)/12*(CAST(系数 AS MONEY))) as 流失佣金收入,
sum(convert(money,月初资产))*0.005 as 隐形流失资产   into ttt from 疑似流失客户考核 group by 服务人
go
update 月度考核 set 流失年佣金=流失年佣金+isnull(b.年净佣,0), 流失佣金收入=a.流失佣金收入+isnull(b.流失佣金收入,0) , 隐形流失资产=isnull(b.隐形流失资产,0)
 from 月度考核 a, ttt b where 姓名=服务人
go

-----------------------********降佣损失********------------------------------------------
DROP TABLE 降佣流水tt
GO
SELECT  Col001 AS 日期,  Col002 AS 客户姓名,  Col003 AS 客户代码,  Col004 AS 费率1,  Col005 AS 费率2 INTO 降佣流水tt 
  FROM 降佣流水2015  WHERE abs(CONVERT(MONEY, Col005) - CONVERT(MONEY, Col004)) / CONVERT(MONEY, Col004) > 0.3 AND CONVERT(MONEY, Col005) < 0.0008
      AND LEFT(CONVERT(CHAR(8), CONVERT(INT, Col001)), 6) = '__REPLACE_YEAR____REPLACE_MONTH__'   ORDER BY Col001
GO
ALTER TABLE 降佣流水tt ADD 服务人 CHAR(20)
ALTER TABLE 降佣流水tt ADD lssxf MONEY
GO
UPDATE 降佣流水tt SET lssxf = 0, 服务人 = ''
GO
UPDATE 降佣流水tt SET 服务人 = b.服务人 FROM 降佣流水tt a, crmcd b WHERE a.客户代码 = b.柜台客户代码
GO
--update 降佣流水tt set lssxf=本年净佣金 from 降佣流水tt a, crmcd b where a.客户代码=b.柜台客户代码
-- GO
--------计算佣金流失-----------------------------------------
DECLARE @CUSTID CHAR(12), @operdate CHAR(8), @lssxf MONEY
DECLARE dxsql CURSOR FOR SELECT DISTINCT 客户代码, CONVERT(CHAR(8), CONVERT(INT, 日期)) AS 日期  FROM 降佣流水tt  ORDER BY 日期
OPEN dxsql
FETCH dxsql INTO @CUSTID, @operdate
WHILE @@FETCH_STATUS = 0
BEGIN
  SELECT @lssxf = SUM(FEE_JSXF)   FROM 历史成交cd 
  WHERE 成交日期 > CONVERT(CHAR(8), DATEADD(MONTH, -12, CONVERT(DATETIME, @operdate, 112)), 112) AND FUNDID = @CUSTID
  UPDATE 降佣流水tt   SET lssxf = isnull(@lssxf, 0)   WHERE 客户代码 = @CUSTID
  FETCH dxsql   INTO @CUSTID, @operdate
END
CLOSE dxsql
DEALLOCATE dxsql
GO

--------------------
DROP TABLE ttt
GO
SELECT  服务人,  SUM(lssxf * ((CONVERT(MONEY, 费率1) - CONVERT(MONEY, 费率2)) / CONVERT(MONEY, 费率1))) / 12 AS lssxf 
  INTO ttt FROM 降佣流水tt GROUP BY 服务人
-- where LEFT(日期,6) in ('__REPLACE_YEAR____REPLACE_MONTH__')
GO
UPDATE 月度考核 SET 降佣损失 = b.lssxf FROM 月度考核 a, ttt b WHERE 姓名 = 服务人
GO

-----------------------********降佣客户扣分********------------------------------------------
DROP TABLE 降佣流水tt
GO
SELECT  Col001 AS 日期,  Col002 AS 客户姓名,  Col003 AS 客户代码,  Col004 AS 费率1,  Col005 AS 费率2 INTO 降佣流水tt FROM 降佣流水2015  
   WHERE CONVERT(MONEY, Col005) < 0.0006 AND LEFT(CONVERT(CHAR(8), CONVERT(INT, Col001)), 6) = '__REPLACE_YEAR____REPLACE_MONTH__'   ORDER BY Col001
GO
ALTER TABLE 降佣流水tt ADD 服务人 CHAR(20)
GO
UPDATE 降佣流水tt SET 服务人 = ''
GO
UPDATE 降佣流水tt SET 服务人 = b.服务人 FROM 降佣流水tt a, crmcd b WHERE a.客户代码 = b.柜台客户代码
GO

DROP TABLE ttt
GO
SELECT  服务人, count(*) as num INTO ttt FROM 降佣流水tt GROUP BY 服务人
GO
UPDATE 月度考核 SET 降佣客户 = b.num FROM 月度考核 a, ttt b WHERE 姓名 = 服务人
GO

---------------------------------------------------------------------------------------------------------------------------------------------------
----计算产品收入（包含天天利,水星1,水星2）
UPDATE 历史现金产品余额 SET 客户代码= b.柜台客户代码 FROM 历史现金产品余额 a, crmcd b WHERE a.客户编号 = b.客户编号 and 客户代码=0
go
DROP TABLE ttt
GO
SELECT * INTO ttt FROM 历史现金产品余额  WHERE LEFT(CONVERT(CHAR(8), CONVERT(INT, 日期)), 6) IN ('__REPLACE_YEAR____REPLACE_MONTH__')
      AND 基金代码 IN ('天天利', 'AA0007', 'AA0006', 'AA0038', 'AA0042')
GO
UPDATE ttt SET 基金余额 = 基金余额 * 10 WHERE 基金代码 IN ('AA0007', 'AA0006', 'AA0038', 'AA0042') AND 日期 IN ('20160205')
GO
ALTER TABLE ttt ADD 服务人 CHAR(20)
GO
UPDATE ttt SET 服务人 = ''
GO
UPDATE ttt SET 服务人 = b.服务人 FROM ttt a, crmcd b WHERE a.客户代码 = b.柜台客户代码
GO
UPDATE ttt SET 服务人 = '机构VIP' WHERE 服务人 IN ('其他', '张志强')
GO
--
DROP TABLE tttt
GO
SELECT 服务人,基金代码,SUM(基金余额) AS num INTO tttt FROM ttt GROUP BY 服务人, 基金代码
GO
UPDATE 月度考核 SET 天天利 = num / 365 FROM 月度考核 a, tttt b WHERE a.姓名 = b.服务人 AND b.基金代码 = '天天利'
UPDATE 月度考核 SET 水星1 = num / 365 FROM 月度考核 a, tttt b WHERE a.姓名 = b.服务人 AND 基金代码 = 'AA0007'
UPDATE 月度考核 SET 水星2 = num / 365 FROM 月度考核 a, tttt b WHERE a.姓名 = b.服务人 AND 基金代码 = 'AA0006'
UPDATE 月度考核 SET 水星3 = num FROM 月度考核 a, tttt b WHERE a.姓名 = b.服务人 AND 基金代码 = 'AA0038'
UPDATE 月度考核 SET 水星5 = num FROM 月度考核 a, tttt b WHERE a.姓名 = b.服务人 AND 基金代码 = 'AA0042'
GO
UPDATE 月度考核 SET 天天利 = 天天利 * 分段标识1, 水星1 = 水星1 * 分段标识2, 水星2 = 水星2 * 分段标识2 FROM 月度考核 a, 积分参数表 b WHERE 参数名称 = '增收系数系数'
UPDATE 月度考核 SET 产品销售收入 = 产品销售收入 + (水星3 + 水星5) * 0.01 / 365
GO

---在营业部基本客户库--计算佣金、息费,为处理特殊处理客户收入-------------
UPDATE 营业部基本客户库 SET 两融息费14 = 0, 净佣14 = 0, 两融净佣14 = 0, 利差14 = 0
------利差14
DROP TABLE ttt
GO
SELECT   CUSTID,  SUM(CAST(FUNDEFFECT AS MONEY)) AS num INTO ttt FROM 结息流水   WHERE LEFT(BIZDATE, 6) IN ('__REPLACE_YEAR____REPLACE_MONTH__')  GROUP BY CUSTID
GO
UPDATE 营业部基本客户库 SET 利差14 = b.num * 8.1465 FROM 营业部基本客户库 a, ttt b  WHERE a.柜台客户代码 = b.CUSTID
GO
----息费
DROP TABLE ttt
GO
SELECT CUSTID, SUM(FUNDEFFECT) AS num INTO ttt FROM 总息费  WHERE LEFT(CONVERT(CHAR(8), CONVERT(INT, SYSDATE)), 6) IN ('__REPLACE_YEAR____REPLACE_MONTH__')
GROUP BY CUSTID
GO
UPDATE 营业部基本客户库 SET 两融息费14 = num FROM 营业部基本客户库 a, ttt b WHERE a.柜台客户代码 = b.CUSTID
GO

--净佣
drop table ttt
go
select FUNDID ,SUM(FEE_JSXF) as num into ttt from 历史成交cd where left(成交日期,6) in ('__REPLACE_YEAR____REPLACE_MONTH__') group by FUNDID
go
UPDATE 营业部基本客户库 SET 净佣14 = b.num FROM 营业部基本客户库 a, ttt b WHERE a.柜台客户代码 = b.FUNDID 
GO

----两融净佣----
DROP TABLE ttt
GO
SELECT  客户代码, 业务标示, SUM(净手续费) AS 净手续费 INTO ttt FROM jqrzrq  
 WHERE LEFT(CONVERT(CHAR(8), CONVERT(INT, 交收日期)), 6) IN ('__REPLACE_YEAR____REPLACE_MONTH__') GROUP BY 客户代码, 业务标示
GO
--担保品净佣
DROP TABLE tttt
GO
SELECT   客户代码, SUM(净手续费) AS num INTO tttt FROM ttt  WHERE 业务标示 IN ('担保品买入', '担保品卖出') GROUP BY 客户代码
GO
UPDATE 营业部基本客户库 SET 净佣14 = 净佣14 + b.num FROM 营业部基本客户库 a, tttt b WHERE a.柜台客户代码 = b.客户代码
GO
--信用交易净佣
DROP TABLE tttt
GO
SELECT  客户代码, SUM(净手续费) AS num INTO tttt FROM ttt  WHERE 业务标示 IN ('融资买入', '卖券还款', '融券卖出', '买券还券')
GROUP BY 客户代码
GO
UPDATE 营业部基本客户库 SET 两融净佣14 = b.num FROM 营业部基本客户库 a, tttt b WHERE a.柜台客户代码 = b.客户代码
GO

------------------
DROP TABLE ttt
GO
SELECT  新服务人, SUM(利差14) AS 利差14, SUM(净佣14) AS 净佣14,SUM(两融净佣14) AS 两融净佣14,SUM(两融息费14) AS 两融息费14 INTO ttt
FROM 营业部基本客户库  GROUP BY 新服务人
-- WHERE 服务关系 <> '不提奖金' 
GO
UPDATE 月度考核 SET 利差=利差14, 净佣=净佣14, 两融净佣=两融净佣14, 息费=两融息费14 FROM 月度考核 a, ttt b WHERE 姓名 = 新服务人
GO

EXEC 积分计算
go
--计算可提成基数
UPDATE 月度考核 SET  达标客户 = CAST(b.达标客户 AS MONEY), 资产贡献度 = (b.达标客户 / a.客户数)  
  FROM 月度考核 a,  产品达成统计  b  WHERE a.姓名 = b.姓名 and a.客户数<>0
go

UPDATE 月度考核  SET 可提成基数 = 息费 * b.分段标识1 * b.分段标识2 * b.参数1 + a.净佣 * b.参数2 + a.两融净佣 * b.参数3 - a.流失佣金基数 - a.流失资产基数, 
                    提成基数 = (a.息费 * b.分段标识1 * b.分段标识2 * b.参数1 + a.净佣 * b.参数2 + a.两融净佣 * b.参数3 - a.流失佣金基数 - a.流失资产基数) * 资产贡献度
FROM 月度考核 a, 积分参数表 b WHERE b.参数名称 = '月度提成基数系数'  and a.客户数<>0


--计算增收系数
UPDATE 月度考核 SET 收入合计 = 利差 + 息费 + 净佣 + 两融净佣 + 天天利 + 水星1 + 水星2 + 产品销售收入 - 降佣损失 - 流失资产收入 - 隐形流失资产 - 流失佣金收入

UPDATE 月度考核 SET 本期目标创收额 = 收入市占率13 * 本期市场收入 * 10000 * 参数1 FROM 月度考核 a, 积分参数表 b WHERE b.参数名称 = '增收系数系数'

UPDATE 月度考核 SET 收入市占差值 = 收入合计 - 本期目标创收额

UPDATE 月度考核 SET 收入市占率 = 收入合计 / 本期目标创收额 WHERE 本期目标创收额 <> 0

UPDATE 月度考核 SET 增收系数 = CASE WHEN Power(收入市占率, 3) < 参数2  THEN 参数2  WHEN Power(收入市占率, 3) > 参数3   THEN 参数3     ELSE Power(收入市占率, 3) END
FROM 月度考核 a, 积分参数表 b  WHERE b.参数名称 = '增收系数系数'

UPDATE 月度考核 SET 服务奖金计算值 = 提成基数 * 对应提成比例 * 增收系数 * 有效覆盖系数


UPDATE 月度考核
SET 服务奖金预发放值 = 服务奖金计算值 - (服务奖金计算值 * (1 - 重大任务系数1) * 重大任务系数权重1
                         + 服务奖金计算值 * (1 - 重大任务系数2) * 重大任务系数权重2
                         + 服务奖金计算值 * (1 - 重大任务系数3) * 重大任务系数权重3
                         + 服务奖金计算值 * (1 - 重大任务系数4) * 重大任务系数权重4
                         + 服务奖金计算值 * (1 - 重大任务系数5) * 重大任务系数权重5)

UPDATE 月度考核 SET 服务奖金发放值=服务奖金预发放值
----计算结束--------------------------------------------------------------------------------------------------------------------------------

print '---------------------------------------------'
print '*****************月度考核计算完成*************'
print '---------------------------------------------'
