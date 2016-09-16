use ydkh
go

if exists(select 1 from sysobjects where xtype='U' and name= '月度考核'+ '__REPLACE_YEAR____REPLACE_MONTH__' )
  begin
   
    if exists(select 1 from sysobjects where xtype='U' and name= '月度考核')
       drop table 月度考核
    if exists(select 1 from sysobjects where xtype='U' and name= 'crmcd')
       drop table crmcd
    if exists(select 1 from sysobjects where xtype='U' and name= '积分参数表')
       drop table 积分参数表

    declare @runsql nvarchar(300) 
    select @runsql = ' if exists(select 1 from sysobjects where xtype=''U'' and name=''' + '月度考核'+ '__REPLACE_YEAR____REPLACE_MONTH__' + ''') ' + char(13) + char(10)
                   +  '  select * into 月度考核'  + ' from 月度考核'+ '__REPLACE_YEAR____REPLACE_MONTH__'
    --select @runsql
    exec sp_executesql @runsql
    select @runsql = ' if exists(select 1 from sysobjects where xtype=''U'' and name=''' + 'crmcd'+ '__REPLACE_YEAR____REPLACE_MONTH__' + ''') ' + char(13) + char(10)
          + '    select * into crmcd'  + ' from crmcd'+ '__REPLACE_YEAR____REPLACE_MONTH__'
    --select @runsql
    exec sp_executesql @runsql
    select @runsql =   ' if exists(select 1 from sysobjects where xtype=''U'' and name=''' + '积分参数表'+ '__REPLACE_YEAR____REPLACE_MONTH__'+ ''') ' + char(13) + char(10)
              +  ' select * into 积分参数表'  + ' from 积分参数表'+ '__REPLACE_YEAR____REPLACE_MONTH__'
    --select @runsql
    exec sp_executesql @runsql

   print '月度考核数据已经恢复为'+'__REPLACE_YEAR____REPLACE_MONTH__'+'数据。'
  end
else 
   print  '__REPLACE_YEAR____REPLACE_MONTH__'+'月度考核数据不存在'
go
