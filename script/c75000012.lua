--Evoltile Marasucho
function c75000012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--pendulum summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC_G)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,10000000)
	e2:SetCondition(c75000012.pencon)
	e2:SetOperation(c75000012.penop)
	e2:SetValue(151)
	c:RegisterEffect(e2)
	--activate limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c75000012.condition)
	e3:SetOperation(c75000012.cedop)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetDescription(aux.Stringid(75000012,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c75000012.eqcon)
	e4:SetTarget(c75000012.target)
	e4:SetOperation(c75000012.operation)
	c:RegisterEffect(e4)
end
function c75000012.penfilter(c,e,tp,lscale,rscale)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and lv>lscale and lv<rscale and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,true)
		and not c:IsForbidden()
end
function c75000012.pencon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	if c:GetSequence()~=7 and c:GetSequence()~=6 then return false end
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,13-c:GetSequence())
	if rpz==nil then return false end
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if c:GetSequence()==7 then
		lscale=c:GetRightScale()
		rscale=rpz:GetLeftScale()
	end
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return false end
	if og then
		return og:IsExists(c75000012.penfilter,1,nil,e,tp,lscale,rscale)
	else
		return Duel.IsExistingMatchingCard(c75000012.penfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp,lscale,rscale)
	end
end
function c75000012.penop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,13-c:GetSequence())
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if c:GetSequence()==7 then
		lscale=c:GetRightScale()
		rscale=rpz:GetLeftScale()
	end
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if og then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=og:FilterSelect(tp,c75000012.penfilter,1,ft,nil,e,tp,lscale,rscale)
		sg:Merge(g)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c75000012.penfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,ft,nil,e,tp,lscale,rscale)
		sg:Merge(g)
	end
	Duel.HintSelection(Group.FromCards(c))
	Duel.HintSelection(Group.FromCards(rpz))
end
function c75000012.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c75000012.filter1(c,e,tp)
	return c:IsSetCard(0x604e) or c:IsSetCard(0x304e) and c:IsCanBeSpecialSummoned(e,152,tp,false,false)
end
function c75000012.filter2(c)
	return (c:IsCode(8632967) or c:IsCode(14154221) or c:IsCode(34026662) or c:IsCode(64815084) or c:IsCode(74100225) or c:IsCode(88760522)) and c:IsAbleToHand()
end
function c75000012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local sel=0
		if Duel.IsExistingMatchingCard(c75000012.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) then sel=sel+1 end
		if Duel.IsExistingMatchingCard(c75000012.filter2,tp,LOCATION_DECK,0,1,nil) then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(75000012,0))
		sel=Duel.SelectOption(tp,aux.Stringid(75000012,1),aux.Stringid(75000012,2))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(75000012,1))
	elseif sel==2 then
		Duel.SelectOption(tp,aux.Stringid(75000012,2))
	end
	e:SetLabel(sel)
	if sel==1 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	else Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) end
end
function c75000012.operation(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c75000012.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
		Duel.SpecialSummon(g,152,tp,tp,false,false,POS_FACEUP)
		local rf=g:GetFirst().evolreg
		if rf then rf(g:GetFirst()) end
		end
		
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c75000012.filter2,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
end
function c75000012.cfilter(c)
	return c:IsSetCard(0x604e) or c:IsSetCard(0x304e)
end
function c75000012.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75000012.cfilter,1,nil)
end
function c75000012.cedop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimit(c75000012.chainlm)
end
function c75000012.chainlm(e,rp,tp)
	return tp==rp
end