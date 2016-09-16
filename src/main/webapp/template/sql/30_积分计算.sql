use ydkh
go

--服务奖金发放值计算
IF exists(SELECT *  FROM sysobjects  WHERE name = '服务奖金发放值计算')
  DROP PROC 服务奖金发放值计算
GO
create proc  服务奖金发放值计算
as
  UPDATE ydkh..月度考核 SET 服务奖金发放值=服务奖金预发放值+部门调整额
go

--参数初始化
IF exists(SELECT *  FROM sysobjects   WHERE name = '参数初始化')
  DROP PROC 参数初始化
GO
create proc  参数初始化
as
  UPDATE ydkh..月度考核 SET 行政评价=0, 合规=0
  UPDATE ydkh..月度考核 SET 有效覆盖系数 = 0, 重大任务系数1 = 0, 重大任务系数2 = 0, 重大任务系数3 = 0, 重大任务系数4 = 0, 重大任务系数5 = 0,
                           重大任务系数权重1=0,重大任务系数权重2=0,重大任务系数权重3=0,重大任务系数权重4=0,重大任务系数权重5=0,其他开户=0,其他资产=0
go

---积分计算
IF exists(SELECT *  FROM sysobjects  WHERE name = '积分计算')
  DROP PROC 积分计算
GO
CREATE PROC 积分计算
AS
  BEGIN
    --月度考核积分计算
    UPDATE 月度考核
    SET 固定产品积分 = 0, 权益产品积分 = 0, 产品总分 = 0, 新开户积分 = 0, 新开户1w积分 = 0, 新开户10w积分 = 0, 新开户50w积分 = 0, 新增资产积分 = 0, 新开户总分 = 0,
      两融开户积分   = 0, 余额市占率差额=0, 余额市占率差额得分 = 0, 两融总分 = 0, 其他开户积分=0, 其他资产积分=0, 流失客户数积分 = 0, 流失资产积分 = 0, 流失年佣金积分 = 0, 
      隐形流失资产积分 = 0, 流失总分 = 0, 月度积分总分   = 0, 积分合格线 = 0, 积分完成率 = 0, 对应提成比例 = 0, 续做固定产品积分=0,降佣客户积分=0

    DECLARE @分段标识1 MONEY, @分段标识2 MONEY, @参数1 MONEY, @参数2 MONEY, @参数3 MONEY

    UPDATE 月度考核 SET 积分合格线 = 参数1 FROM 月度考核 a, 积分参数表 b WHERE 参数名称 = '级别首席投顾' AND (总资产 / 10000) > 分段标识1 AND 积分合格线 = 0
    UPDATE 月度考核 SET 积分合格线 = 参数1 FROM 月度考核 a, 积分参数表 b WHERE 参数名称 = '级别资深投顾' AND (总资产 / 10000) > 分段标识1 AND 积分合格线 = 0
    UPDATE 月度考核 SET 积分合格线 = 参数1 FROM 月度考核 a, 积分参数表 b WHERE 参数名称 = '级别高级投顾' AND (总资产 / 10000) > 分段标识1 AND 积分合格线 = 0
    UPDATE 月度考核 SET 积分合格线 = 参数1 FROM 月度考核 a, 积分参数表 b WHERE 参数名称 = '级别中级投顾' AND (总资产 / 10000) > 分段标识1 AND 积分合格线 = 0
    UPDATE 月度考核 SET 积分合格线 = 参数1 FROM 月度考核 a, 积分参数表 b WHERE 参数名称 = '级别初级投顾' AND (总资产 / 10000) > 分段标识1 AND 积分合格线 = 0
    UPDATE 月度考核 SET 积分合格线 = 参数1 FROM 月度考核 a, 积分参数表 b WHERE 参数名称 = '级别投顾助理' AND (总资产 / 10000) > 分段标识1 AND 积分合格线 = 0

    SELECT @分段标识1 = 0,  @分段标识2 = 0, @参数1 = 0, @参数2 = 0,  @参数3 = 0
    SELECT @分段标识1 = 分段标识1, @分段标识2 = 分段标识2, @参数1 = 参数1, @参数2 = 参数2,  @参数3 = 参数3 FROM 积分参数表    WHERE 参数名称 = '权益产品积分'

    UPDATE 月度考核 SET 权益产品积分 = floor(权益产品) * @参数1   WHERE 权益产品 < @分段标识1
    UPDATE 月度考核 SET 权益产品积分 = floor(权益产品) * @参数2   WHERE 权益产品 >= @分段标识1 AND 权益产品 < @分段标识2
    UPDATE 月度考核 SET 权益产品积分 = floor(权益产品) * @参数3
    WHERE 权益产品 >= @分段标识2

    SELECT @分段标识1 = 0,  @分段标识2 = 0,        @参数1 = 0,        @参数2 = 0,        @参数3 = 0
    SELECT @分段标识1 = 分段标识1,   @分段标识2 = 分段标识2,    @参数1 = 参数1, @参数2 = 参数2, @参数3 = 参数3 FROM 积分参数表  WHERE 参数名称 = '固收产品积分'

    UPDATE 月度考核 SET 固定产品积分 = floor(固定产品) * @参数1   WHERE 固定产品 < @分段标识1
    UPDATE 月度考核 SET 固定产品积分 = floor(固定产品) * @参数2  WHERE 固定产品 = @分段标识1
    UPDATE 月度考核 SET 固定产品积分 = floor(固定产品) * @参数3  WHERE 固定产品 > @分段标识1

    UPDATE 月度考核 SET 产品总分 = 固定产品积分 + 权益产品积分
    UPDATE 月度考核 SET 产品总分 = 参数1 FROM 月度考核 a, 积分参数表 b  WHERE 参数名称 = '产品总分' AND 产品总分 > 参数1

    UPDATE 月度考核 SET 续做固定产品积分 = 续做固定产品 * 参数1 FROM 月度考核 a, 积分参数表 b  WHERE 参数名称 = '续做固收产品积分'
    UPDATE 月度考核 SET 续做固定产品积分 = 分段标识1 FROM 月度考核 a, 积分参数表 b  WHERE 续做固定产品积分>分段标识1 and  参数名称 = '续做固收产品积分'

    UPDATE 月度考核 SET 新开户积分 = 新开户 * 参数1 FROM 月度考核 a, 积分参数表 b  WHERE 参数名称 = '新开户积分'
    UPDATE 月度考核 SET 新开户1w积分 = 新开户1w * 参数1 FROM 月度考核 a, 积分参数表 b  WHERE 参数名称 = '新开户1万积分'  
    UPDATE 月度考核 SET 新开户10w积分 = 新开户10w * 参数1 FROM 月度考核 a, 积分参数表 b  WHERE 参数名称 = '新开户10万积分'
    UPDATE 月度考核 SET 新开户50w积分 = 新开户50w * 参数1 FROM 月度考核 a, 积分参数表 b   WHERE 参数名称 = '新开户50万积分'
    UPDATE 月度考核 SET 新增资产积分 = floor(新增资产) * 参数1 FROM 月度考核 a, 积分参数表 b  WHERE 参数名称 = '新增资产积分'

    UPDATE 月度考核 SET 新开户总分 = 新开户积分 + 新开户1w积分 + 新开户10w积分 + 新开户50w积分 + 新增资产积分
    UPDATE 月度考核 SET 新开户总分 = 参数1 FROM 月度考核 a, 积分参数表 b   WHERE 参数名称 = '新开户总分' AND 新开户总分 > 参数1

 
    UPDATE 月度考核 SET 两融开户积分 = 两融开户 * 参数1 FROM 月度考核 a, 积分参数表 b  WHERE 参数名称 = '两融开户积分'  

    UPDATE 月度考核 SET 上月末余额市占率 = floor(上月末余额) / b.分段标识1 FROM 月度考核 a, 积分参数表 b WHERE 参数名称 = '余额市占率积分'
    UPDATE 月度考核 SET 本月末余额市占率 = floor(本月末余额) / b.分段标识2 FROM 月度考核 a, 积分参数表 b WHERE 参数名称 = '余额市占率积分'
    UPDATE 月度考核 SET 余额市占率差额 =(本月末余额市占率-上月末余额市占率)* b.分段标识2 FROM 月度考核 a, 积分参数表 b WHERE 参数名称 = '余额市占率积分'
    UPDATE 月度考核 SET 余额市占率差额得分 = 余额市占率差额 * 参数1 FROM 月度考核 a, 积分参数表 b  WHERE 参数名称 = '余额市占率积分'

    UPDATE 月度考核 SET 两融总分 = 两融开户积分 + 余额市占率差额得分
    UPDATE 月度考核 SET 两融总分 = 参数1 FROM 月度考核 a, 积分参数表 b  WHERE 参数名称 = '两融总分' AND 两融总分 > 参数1

    UPDATE 月度考核 SET 其他开户积分 = 其他开户 * 参数1 FROM 月度考核 a, 积分参数表 b  WHERE 参数名称 = '其他开户'
    UPDATE 月度考核 SET 其他资产积分 = 其他资产 * 参数1 FROM 月度考核 a, 积分参数表 b  WHERE 参数名称 = '其他新增资产'  
    --UPDATE 月度考核 SET 其他总分 = 其他开户积分 + 其他资产积分
    --UPDATE 月度考核 SET 其他总分 = 参数1 FROM 月度考核 a, 积分参数表 b  WHERE 参数名称 = '其他总分' AND 其他总分 > 参数1

    UPDATE 月度考核 SET 流失客户数积分 = -流失客户数 * 参数1 FROM 月度考核 a, 积分参数表 b  WHERE 参数名称 = '流失客户数'
    UPDATE 月度考核 SET 流失资产积分 = -floor(流失资产) * 参数1 FROM 月度考核 a, 积分参数表 b  WHERE 参数名称 = '流失资产积分'
    UPDATE 月度考核 SET 流失年佣金积分 = -floor(流失年佣金 / 分段标识1) * 参数1 FROM 月度考核 a, 积分参数表 b  WHERE 参数名称 = '流失年佣金积分'
    UPDATE 月度考核 SET 隐形流失资产积分 = -floor(隐形流失资产) / 参数2 / 10000 * 参数1 FROM 月度考核 a, 积分参数表 b  WHERE 参数名称 = '隐形流失资产积分'

    UPDATE 月度考核  SET 流失总分 = 流失客户数积分 + 流失资产积分 + 流失年佣金积分 + 隐形流失资产积分 
    UPDATE 月度考核  SET 流失总分 = 参数1 FROM 月度考核 a, 积分参数表 b  WHERE 参数名称 = '流失总分' AND 流失总分 < 参数1

    UPDATE 月度考核 SET 降佣客户积分 = -降佣客户 * 参数1 FROM 月度考核 a, 积分参数表 b  WHERE 参数名称 = '降佣客户'
    UPDATE 月度考核 SET 降佣客户积分 = 分段标识1 FROM 月度考核 a, 积分参数表 b  WHERE 降佣客户积分<分段标识1 and  参数名称 = '降佣客户'

    UPDATE 月度考核 SET 月度积分总分 = 产品总分 + 续做固定产品积分 + 新开户总分 + 两融总分 +其他开户积分 + 其他资产积分 + 流失总分 + 降佣客户积分 + 合规 + 行政评价

    UPDATE 月度考核 SET 积分完成率 = 月度积分总分 / 积分合格线  WHERE 积分合格线 <> 0

    UPDATE 月度考核 SET 对应提成比例 = 参数1 FROM 月度考核 a, 积分参数表 b  WHERE 参数名称 = '积分合格线1' AND 积分完成率 > 分段标识1
    UPDATE 月度考核 SET 对应提成比例 = 参数1 FROM 月度考核 a, 积分参数表 b  WHERE 参数名称 = '积分合格线2' AND 积分完成率 > 分段标识1
    UPDATE 月度考核 SET 对应提成比例 = 参数1 FROM 月度考核 a, 积分参数表 b  WHERE 参数名称 = '积分合格线3' AND 积分完成率 > 分段标识1
    UPDATE 月度考核 SET 对应提成比例 = 参数1 FROM 月度考核 a, 积分参数表 b  WHERE 参数名称 = '积分合格线4' AND 积分完成率 > 分段标识1
    UPDATE 月度考核 SET 对应提成比例 = 参数1 FROM 月度考核 a, 积分参数表 b  WHERE 参数名称 = '积分合格线5' AND 积分完成率 > 分段标识1
    UPDATE 月度考核 SET 对应提成比例 = 参数1 FROM 月度考核 a, 积分参数表 b  WHERE 参数名称 = '积分合格线6' AND 积分完成率 > 分段标识1

  END
GO
--exec  积分计算
