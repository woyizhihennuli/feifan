-- @Author: baidwwy
-- @Date:   2024-01-13 22:20:01
-- @Last Modified by:   baidwwy
-- @Last Modified time: 2024-01-22 16:51:52
--======================================================================--
--	☆ 作者：飞蛾扑火 QQ：1415559882
--======================================================================--
local floor = math.floor
local ceil  = math.ceil
local jnsss = require("script/角色处理类/技能类")
local insert = table.insert
local cfs    = 删除重复
local rand   = 取随机小数
local 五行_ = {"金","木","水","火","土"}
local 内存类_坐骑 = class()

function 内存类_坐骑:初始化()
	self.参战等级 = 0
	self.等级 = 0
	self.名称 = 0
	self.模型 = 0
	self.气血 = 0
	self.魔法 = 0
	self.攻击 = 0
	self.防御 = 0
	self.速度 = 0
	self.灵力 = 0
	self.体质 = 0
	self.魔力 = 0
	self.力量 = 0
	self.耐力 = 0
	self.敏捷 = 0
	self.潜力 = 5
	self.认证码 = ""
	self.忠诚 = 100
	self.修炼 = {攻击修炼={0,0},法术修炼={0,0},防御修炼={0,0},抗法修炼={0,0},速度修炼={0,0}}
	self.成长 = 0
	self.装备 = {}
	self.技能 = {}
	self.种类 = ""
	self.五行 = 0
	self.饰品 = nil
	self.饰品2 = nil
	self.双五行 = 0
	self.染色组 = 0
	self.染色方案 = nil
	self.参战信息 = nil
	self.战斗技能 = {}
	self.坐骑装备属性 = {
		气血 = 0,
		魔法 = 0,
		命中 = 0,
		伤害 = 0,
		防御 = 0,
		速度 = 0,
		躲避 = 0,
		灵力 = 0,
		体质 = 0,
		魔力 = 0,
		力量 = 0,
		耐力 = 0,
		敏捷 = 0,
		元宵 = 0,
	}
	self.当前经验 = 0
	self.最大经验 = 0
	self.最大气血 = 0
	self.最大魔法 = 0
	self.攻击资质 = 0
	self.防御资质 = 0
	self.体力资质 = 0
	self.法力资质 = 0
	self.速度资质 = 0
	self.躲闪资质 = 0
	self.寿命 = 0
	self.自动 = nil
	self.默认技能 = nil
	self.技能点 = 0
end

function 内存类_坐骑:穿戴装备(装备,格子)
	if 装备.气血 ~= nil then
		self.坐骑装备属性.气血 = self.坐骑装备属性.气血 + 装备.气血
	end
	if 装备.魔法 ~= nil then
		self.坐骑装备属性.魔法 = self.坐骑装备属性.魔法 +  装备.魔法
	end
	if 装备.命中 ~= nil then
		self.坐骑装备属性.命中 = self.坐骑装备属性.命中 +  装备.命中
	end
	if 装备.伤害 ~= nil then
		self.坐骑装备属性.伤害 = self.坐骑装备属性.伤害 +  装备.伤害
	end
	if 装备.防御 ~= nil then
		self.坐骑装备属性.防御 = self.坐骑装备属性.防御 + 装备.防御
	end
	if 装备.速度 ~= nil then
		self.坐骑装备属性.速度 = self.坐骑装备属性.速度 +  装备.速度
	end
	if 装备.躲避 ~= nil then
		self.坐骑装备属性.躲避 = self.坐骑装备属性.躲避 +  装备.躲避
	end
	if 装备.灵力 ~= nil then
		self.坐骑装备属性.灵力 = self.坐骑装备属性.灵力 +  装备.灵力
	end
	if 装备.体质 ~= nil then
		self.坐骑装备属性.体质 = self.坐骑装备属性.体质 + self.坐骑装备属性.体质
	end
	if 装备.魔力 ~= nil then
		self.坐骑装备属性.魔力 = self.坐骑装备属性.魔力 + self.坐骑装备属性.魔力
	end
	if 装备.力量 ~= nil then
		self.坐骑装备属性.力量 = self.坐骑装备属性.力量 + self.坐骑装备属性.力量
	end
	if 装备.耐力 ~= nil then
		self.坐骑装备属性.耐力 = self.坐骑装备属性.耐力 + self.坐骑装备属性.耐力
	end
	if 装备.敏捷 ~= nil then
		self.坐骑装备属性.敏捷 = self.坐骑装备属性.敏捷 + self.坐骑装备属性.敏捷
	end
	self.装备[格子] = 装备
	if 装备.套装效果 ~= nil then
		local sl = {}
		local ab = true
		self.套装 = self.套装 or {}
		for i=1,#self.套装 do
			if self.套装[i][1] == 装备.套装效果[1] and self.套装[i][2] == 装备.套装效果[2] then
				local abc = false
				local abd = true
				for s=1,#self.套装[i][4] do
					if self.套装[i][4][s] == 格子 then
					    abd = false
					    break
					end
				end
				if abd then
					insert(self.套装[i][4],格子)
					abc = true
				end
				if abc then
					self.套装[i][3] = (self.套装[i][3] or 0) + 1
				end
				ab = false
				break
			end
		end
		if ab then
			insert(self.套装,{装备.套装效果[1],装备.套装效果[2],1,{格子}})
		end
	end
	self:刷新信息()
