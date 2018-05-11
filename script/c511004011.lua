--Past Tuning
--Sbripted by Edo9300
function c511004011.initial_effect(c)
	--synchro effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e1:SetCondition(c511004011.sccon)
	e1:SetTarget(c511004011.sctg)
	e1:SetOperation(c511004011.scop)
	c:RegisterEffect(e1)
end
function c511004011.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.SelectTarget(tp,Card.IsLevelAbove,tp,0,LOCATION_MZONE,1,1,nil,1)
end