USE ydkh
GO

TRUNCATE TABLE 营业部基本客户库
GO
INSERT INTO 营业部基本客户库
  SELECT
    柜台客户代码, 客户姓名,开户日期,服务人, zzc, 0, 0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    '',
    '',    '',    '',    0, 0,	0,	'',	0
 FROM crmcd  WHERE 服务人 <> ''
GO

-----计算14年3个月资产贡献度--------------------------------------------------------------------------
UPDATE 营业部基本客户库
SET 总资产     = 0, 净佣14 = 0, 两融净佣14 = 0, 两融息费14 = 0, 净佣13 = 0, 两融净佣13 = 0, 两融息费13 = 0, 利差13 = 0, 天天利积数13 = 0, 水星1号积数13 = 0, 水星2号积数13 = 0, 利差14 = 0,
  权益产品销售额14 = 0, 固收产品销售额14 = 0, 资产贡献度14 = 0
GO
------利差14
DROP TABLE ttt
GO
SELECT  CUSTID,   SUM(CAST(FUNDEFFECT AS MONEY)) AS num  INTO ttt FROM 结息流水 WHERE BIZDATE > '20140101' AND BIZDATE < '20150101' GROUP BY CUSTID
GO
UPDATE 营业部基本客户库 SET 利差13 = b.num * 8.1465 FROM 营业部基本客户库 a, ttt b WHERE a.柜台客户代码 = b.CUSTID
GO

--净佣14
DROP TABLE ttt
GO
SELECT  FUNDID,  sum(FEE_JSXF) AS num INTO ttt FROM 历史成交cd WHERE 成交日期 > '201400' AND 成交日期 < '201500' GROUP BY FUNDID
GO
UPDATE 营业部基本客户库 SET 净佣13 = b.num FROM 营业部基本客户库 a, ttt b WHERE a.柜台客户代码 = b.FUNDID
GO

------两融净佣14
DROP TABLE ttt
GO
SELECT 客户代码,sum(净手续费) AS 净佣金 INTO ttt FROM jqrzrq WHERE 交收日期 > '20140101' AND 交收日期 < '20150101' GROUP BY 客户代码
GO
UPDATE 营业部基本客户库 SET 两融净佣13 = b.净佣金 FROM 营业部基本客户库 a, ttt b WHERE a.柜台客户代码 = b.客户代码
GO

------两融息费14
DROP TABLE ttt
GO
SELECT CUSTID,sum(FUNDEFFECT) AS num  INTO ttt FROM 总息费 WHERE SYSDATE > '20140101' AND SYSDATE < '20150101' GROUP BY CUSTID
GO
UPDATE 营业部基本客户库 SET 两融息费13 = num FROM 营业部基本客户库 a, ttt b WHERE a.柜台客户代码 = b.CUSTID
GO

----现金产品（天天利,水星1,水星2）14
DROP TABLE ttt
GO
SELECT * INTO ttt FROM 历史现金产品余额
WHERE 日期 > '20140101' AND 日期 < '20150101' AND 基金代码 IN ('天天利', 'AA0007', 'AA0006', 'AA0038', 'AA0042')
GO
UPDATE ttt SET 基金余额 = 基金余额 * 3  WHERE 基金代码 IN ('AA0007', 'AA0006', 'AA0038', 'AA0042')
      AND 日期 IN ('20140103', '20140110', '20140117', '20140124', '20140207', '20140214', '20140221', '20140228', '20140307', '20140314', '20140321', '20140328', '20140411', '20140418', '20140425', '20140509', '20140516', '20140523', '20140603', '20140606', '20140613', '20140620', '20140627', '20140704', '20140711', '20140718', '20140725', '20140801', '20140808', '20140815', '20140822', '201408029', '20140912', '20140919', '20140926', '20141010', '20141017', '20141024', '20141031', '20141107', '20141114', '20141121', '20141128', '20141205', '20141212', '20141219', '20141226')
GO
UPDATE ttt SET 基金余额 = 基金余额 * 7
WHERE 基金代码 IN ('AA0007', 'AA0006', 'AA0038', 'AA0042') AND 日期 IN ('20140130', '20141008', '20150105')
UPDATE ttt SET 基金余额 = 基金余额 * 4
WHERE 基金代码 IN ('AA0007', 'AA0006', 'AA0038', 'AA0042') AND 日期 IN ('20140404', '20140430', '20140530')
GO

ALTER TABLE ttt ADD 服务人 CHAR(20)
GO
UPDATE ttt SET 服务人 = ''
GO
UPDATE ttt SET 服务人 = b.服务人 FROM ttt a, crmcd b WHERE a.客户代码 = b.柜台客户代码
GO
DROP TABLE tttt
GO
SELECT 客户代码, 基金代码, SUM(基金余额) AS num INTO tttt FROM ttt GROUP BY 客户代码, 基金代码
GO
UPDATE 营业部基本客户库 SET 天天利积数13 = num FROM 营业部基本客户库 a, tttt b WHERE a.柜台客户代码 = b.客户代码 AND b.基金代码 = '天天利'
UPDATE 营业部基本客户库 SET 水星1号积数13 = num FROM 营业部基本客户库 a, tttt b WHERE a.柜台客户代码 = b.客户代码 AND 基金代码 = 'AA0007'
UPDATE 营业部基本客户库 SET 水星2号积数13 = num FROM 营业部基本客户库 a, tttt b WHERE a.柜台客户代码 = b.客户代码 AND 基金代码 = 'AA0006'
GO
print '---------------------------------------------'
print '*****************基期计算完成*****************'
print '---------------------------------------------'
