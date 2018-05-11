function c60000308.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c60000308.adval)
	c:RegisterEffect(e1)
end
function c60000308.adval(e,tp,eg,ep,ev,re,r,rp,c)
	local atk=c:GetRank()
	local ct=c:GetCounter(xxxxx)
	if atk<ct then
	local ct=c:GetRank()
	local atk=c:GetCounter(xxxxx)
	end
	local atk2=atk
	local ct2=ct
	local diff=atk-ct
	local diff2=diff
	while atk>1 do
	atk=atk-1
	atk2=atk2*atk
	end
	while ct>1 do
	ct=ct-1
	ct2=ct2*ct
	end
	while diff>1 do
	diff=diff-1
	diff2=diff2*diff
	end
	local atkf=atk2/(ct2*diff2)
	return atkf
end