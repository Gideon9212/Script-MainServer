--Necromantic Spectral Reinforcements
function c77777748.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(c77777748.ctop)
    c:RegisterEffect(e1)
    --counter
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAIN_SOLVING)
    e2:SetRange(LOCATION_SZONE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCondition(c77777748.ctcon)
    e2:SetOperation(c77777748.ctop)
    c:RegisterEffect(e2)
end
function c77777748.ctcon(e,tp,eg,ep,ev,re,r,rp)
    return re and re:GetHandler():IsSetCard(0x1c8)and not re:GetHandler():IsCode(77777748)
end
function c77777748.ctop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():AddCounter(0x666+COUNTER_NEED_ENABLE,10)
end