function c984984.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTarget(c984984.target)
	e1:SetOperation(c984984.activate)
	c:RegisterEffect(e1)
end
function c984984.cfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_DEVINE) and c:IsAbleToRemoveAsCost()
end
function c984984.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c984984.cfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c984984.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c984984.cfilter1,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc and Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)~=0 and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
			tc:RegisterFlagEffect(984984,RESET_EVENT+0x1fe0000,0,1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetRange(LOCATION_SZONE)
			e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
			e1:SetCountLimit(1)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
			e1:SetCondition(c984984.thcon)
			e1:SetOperation(c984984.thop)
			e1:SetLabel(0)
			e1:SetLabelObject(tc)
			c:RegisterEffect(e1)
		end
	end
end
function c984984.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c984984.cfilter2(c)
	return c:IsType(TYPE_MONSTER)
end
function c984984.cfilter3(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c984984.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	e:GetHandler():SetTurnCounter(ct+1)
	if ct==1 then
		Duel.Destroy(e:GetHandler(),REASON_RULE)
		if Duel.IsExistingMatchingCard(c984984.cfilter3,tp,LOCATION_GRAVE,0,3,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c984984.cfilter3,tp,LOCATION_GRAVE,0,3,3,nil)
		if Duel.Remove(g,POS_FACEUP,REASON_COST) then
		local tc=e:GetLabelObject()
		if tc:GetFlagEffect(984984)~=0 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
		end
	end
	end
	if ct==0 then
	if Duel.IsExistingMatchingCard(c984984.cfilter2,tp,LOCATION_DECK,0,1,nil) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c984984.cfilter2,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(1)
	end
end
end