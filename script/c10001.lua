--Bloodfen Raptor
function c10001.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10000,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10001.spcon)
	e1:SetCost(c10001.cost)
	e1:SetTarget(c10001.target)
	e1:SetOperation(c10001.operation)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c10001.atklimit)
	c:RegisterEffect(e2)
	--place in spzone
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10000,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c10001.spcon2)
	e3:SetCost(c10001.cost)
	e3:SetTarget(c10001.stg)
	e3:SetOperation(c10001.pzop)
	e3:SetCountLimit(1)
	c:RegisterEffect(e3)
	--direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10000,2))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c10001.damcon)
	e4:SetTarget(c10001.damtg)
	e4:SetOperation(c10001.damop)
	c:RegisterEffect(e4)
	--monster attack
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10000,3))
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c10001.damcon2)
	e5:SetTarget(c10001.damtg2)
	e5:SetOperation(c10001.damop2)
	c:RegisterEffect(e5)
	--cannot attack while taunt in szone or attacked a szone monster
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_ATTACK)
	e6:SetCondition(c10001.atkcon)
	c:RegisterEffect(e6)
	--attack to szone
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(10000,4))
	e7:SetCategory(CATEGORY_DAMAGE)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(c10001.damcon3)
	e7:SetTarget(c10001.damtg2)
	e7:SetOperation(c10001.damop3)
	c:RegisterEffect(e7)
	--atk limit
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e8:SetTarget(c10001.tg)
	e8:SetCondition(c10001.btcon)
	e8:SetValue(aux.imval1)
	c:RegisterEffect(e8)
	--move
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_QUICK_O)	
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCondition(c10001.seqcon)
	e9:SetOperation(c10001.seqop)
	c:RegisterEffect(e9)
end
function c10001.spcon(e)
	local ph=Duel.GetCurrentPhase()
	local tp=Duel.GetTurnPlayer()
	return tp==e:GetHandler():GetControler() and ph==PHASE_BATTLE and Duel.GetCurrentChain()==0
end
function c10001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fd=Duel.GetFieldCard(e:GetHandler():GetControler(),LOCATION_SZONE,5)
	local lv=e:GetHandler():GetLevel()
	if chk==0 then return fd:IsCanRemoveCounter(tp,0xed,lv,REASON_COST) end
	fd:RemoveCounter(tp,0xed,lv,REASON_RULE)
	fd:AddCounter(0xee,lv)
end
function c10001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10001.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
function c10001.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c10001.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0  end
end
function c10001.mfilter(c)
	return not c:IsType(TYPE_SPELL)
end
function c10001.spcon2(e)
	local ph=Duel.GetCurrentPhase()
	local tp=Duel.GetTurnPlayer()
	return tp==e:GetHandler():GetControler() and ph==PHASE_BATTLE and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not
	Duel.IsExistingMatchingCard(c10001.mfilter,e:GetHandler():GetControler(),LOCATION_SZONE,0,2,nil) and Duel.GetCurrentChain()==0
