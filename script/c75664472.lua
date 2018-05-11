--heartstone field
function c75664472.initial_effect(c)
	c:EnableCounterPermit(0xed)
	c:EnableCounterPermit(0xee)
	c:EnableCounterPermit(0xef)
	c:EnableCounterPermit(0xfa)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
	e1:SetCondition(c75664472.ctcon)
	e1:SetOperation(c75664472.ctop)
	c:RegisterEffect(e1)
	--indes battle
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--avoid battle damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_FZONE)
	e4:SetOperation(c75664472.desop)
	c:RegisterEffect(e4)
	--reduce def
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCode(EVENT_BATTLED)
	e5:SetTarget(c75664472.deftg)
	e5:SetOperation(c75664472.defop)
	c:RegisterEffect(e5)
	--direct attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_DIRECT_ATTACK)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetTarget(c75664472.dirtg)
	c:RegisterEffect(e6)
	--Skip m1
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetRange(LOCATION_FZONE)
	e7:SetTargetRange(1,1)
	e7:SetCode(EFFECT_SKIP_M1)
	c:RegisterEffect(e7)
	--Skip m2
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetRange(LOCATION_FZONE)
	e8:SetTargetRange(1,1)
	e8:SetCode(EFFECT_SKIP_M2)
	c:RegisterEffect(e8)
	--hand limit
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_HAND_LIMIT)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetRange(LOCATION_FZONE)
	e9:SetTargetRange(1,1)
	e9:SetValue(10)
	c:RegisterEffect(e9)
end
function c75664472.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0xed)<10
end
function c75664472.ctop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==1-tp then return end
	ct1=e:GetHandler():GetCounter(0xee)
	ct2=e:GetHandler():GetCounter(0xee)
	e:GetHandler():RemoveCounter(tp,0xee,ct1,REASON_RULE)
	if ct1+ct2<11 then
	e:GetHandler():AddCounter(0xed,1+ct1)
	else
	e:GetHandler():RemoveCounter(tp,0xed,ct1,REASON_RULE)
	e:GetHandler():AddCounter(0xed,10)
	end
end
function c75664472.filter(c,e)
	return (c:IsLocation(LOCATION_MZONE) and c:IsDefenceBelow(0)) or (c:IsLocation(LOCATION_SZONE) and c:GetCounter(0xfa)==0 and c:IsType(TYPE_MONSTER))
end
function c75664472.desop(e,tp,eg,ep,ev,re,r,rp)
	conf=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if conf:GetCount()==0 then return end
	local dg=conf:Filter(c75664472.filter,nil)
	Duel.Destroy(dg,REASON_EFFECT)
end
function c75664472.deftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:IsControler(1-tp) then a,d=d,a end
	if chk==0 then return a and d end
	local g=Group.CreateGroup()
	if a:IsRelateToBattle() then g:AddCard(a) end
	if d:IsRelateToBattle() then g:AddCard(d) end
end
function c75664472.defop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:IsFaceup() and d:IsFaceup() then
	local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENCE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(-d:GetAttack()/2)
		a:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENCE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(-a:GetAttack()/2)
		d:RegisterEffect(e2)
	end
end
function c75664472.dirtg(e,c)
	return not Duel.IsExistingMatchingCard(c75664472.dfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c75664472.dfilter(c,e)
	return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0xee) or c:GetFlagEffect(12345678)>0)
end