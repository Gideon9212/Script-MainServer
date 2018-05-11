
function c900000004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,900000004+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c900000004.target)
	e1:SetOperation(c900000004.activate)
	c:RegisterEffect(e1)
end
function c900000004.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DEVINE)	and (c:IsCanBeSpecialSummoned(e,0,tp,true,false) or c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsCanBeSpecialSummoned(e,0,tp,true,true))
end
function c900000004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c900000004.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetChainLimit(aux.FALSE)
end
function c900000004.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c900000004.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and (Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) or Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) or Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP))then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_TO_GRAVE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
		e2:SetValue(c900000004.efilter)
		tc:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
end
function c900000004.efilter(e,re,rp,c)
	return re:GetHandler()==c
end
