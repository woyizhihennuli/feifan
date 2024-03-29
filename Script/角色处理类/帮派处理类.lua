-- @Author: baidwwy
-- @Date:   2023-03-10 11:49:54
-- @Last Modified by:   baidwwy
-- @Last Modified time: 2023-07-09 12:42:18
local 帮派处理类 = class()


function 帮派处理类:初始化()

end

function 帮派处理类:数据处理(id,序号,内容)
	if 序号 == 6101 then
		self:创建帮派(id,内容)
	elseif 序号 == 6102 then
		if self:取是否有帮派(id) then
			发送数据(玩家数据[id].连接id,69,{项目 = "1",编号=玩家数据[id].角色.数据.帮派数据.编号,权限=玩家数据[id].角色.数据.帮派数据.权限})
			发送数据(玩家数据[id].连接id,67, {帮派数据[玩家数据[id].角色.数据.帮派数据.编号]})
		else
		    发送数据(玩家数据[id].连接id, 7, "#Y/请先加入一个帮派。")
		end
		--发送数据(玩家数据[id].连接id, 7, "#Y/帮派功能暂时关闭")
	elseif 序号 == 6103 then
		if self:取是否有帮派(id) then
			发送数据(玩家数据[id].连接id, 7, "#Y/请退出您当前的帮派后再次申请。")
			return 0
		else
			self:申请帮派(id,内容)
		end
	elseif 序号 == 6104 then
		self:处理申请(id,内容)
	elseif 序号 == 6105 then
		self:修改帮派宗旨(id,内容)
	elseif 序号 == 6106 then
		self:逐出处理(id,内容)
	elseif 序号 == 6107 then
		self:退出帮派(id)
	elseif 序号 == 6108 then
		self:帮派技能研究(id,内容)
	elseif 序号 == 6109 then
		self:帮派修炼研究(id,内容)
	elseif 序号 == 6110 then
		self:帮派技能升级(id,内容)
	elseif 序号 == 6111 then
		self:帮派修炼升级(id,内容)
	elseif 序号 == 6112 then
		self:帮派建筑研究(id,内容)
	elseif 序号 == 6113 then
		self:帮派规模提升(id)
    elseif 序号 == 6114 then
		self:缴纳帮费(id)
    elseif 序号 == 6115 then
		self:设置帮费(id,内容)
	end
end






function 帮派处理类:维护处理(编号)
	local gm = 帮派数据[编号].帮派规模
	local 在线人数 = 0
	local 帮派维护费用 = 0
	帮派数据[编号].繁荣度 = 帮派数据[编号].繁荣度 + 10
	帮派数据[编号].安定度 = 帮派数据[编号].安定度 + 10
	帮派数据[编号].行动力 = 帮派数据[编号].行动力 + 10
	local 资材加成 = tonumber(f函数.读配置(程序目录.."配置文件.ini","主要配置","帮派资材刷新数量"))
	if 资材加成 == nil then
		资材加成=100
	end
	帮派数据[编号].帮派资材.当前 = 帮派数据[编号].帮派资材.当前 + 帮派数据[编号].帮派建筑.药房.数量*100 + 资材加成
	for i,v in pairs(帮派数据[编号].成员数据) do
		if 帮派数据[编号].成员数据[i].在线 then
			在线人数 = 在线人数 +1
		end
	end
	帮派数据[编号].人气度 = 帮派数据[编号].人气度 + 在线人数
	if 帮派数据[编号].帮派资金.当前/帮派数据[编号].帮派资金.上限 >= 0.8 then
		帮派数据[编号].物价指数 = 1.5
	elseif 帮派数据[编号].帮派资金.当前/帮派数据[编号].帮派资金.上限 >= 0.5 then
		帮派数据[编号].物价指数 = 1.2
	else
		帮派数据[编号].物价指数 = 1
	end
	if 帮派数据[编号].研究技能 ~= nil then
		local 加成 = tonumber(f函数.读配置(程序目录.."配置文件.ini","主要配置","帮派技能研究经验"))
		if 加成 == nil then
			加成=100
		end
		-- 0914 书院数量影响1000变成5000
		帮派数据[编号].技能数据[帮派数据[编号].研究技能].当前经验 = 帮派数据[编号].技能数据[帮派数据[编号].研究技能].当前经验 + 加成 + 帮派数据[编号].帮派建筑.书院.数量*5000
	end
	if 帮派数据[编号].研究修炼 ~= nil then
		local 加成 = tonumber(f函数.读配置(程序目录.."配置文件.ini","主要配置","帮派修炼研究经验"))
		if 加成 == nil then
			加成=50
		end
		帮派数据[编号].修炼数据[帮派数据[编号].研究修炼].当前经验 = 帮派数据[编号].修炼数据[帮派数据[编号].研究修炼].当前经验 + 加成
	end
	if 帮派数据[编号].繁荣度 >= gm*2000 then
		帮派数据[编号].繁荣度 = gm*2000
	end
	if 帮派数据[编号].安定度 >= gm*1000 then
		帮派数据[编号].安定度 = gm*1000
	end
	if 帮派数据[编号].人气度 >= gm*1000 then
		帮派数据[编号].人气度 = gm*1000
	end
	-- if 帮派数据[编号].帮派资材.当前 > 帮派数据[编号].帮派资材.上限 then
	-- 	帮派数据[编号].帮派资材.当前 = 帮派数据[编号].帮派资材.上限
	-- end
	帮派维护费用 = 帮派数据[编号].当前维护费*帮派数据[编号].物价指数
	帮派数据[编号].帮派资金.当前 = 帮派数据[编号].帮派资金.当前 - 帮派维护费用*0.1
	广播帮派消息({内容="[整点维护]#G/帮派的#Y/繁荣度、安定度、行动力、人气度#G/增加了，帮派资材、物价指数已经刷新,本次维护扣除了#Y/ "..帮派维护费用.."#G/帮派资金",频道="bp"},帮派数据[编号].帮派编号)
end

function 帮派处理类:帮派建筑研究(id,内容)
	local 建筑项目 = 内容.名称
	local 帮派编号 = 玩家数据[id].角色.数据.帮派数据.编号
	id = id+0
	if 玩家数据[id].角色.数据.帮派数据.权限 < 4 then
		发送数据(玩家数据[id].连接id, 7, "#Y/你没有权限进行此操作。")
		return 0
	elseif 建筑项目 ~= "书院" and 建筑项目 ~= "仓库" and 建筑项目 ~= "金库" and 建筑项目 ~= "厢房" and 建筑项目 ~= "兽室" and 建筑项目 ~= "药房" then
		发送数据(玩家数据[id].连接id, 7, "#Y/建筑项目出错请联系GM。")
		return 0
	else
		if 取帮派建筑数量(帮派数据[帮派编号].帮派规模+0) <= 帮派数据[帮派编号].帮派建筑[建筑项目].数量 then
			发送数据(玩家数据[id].连接id, 7, "#Y/当前该建筑数量已经达到了上限,请继续升级帮派或者其他建筑。")
			return 0
		else
			帮派数据[帮派编号].当前内政 = 建筑项目
			发送数据(玩家数据[id].连接id, 7, "#Y/修改帮派内政成功,当前内政研究为:"..建筑项目.."。")
			广播帮派消息({内容="[帮派总管]#G/ "..玩家数据[id].角色.数据.名称.." #Y/将帮派内政修改为"..建筑项目,频道="bp"},帮派编号)
		end
	end
end

function 帮派处理类:取帮派建筑达标情况(等级,帮派编号)
  local 建筑符合 = false
  local 银两符合 = false
  local 建筑数量 = 0
  if 等级 == 1 then
    for i,v in pairs(帮派数据[帮派编号].帮派建筑) do
    	if 帮派数据[帮派编号].帮派建筑[i].数量 >= 2 then
    		建筑数量 = 建筑数量 +1
    	end
    end
  elseif 等级 == 2 then
    for i,v in pairs(帮派数据[帮派编号].帮派建筑) do
    	if 帮派数据[帮派编号].帮派建筑[i].数量 >= 4 then
    		建筑数量 = 建筑数量 +1
    	end
    end
  elseif 等级 == 3 then
    for i,v in pairs(帮派数据[帮派编号].帮派建筑) do
    	if 帮派数据[帮派编号].帮派建筑[i].数量 >= 8 then
    		建筑数量 = 建筑数量 +1
    	end
    end
  elseif 等级 == 4 then
    for i,v in pairs(帮派数据[帮派编号].帮派建筑) do
    	if 帮派数据[帮派编号].帮派建筑[i].数量 >= 12 then
    		建筑数量 = 建筑数量 +1
    	end
    end
  end

  if 等级 == 1 and 建筑数量 >=4 then
    建筑符合 = true
  elseif 等级 == 2 and 建筑数量 >=4  then
  	建筑符合 = true
  elseif 等级 == 3 and 建筑数量 >=4  then
  	建筑符合 = true
  elseif 等级 == 4 and 建筑数量 >=6  then
  	建筑符合 = true
  end

  if 等级 == 1 and 帮派数据[帮派编号].帮派资金.当前+0 > 3000000 then
    银两符合 = true
  elseif 等级 == 2 and 帮派数据[帮派编号].帮派资金.当前+0 > 8000000 then
  	银两符合 = true
  elseif 等级 == 3 and 帮派数据[帮派编号].帮派资金.当前+0 > 15000000 then
  	银两符合 = true
  elseif 等级 == 4 and 帮派数据[帮派编号].帮派资金.当前+0 > 25000000 then
  	银两符合 = true
  end

  if 建筑符合 == false then
  	return 1
  elseif 银两符合 == false then
    return 2
  else
  	return 3
  end
