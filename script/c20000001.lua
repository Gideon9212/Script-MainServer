-- c20000000.initial_effect(c)
function c20000001.initial_effect(c)
	c:EnableCounterPermit(0x15)
	
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c20000001.target)
	c:RegisterEffect(e2)
	
	--snow dust golem al contrario
	--atkdown
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x10fa))
	e3:SetValue(c20000001.atkval)
	c:RegisterEffect(e3)
	
	--carte magie aqua actress + yang zing
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetTarget(c20000001.target2)
	e4:SetOperation(c20000001.operation)
	c:RegisterEffect(e4)
	
	--counter add counter carta magia yosenju
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c20000001.ctcon)
	e5:SetOperation(c20000001.ctop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e7)
end


function c20000001.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x10fa)
end
function c20000001.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c20000001.cfilter,1,nil)
end
function c20000001.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x15+COUNTER_NEED_ENABLE,1)
end


function c20000001.filter4(c,e,tp)
	return c:IsSetCard(0x10fa) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20000001.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c20000001.filter4,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
	-- + photon cesar
end
function c20000001.operation(e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then return true end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c20000001.filter4,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	-- +cweng
end

function c20000001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c20000001.filter(chkc) end
	if chk==0 then return true end
	local c=e:GetHandler()
	c:AddCounter(0x15,2)
end
function c20000001.atkval(e,c)
	return Duel.GetCounter(0,1,1,0x15)*100
end