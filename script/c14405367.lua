--Gardna Buco Nero
function c14405367.initial_effect(c)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c14405367.efilter)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c14405367.spcon)
	e2:SetTarget(c14405367.sptg)
	e2:SetOperation(c14405367.spop)
	c:RegisterEffect(e2)
	--attack cost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ATTACK_COST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetTarget(c14405367.attg)
	e3:SetCost(c14405367.atcost)
	e3:SetOperation(c14405367.atop)
	c:RegisterEffect(e3)
end
function c14405367.efilter(e,te)
	local c=te:GetHandler()
	return c:IsCode(53129443)
end
function c14405367.cfilter(c)
	return c:IsSetCard(0xfd) and c:IsType(TYPE_MONSTER)
end
function c14405367.spcon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c14405367.cfilter,tp,LOCATION_GRAVE,0,1,nil) then return false end
	return Duel.GetAttacker():GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function c14405367.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsPosition,tp,0,LOCATION_MZONE,1,nil,POS_FACEUP)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	local g=Duel.GetMatchingGroup(Card.IsPosition,tp,0,LOCATION_MZONE,nil,POS_FACEUP)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,g:GetCount(),0,0)
end
function c14405367.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.NegateAttack()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,e:GetHandlerPlayer(),0,LOCATION_MZONE,nil)
		local tc=g:GetFirst()
		while tc do
		Debug.Message("ciao")
		tc:AddCounter(0x10fd,1)
		-- local e1=Effect.CreateEffect(c)
		-- e1:SetType(EFFECT_TYPE_SINGLE)
		-- e1:SetCode(EFFECT_ATTACK_COST)
		-- e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		-- e1:SetCondition(c14405367.atkcon)
		-- e1:SetCost(c14405367.atcost)
		-- e1:SetOperation(c14405367.atop)
		-- tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
end
function c14405367.attg(e,c)
	local tc=Duel.GetAttacker()
	Debug.Message("saas")
	Debug.Message(tc)
	return tc and tc:GetCounter(0x10fd)~=0
end
function c14405367.atcost(e,c,tp)
	return Duel.CheckReleaseGroup(tp,nil,1,Duel.GetAttacker())
end
function c14405367.atop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectReleaseGroup(tp,nil,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c14405367.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c14405367.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and e:GetHandler():GetCounter(0x10fd)>0
end
function c14405367.atkfilter(c)
	return c:IsFaceup() and c:IsCode(14405367) and not c:IsDisabled()
end