end
function 帮派处理类:帮派福利(id)
	local 帮派编号 = 玩家数据[id].角色.数据.帮派数据.编号
id = id+0
local 帮贡当前 = 帮派数据[帮派编号].成员数据[id].帮贡.当前
local 帮贡 = 玩家数据[id].角色.数据.帮贡
    if 帮贡 < 500 then
        常规提示(id,"#Y/帮贡不足500,无法领取帮派加成")
        return
    end
玩家数据[id].角色.数据.帮贡 = 玩家数据[id].角色.数据.帮贡 -30
local 帮派成员= 帮派数据[帮派编号].成员数据[id]
 if 帮派数据[玩家数据[id].角色.数据.帮派数据.编号].帮派规模 >= 1 then
 	玩家数据[id].角色.数据.最大气血=玩家数据[id].角色.数据.最大气血+500
 	玩家数据[id].角色.数据.伤害=玩家数据[id].角色.数据.伤害+150
 	玩家数据[id].角色.数据.防御=玩家数据[id].角色.数据.防御+150
 	玩家数据[id].角色.数据.帮派限时属性 = os.time()+3600
 	玩家数据[id].角色.数据.帮派限时属性开关 =true
 	else
 发送数据(玩家数据[id].连接id, 7, "#Y我们这小帮派,没有这项福利哦。")

end
end
function 帮派处理类:帮派规模提升(id)
	local 帮派编号 = 玩家数据[id].角色.数据.帮派数据.编号
	id = id+0
	if 玩家数据[id].角色.数据.帮派数据.权限 < 4 then
		发送数据(玩家数据[id].连接id, 7, "#Y你没有权限进行此操作。")
		return 0
	elseif 帮派数据[帮派编号].帮派规模+0 >= 5 then
		发送数据(玩家数据[id].连接id, 7, "#Y帮派已经达到了顶级。")
		return 0
	elseif self:取帮派建筑达标情况(帮派数据[帮派编号].帮派规模,帮派编号) == 1 then
		发送数据(玩家数据[id].连接id, 7, "#Y帮派升级要求相应建筑数量达到要求。")
		return 0
	-- elseif self:取帮派建筑达标情况(帮派数据[帮派编号].帮派规模,帮派编号) == 2 then
	-- 	发送数据(玩家数据[id].连接id, 7, "#Y帮派升级要求帮派当前资金达到要求。")
	-- 	return 0
	else
		帮派数据[帮派编号].帮派规模 = 帮派数据[帮派编号].帮派规模 +1
		if 帮派数据[帮派编号].帮派规模 == 2 then
			帮派数据[帮派编号].帮派资材.上限 =20000
			帮派数据[帮派编号].帮派资金.上限 =10000000+帮派数据[帮派编号].帮派建筑.金库.数量*1000000
			帮派数据[帮派编号].当前维护费 =200000
			帮派数据[帮派编号].成员数量.上限 = 110
		elseif 帮派数据[帮派编号].帮派规模 == 3 then
			帮派数据[帮派编号].帮派资材.上限 =40000
			帮派数据[帮派编号].帮派资金.上限 =20000000+帮派数据[帮派编号].帮派建筑.金库.数量*1000000
			帮派数据[帮派编号].当前维护费 =300000
			帮派数据[帮派编号].成员数量.上限 = 120
		elseif 帮派数据[帮派编号].帮派规模 == 4 then
			帮派数据[帮派编号].帮派资材.上限 =60000
			帮派数据[帮派编号].帮派资金.上限 =30000000+帮派数据[帮派编号].帮派建筑.金库.数量*1000000
			帮派数据[帮派编号].当前维护费 =400000
			帮派数据[帮派编号].成员数量.上限 = 130
		elseif 帮派数据[帮派编号].帮派规模 == 5 then
			帮派数据[帮派编号].帮派资材.上限 =80000
			帮派数据[帮派编号].帮派资金.上限 =40000000+帮派数据[帮派编号].帮派建筑.金库.数量*1000000
			帮派数据[帮派编号].当前维护费 =500000
			帮派数据[帮派编号].成员数量.上限 = 150
		end
		发送数据(玩家数据[id].连接id,67, {帮派数据[帮派编号]})
	end
end

function 帮派处理类:帮派技能升级(id,内容)
	local 技能项目 = 内容.名称
	local 帮派编号 = 玩家数据[id].角色.数据.帮派数据.编号
	id = id+0
	if 玩家数据[id].角色.数据.帮派数据.权限 < 4 then
		发送数据(玩家数据[id].连接id, 7, "#Y/你没有权限进行此操作。")
		return 0
	elseif 技能项目 ~= "健身术" and 技能项目 ~= "炼金术" and 技能项目 ~= "打造技巧" and 技能项目 ~= "淬灵之术" and 技能项目 ~= "烹饪技巧" and 技能项目 ~= "暗器技巧" and 技能项目 ~= "养生之道" and 技能项目 ~= "强身术" and 技能项目 ~= "冥想"  and 技能项目 ~= "巧匠之术" and 技能项目 ~= "裁缝技巧" and 技能项目 ~= "强壮" and 技能项目 ~= "中药医理" and 技能项目 ~= "神速" then
		发送数据(玩家数据[id].连接id, 7, "#Y/技能项目出错请联系GM。")
		return 0
	else
		if 帮派数据[帮派编号].技能数据[技能项目].当前 >= 129 then
			发送数据(玩家数据[id].连接id, 7, "#Y/该项技能已经达到了上限。")
			return 0
		-- elseif 帮派数据[帮派编号].技能数据[技能项目].当前 >= 109 and 帮派数据[帮派编号].技能数据[技能项目].当前== "强壮" or 帮派数据[帮派编号].技能数据[技能项目].当前== "神速"  then
		-- 	发送数据(玩家数据[id].连接id, 7, "#Y/强壮和神速等级最高109级")
		-- 	return 0

		elseif  帮派数据[帮派编号].技能数据[技能项目].当前经验 < 技能消耗.经验[帮派数据[帮派编号].技能数据[技能项目].当前+1] then
			发送数据(玩家数据[id].连接id, 7, "#Y/该技能研究经验不足。")
			return 0
		else
			帮派数据[帮派编号].技能数据[技能项目].当前经验 = 帮派数据[帮派编号].技能数据[技能项目].当前经验 -技能消耗.经验[帮派数据[帮派编号].技能数据[技能项目].当前+1]
			帮派数据[帮派编号].技能数据[技能项目].当前 = 帮派数据[帮派编号].技能数据[技能项目].当前 +1
			发送数据(玩家数据[id].连接id,67, {帮派数据[帮派编号]})
			发送数据(玩家数据[id].连接id, 7, "#Y/研究技能提升等级成功。")
			-- 发送数据(玩家数据[id].连接id, 7, "#Y/技能升级暂时关闭")
		end
	end

end



function 帮派处理类:帮派技能研究(id,内容)
	local 技能项目 = 内容.名称
	local 帮派编号 = 玩家数据[id].角色.数据.帮派数据.编号
	id = id+0
	if 玩家数据[id].角色.数据.帮派数据.权限 < 4 then
		发送数据(玩家数据[id].连接id, 7, "#Y/你没有权限进行此操作。")
		return 0
	elseif 技能项目 ~= "健身术" and 技能项目 ~= "炼金术" and 技能项目 ~= "打造技巧" and 技能项目 ~= "淬灵之术" and 技能项目 ~= "烹饪技巧" and 技能项目 ~= "暗器技巧" and 技能项目 ~= "养生之道" and 技能项目 ~= "强身术" and 技能项目 ~= "冥想"  and 技能项目 ~= "巧匠之术" and 技能项目 ~= "裁缝技巧" and 技能项目 ~= "强壮" and 技能项目 ~= "中药医理" and 技能项目~= "神速" then
		发送数据(玩家数据[id].连接id, 7, "#Y/技能项目出错请联系GM。")
		return 0
	else
		if 帮派数据[帮派编号].技能数据[技能项目].当前 >= 160 then
			发送数据(玩家数据[id].连接id, 7, "#Y/该项技能已经达到了上限。")
			return 0
		else
			帮派数据[帮派编号].研究技能 = 技能项目
			发送数据(玩家数据[id].连接id, 7, "#Y/修改帮派研究技能成功,当前研究技能为:"..技能项目.."。")
			广播帮派消息({内容="[帮派总管]#G/ "..玩家数据[id].角色.数据.名称.." #Y/将帮派技能研究修改为"..技能项目,频道="bp"},帮派编号)
		end
	end
