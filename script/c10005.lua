--Malfurion Stormrage
function c10005.initial_effect(c)
	c:EnableCounterPermit(0xef)
	c:EnableCounterPermit(0xfb)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10000,2))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c10005.damcon)
	e1:SetTarget(c10005.damtg)
	e1:SetOperation(c10005.damop)
	c:RegisterEffect(e1)
	--monster attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10000,3))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c10005.damcon2)
	e2:SetTarget(c10005.damtg2)
	e2:SetOperation(c10005.damop2)
	c:RegisterEffect(e2)
	--remove armor direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetCondition(c10005.condition)
	e3:SetCost(c10005.cost)
	e3:SetOperation(c10005.activate)
	c:RegisterEffect(e3)
	--remover armor damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_F)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c10005.condition2)
	e4:SetTarget(c10005.target2)
	e4:SetOperation(c10005.operation2)
	c:RegisterEffect(e4)
end
function c10005.damfilter(c)
	return c:GetFlagEffect(12345678)>0
end
function c10005.damcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local tp=Duel.GetTurnPlayer()
	return tp==e:GetHandler():GetControler() and ph==PHASE_BATTLE and
	e:GetHandler():GetFlagEffect(10001)<1 and not 
	Duel.IsExistingMatchingCard(c10005.damfilter,e:GetHandler():GetControler(),0,LOCATION_ONFIELD,1,nil) and Duel.GetCurrentChain()==0
	and e:GetHandler():GetCounter(0xef)>0
end
function c10005.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=e:GetHandler():GetCounter(0xef)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
	e:GetHandler():RegisterFlagEffect(10001,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c10005.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_RULE)
end
function c10005.dam2filter(c)
	return c:IsType(TYPE_MONSTER)
end
function c10005.damcon2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local tp=Duel.GetTurnPlayer()
	return tp==e:GetHandler():GetControler() and ph==PHASE_BATTLE and
	e:GetHandler():GetFlagEffect(10001)<1 and 
	Duel.IsExistingMatchingCard(c10005.dam2filter,e:GetHandler():GetControler(),0,LOCATION_ONFIELD,1,nil) and Duel.GetCurrentChain()==0
	and e:GetHandler():GetCounter(0xef)>0
end
function c10005.damtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	if Duel.IsExistingMatchingCard(c10005.damfilter,e:GetHandler():GetControler(),0,LOCATION_ONFIELD,1,nil) then
	Duel.SelectTarget(tp,c10005.damfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	else
	Duel.SelectTarget(tp,c10005.dam2filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	end
	e:GetHandler():RegisterFlagEffect(10001,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c10005.damop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENCE)
		e1:SetValue(-c:GetCounter(0xef))
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local atk=tc:GetAttack()
		Duel.Damage(tp,atk,REASON_RULE)
	end
	if tc:IsFaceup() and tc:IsLocation(LOCATION_SZONE) and c:IsFaceup() then
	local atk1=c:GetCounter(0xef)
	local atk2=tc:GetCounter(0xef)
	local def1=c:GetCounter(0xfa)
	local def2=tc:GetCounter(0xfa)
	if atk1>def2 then atk1=def2 end
	tc:RemoveCounter(tp,0xfa,atk1,REASON_RULE)
	Duel.Damage(tp,atk2,REASON_RULE)
	end
end
function c10005.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.GetBattleDamage(tp)>=1 and Duel.GetAttackTarget()==nil and Duel.GetCurrentChain()==0
end
function c10005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local dam=Duel.GetBattleDamage(tp)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveCounter(tp,0xfb,1,REASON_RULE) end
	local ct=c:GetCounter(0xfb)
	if ct==1 then 
		c:RemoveCounter(tp,0xfb,1,REASON_RULE)
		e:SetLabel(1)
	else
		local t={}
		local l=1
		while dam>0 and ct>0 do
			dam=dam-1
			ct=ct-1
			t[l]=l
			l=l+1
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(85087012,2))
		c:RemoveCounter(tp,0xfb,l-1,REASON_RULE)
		e:SetLabel(l-1)
	end
end
function c10005.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetOperation(c10005.damop3)
	e1:SetLabel(e:GetLabel())
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c10005.damop3(e,tp,eg,ep,ev,re,r,rp)
	local dam=ev-e:GetLabel()
	if dam<0 then dam=0 end
	Duel.ChangeBattleDamage(tp,dam)
end
function c10005.condition2(e,tp,eg,ep,ev,re,r,rp)
	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_DAMAGE)
	e:SetLabel(cv)
	if ex and (cp==tp or cp==PLAYER_ALL) then return true end
	ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_RECOVER)
	e:SetLabel(cv)
	return ex and (cp==tp or cp==PLAYER_ALL) and Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_RECOVER)
end
function c10005.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10005.operation2(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetLabel(cid)
	e2:SetValue(c10005.damcon3)
	e2:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e2,tp)
end
function c10005.damcon3(e,re,val,r,rp,rc)
	local c=e:GetHandler()
	local cc=Duel.GetCurrentChain()
	if cc==0 or bit.band(r,REASON_EFFECT)==0 then return val end
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	local ct=c:GetCounter(0xfb)
	--if ct>val then
	c:RemoveCounter(tp,0xfb,e:GetLabelObject():GetLabel(),REASON_RULE)
	return 0 end
	--[[if ct<val+1 then
	c:RemoveCounter(tp,0xfb,ct,REASON_RULE)
	return val-ct
	end--]]
--end