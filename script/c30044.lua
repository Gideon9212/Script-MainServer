function c3004.initial_effect(c)
		c:EnableReviveLimit()
		--spsummon condition
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_SPSUMMON_CONDITION)
		e1:SetValue(aux.ritlimit)
		c:RegisterEffect(e1)
		--remove
       	local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
		e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(0xff,0xff)
		e2:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e2)
		--remove on summon
		local e3=Effect.CreateEffect(c)
		e3:SetCategory(CATEGORY_REMOVE)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		e3:SetTarget(c3004.target)
		e3:SetOperation(c3004.activate)
		c:RegisterEffect(e3)
		--negate
		local e4=Effect.CreateEffect(c)
		e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DAMAGE)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
		e4:SetCode(EVENT_CHAINING)
		e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCondition(c3004.discon)
		e4:SetCost(c3004.discost)
		e4:SetTarget(c3004.distg)
		e4:SetOperation(c3004.disop)
		c:RegisterEffect(e4)
		end
function c3004.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and c:IsSetCard(0x98)
end
function c3004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(c3004.rmfilter,tp,LOCATION_DECK,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c3004.rmfilter,tp,LOCATION_DECK,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
end
function c3004.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
function c3004.discon(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER))
		and re:GetHandler()~=e:GetHandler()
end
function c3004.cfilter(c)
	return c:IsAbleToDeck() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x98)
end
function c3004.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3004.cfilter,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c3004.cfilter,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c3004.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c3004.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end