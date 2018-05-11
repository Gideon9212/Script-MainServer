function c479587362.initial_effect(c)
aux.EnablePendulumAttribute(c)
--Scale change
local e1=Effect.CreateEffect(c)
e1:SetDescription(aux.Stringid(479587362,0))
e1:SetType(EFFECT_TYPE_IGNITION)
e1:SetCountLimit(1)
e1:SetRange(LOCATION_PZONE)
e1:SetCost(c479587362.cst)
e1:SetOperation(c479587362.op)
c:RegisterEffect(e1)
end
function c479587362.cst(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return true end
local c=e:GetHandler()
local rank=c:GetLevel()
local lp=Duel.GetLP(tp)
local cst1=0
while lp>=1000 do
cst1=cst1+1
lp=lp-1000
end
if cst1>rank then cst1=rank end
local t={}
local i=0
local p=1
for i=0,cst1 do 
t[p]=i p=p+1
end
t[p]=nil
Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(479587362,1))
local cst=Duel.AnnounceNumber(tp,table.unpack(t))
Duel.PayLPCost(tp,cst*1000)
e:SetLabel(cst)
end
function c479587362.op(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
if c:IsFaceup() and c:IsRelateToEffect(e) then
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_SINGLE)
e1:SetCode(EFFECT_CHANGE_LSCALE)
e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
e1:SetValue(e:GetLabel())
c:RegisterEffect(e1)
local e2=e1:Clone()
e2:SetCode(EFFECT_CHANGE_RSCALE)
c:RegisterEffect(e2)
end
end