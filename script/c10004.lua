--Fireblast
function c10004.initial_effect(c)
	--damage monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10004,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c10004.damcon)
	e1:SetCost(c10004.cost)
	e1:SetTarget(c10004.damtg)
	e1:SetOperation(c10004.damop)
	c:RegisterEffect(e1)
	--damage oppo
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(10004,1))
	e2:SetCondition(c10004.damcon2)
	e2:SetTarget(c10004.damtg2)
	e2:SetOperation(c10004.damop2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(10004,2))
	e3:SetTarget(c10004.damtg3)
	c:RegisterEffect(e3)
end
function c10004.damfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c10004.damcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local tp=Duel.GetTurnPlayer()
	return tp==e:GetHandler():GetControler() and ph==PHASE_BATTLE and
	Duel.IsExistingMatchingCard(c10004.damfilter,e:GetHandler():GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.GetCurrentChain()==0 and
	e:GetHandler():GetFlagEffect(10004)<1
end
function c10004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fd=Duel.GetFieldCard(e:GetHandler():GetControler(),LOCATION_SZONE,5)
	if chk==0 then return fd:IsCanRemoveCounter(tp,0xed,2,REASON_COST) end
	fd:RemoveCounter(tp,0xed,2,REASON_RULE)
	fd:AddCounter(0xee,2)
end
function c10004.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c10004.damfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	e:GetHandler():RegisterFlagEffect(10004,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c10004.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENCE)
		e1:SetValue(-1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
	if tc:IsFaceup() and tc:IsLocation(LOCATION_SZONE) then
	tc:RemoveCounter(tp,0xfa,1,REASON_RULE)
	end
end
function c10004.damcon2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local tp=Duel.GetTurnPlayer()
	return tp==e:GetHandler():GetControler() and ph==PHASE_BATTLE and Duel.GetCurrentChain()==0 and
	e:GetHandler():GetFlagEffect(10004)<1
end
function c10004.damtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1)
	e:GetHandler():RegisterFlagEffect(10004,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c10004.damop2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c10004.damtg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1)
	e:GetHandler():RegisterFlagEffect(10004,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
