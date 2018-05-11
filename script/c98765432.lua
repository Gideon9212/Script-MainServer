--bessonth
function c98765432.initial_effect(c)
c:SetSPSummonOnce(98765432)
--xyz summon
	aux.Stringid(98765432,0)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),6,2)
	c:EnableReviveLimit()
--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c98765432.ffilter1,c98765432.ffilter2,true)
--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98765432,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c98765432.sprcon)
	e2:SetOperation(c98765432.sprop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--cannot disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c98765432.sumsuc)
	c:RegisterEffect(e4)
	--return
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(55171412,0))
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c98765432.retcon1)
	e5:SetTarget(c98765432.rettg)
	e5:SetOperation(c98765432.retop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(0)
	e6:SetCondition(c98765432.retcon2)
	c:RegisterEffect(e6)
	--fusion success
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(21113684,0))
	e7:SetCategory(CATEGORY_RECOVER)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetCondition(c98765432.reccon)
	e7:SetTarget(c98765432.rectg)
	e7:SetOperation(c98765432.recop)
	c:RegisterEffect(e7)
	--xyz success
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetCondition(c98765432.spcon)
	e8:SetCost(c98765432.spcost)
	e8:SetTarget(c98765432.sptg)
	e8:SetOperation(c98765432.spop)
	c:RegisterEffect(e8)
end
function c98765432.ffilter1(c,tp)
	local lv=c:GetLevel()
	return lv==6 and c:IsType(TYPE_TUNER) and c:IsRace(RACE_DRAGON)
end
function c98765432.ffilter2(c,tp)
	local lv=c:GetLevel()
	return lv==6 and not c:IsType(TYPE_TUNER) and c:IsRace(RACE_DRAGON)
end
function c98765432.sprfilter1(c,tp)
	local lv=c:GetLevel()
	return lv==6 and c:IsFaceup() and c:IsType(TYPE_TUNER) and c:IsRace(RACE_DRAGON) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c98765432.sprfilter2,tp,LOCATION_MZONE,0,1,nil,lv)
end
function c98765432.sprfilter2(c,lv)
	return c:IsFaceup() and c:GetLevel()==lv and not c:IsType(TYPE_TUNER) and c:IsRace(RACE_DRAGON) and c:IsAbleToGraveAsCost()
end
function c98765432.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c98765432.sprfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c98765432.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c98765432.sprfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c98765432.sprfilter2,tp,LOCATION_MZONE,0,1,1,nil,g1:GetFirst():GetLevel())
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
	local c=e:GetHandler()
	local atk=0
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	local tc=g:GetFirst()
	while tc do
		atk=atk+(tc:GetLevel()or tc:GetRank())
		tc=g:GetNext()
	end
	Duel.Damage(1-tp,atk*500,REASON_EFFECT)
	Duel.RegisterFlagEffect(tp,98765432,0,0,Duel.GetFlagEffect(tp,98765432)+1)
end
function c98765432.retcon1(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetFlagEffect(tp,98765432)==0 or Duel.GetFlagEffect(tp,98765433)==0 or Duel.GetFlagEffect(tp,98765434)==0
end
function c98765432.retcon2(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetFlagEffect(tp,98765432)~=0 and Duel.GetFlagEffect(tp,98765433)~=0 and Duel.GetFlagEffect(tp,98765434)~=0
end
function c98765432.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c98765432.retop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end
function c98765432.reccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end
function c98765432.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local atk=0
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	local tc=g:GetFirst()
	while tc do
		atk=atk+tc:GetAttack()
		tc=g:GetNext()
	end
	Duel.RegisterFlagEffect(tp,98765432,0,0,Duel.GetFlagEffect(tp,98765433)+1)Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(atk)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
end
function c98765432.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c98765432.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c98765432.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c98765432.spfilter(c,e,tp)
	return (c:IsType(TYPE_FUSION) or c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ)) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c98765432.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98765432.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98765432.spop(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c98765432.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		Duel.RegisterFlagEffect(tp,98765432,0,0,Duel.GetFlagEffect(tp,98765434)+1)Duel.SetTargetPlayer(tp)
end
