--Utilities to be added to the core
function Card.IsInMainMZone(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 and (not tp or c:IsControler(tp))
end
function Card.IsInExtraMZone(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:GetSequence()>4 and (not tp or c:IsControler(tp))
end
function GetID()
    local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
    str=string.sub(str,1,string.len(str)-4)
    local scard=_G[str]
    local s_id=tonumber(string.sub(str,2))
    return scard,s_id
end

--workaround for gryphon while update not happen and fix that (credits to cc/l)
local ils = Card.IsLinkState
Card.IsLinkState = function(c)
    return ils(c) or Duel.IsExistingMatchingCard(function(c,tc)return c:IsFaceup() and c:GetLinkedGroup():IsContains(tc) end,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c)
end
function Card.IsFusionSetCard(...)
	local arg = {...}
	return Card.IsSetCard(arg[1],arg[2],nil,SUMMON_TYPE_FUSION,2)
end
function Card.GetFusionSetCard(...)
	local arg = {...}
	return Card.GetSetCard(arg[1],nil,SUMMON_TYPE_FUSION,2)
end
function Card.IsFusionCode(...)
	local arg = {...}
	return Card.IsSummonCode(arg[1],nil,SUMMON_TYPE_FUSION,2,arg[2])
end
function Card.GetFusionCode(...)
	local arg = {...}
	return Card.GetCode(arg[1],nil,SUMMON_TYPE_FUSION,2)
end

function Card.IsLinkSetCard(...)
	local arg = {...}
	return Card.IsSetCard(arg[1],arg[2],nil,SUMMON_TYPE_LINK,2)
end
function Card.GetLinkSetCard(...)
	local arg = {...}
	return Card.GetSetCard(arg[1],nil,SUMMON_TYPE_LINK,2)
end
function Card.IsLinkCode(...)
	local arg = {...}
	return Card.IsSummonCode(arg[1],nil,SUMMON_TYPE_LINK,2,arg[2])
end
function Card.GetLinkCode(...)
	local arg = {...}
	return Card.GetCode(arg[1],nil,SUMMON_TYPE_LINK,2)
end

--Lair of Darkness
function Auxiliary.ReleaseCostFilter(c,f,...)
	return c:IsFaceup() and c:IsReleasable() and c:IsHasEffect(59160188) 
		and (not f or f(c,table.unpack({...})))
end
function Auxiliary.ReleaseCheckSingleUse(sg,tp,exg)
	return #sg-#(sg-exg)<=1
end
function Auxiliary.ReleaseCheckMMZ(sg,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		or sg:IsExists(aux.FilterBoolFunction(Card.IsInMainMZone,tp),1,nil)
end
function Auxiliary.ReleaseCheckTarget(sg,tp,exg,dg)
	return dg:IsExists(aux.TRUE,1,sg)
end
function Auxiliary.RelCheckRecursive(c,tp,sg,mg,exg,mustg,ct,minc,specialchk,...)
	sg:AddCard(c)
	ct=ct+1
	local res=Auxiliary.RelCheckGoal(tp,sg,exg,mustg,ct,minc,specialchk,table.unpack({...})) 
		or (ct<minc and mg:IsExists(Auxiliary.RelCheckRecursive,1,sg,tp,sg,mg,exg,mustg,ct,minc,specialchk,table.unpack({...})))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function Auxiliary.RelCheckGoal(tp,sg,exg,mustg,ct,minc,specialchk,...)
	return ct>=minc and (not specialchk or specialchk(sg,tp,exg,table.unpack({...}))) and sg:Includes(mustg)
end
function Duel.CheckReleaseGroupCost(tp,f,ct,use_hand,specialchk,ex,...)
	local params={...}
	if not ex then ex=Group.CreateGroup() end
	if not specialchk then specialchk=Auxiliary.ReleaseCheckSingleUse else specialchk=Auxiliary.AND(specialchk,Auxiliary.ReleaseCheckSingleUse) end
	local g=Duel.GetReleaseGroup(tp,use_hand)
	if f then
		g=g:Filter(f,ex,table.unpack(params))
	else
		g=g-ex
	end
	local exg=Duel.GetMatchingGroup(Auxiliary.ReleaseCostFilter,tp,0,LOCATION_MZONE,g+ex,f,table.unpack(params))
	local mustg=g:Filter(function(c,tp)return c:IsHasEffect(EFFECT_EXTRA_RELEASE) and c:IsControler(1-tp)end,nil,tp)
	local mg=g+exg
	local sg=Group.CreateGroup()
	return mg:Includes(mustg) and mg:IsExists(Auxiliary.RelCheckRecursive,1,nil,tp,sg,mg,exg,mustg,0,ct,specialchk,table.unpack({...}))
end
function Duel.SelectReleaseGroupCost(tp,f,minc,maxc,use_hand,specialchk,ex,...)
	local params={...}
	if not ex then ex=Group.CreateGroup() end
	if not specialchk then specialchk=Auxiliary.ReleaseCheckSingleUse else specialchk=Auxiliary.AND(specialchk,Auxiliary.ReleaseCheckSingleUse) end
	local g=Duel.GetReleaseGroup(tp,use_hand)
	if f then
		g=g:Filter(f,ex,table.unpack(params))
	else
		g=g-ex
	end
	local exg=Duel.GetMatchingGroup(Auxiliary.ReleaseCostFilter,tp,0,LOCATION_MZONE,g+ex,f,table.unpack(params))
	local mg=g+exg
	local mustg=g:Filter(function(c,tp)return c:IsHasEffect(EFFECT_EXTRA_RELEASE) and c:IsControler(1-tp)end,nil,tp)
	local sg=Group.CreateGroup()
	local cancel=false
	sg:Merge(mustg)
	while #sg<maxc do
		local cg=mg:Filter(Auxiliary.RelCheckRecursive,sg,tp,sg,mg,exg,mustg,#sg,minc,specialchk,table.unpack({...}))
		if #cg==0 then break end
		cancel=#sg>=minc and #sg<=maxc and Auxiliary.RelCheckGoal(tp,sg,exg,mustg,#sg,minc,specialchk,table.unpack({...}))
		local tc=Group.SelectUnselect(cg,sg,tp,cancel,cancel,1,1)
		if not tc then break end
		if #mustg==0 or not mustg:IsContains(tc) then
			if not sg:IsContains(tc) then
				sg=sg+tc
			else
				sg=sg-tc
			end
		end
	end
	if #sg==0 then return sg end
	if #sg~=#(sg-exg) then
		--LoD is reset for the rest of the turn
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		Duel.Hint(HINT_CARD,0,fc:GetCode())
		fc:RegisterFlagEffect(59160188,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
	end
	return sg
end

--Witch's Strike
local ns=Duel.NegateSummon
Duel.NegateSummon=function(g)   
	ns(g)
	local ng = Group.CreateGroup()
	if userdatatype(g) == "Card" then
		if g:IsStatus(STATUS_SUMMON_DISABLED) then ng:AddCard(g) end
	else
		ng = g:Filter(Card.IsStatus,nil,STATUS_SUMMON_DISABLED)
	end
	if #ng>0 then
		Duel.RaiseEvent(ng,EVENT_CUSTOM+101007179,Effect.GlobalEffect(),0,0,0,0)
	end
end

--T.G. Tank Larva
local nt=Card.IsNotTuner
Card.IsNotTuner=function (c,sc,tp)
    local nte = c:GetCardEffect(EFFECT_NONTUNER)
    local val = nte and nte:GetValue() or nil
    if not val or type(val) == 'number' then
        return nt(c,sc,tp)
    else
        return val(c,sc,tp) or not c:IsType(TYPE_TUNER,sc,SUMMON_TYPE_SYNCHRO,tp)
    end
end