end

function 内存类_坐骑:卸下装备(装备,格子)
	if 装备.气血 ~= nil then
		self.坐骑装备属性.气血 = self.坐骑装备属性.气血 - 装备.气血
	end
	if 装备.魔法 ~= nil then
		self.坐骑装备属性.魔法 = self.坐骑装备属性.魔法 -  装备.魔法
	end
	if 装备.命中 ~= nil then
		self.坐骑装备属性.命中 = self.坐骑装备属性.命中 -  装备.命中
	end
	if 装备.伤害 ~= nil then
		self.坐骑装备属性.伤害 = self.坐骑装备属性.伤害 -  装备.伤害
	end
	if 装备.防御 ~= nil then
		self.坐骑装备属性.防御 = self.坐骑装备属性.防御 - 装备.防御
	end
	if 装备.速度 ~= nil then
		self.坐骑装备属性.速度 = self.坐骑装备属性.速度 -  装备.速度
	end
	if 装备.躲避 ~= nil then
		self.坐骑装备属性.躲避 = self.坐骑装备属性.躲避 -  装备.躲避
	end
	if 装备.灵力 ~= nil then
		self.坐骑装备属性.灵力 = self.坐骑装备属性.灵力 -  装备.灵力
	end
	if 装备.体质 ~= nil then
		self.坐骑装备属性.体质 = self.坐骑装备属性.体质 - self.坐骑装备属性.体质
	end
	if 装备.魔力 ~= nil then
		self.坐骑装备属性.魔力 = self.坐骑装备属性.魔力 - self.坐骑装备属性.魔力
	end
	if 装备.力量 ~= nil then
		self.坐骑装备属性.力量 = self.坐骑装备属性.力量 - self.坐骑装备属性.力量
	end
	if 装备.耐力 ~= nil then
		self.坐骑装备属性.耐力 = self.坐骑装备属性.耐力 - self.坐骑装备属性.耐力
	end
	if 装备.敏捷 ~= nil then
		self.坐骑装备属性.敏捷 = self.坐骑装备属性.敏捷 - self.坐骑装备属性.敏捷
	end
	self.装备[格子] = nil
	self:刷新信息()
end

