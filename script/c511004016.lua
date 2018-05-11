--Manual Mode
code=511004016
function c511004016.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCountLimit(1)
	e1:SetCondition(c511004016.stcon)
	e1:SetOperation(c511004016.stop)
	c:RegisterEffect(e1)
	-- local e2=Effect.CreateEffect(c)
	-- e2:SetType(EFFECT_TYPE_FIELD)
	-- e2:SetCode(EFFECT_SPSUMMON_PROC_G)
	-- e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	-- e2:SetRange(LOCATION_DECK)
	-- e2:SetCondition(function(e)return e:GetHandler():GetCode()==code end)
	-- e2:SetOperation(c511004016.mainop)
	-- c:RegisterEffect(e2)
	if not c511004016.global_check then
		c511004016.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(c511004016.check)
		Duel.RegisterEffect(ge1,0)
	end
end
function c511004016.check(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	local tc=nil
	if g:GetCount()>0 then
		tc=g:GetFirst()
	end
	while tc do
		tc:SetStatus(STATUS_SUMMON_TURN,false)
		tc:SetStatus(STATUS_SPSUMMON_TURN,false)
		tc:SetStatus(STATUS_FORM_CHANGED,false)
		tc:SetStatus(STATUS_SET_TURN,false)
		tc:SetStatus(STATUS_FLIP_SUMMON_TURN,false)
		tc=g:GetNext()
	end
end
function c511004016.mainop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,0xff,0xff,1,1,nil,TYPE_MONSTER)
	-- sg:Merge(g)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c511004016.stcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnCount()==1 and e:GetHandler():GetCode()==code
end
function c511004016.stop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,c:GetCode())
	local g=Duel.GetFieldGroup(tp,0xff,0xff)
	g:RemoveCard(c)
	local tc=g:GetFirst()
	while tc do
		tc:ReplaceEffect(code,0)
		tc=g:GetNext()
	end
	Duel.DisableShuffleCheck()
	local token=Duel.CreateToken(1-tp,code)
	Duel.SendtoDeck(token,1-tp,2,REASON_RULE)
	Duel.MoveSequence(token,1)
	token:ReverseInDeck()
	Duel.SendtoDeck(c,tp,2,REASON_RULE)
	Duel.MoveSequence(c,1)
	c:ReverseInDeck()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DRAW_COUNT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(0)
	Duel.RegisterEffect(e1,0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetValue(99)
	Duel.RegisterEffect(e2,0)
end