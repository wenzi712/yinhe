drop table 排序表 
go
print '开始执行排序操作................'
go
delete ydkh..月度考核 where 姓名='总计'
go

SELECT
  0 AS [序号],
  [营业部],
  [部门],
  [姓名]
INTO [排序表]
FROM [月度考核]
WHERE 1 = 2


DECLARE 月度考核 CURSOR LOCAL FOR
  SELECT
    [营业部],
    [部门],
    [姓名]
  FROM [月度考核]
OPEN 月度考核
DECLARE @营业部 NVARCHAR(255)
DECLARE @部门 NVARCHAR(255)
DECLARE @姓名 NVARCHAR(255)
DECLARE @上次营业部 NVARCHAR(255)
DECLARE @上次部门 NVARCHAR(255)
DECLARE @序号 INT
SET @序号 = 1
FETCH NEXT FROM 月度考核
INTO @营业部, @部门, @姓名
WHILE @@FETCH_STATUS = 0
  BEGIN
    BEGIN
      INSERT INTO [排序表] ([序号], [营业部], [部门], [姓名]) VALUES (@序号, @营业部, @部门, @姓名)

      SET @序号 = @序号 + 1
      SET @上次营业部 = @营业部
      SET @上次部门 = @部门

      FETCH NEXT FROM 月度考核
      INTO @营业部, @部门, @姓名

      IF @营业部 = @上次营业部
        BEGIN
          IF @上次部门 != @部门
            BEGIN
              INSERT INTO [排序表] ([序号], [营业部], [部门], [姓名]) VALUES (@序号, @营业部, @上次部门, '总计')
              SET @序号 = @序号 + 1
            END
        END
      ELSE
        BEGIN
          INSERT INTO [排序表] ([序号], [营业部], [部门], [姓名]) VALUES (@序号, @上次营业部, @上次部门, '总计')
          SET @序号 = @序号 + 1
          INSERT INTO [排序表] ([序号], [营业部], [部门], [姓名]) VALUES (@序号, @上次营业部, '总计', '总计')
          SET @序号 = @序号 + 1
          SET @上次部门 = NULL
        END
    END
  END
INSERT INTO [排序表] ([序号], [营业部], [部门], [姓名]) VALUES (@序号, @上次营业部, @上次部门, '总计')
SET @序号 = @序号 + 1
INSERT INTO [排序表] ([序号], [营业部], [部门], [姓名]) VALUES (@序号, @上次营业部, '总计', '总计')
SET @序号 = @序号 + 1
INSERT INTO [排序表] ([序号], [营业部], [部门], [姓名]) VALUES (@序号, '总计', '总计', '总计')
CLOSE 月度考核
DEALLOCATE 月度考核
GO

drop table www
go

SELECT
        CASE WHEN GROUPING(营业部) = 1 THEN '总计' ELSE 营业部 END 营业部,
        CASE WHEN GROUPING(部门) = 1 THEN '总计' ELSE 部门 END 部门,
        CASE WHEN GROUPING(姓名) = 1 THEN '总计' ELSE 姓名 END 姓名,
	SUM(客户数) AS 客户数,
SUM(总资产) AS 总资产,

SUM(权益产品) AS 权益产品,
SUM(权益产品积分) AS 权益产品积分,
SUM(固定产品) AS 固定产品,
SUM(固定产品积分) AS 固定产品积分,
SUM(产品总分) AS 产品总分,

SUM(续做固定产品) AS 续做固定产品,
SUM(续做固定产品积分) AS 续做固定产品积分,

SUM(新开户) AS 新开户,
SUM(新开户积分) AS 新开户积分,
SUM(新开户1w) AS 新开户1w,
SUM(新开户1w积分) AS 新开户1w积分,
SUM(新开户10w) AS 新开户10w,
SUM(新开户10w积分) AS 新开户10w积分,
SUM(新开户50w) AS 新开户50w,
SUM(新开户50w积分) AS 新开户50w积分,
SUM(新增资产) AS 新增资产,
SUM(新增资产积分) AS 新增资产积分,
SUM(新开户总分) AS 新开户总分,

SUM(两融开户) AS 两融开户,
SUM(两融开户积分) AS 两融开户积分,
SUM(上月末余额) AS 上月末余额,
SUM(上月末余额市占率) AS 上月末余额市占率,
SUM(本月末余额) AS 本月末余额,
SUM(本月末余额市占率) AS 本月末余额市占率,

