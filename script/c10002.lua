--the coin
function c10002.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10002.con)
	e1:SetCost(c10002.cost)
	e1:SetTarget(c10002.target)
	e1:SetOperation(c10002.operation)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
end
function c10002.con(e)
	local ph=Duel.GetCurrentPhase()
	local tp=Duel.GetTurnPlayer()
	return tp==e:GetHandler():GetControler() and ph==PHASE_BATTLE and Duel.GetCurrentChain()==0
end
function c10002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c10002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local fd=Duel.GetFieldCard(e:GetHandler():GetControler(),LOCATION_SZONE,5)
	if chk==0 then return Duel.GetFieldCard(e:GetHandler():GetControler(),LOCATION_SZONE,5) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xed)
	Duel.SetChainLimit(aux.FALSE)
end
function c10002.operation(e,tp,eg,ep,ev,re,r,rp)
	local fd=Duel.GetFieldCard(e:GetHandler():GetControler(),LOCATION_SZONE,5)
	fd:AddCounter(0xed,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1)
	e1:SetTarget(c10002.target)
	e1:SetOperation(c10002.desop)
	Duel.RegisterEffect(e1,tp)
end
function c10002.desop(e,tp,eg,ep,ev,re,r,rp)
	local fd=Duel.GetFieldCard(e:GetHandler():GetControler(),LOCATION_SZONE,5)
	if fd:GetCounter(0xed)<1 then
	fd:RemoveCounter(tp,0xee,1,REASON_COST)
	else
	fd:RemoveCounter(tp,0xed,1,REASON_COST)
	end
end