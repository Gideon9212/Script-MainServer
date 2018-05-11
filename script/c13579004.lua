function c13579004.initial_effect(c)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c13579004.con2)
	e5:SetTarget(c13579004.rmtg)
	e5:SetOperation(c13579004.operation2)
	c:RegisterEffect(e5)
end
function c13579004.confilter(c,tp)
	return c:IsSetCard(0x12c) and not c:IsCode(13579004)
end
function c13579004.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c13579004.confilter,1,nil,tp)
end
function c13579004.spfilter(c,e,tp,att)
	return c:IsAttribute(att) and c:IsAbleToRemove()
end
function c13579004.cfilter(c,e,tp)
	return c:IsSetCard(0x12c) and not c:IsCode(13579004) and Duel.IsExistingMatchingCard(c13579004.filter,tp,LOCATION_EXTRA,0,1,nil,c:GetAttribute(),e,tp)
end
function c13579004.filter(c,att,e,tp)
	return c:IsAbleToRemove() and c:IsAttribute(att) and c:IsSetCard(0x12c) and not c:IsCode(13579004)
end
function c13579004.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return eg:IsExists(c13579004.cfilter,1,nil,e,tp) end
	local r=eg:GetFirst()
	local att=r:GetAttribute()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c13579004.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,att)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c13579004.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end