end
function c10001.pzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=c:GetAttack()
	local def=c:GetDefence()
	if not (Duel.CheckLocation(tp,LOCATION_SZONE,1) or Duel.CheckLocation(tp,LOCATION_SZONE,2) or Duel.CheckLocation(tp,LOCATION_SZONE,3)
 	or Duel.CheckLocation(tp,LOCATION_SZONE,4) or Duel.CheckLocation(tp,LOCATION_SZONE,5)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	c:AddCounter(0xef,atk)
	c:AddCounter(0xfa,def)
	c:RegisterFlagEffect(10001,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c10001.damfilter(c)
	return c:GetFlagEffect(12345678)>0
end
function c10001.damcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local tp=Duel.GetTurnPlayer()
	return tp==e:GetHandler():GetControler() and ph==PHASE_BATTLE and
	e:GetHandler():GetFlagEffect(10001)<1 and not 
	Duel.IsExistingMatchingCard(c10001.damfilter,e:GetHandler():GetControler(),0,LOCATION_ONFIELD,1,nil) and Duel.GetCurrentChain()==0
end
function c10001.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=e:GetHandler():GetCounter(0xef)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
	e:GetHandler():RegisterFlagEffect(10001,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c10001.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c10001.dam2filter(c)
	return c:IsType(TYPE_MONSTER)
end
function c10001.damcon2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local tp=Duel.GetTurnPlayer()
	return tp==e:GetHandler():GetControler() and ph==PHASE_BATTLE and
	e:GetHandler():GetFlagEffect(10001)<1 and 
	Duel.IsExistingMatchingCard(c10001.dam2filter,e:GetHandler():GetControler(),0,LOCATION_ONFIELD,1,nil) and Duel.GetCurrentChain()==0
end
function c10001.damtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	if Duel.IsExistingMatchingCard(c10001.damfilter,e:GetHandler():GetControler(),0,LOCATION_ONFIELD,1,nil) then
	Duel.SelectTarget(tp,c10001.damfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	else
	Duel.SelectTarget(tp,c10001.dam2filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	end
	e:GetHandler():RegisterFlagEffect(10001,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c10001.damop2(e,tp,eg,ep,ev,re,r,rp)
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
		if atk>c:GetCounter(0xfa) then atk=c:GetCounter(0xfa)
		end
		c:RemoveCounter(tp,0xfa,atk,REASON_RULE)
	end
	if tc:IsFaceup() and tc:IsLocation(LOCATION_SZONE) and c:IsFaceup() then
	local atk1=c:GetCounter(0xef)
	local atk2=tc:GetCounter(0xef)
	local def1=c:GetCounter(0xfa)
	local def2=tc:GetCounter(0xfa)
	if atk2>def1 then atk2=def1 end
	if atk1>def2 then atk1=def2 end
	c:RemoveCounter(tp,0xfa,atk2,REASON_RULE)
	tc:RemoveCounter(tp,0xfa,atk1,REASON_RULE)
	end
end
function c10001.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.IsExistingMatchingCard(c10001.damfilter,e:GetHandler():GetControler(),0,LOCATION_SZONE,1,nil) or e:GetHandler():GetFlagEffect(10001)>0)
	and Duel.GetCurrentChain()==0
end
function c10001.damcon3(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local tp=Duel.GetTurnPlayer()
	return tp==e:GetHandler():GetControler() and ph==PHASE_BATTLE and
	e:GetHandler():GetFlagEffect(10001)<1 and 
	Duel.IsExistingMatchingCard(c10001.dam2filter,e:GetHandler():GetControler(),0,LOCATION_SZONE,1,nil)
	and Duel.GetCurrentChain()==0
end
function c10001.damop3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENCE)
		e1:SetValue(-c:GetAttack())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENCE)
		e2:SetValue(-tc:GetAttack())
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
	end
	if tc:IsFaceup() and tc:IsLocation(LOCATION_SZONE) and c:IsFaceup() then
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENCE)
		e1:SetValue(-tc:GetCounter(0xef))
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local atk=c:GetAttack()
		if atk>tc:GetCounter(0xfa) then atk=tc:GetCounter(0xfa)
		end
		tc:RemoveCounter(tp,0xfa,atk,REASON_RULE)
	end
end
function c10001.tg(e,c)
	return not c:GetFlagEffect(12345678)>0
end
function c10001.btcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(12345678)>0
end
function c10001.seqcon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	local ph=Duel.GetCurrentPhase()
	local tp=Duel.GetTurnPlayer()
	return ((seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
		or (seq==0 and Duel.CheckLocation(tp,LOCATION_SZONE,seq))    
		or (seq==4 and Duel.CheckLocation(tp,LOCATION_SZONE,seq)))
		and tp==e:GetHandler():GetControler() and ph==PHASE_BATTLE and Duel.GetCurrentChain()==0
end
function c10001.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsControler(1-tp) then return end
	local seq=c:GetSequence()
	if (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)
		or (seq==0 and Duel.CheckLocation(tp,LOCATION_SZONE,seq))    
		or (seq==4 and Duel.CheckLocation(tp,LOCATION_SZONE,seq))) then
		local flag=0
		if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=bit.bor(flag,bit.lshift(0x1,seq-1)) end
		if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=bit.bor(flag,bit.lshift(0x1,seq+1)) end
		if seq==0 and Duel.CheckLocation(tp,LOCATION_SZONE,seq) then flag=bit.bor(flag,bit.lshift(0x1,seq)) end
		if seq==4 and Duel.CheckLocation(tp,LOCATION_SZONE,seq) then flag=bit.bor(flag,bit.lshift(0x1,seq)) end
		flag=bit.bxor(flag,0xff)
		if seq==0 or seq==4 then
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE+LOCATION_SZONE,0,flag)
		else
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
		end
		local nseq=0
		if s==1 then nseq=0
		elseif s==2 then nseq=1
		elseif s==4 then nseq=2
		elseif s==8 then nseq=3
		else nseq=4 end
		if seq==0 or seq==4 then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
		Duel.MoveSequence(c,seq)
		else
		Duel.MoveSequence(c,nseq)
	end
end
end