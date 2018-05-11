function c13713717.initial_effect(c)
	--xyz summon
	--aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c13713717.xyzcon)
	e1:SetOperation(c13713717.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--cannot disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(c13713717.effcon)
	c:RegisterEffect(e2)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c13713717.effcon2)
	e3:SetOperation(c13713717.spsumsuc)
	c:RegisterEffect(e3)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c13713717.tgcon)
	e4:SetValue(aux.imval1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetValue(aux.tgval)
	c:RegisterEffect(e5)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(1426714,0))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c13713717.spcon)
	e6:SetTarget(c13713717.sptg)
	e6:SetOperation(c13713717.spop)
	c:RegisterEffect(e6)
end
c13713717.xyz_number=0
function c13713717.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:CheckRemoveOverlayCard(tp,2,REASON_COST) and c:IsCanBeXyzMaterial(xyzc) 
	and c:IsSetCard(0x7f) and (c:IsSetCard(0x1048) or (c:IsCode(56832966) or c:IsCode(86532744) or c:IsCode(13713717)) or c:IsCode(65305468)) 
end
function c13713717.mfilter(c,xyzc)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsCanBeXyzMaterial(xyzc) and c:GetOverlayCount()==0
end
function c13713717.xyzfilter1(c,g)
	return g:IsExists(c13713717.xyzfilter2,2,c,c:GetRank()) and c:GetOverlayCount()==0
end
function c13713717.xyzfilter2(c,rk)
	return c:GetRank()==rk
end
function c13713717.xyzcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft
	if 3<=ct then return false end
	if ct<1 and Duel.IsExistingMatchingCard(aux.XyzAlterFilter,tp,LOCATION_MZONE,0,1,nil,c13713717.ovfilter,c) then
		return true
	end
	local mg=Duel.GetMatchingGroup(c13713717.mfilter,tp,LOCATION_MZONE,0,nil,c)
	return mg:IsExists(c13713717.xyzfilter1,1,nil,mg)
end
function c13713717.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft
	local mg=Duel.GetMatchingGroup(c13713717.mfilter,tp,LOCATION_MZONE,0,nil,c)
	local b1=mg:IsExists(c13713717.xyzfilter1,1,nil,mg)
	local b2=ct<1 and Duel.IsExistingMatchingCard(aux.XyzAlterFilter,tp,LOCATION_MZONE,0,1,nil,c13713717.ovfilter,c)
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(13713717,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,aux.XyzAlterFilter,tp,LOCATION_MZONE,0,1,1,nil,c13713717.ovfilter,c)
		g:GetFirst():RemoveOverlayCard(tp,2,2,REASON_COST)
		local g2=g:GetFirst():GetOverlayGroup()
		if g2:GetCount()~=0 then
			Duel.Overlay(c,g2)
		end
		c:SetMaterial(g)
		Duel.Overlay(c,g)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g1=mg:FilterSelect(tp,c13713717.xyzfilter1,1,1,nil,mg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g2=mg:FilterSelect(tp,c13713717.xyzfilter2,2,2,g1:GetFirst(),g1:GetFirst():GetRank())
		g1:Merge(g2)
		local sg=Group.CreateGroup()
		local tc=g1:GetFirst()
		while tc do
			sg:Merge(tc:GetOverlayGroup())
			tc=g1:GetNext()
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		c:SetMaterial(g1)
		Duel.Overlay(c,g1)
	end
end
function c13713717.effcon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c13713717.effcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c13713717.spsumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c13713717.chlimit)
end
function c13713717.chlimit(e,ep,tp)
	return tp==ep
end
function c13713717.tgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c13713717.tgcon(e)
	return Duel.IsExistingMatchingCard(c13713717.tgfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c13713717.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c13713717.filter(c,e,tp)
	return c:IsType(TYPE_XYZ) and (c:IsSetCard(0x48) or c:IsSetCard(0x1073)) and not c:IsSetCard(0x7f)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c13713717.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c13713717.filter,e:GetHandlerPlayer(),LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c13713717.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.SelectMatchingCard(tp,c13713717.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
		Duel.Overlay(tc,e:GetHandler():GetOverlayGroup():Select(tp,1,1,nil))
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end