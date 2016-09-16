USE ydkh
GO

--0 两融开户
UPDATE 两融开户 SET 机构名称 = b.营业部代码 FROM 两融开户 a, 营业部库 b WHERE a.机构名称 = b.营业部
UPDATE 两融开户 SET 机构名称 ='4103' where 机构名称='成都人民南路证券营'
go

--1 当月成交cd
DELETE 当月成交cd WHERE ORGID = '总计'
GO
IF not EXISTS( SELECT 1 FROM 历史成交cd WHERE 成交日期 = '__REPLACE_YEAR____REPLACE_MONTH____REPLACE_DAY__')
    INSERT INTO 历史成交cd SELECT  '__REPLACE_YEAR____REPLACE_MONTH____REPLACE_DAY__',  * FROM 当月成交cd
GO

--2 crmcd
ALTER TABLE crmcd ADD zzc MONEY
GO
UPDATE crmcd SET zzc = 0
GO
UPDATE crmcd SET zzc = convert(MONEY, 昨日总资产)
GO
UPDATE crmcd SET zzc = zzc + CAST(ALLASSET AS MONEY) - CAST(ALLDEBTS AS MONEY) FROM crmcd a, 维持担保比例 b WHERE a.柜台客户代码 = b.CUSTID
GO
UPDATE crmcd SET 开发人 = b.开发人员 FROM crmcd a, 暂挂开户 b WHERE a.柜台客户代码 = b.客户号
GO
UPDATE crmcd SET 开户日期 = b.开户日期, 开发人 = b.开发人 FROM crmcd a, 二次开发 b WHERE a.柜台客户代码 = b.客户代码
GO
--update crmcd set 服务人='张红宇VIP'  where 柜台客户代码 in ( select 柜台客户代码 from crm160226  where 服务人='张红宇VIP' )
--go

--3 当月息费
DELETE 当月息费 WHERE ORGID = '合计'
GO
IF not EXISTS( SELECT 1 FROM 总息费 WHERE SYSDATE IN ( select DISTINCT SYSDATE from 当月息费 ))
     INSERT INTO 总息费   SELECT  SYSDATE, CUSTID, CUSTNAME, DEBTSTY005,  FUNDEFFECT,ORGID  FROM 当月息费  ORDER BY SYSDATE
GO

--4
DELETE 两融余额 WHERE ORGID = '合计'
GO
IF not EXISTS( SELECT 1 FROM 历史融资融券余额 WHERE 清算日期 IN ( select DISTINCT SYSDATE from 两融余额 ))
    INSERT INTO 历史融资融券余额 SELECT    SYSDATE,    CUSTID,    CUSTNAME,    ALLDEBTS,    DEBTSAM005,    DEBTSAM005,    ORGID  FROM 两融余额
go

--5
DELETE 两融成交 WHERE ORGIDNAME IN ('合计:', '银河证券总部')
GO
UPDATE 两融成交 SET ORGIDNAME = b.营业部代码 FROM 两融成交 a, 营业部库 b WHERE a.ORGIDNAME = b.营业部
GO
UPDATE 两融成交 SET ORGIDNAME = '4108' WHERE ORGIDNAME = '乐山人民南路营业'
UPDATE 两融成交 SET ORGIDNAME = '4106' WHERE ORGIDNAME = '成都人民南路证券营'
GO
--IF not EXISTS( SELECT 1 FROM jqrzrq WHERE 交收日期 IN ( select DISTINCT MATCHAMT from 两融成交 ) )
   INSERT INTO jqrzrq  SELECT CUSTID,  RTRIM(LTRIM(CUSTNAME)),  MATCHAMT,  FEE_JSXF,  FEE_SXF, BIZDATE, DIGESTNAME,
       CAST(RTRIM(LTRIM(ORGIDNAME)) AS CHAR(4)), FEE_GHF  FROM 两融成交
GO

---6
UPDATE 现金产品余额 SET ORGIDNAME = b.营业部代码 FROM 现金产品余额 a, 营业部库 b WHERE a.ORGIDNAME = b.营业部
GO
IF not EXISTS( SELECT 1 FROM 历史现金产品余额 WHERE 日期 = convert(char(8),getdate(),112) and 基金代码<>'天天利' )
   insert into 历史现金产品余额 select convert(char(8),getdate(),112),CUSTID,CUSTNAME,OFCODE,OFNAME,OFBAL,MARKETV006,ORGIDNAME,''  from 现金产品余额
GO