SUM(余额市占率差额) AS 余额市占率差额,
SUM(余额市占率差额得分) AS 余额市占率差额得分,
SUM(两融总分) AS 两融总分,

SUM(其他开户) AS 其他开户,
SUM(其他开户积分) AS 其他开户积分,
SUM(其他资产) AS 其他资产,
SUM(其他资产积分) AS 其他资产积分,

SUM(流失客户数) AS 流失客户数,
SUM(流失客户数积分) AS 流失客户数积分,
SUM(流失资产) AS 流失资产,
SUM(流失资产积分) AS 流失资产积分,
SUM(流失年佣金) AS 流失年佣金,
SUM(流失年佣金积分) AS 流失年佣金积分,
SUM(隐形流失资产) AS 隐形流失资产,
SUM(隐形流失资产积分) AS 隐形流失资产积分,
SUM(流失总分) AS 流失总分,

SUM(降佣客户) AS 降佣客户,
SUM(降佣客户积分) AS 降佣客户积分,
SUM(降佣损失) AS 降佣损失,

SUM(月度积分总分) AS 月度积分总分,
SUM(积分合格线) AS 积分合格线,
SUM(积分完成率) AS 积分完成率,
SUM(对应提成比例) AS 对应提成比例,

SUM(流失佣金收入) AS 流失佣金收入,
SUM(流失资产收入) AS 流失资产收入,
SUM(流失佣金基数) AS 流失佣金基数,
SUM(流失资产基数) AS 流失资产基数,

SUM(利差) AS 利差,
SUM(息费) AS 息费,
SUM(净佣) AS 净佣,
SUM(两融净佣) AS 两融净佣,
SUM(天天利) AS 天天利,
SUM(水星1) AS 水星1,
SUM(水星2) AS 水星2,
SUM(产品销售收入) AS 产品销售收入,
SUM(水星3) AS 水星3,
SUM(水星5) AS 水星5,
SUM(收入合计) AS 收入合计,
SUM(可提成基数) AS 可提成基数,
SUM(提成基数) AS 提成基数,
SUM(达标客户) AS 达标客户,
SUM(资产贡献度) AS 资产贡献度,
SUM(本期市场收入) AS 本期市场收入,
SUM(本期目标创收额) AS 本期目标创收额,
SUM(收入市占差值) AS 收入市占差值,
SUM(收入市占率) AS 收入市占率,
SUM(增收系数) AS 增收系数,

SUM(有效覆盖系数) AS 有效覆盖系数,
SUM(重大任务系数1) AS 重大任务系数1,
SUM(重大任务系数2) AS 重大任务系数2,
SUM(重大任务系数3) AS 重大任务系数3,
SUM(重大任务系数4) AS 重大任务系数4,
SUM(重大任务系数5) AS 重大任务系数5,
SUM(重大任务系数权重1) AS 重大任务系数权重1,
SUM(重大任务系数权重2) AS 重大任务系数权重2,
SUM(重大任务系数权重3) AS 重大任务系数权重3,
SUM(重大任务系数权重4) AS 重大任务系数权重4,
SUM(重大任务系数权重5) AS 重大任务系数权重5,

SUM(服务奖金计算值) AS 服务奖金计算值,
SUM(服务奖金预发放值) AS 服务奖金预发放值,
SUM(部门调整额) AS 部门调整额,
SUM(服务奖金发放值) AS 服务奖金发放值,
convert(varchar(255),'') AS  部门调整备注,

SUM(净佣13) AS 净佣13,
SUM(两融净佣13) AS 两融净佣13,
SUM(利差13) AS 利差13,
SUM(息费13) AS 息费13,
SUM(天天利13) AS 天天利13,
SUM(水星一13) AS 水星一13,
SUM(水星二13) AS 水星二13,
SUM(全市场收入13) AS 全市场收入13,
SUM(收入市占率13) AS 收入市占率13,

SUM(合规) AS 合规,
SUM(行政评价) AS 行政评价

 into www
        FROM 月度考核
	GROUP BY 营业部,部门,姓名 WITH ROLLUP
go

drop table 月度考核
go
select b.* into 月度考核 from 排序表 a, www b where a.营业部=b.营业部 and a.部门=b.部门 and a.姓名=b.姓名 order by 序号
go


print '---------------------------------------------'
print '*****************排序完成*************'
print '---------------------------------------------'