end

function 帮派处理类:帮派修炼升级(id,内容)
	local 修炼项目 = 内容.名称
	local 帮派编号 = 玩家数据[id].角色.数据.帮派数据.编号
	id = id+0
	if 玩家数据[id].角色.数据.帮派数据.权限 < 4 then
		发送数据(玩家数据[id].连接id, 7, "#Y/你没有权限进行此操作。")
		return 0
	elseif 修炼项目 ~= "攻击修炼" and 修炼项目 ~= "防御修炼" and 修炼项目 ~= "法术修炼" and 修炼项目 ~= "法抗修炼" then
		发送数据(玩家数据[id].连接id, 7, "#Y/修炼项目出错请联系GM。")
		return 0
	else
		if 帮派数据[帮派编号].修炼数据[修炼项目].当前 >= 帮派数据[帮派编号].修炼数据[修炼项目].上限 then
			发送数据(玩家数据[id].连接id, 7, "#Y/该项修炼已经达到了上限。")
			return 0
		elseif  帮派数据[帮派编号].修炼数据[修炼项目].当前经验 < 技能消耗.经验[帮派数据[帮派编号].修炼数据[修炼项目].当前+1] then
			发送数据(玩家数据[id].连接id, 7, "#Y/该修炼研究经验不足。")
			return 0
		else
			-- 帮派数据[帮派编号].修炼数据[修炼项目].当前经验 = 帮派数据[帮派编号].修炼数据[修炼项目].当前经验 - 技能消耗.经验[帮派数据[帮派编号].修炼数据[修炼项目].当前+1]
			-- 帮派数据[帮派编号].修炼数据[修炼项目].当前 = 帮派数据[帮派编号].修炼数据[修炼项目].当前 +1
			-- 玩家数据[id].角色.数据.修炼[玩家数据[id].角色.数据.修炼.当前][3]=玩家数据[id].角色.数据.修炼[玩家数据[id].角色.数据.修炼.当前][3]+1
			-- 发送数据(玩家数据[id].连接id,67, {帮派数据[帮派编号]})
			-- 发送数据(玩家数据[id].连接id, 7, "#Y/研究技能提升研究等级成功。")
			发送数据(玩家数据[id].连接id, 7, "#Y/修炼研究关闭,请在#G帮派药房#去点修!")
		end
	end

end


function 帮派处理类:帮派修炼研究(id,内容)
	local 修炼项目 = 内容.名称
	local 帮派编号 = 玩家数据[id].角色.数据.帮派数据.编号
	id = id+0
	if 玩家数据[id].角色.数据.帮派数据.权限 < 4 then
		发送数据(玩家数据[id].连接id, 7, "#Y/你没有权限进行此操作。")
		return 0
	elseif 修炼项目 ~= "攻击修炼" and 修炼项目 ~= "防御修炼" and 修炼项目 ~= "法术修炼" and 修炼项目 ~= "法抗修炼" then
		发送数据(玩家数据[id].连接id, 7, "#Y/修炼项目出错请联系GM。")
		return 0
	else
		if 帮派数据[帮派编号].修炼数据[修炼项目].当前 >= 帮派数据[帮派编号].修炼数据[修炼项目].上限 then
			发送数据(玩家数据[id].连接id, 7, "#Y/该项修炼已经达到了上限。")
			return 0
		else
			帮派数据[帮派编号].研究修炼 = 修炼项目
			发送数据(玩家数据[id].连接id, 7, "#Y/修改帮派研究修炼成功,当前研究技能为:"..修炼项目.."。")
			广播帮派消息({内容="[帮派总管]#G/ "..玩家数据[id].角色.数据.名称.." #Y/将帮派修炼研究修改为"..修炼项目,频道="bp"},帮派编号)
		end
	end
end

function 帮派处理类:退出帮派(id)

	local 帮派编号 = 玩家数据[id].角色.数据.帮派数据.编号

	if 玩家数据[id].角色.数据.帮派数据.权限 > 0 then
		发送数据(玩家数据[id].连接id, 7, "#Y/你身兼要职暂时无法进行此操作。")
		return 0
	end

	帮派数据[帮派编号].成员数据[id] = nil
	玩家数据[id].角色.数据.帮派 = "无帮派"
	玩家数据[玩家id].角色.数据.帮战积分 = 0
    玩家数据[玩家id].角色.数据.帮战次数 = 0
	玩家数据[id].角色.数据.帮派数据 = nil
	发送数据(玩家数据[id].连接id, 7, "#Y/退出帮派成功。")
	广播帮派消息({内容="[帮派总管]#G/ "..玩家数据[id].角色.数据.名称.." #Y/已经退出了帮派,从此与本帮再无瓜葛",频道="bp"},帮派编号)
	玩家数据[id].角色:删除称谓(id,帮派数据[帮派编号].帮派名称.."帮众")
	发送数据(玩家数据[id].连接id,69,{项目 = "3"})
	帮派数据[帮派编号].成员数量.当前 = 帮派数据[帮派编号].成员数量.当前 - 1

end

function 帮派处理类:逐出处理(id,内容)

	local 帮派编号 = 玩家数据[id].角色.数据.帮派数据.编号
	local 玩家id = 内容.玩家id+0
	if 玩家数据[id].角色.数据.帮派数据.权限 < 2 then
		发送数据(玩家数据[id].连接id, 7, "#Y/你没有权限进行此操作。")
		return 0
	end

	if 玩家数据[玩家id] == nil then
		if 帮派数据[帮派编号].成员数据[玩家id].职务 ~= "帮众" then
			发送数据(玩家数据[id].连接id, 7, "#Y/请先解除对方的职务后再近些此操作。")
			return 0
		end
		帮派数据[帮派编号].成员数据[玩家id] = nil
		帮派数据[帮派编号].成员数量.当前 = 帮派数据[帮派编号].成员数量.当前 - 1
	else
		if 玩家数据[玩家id].角色.数据.帮派数据.权限 >= 1 then
			发送数据(玩家数据[id].连接id, 7, "#Y/请先解除对方的职务后再近些此操作。")
			return 0
		end
		玩家数据[玩家id].角色.数据.帮派 = "无帮派"
		玩家数据[玩家id].角色.数据.帮派数据 = nil
		玩家数据[玩家id].角色.数据.帮战积分 = 0
        玩家数据[玩家id].角色.数据.帮战次数 = 0
		发送数据(玩家数据[玩家id].连接id, 7, "#Y/你已经被逐出了帮派。")
		发送数据(玩家数据[id].连接id, 7, "#Y/操作成功。")
		广播帮派消息({内容="[帮派总管]#G/ "..玩家数据[id].角色.数据.名称.." #Y/使用管理权限将: #P/"..玩家数据[玩家id].角色.数据.名称.." #Y/逐出了帮派！",频道="bp"},帮派编号)
		玩家数据[玩家id].角色:删除称谓(玩家id,帮派数据[帮派编号].帮派名称.."帮众")
		帮派数据[帮派编号].成员数据[玩家id] = nil
		帮派数据[帮派编号].成员数量.当前 = 帮派数据[帮派编号].成员数量.当前 - 1
		发送数据(玩家数据[id].连接id,67, {帮派数据[帮派编号]})
	end

end

