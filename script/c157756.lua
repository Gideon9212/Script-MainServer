--ABCVWXYZ-Drago Imperatore Macchina
function c157756.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,7024,84243274,true,true)
	--spsummon condition
	local e=Effect.CreateEffect(c)
	e:SetType(EFFECT_TYPE_SINGLE)
	e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e:SetCode(EFFECT_SPSUMMON_CONDITION)
	e:SetValue(c157756.splimit)
	c:RegisterEffect(e)
	--special summon rule
	local d=Effect.CreateEffect(c)
	d:SetType(EFFECT_TYPE_FIELD)
	d:SetCode(EFFECT_SPSUMMON_PROC)
	d:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	d:SetRange(LOCATION_EXTRA)
	d:SetCondition(c157756.spcon)
	d:SetOperation(c157756.spop)
	c:RegisterEffect(d)
	--special summon rule
	local o=Effect.CreateEffect(c)
	o:SetType(EFFECT_TYPE_FIELD)
	o:SetCode(EFFECT_SPSUMMON_PROC)
	o:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	o:SetRange(LOCATION_EXTRA)
	o:SetCondition(c157756.spcon2)
	o:SetOperation(c157756.spop3)
	c:RegisterEffect(o)
	--remove
	local e9=Effect.CreateEffect(c)
	e9:SetCategory(CATEGORY_REMOVE)
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetCountLimit(1)
	e9:SetCost(c157756.rmcost)
	e9:SetCondition(c157756.rmcon)
	e9:SetTarget(c157756.rmtg)
	e9:SetOperation(c157756.rmop)
	c:RegisterEffect(e9)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(157756,1))
	e3:SetCategory(CATEGORY_SPSUMMON)
	e3:SetRange(LOCATION_MZONE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetCountLimit(1,157756+EFFECT_COUNT_CODE_DUEL)
	e3:SetCondition(c157756.spcon3)
	e3:SetCost(c157756.spcost)
	e3:SetTarget(c157756.sptg)
	e3:SetOperation(c157756.spop2)
	c:RegisterEffect(e3)
end
function c157756.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c157756.spfilter(c,code)
	return c:IsCode(code) and c:IsAbleToRemoveAsCost()
end
function c157756.spcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<-1 then return false end
	local g1=Duel.GetMatchingGroup(c157756.spfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,7024)
	local g2=Duel.GetMatchingGroup(c157756.spfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,84243274)
	if g1:GetCount()==0 or g2:GetCount()==0 then return false end
	if ft>0 then return true end
	local f1=g1:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)
	local f2=g2:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)
	if ft==-1 then return f1>0 and f2>0
	else return f1>0 or f2>0 end
end
function c157756.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g1=Duel.GetMatchingGroup(c157756.spfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,7024)
	local g2=Duel.GetMatchingGroup(c157756.spfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,84243274)
	g1:Merge(g2)
	local g=Group.CreateGroup()
	local tc=nil
	for i=1,2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		if ft<=0 then
			tc=g1:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_MZONE):GetFirst()
		else
			tc=g1:Select(tp,1,1,nil):GetFirst()
		end
		g:AddCard(tc)
		g1:Remove(Card.IsCode,nil,tc:GetCode())
		ft=ft+1
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c157756.spfilter3(c,code)
	return (c:IsCode(7021) or c:IsCode(7022) or c:IsCode(7023) or c:IsCode(51638941) or c:IsCode(96300057) or c:IsCode(62651957) or c:IsCode(65622692) or c:IsCode(64500000)) and c:IsAbleToRemoveAsCost()
end
function c157756.spfilter4(c)
	return c:IsLocation(LOCATION_MZONE) and c:GetSummonType()~=SUMMON_TYPE_PENDULUM
end
function c157756.spcon2(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	local g1=Duel.GetMatchingGroup(c157756.spfilter3,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,0,nil)
	local ct=g1:GetClassCount(Card.GetCode)
	if ct~=8 then return false end
	g=g1:Filter(c157756.spfilter4,nil,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>4
end
function c157756.spop3(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.GetMatchingGroup(c157756.spfilter3,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,0,nil)
	local g=Group.CreateGroup()
	local tc=nil
	local a=0
	local b=0
	while b<8 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		if a<5 then
			tc=g1:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_MZONE):GetFirst()
		else
			tc=g1:Select(tp,1,1,nil):GetFirst()
		end
		g:AddCard(tc)
		g1:Remove(Card.IsCode,nil,tc:GetCode())
		a=a+1
		b=b+1
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c157756.rmfilter(c,tp)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c157756.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) or Duel.IsExistingMatchingCard(c157756.rmfilter,tp,LOCATION_GRAVE,0,1,nil,tp)) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c157756.rmfilter,tp,LOCATION_GRAVE,0,nil)
	g:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(157756,2))
	tc=g:Select(tp,1,1,nil):GetFirst()
	if tc:IsLocation(LOCATION_HAND) then
	Duel.SendtoGrave(Group.FromCards(tc),REASON_COST+REASON_DISCARD)
	else
	Duel.Remove(Group.FromCards(tc),POS_FACEUP,REASON_COST)
	end
end
function c157756.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return not (Duel.GetCurrentPhase()==PHASE_STANDBY and Duel.GetTurnPlayer()~=tp)
end
function c157756.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove()
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
end
function c157756.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND+LOCATION_ONFIELD,0)
	if g:GetCount()==0 then return end
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local fid=c:GetFieldID()
		local og=Duel.GetOperatedGroup()
		local oc=og:GetFirst()
		while oc do
		oc:RegisterFlagEffect(157756,RESET_EVENT+0x1fe0000,0,1,fid)
		oc=og:GetNext()
		end
		og:KeepAlive()
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e0:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e0:SetCountLimit(1)
		e0:SetLabel(fid)
		e0:SetLabelObject(og)
		e0:SetCondition(c157756.retcon)
		e0:SetOperation(c157756.retop)
		e0:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN)
		Duel.RegisterEffect(e0,tp)
		Duel.Recover(tp,1000,REASON_EFFECT)
		c:RegisterFlagEffect(157756,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1,1)
	end
end
function c157756.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c157756.retfilter(c,fid)
	return c:GetFlagEffectLabel(157756)==fid
end
function c157756.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c157756.retfilter,nil,e:GetLabel())
	g:DeleteGroup()
	local tc=sg:GetFirst()
	while tc do
		if not Duel.ReturnToField(tc) then
			Duel.SendtoHand(tc,tc:GetPreviousControler(),REASON_EFFECT)
		end
		tc=sg:GetNext()
	end
end
function c157756.spcon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c157756.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,0,REASON_COST)
end
function c157756.spfilter2(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c157756.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c157756.spfilter2,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,7024)
		and Duel.IsExistingMatchingCard(c157756.spfilter2,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,84243274) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c157756.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g1=Duel.GetMatchingGroup(c157756.spfilter2,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp,7024)
	local g2=Duel.GetMatchingGroup(c157756.spfilter2,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp,84243274)
	if g1:GetCount()>0 and g1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g1:Select(tp,1,1,nil)
		local sg1=g2:Select(tp,1,1,nil)
		sg:Merge(sg1)
		local tc=sg:GetFirst()
		Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP)
		tc=sg:GetNext()
		Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end
