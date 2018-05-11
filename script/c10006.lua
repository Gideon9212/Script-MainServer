--Shapeshift
function c10006.initial_effect(c)
	--Atk/armor
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7802006,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c10006.damcon)
	e1:SetCost(c10006.cost)
	e1:SetOperation(c10006.operation)
	c:RegisterEffect(e1)
end
function c10006.damcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local tp=Duel.GetTurnPlayer()
	return tp==e:GetHandler():GetControler() and ph==PHASE_BATTLE and Duel.GetCurrentChain()==0 and
	e:GetHandler():GetFlagEffect(10004)<1
end
function c10006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fd=Duel.GetFieldCard(e:GetHandler():GetControler(),LOCATION_SZONE,5)
	if chk==0 then return fd:IsCanRemoveCounter(tp,0xed,2,REASON_COST) end
	fd:RemoveCounter(tp,0xed,2,REASON_RULE)
	fd:AddCounter(0xee,2)
	e:GetHandler():RegisterFlagEffect(10004,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c10006.filter(c)
	return c:IsSetCard(0x1c8)
end
function c10006.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10006.filter,tp,LOCATION_SZONE,0,nil)
	local tc=g:GetFirst()
	tc:AddCounter(0xef,1)
	tc:AddCounter(0xfb,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetOperation(c10006.desop)
	Duel.RegisterEffect(e1,tp)
end
function c10006.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10006.filter,tp,LOCATION_SZONE,0,nil)
	local tc=g:GetFirst()
	tc:RemoveCounter(tp,0xef,1,REASON_COST)
end