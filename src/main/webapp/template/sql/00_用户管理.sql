USE ydkh
GO

DELETE FROM 理财部人员表 WHERE 角色 = '管理员'
GO

ALTER TABLE 理财部人员表 ADD 存档权限 BIT DEFAULT 0
ALTER TABLE 理财部人员表 ADD 登陆名 NVARCHAR(32)
ALTER TABLE 理财部人员表 ADD 密码 NVARCHAR(128)
GO
UPDATE 理财部人员表 SET 存档权限 = 0, 登陆名 = '', 密码 = ''
GO
UPDATE 理财部人员表 SET 存档权限 = b.存档权限, 登陆名 = b.登陆名, 密码 = b.密码 FROM 理财部人员表 a, 用户表 b WHERE a.营业部 = b.营业部 AND a.部门 = b.部门 AND a.姓名 = b.姓名
GO
INSERT INTO 理财部人员表 SELECT * FROM 用户表 WHERE 角色 = '管理员'
GO
DROP TABLE 用户表
GO
SELECT * INTO 用户表 FROM 理财部人员表 ORDER BY CONVERT(INT, 序号)
GO
-------------------------------------------------------------------------
IF EXISTS(SELECT *  FROM sysobjects WHERE name = '月度考核tt')
  DROP TABLE 月度考核tt
GO
SELECT * INTO 月度考核tt FROM 月度考核
GO
-------------------------------------------------------------------------
IF EXISTS(SELECT * FROM sysobjects WHERE name = '月度考核')
  DROP TABLE 月度考核
GO
SELECT  营业部, 部门, 姓名 INTO 月度考核 FROM 用户表 WHERE 角色 <> '管理员'
GO

ALTER TABLE 月度考核 ADD 客户数 MONEY
ALTER TABLE 月度考核 ADD 总资产 MONEY

ALTER TABLE 月度考核 ADD 权益产品 MONEY
ALTER TABLE 月度考核 ADD 权益产品积分 MONEY
ALTER TABLE 月度考核 ADD 固定产品 MONEY
ALTER TABLE 月度考核 ADD 固定产品积分 MONEY
ALTER TABLE 月度考核 ADD 产品总分 MONEY

ALTER TABLE 月度考核 ADD 续做固定产品 MONEY
ALTER TABLE 月度考核 ADD 续做固定产品积分 MONEY

ALTER TABLE 月度考核 ADD 新开户 MONEY
ALTER TABLE 月度考核 ADD 新开户积分 MONEY
ALTER TABLE 月度考核 ADD 新开户1w MONEY
ALTER TABLE 月度考核 ADD 新开户1w积分 MONEY
ALTER TABLE 月度考核 ADD 新开户10w MONEY
ALTER TABLE 月度考核 ADD 新开户10w积分 MONEY
ALTER TABLE 月度考核 ADD 新开户50w MONEY
ALTER TABLE 月度考核 ADD 新开户50w积分 MONEY
ALTER TABLE 月度考核 ADD 新增资产 MONEY
ALTER TABLE 月度考核 ADD 新增资产积分 MONEY
ALTER TABLE 月度考核 ADD 新开户总分 MONEY

ALTER TABLE 月度考核 ADD 两融开户 MONEY
ALTER TABLE 月度考核 ADD 两融开户积分 MONEY
ALTER TABLE 月度考核 ADD 上月末余额 MONEY
ALTER TABLE 月度考核 ADD 上月末余额市占率 MONEY
ALTER TABLE 月度考核 ADD 本月末余额 MONEY
ALTER TABLE 月度考核 ADD 本月末余额市占率 MONEY

ALTER TABLE 月度考核 ADD 余额市占率差额 MONEY
ALTER TABLE 月度考核 ADD 余额市占率差额得分 MONEY
ALTER TABLE 月度考核 ADD 两融总分 MONEY

ALTER TABLE 月度考核 ADD 其他开户 MONEY
ALTER TABLE 月度考核 ADD 其他开户积分 MONEY
ALTER TABLE 月度考核 ADD 其他资产 MONEY
ALTER TABLE 月度考核 ADD 其他资产积分 MONEY

ALTER TABLE 月度考核 ADD 流失客户数 MONEY
ALTER TABLE 月度考核 ADD 流失客户数积分 MONEY
ALTER TABLE 月度考核 ADD 流失资产 MONEY
ALTER TABLE 月度考核 ADD 流失资产积分 MONEY
ALTER TABLE 月度考核 ADD 流失年佣金 MONEY
ALTER TABLE 月度考核 ADD 流失年佣金积分 MONEY
ALTER TABLE 月度考核 ADD 隐形流失资产 MONEY
ALTER TABLE 月度考核 ADD 隐形流失资产积分 MONEY
ALTER TABLE 月度考核 ADD 流失总分 MONEY

ALTER TABLE 月度考核 ADD 降佣客户 MONEY
ALTER TABLE 月度考核 ADD 降佣客户积分 MONEY
ALTER TABLE 月度考核 ADD 降佣损失 MONEY

