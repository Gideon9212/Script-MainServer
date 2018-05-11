--spell Search
function c99999997.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCountLimit(1)
	e1:SetRange(0xff)
	e1:SetCondition(c99999997.con)
	e1:SetOperation(c99999997.op)
	c:RegisterEffect(e1)
end
function c99999997.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnCount()==1
end
function c99999997.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,511004014) then
		Duel.DisableShuffleCheck()
		Duel.SendtoDeck(c,nil,-2,REASON_RULE)		
	else
		Duel.Remove(c,POS_FACEUP,REASON_RULE)
	end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0Xff,0Xff,nil,TYPE_MONSTER)
		Debug.Message(g:GetCount()) 
		local tc=g:GetFirst()
		local i=0
		while tc do
		i=i+1
		Debug.Message(i) 
		tc:ReplaceEffect(16178681,RESET_EVENT+0x1fe0000)
		tc=g:GetNext()
		end
	if e:GetHandler():GetPreviousLocation()==LOCATION_HAND then
		Duel.Draw(tp,1,REASON_RULE)
	end
end
    -- local e1=Effect.CreateEffect(c)
    -- e1:SetDescription(aux.Stringid(99999997,0))
    -- e1:SetCategory(CATEGORY_TOHAND)
    -- e1:SetType(EFFECT_TYPE_ACTIVATE)
    -- e1:SetCode(99999997)
    -- e1:SetCondition(c99999997.condition)
    -- e1:SetTarget(c99999997.target)
    -- e1:SetOperation(c99999997.operation)
    -- c:RegisterEffect(e1)
    -- local e1=Effect.CreateEffect(c)
    -- e1:SetDescription(aux.Stringid(99999997,0))
    -- e1:SetCategory(CATEGORY_TOHAND)
    -- e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    -- e1:SetCode(99999997)
	-- e1:SetRange(LOCATION_SZONE)
    -- e1:SetOperation(function (e)Duel.Damage(tp,1000,REASON_RULE)end)
    -- c:RegisterEffect(e1)
	-- local e3=Effect.CreateEffect(c)
	-- e3:SetType(EFFECT_TYPE_SINGLE)
	-- e3:SetCode(EFFECT_REMAIN_FIELD)
	-- c:RegisterEffect(e3)
	-- if not c99999997.global_check then
		-- c99999997.global_check=true
		-- local ge1=Effect.CreateEffect(c)
		-- ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		-- ge1:SetCode(EVENT_PREDRAW)
		-- ge1:SetOperation(c99999997.checkop)
		-- Duel.RegisterEffect(ge1,0)
	-- end
-- end
-- function c99999997.checkop(e,tp,eg,ep,ev,re,r,rp)
	-- Debug.Message("ciao")
	-- Duel.Damage(tp,100,REASON_RULE)
	-- Duel.RaiseEvent(Duel.GetMatchingGroup(nil,0,LOCATION_ONFIELD,0,nil),99999997,e,0,0,0,0)
	-- Duel.Damage(tp,100,REASON_RULE)
-- end
-- function c99999997.condition(e,tp,eg,ep,ev,re,r,rp)
    -- return Duel.GetTurnPlayer()~=tp and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0
-- end
-- function c99999997.target(e,tp,eg,ep,ev,re,r,rp,chk)
    -- if chk==0 then return Duel.IsExistingMatchingCard(c99999997.filter,1-tp,0,LOCATION_DECK,1,nil) end
    -- local dt=Duel.GetDrawCount(tp)
    -- if dt~=0 then
        -- _replace_count=0
        -- _replace_max=dt
        -- local e1=Effect.CreateEffect(e:GetHandler())
        -- e1:SetType(EFFECT_TYPE_FIELD)
        -- e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        -- e1:SetCode(EFFECT_DRAW_COUNT)
        -- e1:SetTargetRange(0,1)
        -- e1:SetReset(RESET_PHASE+PHASE_DRAW)
        -- e1:SetValue(0)
        -- Duel.RegisterEffect(e1,tp)
    -- end
    -- Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_DECK)
-- end
-- function c99999997.filter(c)
    -- return c:IsAbleToHand() and c:IsType(TYPE_SPELL)
-- end
-- function c99999997.operation(e,tp,eg,ep,ev,re,r,rp)
    -- local c=e:GetHandler()
    -- _replace_count=_replace_count+1
    -- if _replace_count<=_replace_max and c:IsRelateToEffect(e) then
        -- g=Duel.SelectMatchingCard(1-tp,c99999997.filter,1-tp,LOCATION_DECK,0,1,1,nil)
        -- g:GetFirst()
        -- Duel.SendtoHand(g,nil,REASON_EFFECT)
        -- Duel.ConfirmCards(1-tp,g)
    -- end
-- end