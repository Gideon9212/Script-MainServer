function c900000022.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c900000022.spcon)
	e1:SetOperation(c900000022.spop)
	c:RegisterEffect(e1)
	--Cannot Lose
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DRAW_COUNT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetTargetRange(1,0)
	e2:SetValue(c900000022.dc)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetTargetRange(1,0)
	e3:SetCondition(c900000022.rcon1)
	e3:SetValue(c900000022.val)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCondition(c900000022.rcon2)
	c:RegisterEffect(e4)
	--No Return
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_TO_DECK)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EFFECT_CANNOT_REMOVE) 
	c:RegisterEffect(e7)
	--attack cost
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_ATTACK_COST)
	e8:SetCost(c900000022.atcost)
	e8:SetOperation(c900000022.atop)
	c:RegisterEffect(e8)
	--indes
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e9:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e9)
	--pierce
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e10)
end
function c900000022.spfilter(c)
	return c:GetCode()==170000170 or c:GetCode()==6132
end
function c900000022.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.CheckReleaseGroup(tp,c900000022.spfilter,1,nil)
end
function c900000022.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c900000022.spfilter,1,1,nil)
	Duel.Release(g1,REASON_COST)
	if Duel.GetLP(e:GetHandlerPlayer())==0 then
		Duel.SetLP(e:GetHandlerPlayer(),1)
	end
end
function c900000022.dc(e)
	local tp=e:GetHandler():GetControler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 then
		return 1
		else
		return 0
	end
end
function c900000022.rcon1(e,tp,eg,ep,ev,re,r,rp)
	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_DAMAGE)
	if not ex then
		ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_RECOVER)
		if not ex or not Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_RECOVER) then return false end
		if (cp==tp or cp==PLAYER_ALL) and cv>=Duel.GetLP(tp) then return true end
	else return (cp==tp or cp==PLAYER_ALL) and cv>=Duel.GetLP(tp)
	end
	return false
end
function c900000022.rcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetBattleDamage(tp)>=Duel.GetLP(tp)
end
function c900000022.val(tp)
	if Duel.GetLP(tp)>1 then
		return Duel.GetLP(tp)-1
		else
		return 0
	end
end
function c900000022.atcost(e,c,tp)
	return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=10
end
function c900000022.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,10,REASON_COST)
end