--7 天天利
UPDATE 天天利 SET 营业部名称 = b.营业部代码 FROM 天天利 a, 营业部库 b WHERE a.营业部名称 = b.营业部
GO
ALTER TABLE 天天利 ADD 柜台客户代码 CHAR(12)
GO
UPDATE 天天利 SET 柜台客户代码 = ''
GO
UPDATE 天天利 SET 柜台客户代码 = b.柜台客户代码 FROM 天天利 a, crmcd b WHERE a.客户编号 = b.客户编号
GO
IF not EXISTS( SELECT 1 FROM 历史现金产品余额 WHERE 日期 IN ( select DISTINCT 股份日期 from 天天利 ) and 基金名称='天天利')
   INSERT INTO 历史现金产品余额 SELECT 股份日期, 柜台客户代码,客户姓名,'天天利','天天利',股份余额, 0, CAST(营业部名称 AS CHAR(4)) AS 营业部名称,客户编号 FROM 天天利
GO

---8.结息流水------------------
update 结息流水tt set ORGIDNAME =b.营业部代码 from  结息流水tt a,营业部库 b WHERE a.ORGIDNAME=b.营业部
go
IF not EXISTS( SELECT 1 FROM 结息流水 WHERE BIZDATE IN ( select DISTINCT BIZDATE from 结息流水tt ))
   insert INTO 结息流水 select BIZDATE,ORGIDNAME,CUSTID,CUSTNAME,MONEYTY010 as MONEYTYP, DIGESTID,FUNDEFFECT from 结息流水tt
go

---9.转账流水------------------
IF not EXISTS( SELECT 1 FROM 集中转账 WHERE BIZDATE IN ( select DISTINCT BIZDATE from 集中转账tt ))
    insert into 集中转账 select BIZDATE,ORGIDNAME,CUSTID,CUSTNAME,MONEYTY010 as MONEYTYP, DIGESTID,FUNDEFFECT from 集中转账tt

IF not EXISTS( SELECT 1 FROM 两融转账 WHERE BIZDATE IN ( select DISTINCT BIZDATE from 两融转账tt ))
    insert into 两融转账 select BIZDATE,ORGIDNAME,CUSTID,CUSTNAME,MONEYTY011 as MONEYTYP, DIGESTID,FUNDEFFECT from 两融转账tt

---10.产品销售------------------
update 产品销售tt set TRDIDNAME=''
go
update 产品销售tt set TRDIDNAME='现金类' WHERE left(OFNAME,4)='银河水星'
update 产品销售tt set TRDIDNAME='现金类' WHERE OFNAME like '%货币%'
update 产品销售tt set TRDIDNAME='现金类' WHERE OFNAME like '%现金%'
update 产品销售tt set TRDIDNAME='固定类' WHERE OFNAME like '%纯债%'
go
update 产品销售tt set TRDIDNAME='权益类' where TRDIDNAME not in ('现金类','固定类')
go
IF not EXISTS( SELECT 1 FROM 产品销售 WHERE MATCHDATE IN ( select DISTINCT MATCHDATE from 产品销售tt ) )
   insert into 产品销售 select * from 产品销售tt
go

-----生成昨日合并资产数据--------------------------
truncate table 产品余额tt
go
declare @khrq char(8)
select @khrq=max(开户日期)  from crmcd 
IF not EXISTS(SELECT 1 FROM 历史资产表 WHERE 资产日期 = @khrq)
begin
   insert into 历史资产表 select @khrq as 资产日期,客户编号,柜台客户代码,客户姓名,zzc,0.0 as 产品市值, 0.0 as 权益类资产  from crmcd where zzc>0
   insert into 产品余额tt  select * ,'' as 服务人 from 历史现金产品余额  where 日期=@khrq and 营业部代码='4103'
   update 产品余额tt set 服务人=b.服务人 from 产品余额tt a,crmcd b where a.客户代码=b.柜台客户代码
end
go
drop table ttt
go
select 客户代码,sum(convert(money,基金证券市值)) as num into ttt from 产品余额tt group by 客户代码
go
IF EXISTS(SELECT 1 FROM 产品余额tt )
begin
  declare @khrq char(8)
  select @khrq=max(资产日期)  from 历史资产表 
  update 历史资产表 set 产品市值=b.num from 历史资产表 a, ttt b where a.柜台客户代码=b.客户代码 and 资产日期=@khrq
  update 历史资产表 set 权益类资产=zzc-产品市值 where 资产日期=@khrq
end
go

update crmcd set 服务人='陈彦' where 柜台客户代码 in ('410499405473','410399120736','410499420588 ','410399116238')
go

print '---------------------------------------------'
print '*****************数据归档完成*************'
print '---------------------------------------------'


truncate table 当月成交cd
truncate table 当月息费
truncate table 两融余额
truncate table 两融成交
truncate table 现金产品余额
truncate table 天天利
truncate table 结息流水tt
truncate table 集中转账tt
truncate table 两融转账tt
truncate table 隐形流失客户tt
truncate table 产品销售tt
go
