function c160002496.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2011,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c2011.destg)
	e1:SetOperation(c2011.desop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2011,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetCondition(c2011.condition)
	e2:SetTarget(c2011.target)
	e2:SetOperation(c2011.operation)
	c:RegisterEffect(e2)
       
end
---destroy
function c2011.cfilter(c)
       return c:IsFaceup() and c:IsSetCard(0x97)
end
function c2011.destg(e,tp,eg,ep,ev,re,r,rp,chk)
       if chk==0 then return Duel.GetMatchingGroupCount(c2011.cfilter,tp,LOCATION_MZONE,0,nil)<=Duel.GetMatchingGroupCount(Card.IsDestructable,tp,0,LOCATION_SZONE,nil) end
	local ct=Duel.GetMatchingGroupCount(c2011.cfilter,tp,LOCATION_MZONE,0,nil)
	local dg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,ct,0,0)
end
function c2011.desop(e,tp,eg,ep,ev,re,r,rp)
       local ct=Duel.GetMatchingGroupCount(c2011.cfilter,tp,LOCATION_MZONE,0,nil)
       local g=Duel.GetMatchingGroup(c160002496.filter,tp,0,LOCATION_SZONE,nil)
       if ct>g:GetCount() then return end
       Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
       local sg=g:Select(tp,ct,ct,nil)
       Duel.HintSelection(sg)
       Duel.Destroy(sg,REASON_EFFECT)
end
----summon
function c2011.condition(e,tp,eg,ep,ev,re,r,rp)
       return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_BATTLE)
end
function c2011.sfilter(c,e,tp)
       return c:IsLevelBelow(4) and c:IsSetCard(0x97) and not c:IsCode(2011) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c2011.target(e,tp,eg,ep,ev,re,r,rp,chk)
       if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
               and Duel.IsExistingMatchingCard(c2011.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
       Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c2011.operation(e,tp,eg,ep,ev,re,r,rp)
       if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
       Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
       local g = Duel.SelectMatchingCard(tp,c2011.sfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
       if g:GetCount()>0 then
               Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
       end
end