ALTER TABLE 月度考核 ADD 月度积分总分 MONEY
ALTER TABLE 月度考核 ADD 积分合格线 MONEY
ALTER TABLE 月度考核 ADD 积分完成率 MONEY
ALTER TABLE 月度考核 ADD 对应提成比例 MONEY


ALTER TABLE 月度考核 ADD 流失佣金收入 MONEY
ALTER TABLE 月度考核 ADD 流失资产收入 MONEY
ALTER TABLE 月度考核 ADD 流失佣金基数 MONEY
ALTER TABLE 月度考核 ADD 流失资产基数 MONEY

ALTER TABLE 月度考核 ADD 利差 MONEY
ALTER TABLE 月度考核 ADD 息费 MONEY
ALTER TABLE 月度考核 ADD 净佣 MONEY
ALTER TABLE 月度考核 ADD 两融净佣 MONEY
ALTER TABLE 月度考核 ADD 天天利 MONEY
ALTER TABLE 月度考核 ADD 水星1 MONEY
ALTER TABLE 月度考核 ADD 水星2 MONEY
ALTER TABLE 月度考核 ADD 产品销售收入 MONEY
ALTER TABLE 月度考核 ADD 水星3 MONEY
ALTER TABLE 月度考核 ADD 水星5 MONEY
ALTER TABLE 月度考核 ADD 收入合计 MONEY
ALTER TABLE 月度考核 ADD 可提成基数 MONEY
ALTER TABLE 月度考核 ADD 提成基数 MONEY
ALTER TABLE 月度考核 ADD 达标客户 MONEY
ALTER TABLE 月度考核 ADD 资产贡献度 MONEY
ALTER TABLE 月度考核 ADD 本期市场收入 MONEY
ALTER TABLE 月度考核 ADD 本期目标创收额 MONEY
ALTER TABLE 月度考核 ADD 收入市占差值 MONEY
ALTER TABLE 月度考核 ADD 收入市占率 MONEY
ALTER TABLE 月度考核 ADD 增收系数 MONEY

ALTER TABLE 月度考核 ADD 有效覆盖系数 MONEY
ALTER TABLE 月度考核 ADD 重大任务系数1 MONEY
ALTER TABLE 月度考核 ADD 重大任务系数2 MONEY
ALTER TABLE 月度考核 ADD 重大任务系数3 MONEY
ALTER TABLE 月度考核 ADD 重大任务系数4 MONEY
ALTER TABLE 月度考核 ADD 重大任务系数5 MONEY
ALTER TABLE 月度考核 ADD 重大任务系数权重1 MONEY
ALTER TABLE 月度考核 ADD 重大任务系数权重2 MONEY
ALTER TABLE 月度考核 ADD 重大任务系数权重3 MONEY
ALTER TABLE 月度考核 ADD 重大任务系数权重4 MONEY
ALTER TABLE 月度考核 ADD 重大任务系数权重5 MONEY

ALTER TABLE 月度考核 ADD 服务奖金计算值 MONEY
ALTER TABLE 月度考核 ADD 服务奖金预发放值 MONEY
ALTER TABLE 月度考核 ADD 部门调整额 MONEY
ALTER TABLE 月度考核 ADD 服务奖金发放值 MONEY
ALTER TABLE 月度考核 ADD 部门调整备注 varchar(500)

ALTER TABLE 月度考核 ADD 净佣13 MONEY
ALTER TABLE 月度考核 ADD 两融净佣13 MONEY
ALTER TABLE 月度考核 ADD 利差13 MONEY
ALTER TABLE 月度考核 ADD 息费13 MONEY
ALTER TABLE 月度考核 ADD 天天利13 MONEY
ALTER TABLE 月度考核 ADD 水星一13 MONEY
ALTER TABLE 月度考核 ADD 水星二13 MONEY
ALTER TABLE 月度考核 ADD 全市场收入13 MONEY
ALTER TABLE 月度考核 ADD 收入市占率13 MONEY

ALTER TABLE 月度考核 ADD 合规 MONEY
ALTER TABLE 月度考核 ADD 行政评价 MONEY
GO

UPDATE 月度考核 SET 行政评价  = b.行政评价, 合规 = b.合规, 有效覆盖系数 = b.有效覆盖系数, 重大任务系数1 = b.重大任务系数1, 重大任务系数2 = b.重大任务系数2, 
                               重大任务系数3 = b.重大任务系数3,  重大任务系数4 = b.重大任务系数4, 重大任务系数5 = b.重大任务系数5,
                               重大任务系数权重1 = b.重大任务系数权重1, 重大任务系数权重2 = b.重大任务系数权重2, 
                               重大任务系数权重3 = b.重大任务系数权重3,  重大任务系数权重4 = b.重大任务系数权重4, 重大任务系数权重5 = b.重大任务系数权重5 
FROM 月度考核 a, 月度考核tt b WHERE a.姓名 = b.姓名
GO