function 内存类_坐骑:置新对象(模型,名称,类型,属性,等级,染色方案,技能组,资质组,成长,参战等级,属性表,id)
	local n = 全局坐骑资料:取坐骑(模型)
	if n[1] == nil or 属性表 ~= nil then
		self.模型 = 模型
		self.等级 = 等级 or 0
		self.种类 = 类型
		self.名称 = 名称 or 模型
		资质组 = 资质组 or {0,0,0,0,0,0}
		self.攻击资质 = 资质组[1]
		self.防御资质 = 资质组[2]
		self.体力资质 = 资质组[3]
		self.法力资质 = 资质组[4]
		self.速度资质 = 资质组[5]
		self.躲闪资质 = 资质组[6]
		self.技能 = 技能组 or {}
		self.成长 = 成长 or 0
		self.参战等级 = 参战等级 or 0
		self.五行 = 五行_[取随机数(1,5)]
		if 类型 == "神兽" or 类型 == "宝宝" or 类型 == "野怪" or 类型 == "变异" or 类型 == "孩子" then
		    self.内丹 = {内丹上限=6,可用内丹=6}
		else
			self.内丹 = {内丹上限=floor(self.参战等级 / 35)+1,可用内丹=floor(self.参战等级 / 35)+1}
		end
		for m=1,#self.技能 do
			local w = self.技能[m]
			self.技能[m] = jnsss()
			self.技能[m]:置对象(w,2)
		end
		属性表 = 属性表 or {0,0,0,0,0,0}
		self.忠诚 = 属性表[1]
		self.体质 = 属性表[2]
		self.魔力 = 属性表[3]
		self.力量 = 属性表[4]
		self.耐力 = 属性表[5]
		self.敏捷 = 属性表[6]
		if 属性表 ~= nil then
			self:刷新信息("1")
		end
		return
	end
	等级 = 等级 or 0
	local 波动上限 = 1
	local 能力 = 0
	local 五维总值 = 0
	类型 = "坐骑"
	if 属性 == nil then
		属性 = 50 + 等级 * 5
	end
	self.模型 = 模型
	self.种类 = 类型
	if 类型 == "坐骑" then
		能力 = 0.925
		五维总值 = 属性
		self.忠诚 = 100
		self.体质 = 10
		self.魔力 = 10
		self.力量 = 10
		self.耐力 = 10
		self.敏捷 = 10
	end
	self.名称 = 名称 or 模型
	self.认证码 =id.."_"..os.time().."_"..取随机数(1000,9999999).."_"..随机序列
	self.参战等级 = n[1]
	self.攻击资质= ceil(n[2]*rand(能力,波动上限))
	self.防御资质= ceil(n[3]*rand(能力,波动上限))
	self.体力资质= ceil(n[4]*rand(能力,波动上限))
	self.法力资质= ceil(n[5]*rand(能力,波动上限))
	self.速度资质= ceil(n[6]*rand(能力,波动上限))
	self.躲闪资质= ceil(n[7]*rand(能力,波动上限))
	self.寿命= n[10]
	local jn = n[9]
	local jn0 = {}
	local cz1 = 取随机数(1,100)
	if cz1 < 30 then
		self.成长 = n[8][1]
	elseif cz1 > 30  and cz1 < 60 then
		self.成长 = n[8][2]
	elseif cz1 > 60  and cz1 < 80 then
		self.成长 = n[8][3]
	elseif cz1 > 80  and cz1 < 95 then
		self.成长 = n[8][4]
	elseif cz1 > 95  and cz1 < 100 then
		self.成长 = n[8][5]
	end
	if self.成长 == 0 then
		self.成长 = n[8][1]
	end
	for q=1,#jn do
		insert(jn0, jn[取随机数(1,#jn)])
	end
	self.技能={}
	jn0 = cfs(技能组 or jn0)
	for j=1,#jn0 do
		self.技能[j] = jn0[j]
	end
	for m=1,#self.技能 do
		local w = self.技能[m]
	--	self.技能[m] = jnsss()
	--	self.技能[m]:置对象(w,2)
	end
	self.五行 = 五行_[取随机数(1,5)]
	if n.染色方案 ~= nil then
		self.染色方案 = n.染色方案
		self.染色组 = {1,0}
	end
	if 染色方案 ~= nil then
		self.染色方案 = 染色方案[1]
		self.染色组 = 染色方案[2]
	end
	if 类型 == "神兽" or 类型 == "宝宝" or 类型 == "野怪" or 类型 == "变异" or 类型 == "孩子" then
	    self.内丹 = {内丹上限=6,可用内丹=6}
	else
		self.内丹 = {内丹上限=floor(self.参战等级 / 35)+1,可用内丹=floor(self.参战等级 / 35)+1}
	end
	self.种类 = 类型
	self:刷新信息("1")
end

function 内存类_坐骑:置新对象1(模型,名称,类型,属性,等级,染色方案,技能组,资质组,成长,参战等级,属性表,id)
	local n = 全局坐骑资料:取坐骑123(模型)
	if n[1] == nil or 属性表 ~= nil then
		self.模型 = 模型
		self.等级 = 等级 or 0
		self.种类 = 类型
		self.名称 = 名称 or 模型
		资质组 = 资质组 or {0,0,0,0,0,0}
		self.攻击资质 = 资质组[1]
		self.防御资质 = 资质组[2]
		self.体力资质 = 资质组[3]
		self.法力资质 = 资质组[4]
		self.速度资质 = 资质组[5]
		self.躲闪资质 = 资质组[6]
		self.技能 = 技能组 or {}
		self.成长 = 成长 or 0
		self.参战等级 = 参战等级 or 0
		self.五行 = 五行_[取随机数(1,5)]
		if 类型 == "神兽" or 类型 == "宝宝" or 类型 == "野怪" or 类型 == "变异" or 类型 == "孩子" then
		    self.内丹 = {内丹上限=6,可用内丹=6}
		else
			self.内丹 = {内丹上限=floor(self.参战等级 / 35)+1,可用内丹=floor(self.参战等级 / 35)+1}
		end
		for m=1,#self.技能 do
			local w = self.技能[m]
			self.技能[m] = jnsss()
			self.技能[m]:置对象(w,2)
		end
		属性表 = 属性表 or {0,0,0,0,0,0}
		self.忠诚 = 属性表[1]
		self.体质 = 属性表[2]
		self.魔力 = 属性表[3]
		self.力量 = 属性表[4]
		self.耐力 = 属性表[5]
		self.敏捷 = 属性表[6]
		if 属性表 ~= nil then
			self:刷新信息("1")
		end
		return
	end
	等级 = 等级 or 0
	local 波动上限 = 1
	local 能力 = 0
	local 五维总值 = 0
	类型 = "坐骑"
	if 属性 == nil then
		属性 = 50 + 等级 * 5
	end
	self.模型 = 模型
	self.种类 = 类型
	if 类型 == "坐骑" then
		能力 = 0.925
		五维总值 = 属性
		self.忠诚 = 100
		self.体质 = 10
		self.魔力 = 10
		self.力量 = 10
		self.耐力 = 10
		self.敏捷 = 10
	end
	self.名称 = 名称 or 模型
	self.认证码 =id.."_"..os.time().."_"..取随机数(1000,9999999).."_"..随机序列
	self.参战等级 = n[1]
	self.攻击资质= ceil(n[2]*rand(能力,波动上限))
	self.防御资质= ceil(n[3]*rand(能力,波动上限))
	self.体力资质= ceil(n[4]*rand(能力,波动上限))
	self.法力资质= ceil(n[5]*rand(能力,波动上限))
	self.速度资质= ceil(n[6]*rand(能力,波动上限))
	self.躲闪资质= ceil(n[7]*rand(能力,波动上限))
	self.寿命= n[10]
	local jn = n[9]
	local jn0 = {}
	local cz1 = 取随机数(1,100)
	if cz1 < 20 then
		self.成长 = n[8][1]
	elseif cz1 > 20  and cz1 < 40 then
		self.成长 = n[8][2]
	elseif cz1 > 40  and cz1 < 60 then
		self.成长 = n[8][3]
	elseif cz1 > 60  and cz1 < 80 then
		self.成长 = n[8][4]
	elseif cz1 > 80  and cz1 < 100 then
		self.成长 = n[8][5]
	end
	if self.成长 == 0 then
		self.成长 = n[8][1]
	end
	for q=1,#jn do
		insert(jn0, jn[取随机数(1,#jn)])
	end
	self.技能={}
	jn0 = cfs(技能组 or jn0)
	for j=1,#jn0 do
		self.技能[j] = jn0[j]
	end
	for m=1,#self.技能 do
		local w = self.技能[m]
	--	self.技能[m] = jnsss()
	--	self.技能[m]:置对象(w,2)
	end
	self.五行 = 五行_[取随机数(1,5)]
	if n.染色方案 ~= nil then
		self.染色方案 = n.染色方案
		self.染色组 = {1,0}
	end
	if 染色方案 ~= nil then
		self.染色方案 = 染色方案[1]
		self.染色组 = 染色方案[2]
	end
	if 类型 == "神兽" or 类型 == "宝宝" or 类型 == "野怪" or 类型 == "变异" or 类型 == "孩子" then
	    self.内丹 = {内丹上限=6,可用内丹=6}
	else
		self.内丹 = {内丹上限=floor(self.参战等级 / 35)+1,可用内丹=floor(self.参战等级 / 35)+1}
	end
	self.种类 = 类型
	self:刷新信息("1")
end
function 内存类_坐骑:升级()
	self.等级 = self.等级 + 1
	self.体质 = self.体质 + 1
	self.魔力 = self.魔力 + 1
	self.力量 = self.力量 + 1
	self.耐力 = self.耐力 + 1
	self.敏捷 = self.敏捷 + 1
	self.潜力 = self.潜力 + 5
	self.当前经验 = self.当前经验 - self.最大经验
	self:刷新信息("1")
end

function 内存类_坐骑:降级(级数)
	self.等级 = self.等级 - 级数
	self.体质 = self.体质 - 级数
	self.魔力 = self.魔力 - 级数
	self.力量 = self.力量 - 级数
	self.耐力 = self.耐力 - 级数
	self.敏捷 = self.敏捷 - 级数
	self.潜力 = self.潜力 - 级数 * 5
	self:刷新信息("1")
end

function 内存类_坐骑:添加技能(名称)
	local jn = jnsss()
	jn:置对象(名称)
	self.技能[#self.技能+1] = jn
end

function 内存类_坐骑:替换技能(名称)
	local jn = jnsss()
	jn:置对象(名称)
	self.技能[取随机数(1,#self.技能)] = jn
end

function 内存类_坐骑:取差异属性(sxb)
	local sx1 = self.最大气血
	local sx2 = self.最大魔法
	local sx3 = self.伤害
	local sx4 = self.防御
	local sx5 = self.速度
	local sx6 = self.灵力
	local 体质 = self.体质 + self.坐骑装备属性.体质 + sxb.体质
	local 魔力 = self.魔力 + self.坐骑装备属性.魔力 + sxb.魔力
	local 力量 = self.力量 + self.坐骑装备属性.力量 + sxb.力量
	local 耐力 = self.耐力 + self.坐骑装备属性.耐力 + sxb.耐力
	local 敏捷 = self.敏捷 + self.坐骑装备属性.敏捷 + sxb.敏捷
	local 最大气血 = ceil(self.等级*self.体力资质/1000+体质*self.成长*6) + self.坐骑装备属性.气血
	local 最大魔法 = ceil(self.等级*self.法力资质/500+魔力*self.成长*3) + self.坐骑装备属性.魔法
	local 伤害1 = ceil(self.等级*self.攻击资质*(self.成长+1.4)/750+力量*self.成长) + self.坐骑装备属性.伤害
	local 防御1 = ceil(self.等级*self.防御资质*(self.成长+1.4)/1143+耐力*(self.成长-1/253)*253/190)+ self.坐骑装备属性.防御
	local 速度1 = ceil(self.速度资质 * 敏捷/1000)  + self.坐骑装备属性.速度
	local 灵力1 = ceil(self.等级*(self.法力资质+1666)/3333+魔力*0.7+力量*0.4+体质*0.3+耐力*0.2) + self.坐骑装备属性.灵力
	return {气血=最大气血-sx1,魔法=最大魔法-sx2,伤害=伤害1-sx3,防御=防御1-sx4,速度=速度1-sx5,灵力=灵力1-sx6}
end

function 内存类_坐骑:刷新信息(是否,体质,魔力)
	self.体质 = self.体质 + self.坐骑装备属性.体质
	self.魔力 = self.魔力 + self.坐骑装备属性.魔力
	self.力量 = self.力量 + self.坐骑装备属性.力量
	self.耐力 = self.耐力 + self.坐骑装备属性.耐力
	self.敏捷 = self.敏捷 + self.坐骑装备属性.敏捷
	self.最大气血 = ceil(self.等级*self.体力资质/1000+self.体质*self.成长*6) + self.坐骑装备属性.气血
	self.最大魔法 = ceil(self.等级*self.法力资质/500+self.魔力*self.成长*3) + self.坐骑装备属性.魔法
	self.伤害 = ceil(self.等级*self.攻击资质*(self.成长+1.4)/750+self.力量*self.成长) + self.坐骑装备属性.伤害
	self.防御 = ceil(self.等级*self.防御资质*(self.成长+1.4)/1143+self.耐力*(self.成长-1/253)*253/190)+ self.坐骑装备属性.防御
	self.速度 = ceil(self.速度资质 * self.敏捷/1000)  + self.坐骑装备属性.速度
	self.灵力 = ceil(self.等级*(self.法力资质+1666)/3333+self.魔力*0.7+self.力量*0.4+self.体质*0.3+self.耐力*0.2) + self.坐骑装备属性.灵力
	if 是否 == "1" then
		self.气血 = self.最大气血
		self.魔法 = self.最大魔法
	end
	if 体质 ~= nil and 体质 > 0 then
		self.气血 = self.最大气血
	end
	if 魔力 ~= nil and 魔力 > 0 then
		self.魔法 = self.最大魔法
	end
	self.气血 = self.气血
	self.最大气血 = self.最大气血
	if self.气血 > self.最大气血 then
		self.气血 = self.最大气血 - self.气血 + self.气血
	end
	self.魔法 = self.魔法
	self.最大魔法 = self.最大魔法
	if self.魔法 > self.最大魔法 then
		self.魔法 = self.最大魔法 - self.魔法 + self.魔法
	end
	self.等级 = self.等级
	if self.等级 <= 175 then
		self.最大经验 = self:取经验(2,self.等级)
	end
end

function 内存类_坐骑:取经验(id,lv)
	local exp={}
	if id==1 then
		exp={
			40,110,237,450,779,1252,1898,2745,3822,5159,6784,8726,11013,13674,16739,20236,24194,28641,33606,39119,45208,
			51902,55229,67218,75899,85300,95450,106377,118110,130679,144112,158438,173685,189882,207059,225244,244466,264753,
			286134,308639,332296,357134,383181,410466,439019,468868,500042,532569,566478,601799,638560,676790,716517,757770,
			800579,844972,890978,938625,987942,1038959,1091704,1146206,1202493,1260594,1320539,1382356,1446074,1511721,1579326,
			1648919,1720528,1794182,1869909,1947738,2027699,2109820,2194130,2280657,2369431,2460479,2553832,2649518,2747565,
			2848003,2950859,3056164,3163946,3274233,3387055,3502439,3620416,3741014,3864261,3990187,4118819,4250188,4384322,
			4521249,4660999,4803599,4998571,5199419,5406260,5619213,5838397,6063933,6295941,6534544,6779867,7032035,7291172,
			7557407,7830869,8111686,8399990,8695912,8999586,9311145,9630726,9958463,10294496,10638964,10992005,11353761,11724374,
			12103988,12492748,12890799,13298287,13715362,14142172,14578867,15025600,15482522,15949788,16427552,16915970,17415202,
			17925402,18446732,18979354,19523428,20079116,20646584,21225998,43635044,44842648,46075148,47332886,48616200,74888148,
			76891401,78934581,81018219,83142835,85308969,87977421,89767944,92061870,146148764,150094780,154147340,158309318,
			162583669,166973428,171481711,176111717,180866734,185780135,240602904,533679362,819407100,1118169947, 1430306664,
			1756161225,2096082853
		}
	else
		exp={
			50,200,450,800,1250,1800,2450,3250,4050,5000,6050,7200,8450,9800,11250,12800,14450,16200,18050,20000,22050,24200,
			26450,28800,31250,33800,36450,39200,42050,45000,48050,51200,54450,57800,61250,64800,68450,72200,76050,80000,84050,
			88200,92450,96800,101250,105800,110450,115200,120050,125000,130050,135200,140450,145800,151250,156800,162450,
			168200,174050,180000,186050,192200,198450,204800,211250,217800,224450,231200,238050,245000,252050,259200,266450,
			273800,281250,288800,296450,304200,312050,320000,328050,336200,344450,352800,361250,369800,378450,387200,396050,
			405000,414050,423200,432450,441800,451250,460800,470450,480200,490050,500000,510050,520200,530450,540800,551250,
			561800,572450,583200,594050,605000,616050,627200,638450,649800,661250,672800,684450,696200,708050,720000,732050,
			744200,756450,768800,781250,793800,806450,819200,832050,845000,858050,871200,884450,897800,911250,924800,938450,
			952200,966050,980000,994050,1008200,1022450,1036800,1051250,1065800,1080450,1095200,1110050,1125000,1140050,1155200,
			1170450,1185800,1201250,1216800,1232450,1248200,1264050,1280000,1300000,1340000,1380000,1420000,1460000,1500000,1540000,
			1580000,1700000,1780000,1820000,1940000,2400000,2880000,3220000,4020000,4220000,4420000,4620000,5220000,5820000,6220000,
			7020000,8020000,9020000
		}
	end
	return exp[lv+1]
end

return 内存类_坐骑