function 帮派处理类:任命处理(id,玩家id,事件)
	if self:取是否有帮派(id) then
		local 帮派编号 = 玩家数据[id].角色.数据.帮派数据.编号
		玩家id = 玩家id +0
		id = id +0
		local 管理权限 = 玩家数据[id].角色.数据.帮派数据.权限+0
		if 玩家数据[玩家id] == nil then
			local 玩家账号 = 帮派数据[帮派编号].成员数据[玩家id].账号
			local 角色数据 = 读入文件([[data/]]..玩家账号..[[/]]..玩家id..[[/角色.txt]])
   			角色数据 = table.loadstring(角色数据)
   			if 角色数据.帮派数据 == nil or 角色数据.帮派 == "无帮派" then
   				常规提示(id,"#Y/该玩家帮派数据错误请联系管理员处理！")
				return
			elseif 角色数据.帮派数据.权限 > 0 and 事件 ~= "帮众" then
				常规提示(id,"#Y/该玩家已经在帮派内担任职务,请先解除其对应的职务！")
				return
			elseif 事件 == "商人" then
				常规提示(id,"#Y/任命商人需要该玩家在线！")
				return
			else
				if 事件 == "帮主" then
					if 管理权限 < 5 then
						常规提示(id,"#Y/你没有足够的权限！")
						return 0
					end
					角色数据.帮派数据.权限 = 5
					帮派数据[帮派编号].现任帮主 = {名称=角色数据.名称,id=玩家id}
					帮派数据[帮派编号].成员数据[玩家id].职务 = "帮主"
					玩家数据[id].角色.数据.帮派数据.权限 = 0
					帮派数据[帮派编号].成员数据[id].职务 = "帮众"
					常规提示(id,"#Y/你已经卸任帮主了！")
					广播帮派消息({内容="[帮派总管]#G/ "..玩家数据[id].角色.数据.名称.." #Y/将帮主之位禅让于: #P/"..角色数据.名称.."！",频道="bp"},帮派编号)
				elseif 事件 == "副帮主" then
					if 管理权限 < 5 then
						常规提示(id,"#Y/你没有足够的权限！")
						return 0
					end
					if 帮派数据[帮派编号].副帮主.名称 == nil then
						角色数据.帮派数据.权限 = 4
						帮派数据[帮派编号].副帮主 = {名称=角色数据.名称,id=玩家id}
						帮派数据[帮派编号].成员数据[玩家id].职务 = "副帮主"
						常规提示(id,"#Y/任命成功！")
						广播帮派消息({内容="[帮派总管]#G/ "..玩家数据[id].角色.数据.名称.." #Y/将委任 #P/"..角色数据.名称.." 为新的副帮主！",频道="bp"},帮派编号)
					else
						常规提示(玩家id,"#Y/本帮已经拥有一位副帮主了，请先解除对方的职务！")
					end
				elseif 事件 == "左护法" or 事件=="右护法" then
					if 管理权限 < 4 then
						常规提示(id,"#Y/你没有足够的权限！")
						return 0
					end
					if 事件 == "左护法" then
						if 帮派数据[帮派编号].左护法.名称 == nil then
							角色数据.帮派数据.权限 = 3
							帮派数据[帮派编号].左护法 = {名称=角色数据.名称,id=玩家id}
							帮派数据[帮派编号].成员数据[玩家id].职务 = "左护法"
							常规提示(id,"#Y/任命成功！")
							广播帮派消息({内容="[帮派总管]#G/ "..玩家数据[id].角色.数据.名称.." #Y/将委任 #P/"..角色数据.名称.." 为新的左护法！",频道="bp"},帮派编号)
						else
							常规提示(玩家id,"#Y/本帮已经拥有一位左护法了，请先解除对方的职务！")
						end
					else
						if 帮派数据[帮派编号].右护法.名称 == nil then
							角色数据.帮派数据.权限 = 3
							帮派数据[帮派编号].右护法 = {名称=角色数据.名称,id=玩家id}
							帮派数据[帮派编号].成员数据[玩家id].职务 = "右护法"
							常规提示(id,"#Y/任命成功！")
							广播帮派消息({内容="[帮派总管]#G/ "..玩家数据[id].角色.数据.名称.." #Y/将委任 #P/"..角色数据.名称.." 为新的右护法！",频道="bp"},帮派编号)
						else
							常规提示(玩家id,"#Y/本帮已经拥有一位右护法了，请先解除对方的职务！")
						end
					end
				elseif 事件 == "长老" then
					if 管理权限 < 3 then
						常规提示(id,"#Y/你没有足够的权限！")
						return 0
					end
					if 帮派数据[帮派编号].长老 == nil then
						帮派数据[帮派编号].长老 = {}
					end
					if #帮派数据[帮派编号].长老 >= 4 then
						常规提示(id,"#Y/本帮已经存在4位长老,无法任命更多的长老了！")
						return 0
					else
						帮派数据[帮派编号].长老[#帮派数据[帮派编号].长老+1] = {名称=角色数据.名称,id=玩家id}
						角色数据.帮派数据.权限 = 2
						帮派数据[帮派编号].成员数据[玩家id].职务 = "长老"
						常规提示(id,"#Y/任命成功！")
						广播帮派消息({内容="[帮派总管]#G/ "..玩家数据[id].角色.数据.名称.." #Y/将委任 #P/"..角色数据.名称.." 为新的长老！",频道="bp"},帮派编号)
					end
				elseif 事件 == "堂主" then
					if 管理权限 < 2 then
						常规提示(id,"#Y/你没有足够的权限！")
						return 0
					end
					if 帮派数据[帮派编号].堂主 == nil then
						帮派数据[帮派编号].堂主 = {}
					end
					if #帮派数据[帮派编号].堂主 >= 4 then
						常规提示(id,"#Y/本帮已经存在4位堂主,无法任命更多的堂主了！")
						return 0
					else
						帮派数据[帮派编号].堂主[#帮派数据[帮派编号].堂主+1] = {名称=角色数据.角色.数据.名称,id=玩家id}
						角色数据.帮派数据.权限 = 1
						帮派数据[帮派编号].成员数据[玩家id].职务 = "堂主"
						常规提示(id,"#Y/任命成功！")
						广播帮派消息({内容="[帮派总管]#G/ "..玩家数据[id].角色.数据.名称.." #Y/将委任 #P/"..角色数据.名称.." 为新的堂主！",频道="bp"},帮派编号)
					end
				elseif 事件 == "帮众" then
					if 管理权限 < 1 then
						常规提示(id,"#Y/你没有足够的权限！")
						return 0
					end
					if 角色数据.帮派数据.权限+0 >= 5 then
						常规提示(id,"#Y/帮主之位只可以禅让，无法任免！")
						return 0
					end
					if 角色数据.帮派数据.权限+0 == 4 then
						帮派数据[帮派编号].副帮主 = {}
					elseif 角色数据.帮派数据.权限+0 == 3 then
						if 帮派数据[帮派编号].成员数据[玩家id].职务 == "左护法" then
							帮派数据[帮派编号].左护法 = {}
						else
							帮派数据[帮派编号].右护法 = {}
						end
					elseif 角色数据.帮派数据.权限+0 == 2 then
						for i=1,#帮派数据[帮派编号].长老 do
							if 帮派数据[帮派编号].长老[i] ~= nil then
								if 帮派数据[帮派编号].长老[i].id+0 == 玩家id then
									table.remove(帮派数据[帮派编号].长老,i)
								end
							end
						end
					elseif 角色数据.帮派数据.权限+0 == 1 then
						for i=1,#帮派数据[帮派编号].堂主 do
							if 帮派数据[帮派编号].堂主[i] ~= nil then
								if 帮派数据[帮派编号].堂主[i].id+0 == 玩家id then
									table.remove(帮派数据[帮派编号].堂主,i)
								end
							end
						end
					end
					角色数据.帮派数据.权限 = 0
					帮派数据[帮派编号].成员数据[玩家id].职务 = "帮众"
				end
				写出文件([[data/]]..玩家账号..[[/]]..玩家id..[[/角色.txt]],table.tostring(角色数据))
				常规提示(id,"#Y/任命成功！")
				发送数据(玩家数据[id].连接id,69,{项目 = "1",编号=玩家数据[id].角色.数据.帮派数据.编号,权限=玩家数据[id].角色.数据.帮派数据.权限})
				发送数据(玩家数据[id].连接id,67, {帮派数据[帮派编号]})
			end
		else
			if self:取是否有帮派(玩家id) == false or 玩家数据[玩家id].角色.数据.帮派数据.编号 ~= 玩家数据[id].角色.数据.帮派数据.编号 then
				return
			elseif 玩家数据[玩家id].角色.数据.帮派数据.权限 > 0 and 事件 ~= "帮众" then
				常规提示(id,"#Y/该玩家已经在帮派内担任职务,请先解除其对应的职务！")
				return
			end

			if 事件 == "帮主" then
				if 管理权限 < 5 then
					常规提示(id,"#Y/你没有足够的权限！")
					return 0
				end
				玩家数据[玩家id].角色.数据.帮派数据.权限 = 5
				帮派数据[帮派编号].现任帮主 = {名称=玩家数据[玩家id].角色.数据.名称,id=玩家id}
				常规提示(玩家id,"#Y/你已经成为新的帮主了！")
				帮派数据[帮派编号].成员数据[玩家id].职务 = "帮主"

				玩家数据[玩家id].角色:删除称谓(玩家id,帮派数据[帮派编号].帮派名称.."帮众")
				玩家数据[玩家id].角色:添加称谓(玩家id,帮派数据[帮派编号].帮派名称.."帮主")

				玩家数据[id].角色.数据.帮派数据.权限 = 0
				帮派数据[帮派编号].成员数据[id].职务 = "帮众"
				玩家数据[id].角色:删除称谓(id,帮派数据[帮派编号].帮派名称.."帮主")
				玩家数据[id].角色:添加称谓(id,帮派数据[帮派编号].帮派名称.."帮众")

				常规提示(id,"#Y/你已经卸任帮主了！")
				广播帮派消息({内容="[帮派总管]#G/ "..玩家数据[id].角色.数据.名称.." #Y/将帮主之位禅让于: #P/"..玩家数据[玩家id].角色.数据.名称.."！",频道="bp"},帮派编号)
			elseif 事件 == "副帮主" then
				if 管理权限 < 5 then
					常规提示(id,"#Y/你没有足够的权限！")
					return 0
				end
				if 帮派数据[帮派编号].副帮主.名称 == nil then
					玩家数据[玩家id].角色.数据.帮派数据.权限 = 4
					帮派数据[帮派编号].副帮主 = {名称=玩家数据[玩家id].角色.数据.名称,id=玩家id}
					常规提示(玩家id,"#Y/你已经被任命为副帮主！")
					帮派数据[帮派编号].成员数据[玩家id].职务 = "副帮主"

					玩家数据[玩家id].角色:删除称谓(玩家id,帮派数据[帮派编号].帮派名称.."帮众")
					玩家数据[玩家id].角色:添加称谓(玩家id,帮派数据[帮派编号].帮派名称.."副帮主")


					常规提示(id,"#Y/任命成功！")
					广播帮派消息({内容="[帮派总管]#G/ "..玩家数据[id].角色.数据.名称.." #Y/将委任 #P/"..玩家数据[玩家id].角色.数据.名称.." 为新的副帮主！",频道="bp"},帮派编号)
				else
					常规提示(玩家id,"#Y/本帮已经拥有一位副帮主了，请先解除对方的职务！")
				end
			elseif 事件 == "左护法" or 事件=="右护法" then
				if 管理权限 < 4 then
					常规提示(id,"#Y/你没有足够的权限！")
					return 0
				end
				if 事件 == "左护法" then
					if 帮派数据[帮派编号].左护法.名称 == nil then
						玩家数据[玩家id].角色.数据.帮派数据.权限 = 3
						帮派数据[帮派编号].左护法 = {名称=玩家数据[玩家id].角色.数据.名称,id=玩家id}
						常规提示(玩家id,"#Y/你已经被任命为左护法！")
						帮派数据[帮派编号].成员数据[玩家id].职务 = "左护法"


						玩家数据[玩家id].角色:删除称谓(玩家id,帮派数据[帮派编号].帮派名称.."帮众")
						玩家数据[玩家id].角色:添加称谓(玩家id,帮派数据[帮派编号].帮派名称.."左护法")


						常规提示(id,"#Y/任命成功！")
						广播帮派消息({内容="[帮派总管]#G/ "..玩家数据[id].角色.数据.名称.." #Y/将委任 #P/"..玩家数据[玩家id].角色.数据.名称.." 为新的左护法！",频道="bp"},帮派编号)
					else
						常规提示(玩家id,"#Y/本帮已经拥有一位左护法了，请先解除对方的职务！")
					end
				else
					if 帮派数据[帮派编号].右护法.名称 == nil then
						玩家数据[玩家id].角色.数据.帮派数据.权限 = 3
						帮派数据[帮派编号].右护法 = {名称=玩家数据[玩家id].角色.数据.名称,id=玩家id}
						帮派数据[帮派编号].成员数据[玩家id].职务 = "右护法"
						玩家数据[玩家id].角色:删除称谓(玩家id,帮派数据[帮派编号].帮派名称.."帮众")
						玩家数据[玩家id].角色:添加称谓(玩家id,帮派数据[帮派编号].帮派名称.."右护法")


						常规提示(玩家id,"#Y/你已经被任命为右护法！")
						常规提示(id,"#Y/任命成功！")
						广播帮派消息({内容="[帮派总管]#G/ "..玩家数据[id].角色.数据.名称.." #Y/将委任 #P/"..玩家数据[玩家id].角色.数据.名称.." 为新的右护法！",频道="bp"},帮派编号)
					else
						常规提示(玩家id,"#Y/本帮已经拥有一位右护法了，请先解除对方的职务！")
					end
				end
			elseif 事件 == "长老" then
				if 管理权限 < 3 then
					常规提示(id,"#Y/你没有足够的权限！")
					return 0
				end
				if 帮派数据[帮派编号].长老 == nil then
					帮派数据[帮派编号].长老 = {}
				end
				if #帮派数据[帮派编号].长老 >= 4 then
					常规提示(id,"#Y/本帮已经存在4位长老,无法任命更多的长老了！")
					return 0
				else
					帮派数据[帮派编号].长老[#帮派数据[帮派编号].长老+1] = {名称=玩家数据[玩家id].角色.数据.名称,id=玩家id}
					玩家数据[玩家id].角色.数据.帮派数据.权限 = 2
					常规提示(玩家id,"#Y/你已经被任命为帮派长老！")
					帮派数据[帮派编号].成员数据[玩家id].职务 = "长老"
					玩家数据[玩家id].角色:删除称谓(玩家id,帮派数据[帮派编号].帮派名称.."帮众")
					玩家数据[玩家id].角色:添加称谓(玩家id,帮派数据[帮派编号].帮派名称.."长老")

					常规提示(id,"#Y/任命成功！")
					广播帮派消息({内容="[帮派总管]#G/ "..玩家数据[id].角色.数据.名称.." #Y/将委任 #P/"..玩家数据[玩家id].角色.数据.名称.." 为新的长老！",频道="bp"},帮派编号)
				end
			elseif 事件 == "堂主" then
				if 管理权限 < 2 then
					常规提示(id,"#Y/你没有足够的权限！")
					return 0
				end
				if 帮派数据[帮派编号].堂主 == nil then
					帮派数据[帮派编号].堂主 = {}
				end
				if #帮派数据[帮派编号].堂主 >= 4 then
					常规提示(id,"#Y/本帮已经存在4位堂主,无法任命更多的堂主了！")
					return 0
				else
					帮派数据[帮派编号].堂主[#帮派数据[帮派编号].堂主+1] = {名称=玩家数据[玩家id].角色.数据.名称,id=玩家id}
					玩家数据[玩家id].角色.数据.帮派数据.权限 = 1
					帮派数据[帮派编号].成员数据[玩家id].职务 = "堂主"
					玩家数据[玩家id].角色:删除称谓(玩家id,帮派数据[帮派编号].帮派名称.."帮众")
					玩家数据[玩家id].角色:添加称谓(玩家id,帮派数据[帮派编号].帮派名称.."堂主")

					常规提示(玩家id,"#Y/你已经被任命为帮派堂主！")
					常规提示(id,"#Y/任命成功！")
					广播帮派消息({内容="[帮派总管]#G/ "..玩家数据[id].角色.数据.名称.." #Y/将委任 #P/"..玩家数据[玩家id].角色.数据.名称.." 为新的堂主！",频道="bp"},帮派编号)
				end

			elseif 事件 == "商人" then
					if 管理权限 < 2 then
						常规提示(id,"#Y/你没有足够的权限！")
						return 0
					end
					if 帮派数据[帮派编号].商人 == nil then
						帮派数据[帮派编号].商人 = {}
					end
					-- 0914 不限制帮派跑商人数
					if #帮派数据[帮派编号].商人 >= 100 then
						常规提示(id,"#Y/本帮已经存在100位商人,无法任命更多的商人了！")
						return 0
					else
						帮派数据[帮派编号].商人[#帮派数据[帮派编号].商人+1] = {名称=玩家数据[玩家id].角色.数据.名称,id=玩家id}
						帮派数据[帮派编号].成员数据[玩家id].职务 = "商人"
						玩家数据[玩家id].角色.数据.帮派数据.权限 = 0
						玩家数据[玩家id].角色:删除称谓(玩家id,帮派数据[帮派编号].帮派名称.."帮众")
						玩家数据[玩家id].角色:添加称谓(玩家id,帮派数据[帮派编号].帮派名称.."商人")
						常规提示(id,"#Y/任命成功！")
						广播帮派消息({内容="[帮派总管]#G/ "..玩家数据[id].角色.数据.名称.." #Y/将委任 #P/"..玩家数据[玩家id].角色.数据.名称.." 为商人！",频道="bp"},帮派编号)
					end

			elseif 事件 == "帮众" then
				if 管理权限 < 1 then
					常规提示(id,"#Y/你没有足够的权限！")
					return 0
				end
				if 玩家数据[玩家id].角色.数据.帮派数据.权限+0 >= 5 then
					常规提示(id,"#Y/帮主之位只可以禅让，无法任免！")
					return 0
				end
				if 玩家数据[玩家id].角色.数据.帮派数据.权限+0 == 4 then
					帮派数据[帮派编号].副帮主 = {}
					玩家数据[玩家id].角色:删除称谓(玩家id,帮派数据[帮派编号].帮派名称.."副帮主")
				elseif 玩家数据[玩家id].角色.数据.帮派数据.权限+0 == 3 then
					if 帮派数据[帮派编号].成员数据[玩家id].职务 == "左护法" then
						帮派数据[帮派编号].左护法 = {}
						玩家数据[玩家id].角色:删除称谓(玩家id,帮派数据[帮派编号].帮派名称.."左护法")
					else
						帮派数据[帮派编号].右护法 = {}
						玩家数据[玩家id].角色:删除称谓(玩家id,帮派数据[帮派编号].帮派名称.."右护法")
					end
				elseif 玩家数据[玩家id].角色.数据.帮派数据.权限+0 == 2 then
					for i=1,#帮派数据[帮派编号].长老 do
						if 帮派数据[帮派编号].长老[i] ~= nil then
							if 帮派数据[帮派编号].长老[i].id+0 == 玩家id then
								table.remove(帮派数据[帮派编号].长老,i)
								玩家数据[玩家id].角色:删除称谓(玩家id,帮派数据[帮派编号].帮派名称.."长老")
							end
						end
					end
				elseif 玩家数据[玩家id].角色.数据.帮派数据.权限+0 == 1 then
					for i=1,#帮派数据[帮派编号].堂主 do
						if 帮派数据[帮派编号].堂主[i] ~= nil then
							if 帮派数据[帮派编号].堂主[i].id+0 == 玩家id then
								table.remove(帮派数据[帮派编号].堂主,i)
								玩家数据[玩家id].角色:删除称谓(玩家id,帮派数据[帮派编号].帮派名称.."堂主")
							end
						end
					end
				elseif 帮派数据[帮派编号].成员数据[玩家id].职务 == "商人" then
					for i=1,#帮派数据[帮派编号].商人 do
						if 帮派数据[帮派编号].商人[i] ~= nil then
							if 帮派数据[帮派编号].商人[i].id+0 == 玩家id then
								table.remove(帮派数据[帮派编号].商人,i)
								玩家数据[玩家id].角色:删除称谓(玩家id,帮派数据[帮派编号].帮派名称.."商人")
							end
						end
					end
				end
				玩家数据[玩家id].角色.数据.帮派数据.权限 = 0
				帮派数据[帮派编号].成员数据[玩家id].职务 = "帮众"
				常规提示(id,"#Y/任命成功！")
			end
			玩家数据[玩家id].角色:添加称谓(玩家id,帮派数据[帮派编号].帮派名称.."帮众")
			发送数据(玩家数据[id].连接id,69,{项目 = "1",编号=玩家数据[id].角色.数据.帮派数据.编号,权限=玩家数据[id].角色.数据.帮派数据.权限})
			发送数据(玩家数据[玩家id].连接id,69,{项目 = "1",编号=玩家数据[玩家id].角色.数据.帮派数据.编号,权限=玩家数据[玩家id].角色.数据.帮派数据.权限})
			发送数据(玩家数据[id].连接id,67, {帮派数据[帮派编号]})
		end
	end
end


function 帮派处理类:修改帮派宗旨(id,内容)
	if self:取是否有帮派(id) then
		local 帮派编号 = 玩家数据[id].角色.数据.帮派数据.编号
		if 玩家数据[id].角色.数据.帮派数据.权限 <= 4 then
			发送数据(玩家数据[id].连接id, 7, "#Y/你没有权限修改此项。")
			return 0
		else
			帮派数据[帮派编号].帮派宗旨 = 内容.文本
			发送数据(玩家数据[id].连接id, 7, "#Y/恭喜你修改帮派宗旨成功。")
			广播帮派消息({内容="[帮派总管]#G/ "..玩家数据[id].角色.数据.名称.." #Y/将帮派宗旨修改为: #P/"..内容.文本.."！",频道="bp"},帮派编号)
			发送数据(玩家数据[id].连接id,67, {帮派数据[帮派编号]})
		end
	end
end

function 帮派处理类:取是否有帮派(id)
	if 玩家数据[id].角色.数据.帮派 ~= "无帮派" and 玩家数据[id].角色.数据.帮派数据 ~= nil and 帮派数据[玩家数据[id].角色.数据.帮派数据.编号] ~= nil then

		return true
	else
			发送数据(玩家数据[id].连接id, 7, "#Y/少侠不妨先加入一个帮派。")
	    return false
	end
end

function 帮派处理类:处理申请(id,内容)
	local 帮派编号 = 玩家数据[id].角色.数据.帮派数据.编号
	local 申请信息 = 帮派数据[帮派编号].申请数据
	local 临时申请id = 申请信息[内容.玩家序号].id+0

	if 玩家数据[临时申请id] == nil then
		发送数据(玩家数据[id].连接id, 7, "#Y/该玩家已经下线。")
		table.remove(帮派数据[帮派编号].申请数据, 内容.玩家序号+0)
		return 0
	elseif self:取是否有帮派(临时申请id) then
		table.remove(帮派数据[帮派编号].申请数据, 内容.玩家序号)
		发送数据(玩家数据[id].连接id, 7, "#Y/该玩家已经加入其它帮派。")
		return 0
	elseif 帮派数据[帮派编号].成员数量.当前 +0 >= 150+0 then
		table.remove(帮派数据[帮派编号].申请数据, 内容.玩家序号)
		发送数据(玩家数据[id].连接id, 7, "#Y/帮派成员已达上限")
		return 0
	else
		帮派数据[帮派编号].成员数据[临时申请id] = {帮战积分=玩家数据[临时申请id].角色.数据.帮战积分,帮战次数=玩家数据[临时申请id].角色.数据.帮战次数,名称=玩家数据[临时申请id].角色.数据.名称,账号=玩家数据[临时申请id].角色.数据.账号,门派=玩家数据[临时申请id].角色.数据.门派,等级=玩家数据[临时申请id].角色.数据.等级,所属="无",称谓=玩家数据[临时申请id].角色.数据.当前称谓,职务="帮众",id = 临时申请id,帮贡={当前=0,上限=0},青龙=0,跑商=0,迷宫=0,厢房=0,敌对=0,入帮时间=os.time(),离线时间=os.time(),在线=true}
		玩家数据[临时申请id].角色.数据.帮派 = 帮派数据[帮派编号].帮派名称
		玩家数据[临时申请id].角色.数据.帮派数据 = {编号=帮派编号,权限=0}
		帮派数据[帮派编号].成员数量.当前 = 帮派数据[帮派编号].成员数量.当前+1
		table.remove(帮派数据[帮派编号].申请数据, 内容.玩家序号)
		发送数据(玩家数据[临时申请id].连接id,69,{项目 = "1",编号=帮派编号,权限=0})
		发送数据(玩家数据[临时申请id].连接id, 7, "#Y/恭喜你已经被批准加入帮派,赶快和帮派里的小伙伴打声招呼吧。")
		玩家数据[临时申请id].角色:添加称谓(临时申请id,帮派数据[帮派编号].帮派名称.."帮众")
		广播帮派消息({内容="[帮派总管]#Y/恭喜新的朋友#G/"..玩家数据[临时申请id].角色.数据.名称.."#Y/加入大家庭！",频道="bp"},帮派编号)
		发送数据(玩家数据[id].连接id,67, {帮派数据[帮派编号]})
	end
end
function 帮派处理类:申请帮派(id,内容)
	if 帮派数据[内容.帮派序号] == nil then
		发送数据(玩家数据[id].连接id, 7, "#Y/帮派数据错误请联系管理员。")
		return 0
	elseif 帮派数据[内容.帮派序号].成员数量.当前 >= 帮派数据[内容.帮派序号].成员数量.上限 then
		发送数据(玩家数据[id].连接id, 7, "#Y/该帮派人数已满。")
		return 0
	else
		if 帮派数据[内容.帮派序号].申请数据 == nil then
			帮派数据[内容.帮派序号].申请数据 = {}
			帮派数据[内容.帮派序号].申请数据[#帮派数据[内容.帮派序号].申请数据+1] = {id = id,名称 = 玩家数据[id].角色.数据.名称,等级=玩家数据[id].角色.数据.等级,门派=玩家数据[id].角色.数据.门派}
			发送数据(玩家数据[id].连接id, 7, "#Y/申请帮派成功。")
		else
			for i = 1,#帮派数据[内容.帮派序号].申请数据 do
			    if 帮派数据[内容.帮派序号].申请数据[i].id+0 == id+0 then
			    	发送数据(玩家数据[id].连接id, 7, "#Y/请勿重复申请。")
			    	return 0
			    end
			end
			帮派数据[内容.帮派序号].申请数据[#帮派数据[内容.帮派序号].申请数据+1] = {id = 内容.数字id,名称 = 玩家数据[id].角色.数据.名称,等级=玩家数据[id].角色.数据.等级,门派=玩家数据[id].角色.数据.门派}
			发送数据(玩家数据[id].连接id, 7, "#Y/申请帮派成功。")
		end
		广播帮派消息({内容="[帮派总管]#R/有新的玩家正在申请入帮，请在线管理及时处理！",频道="bp"},内容.帮派序号)
	end
end
function 帮派处理类:加入帮派(id)

	if 玩家数据[id].角色.数据.帮派 ~= "无帮派" and 玩家数据[id].角色.数据.帮派数据 ~= nil and 帮派数据[玩家数据[id].角色.数据.帮派数据.编号] ~= nil then
		发送数据(玩家数据[id].连接id, 7, "#Y/请退出您当前的帮派后再次申请。")
		return 0
	elseif 玩家数据[id].角色.数据.等级 < 30 then
		发送数据(玩家数据[id].连接id, 7, "#Y/加入帮派要求等级大于30级。")
		return 0
	elseif #帮派数据 <= 0 then
		发送数据(玩家数据[id].连接id, 7, "#Y/当前没有可以加入的帮派。")
		return 0
	else

		local 发送信息 = {}
	    for i=1,#帮派数据 do
	    	if 帮派数据[i] ~= nil then
	    		发送信息[#发送信息+1] = {}
	    		发送信息[#发送信息].编号 = i
	    		发送信息[#发送信息].规模 = 帮派数据[i].帮派规模
	    		发送信息[#发送信息].公告 = 帮派数据[i].帮派宗旨
	    		发送信息[#发送信息].帮派名称 = 帮派数据[i].帮派名称
	    		发送信息[#发送信息].创建时间 = os.time()
	    		发送信息[#发送信息].帮派人数 = 帮派数据[i].成员数量
	    		发送信息[#发送信息].帮派费用 = 帮派数据[i].帮派费用
	    		发送信息[#发送信息].管理数据 = {}
	    		发送信息[#发送信息].管理数据.帮主 = {名称=帮派数据[i].现任帮主.名称,是否在线=false}
	    		if 玩家数据[帮派数据[i].现任帮主.id] ~= nil then
	    			发送信息[#发送信息].管理数据.帮主.是否在线 = true
	    		end
	    		if 帮派数据[i].副帮主.名称 ~= nil then
		    		发送信息[#发送信息].管理数据.副帮主 = {名称=帮派数据[i].副帮主.名称,是否在线=false}
		    		if 玩家数据[帮派数据[i].副帮主.id] ~= nil then
		    			发送信息[#发送信息].管理数据.副帮主.是否在线 = true
		    		end
		    	end
		    	if 帮派数据[i].左护法.名称 ~= nil then
		    		发送信息[#发送信息].管理数据.左护法 = {名称=帮派数据[i].左护法.名称,是否在线=false}
		    		if 玩家数据[帮派数据[i].左护法.id] ~= nil then
		    			发送信息[#发送信息].管理数据.左护法.是否在线 = true
		    		end
		    	end
		    	if 帮派数据[i].右护法.名称 ~= nil then
		    		发送信息[#发送信息].管理数据.右护法 = {名称=帮派数据[i].右护法.名称,是否在线=false}
		    		if 玩家数据[帮派数据[i].右护法.id] ~= nil then
		    			发送信息[#发送信息].管理数据.右护法.是否在线 = true
		    		end
		    	end
	    	end
	    end
	    发送数据(玩家数据[id].连接id, 68, 发送信息)
	end

end

function 帮派处理类:回到帮派(id)
	local 队长帮派编号 = 0
	local 队员帮派编号 = 0
	if self:取是否有帮派(id) then
		if 玩家数据[id].队伍==0 then
		else
			local id组 = 取id组(id)
			for n=1,#id组 do
				if 队伍处理类:取是否助战(玩家数据[id].队伍,n) == 0 then
					if 玩家数据[id组[n]].角色.数据.帮派数据~=nil and 玩家数据[id组[n]].角色.数据.帮派数据.编号~=nil then
					    if 取队长权限(id组[n]) then
						    队长帮派编号 = 玩家数据[id组[n]].角色.数据.帮派数据.编号
						else
							队员帮派编号 = 玩家数据[id组[n]].角色.数据.帮派数据.编号
						end
						if 队员帮派编号~=nil and 队员帮派编号~=0 and 队员帮派编号~=队长帮派编号 then
						    发送数据(玩家数据[id].连接id, 7, "#Y/队伍中有不同帮派的玩家，无法传送")
							return 0
						end
					else
						发送数据(玩家数据[id].连接id, 7, "#Y/队伍里有玩家没有帮派哦，无法传送进帮派")
						return 0
					end
				end
			end
		end
		地图处理类:跳转地图(id,1875,44,34)
	else
		发送数据(玩家数据[id].连接id, 7, "#Y/你没有帮派。")
		return 0
	end
end

function 帮派处理类:创建帮派(id,内容)
	if self:取是否有帮派(id) then
		发送数据(玩家数据[id].连接id, 7, "#Y/请退出您当前的帮派后创建。")
		return 0
	elseif 玩家数据[id].角色.数据.等级 < 30 then
		发送数据(玩家数据[id].连接id, 7, "#Y/等级低于30不能创建帮派。")
		return 0
	elseif 帮派数据[10] then
		发送数据(玩家数据[id].连接id, 7, "#Y/本区最多可建立10个帮派,没帮派的请申请建立好的帮派")
		return 0
	-- elseif f函数.读配置(程序目录..[[data\]]..玩家数据[id].账号..[[\账号信息.txt]],"账号配置","仙玉")+0 < 300000000 then
	elseif 取银子(id) < 500000 then
		发送数据(玩家数据[id].连接id, 7, "#Y/你好像没有那么多银子哟，创建帮派需要花费50万银子")
		return 0
	else
		玩家数据[id].角色:扣除银子(500000,0,0,"创建帮派",1)
		帮派数据[#帮派数据+1] =
		{
		    帮战开关 = false,---帮战
		    帮派积分 = 0,---帮战
			帮派名称 = 内容.文本,
			帮派编号 = #帮派数据+1,
			帮派规模 = 1,
			创始人 = {名称=玩家数据[id].角色.数据.名称,id=id},
			成员数量 = {上限=300,当前=1},
			繁荣度 = 2000,
			现任帮主 = {名称=玩家数据[id].角色.数据.名称,id=id},
			副帮主 = {},
			左护法 = {},
			右护法 = {},
			掌控区域 = "无",
			研究力 = 500,
			帮派资金 = {上限=50000000,当前=10000000},
			管辖社区 = "无",
			安定度 = 1000,
			储备金 = 0,
			训练力 = 500,
			人气度 = 1000,
			帮派费用 = 0 ,
			同盟帮派 = "无",
			敌对帮派 = "无",
			行动力 = 500,
			帮派资材 = {上限=500000,当前=5000},
			每周帮费 = {帮费=0},
			帮派宗旨 = "无",
			药品增加量 = 0,
			物价指数 = 1,
			修理指数 = 1,
			守护兽等级 = 1,
			帮派迷宫 = "无",
			当前内政 = "金库",
			当前维护费 = 500000,
			维护时间 = "整点",
			成员数据 = {},
			创建时间 = os.time(),
			申请数据 = {},
			帮派建筑 = {金库={数量=0,当前经验=0},书院={数量=0,当前经验=0},兽室={数量=0,当前经验=0},厢房={数量=0,当前经验=0},药房={数量=0,当前经验=0},仓库={数量=0,当前经验=0}},
			技能数据 = {打造技巧={当前=160,上限=160,当前经验=0},暗器技巧={当前=160,上限=160,当前经验=0},健身术={当前=160,上限=160,当前经验=0},养生之道={当前=160,上限=160,当前经验=0},巧匠之术={当前=160,上限=160,当前经验=0},炼金术={当前=160,上限=160,当前经验=0},裁缝技巧={当前=160,上限=160,当前经验=0},烹饪技巧={当前=160,上限=160,当前经验=0},中药医理={当前=160,上限=160,当前经验=0},冥想={当前=160,上限=160,当前经验=0},强身术={当前=50,上限=160,当前经验=0},强壮={当前=0,上限=160,当前经验=0},神速={当前=0,上限=160,当前经验=0}},
			修炼数据 = {攻击修炼={当前=9,上限=20,当前经验=0},防御修炼={当前=9,上限=20,当前经验=0},法术修炼={当前=9,上限=20,当前经验=0},法抗修炼={当前=9,上限=20,当前经验=0}}
		}
		帮派数据[#帮派数据].成员数据[id] = {帮战积分=玩家数据[id].角色.数据.帮战积分,帮战次数=玩家数据[id].角色.数据.帮战次数,名称=玩家数据[id].角色.数据.名称,门派=玩家数据[id].角色.数据.门派,账号=玩家数据[id].角色.数据.账号,等级=玩家数据[id].角色.数据.等级,所属="无",称谓=玩家数据[id].角色.数据.当前称谓,职务="帮主",id = id,帮贡={当前=0,上限=0},青龙=0,跑商=0,迷宫=0,厢房=0,敌对=0,入帮时间=os.time(),离线时间=os.time(),在线 = true}
		玩家数据[id].角色.数据.帮派 = 内容.文本
		玩家数据[id].角色.数据.帮派数据 = {编号=#帮派数据,权限=5}
		发送数据(玩家数据[id].连接id, 7, "#Y/恭喜你成功创建帮派。")
		玩家数据[id].角色:添加称谓(id,内容.文本.."帮主")
		广播消息({内容=format("#G/"..玩家数据[id].角色.数据.名称.."#R/在帮派关管理员处#Y花费50万银子创建了一个帮派，正在广纳贤才！"),频道="xt"})
        if 成就数据[id].首次创建帮派 == nil then
           成就数据[id].首次创建帮派 = 1
	       成就数据[id].成就点=成就数据[id].成就点+1
	       常规提示(id,"#Y/获得了1点成就点")
	       local 成就提示  = "成为一帮之主"
	       local 成就提示1 = "少侠赶快去广纳贤才吧"
	       发送数据(玩家数据[id].连接id,149,{内容=成就提示,内容1=成就提示1})
       end
	end
end

function 帮派处理类:缴纳帮费(id)
     if self:取是否有帮派(id) then

     end
 	local 帮派编号 = 玩家数据[id].角色.数据.帮派数据.编号
	id = id+0
	   if 帮派数据[玩家数据[id].角色.数据.帮派数据.编号].成员数据[id].职务 == "帮主" then
      常规提示(id,"#Y/帮主交什么帮费,?我行我素还不行?")
      return
  end
  if	玩家数据[id].角色.数据.帮费限时 == nil then
  	玩家数据[id].角色.数据.帮费限时 = os.time()
end
  	   if  玩家数据[id].角色.数据.帮费限时 > os.time()  then
      常规提示(id,"#Y/本周已经交过帮费了少侠!")
      return
  end
if 帮派数据[帮派编号].每周帮费.帮费 == nil then
	帮派数据[帮派编号].每周帮费.帮费 =1
end
   local 帮费费用 = 10000

    if 取银子(id) < 10000 then
    	常规提示(id,"#Y/银子没有10000无法缴纳帮费")
    return
end

        if 帮派缴纳情况[玩家数据[id].角色.数据.帮派数据.编号]==nil then
          帮派缴纳情况[玩家数据[id].角色.数据.帮派数据.编号] = {}
          帮派缴纳情况[玩家数据[id].角色.数据.帮派数据.编号].缴费人数 = 0
          帮派缴纳情况[玩家数据[id].角色.数据.帮派数据.编号].缴费总金额 = 0
          帮派缴纳情况[玩家数据[id].角色.数据.帮派数据.编号].起始时间 = os.time()
        end
        local 扣除帮费 = 帮派数据[帮派编号].每周帮费.帮费
    玩家数据[id].角色:扣除银子(扣除帮费,0,0,"帮费缴纳",1)
    if 玩家数据[id].角色.数据.本周已缴帮费 == nil then
       玩家数据[id].角色.数据.本周已缴帮费 = false
   end

    if 玩家数据[id].角色.数据.帮费限时 == nil then
       玩家数据[id].角色.数据.帮费限时 = os.time()
    end
    玩家数据[id].角色.数据.本周已缴帮费 = true
    玩家数据[id].角色.数据.帮费限时 = os.time()+604800
    常规提示(id,"#Y/成功缴纳帮费，每周都需要缴纳帮费哦~")
   帮派缴纳情况[玩家数据[id].角色.数据.帮派数据.编号].缴费人数 = 帮派缴纳情况[玩家数据[id].角色.数据.帮派数据.编号].缴费人数+1
   帮派缴纳情况[玩家数据[id].角色.数据.帮派数据.编号].缴费总金额 = 帮派缴纳情况[玩家数据[id].角色.数据.帮派数据.编号].缴费总金额+扣除帮费
   帮派缴纳情况[玩家数据[id].角色.数据.帮派数据.编号].起始时间 =帮派缴纳情况[玩家数据[id].角色.数据.帮派数据.编号].起始时间+100
   帮派缴纳情况[玩家数据[id].角色.数据.帮派数据.编号].所在帮派 = 玩家数据[id].角色.数据.帮派数据.编号


end

function 帮派处理类:设置帮费(id,内容)
	if self:取是否有帮派(id) then
		local 帮派编号 = 玩家数据[id].角色.数据.帮派数据.编号
		if 玩家数据[id].角色.数据.帮派数据.权限 <= 4 then
			发送数据(玩家数据[id].连接id, 7, "#Y/你没有权限修改此项。")
			return 0
		else
			帮派数据[帮派编号].每周帮费.帮费 = 内容.文本
			发送数据(玩家数据[id].连接id, 7, "#Y/恭喜你修改帮费成功。")
			广播帮派消息({内容="[帮派总管]#G/ "..玩家数据[id].角色.数据.名称.." #Y/将每周帮费修改为: #P/"..内容.文本.."！",频道="bp"},帮派编号)
			-- 发送数据(玩家数据[id].连接id,67, {帮派数据[帮派编号]})
		end
	end
end

function 帮派处理类:领取帮费(id,玩家id)

	-- local 领取帮费 = 帮派缴纳情况[id].缴费总金额
	local 角色数据 = 读入文件([[data/]]..玩家数据[id].账号..[[/]]..id..[[/角色.txt]])
   	角色数据 = table.loadstring(角色数据)
   -- if	角色数据.帮派数据.权限 == 5 then
   -- 	角色数据.帮派数据.权限 = 现任帮主
   -- end
   -- if 帮派缴纳情况[玩家数据[id].角色.数据.帮派数据.编号] ~= 角色数据.帮派数据.编号 then
-- 常规提示(id,"#Y/不是帮主领个毛")
	if 角色数据.帮派数据.权限 == 5 then

    玩家数据[id].角色.数据.银子 =玩家数据[id].角色.数据.银子 + 帮派缴纳情况[玩家数据[id].角色.数据.帮派数据.编号].缴费总金额
    帮派缴纳情况[玩家数据[id].角色.数据.帮派数据.编号].缴费总金额 = 帮派缴纳情况[玩家数据[id].角色.数据.帮派数据.编号].缴费总金额-帮派缴纳情况[玩家数据[id].角色.数据.帮派数据.编号].缴费总金额
else
	常规提示(id,"#Y/不是帮主领个毛")
-- end
end
end
-- function 帮派处理类:帮派规模提升(id)
-- 	local 帮派编号 = 玩家数据[id].角色.数据.帮派数据.编号
-- local 帮费缴纳 =100000
-- local 帮费缴纳时间=玩家数据[id].角色.数据.帮派数据.编号.帮费缴纳时间
--   if 帮费缴纳时间 == nil then
--     帮费缴纳时间 =  os.time()+7200--172800
--   else
--     帮费缴纳时间 =  os.time()+限用时间
--   end
--         if 玩家数据[id].角色.数据.帮派数据.编号.帮费缴纳 == nil then
--            玩家数据[id].角色.数据.帮派数据.编号.帮费缴纳 =0
--            return 常规提示(id,"#Y/请先激活月卡在来领取")
--         end
--         if 帮费缴纳数据[id] == nil then
--            帮费缴纳数据[id] = false
--         end


--         elseif 玩家数据[id].角色.数据.帮派数据.编号.帮费缴纳 - os.time == true then

--            帮费缴纳数据[id] =true
--            玩家数据[id].角色.数据.月卡领取 =  玩家数据[id].角色.数据.月卡领取 - 1
--            写出文件([[tysj/月卡数据.txt]],table.tostring(月卡数据))
--            return 常规提示(id,"#Y/附魔宝珠-动物套")
--         end
-- 	end
-- end
-- function 帮派处理类:检测缴纳帮费是否成功(id)

--         if 帮费缴纳数据[id] == false then
--         常规提示(id,"#Y/您本周没有缴纳帮派,请缴纳帮费！")
--         return
-- else
--         seif:回到帮派(id)
-- end
function 帮派处理类:更新(dt)end

function 帮派处理类:显示()end

return 帮派处理类