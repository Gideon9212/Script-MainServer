function c600000000.initial_effect(c)
    --summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c600000000.ttcon)
	e1:SetOperation(c600000000.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(c600000000.ttcon)
	e2:SetOperation(c600000000.ttop)
	c:RegisterEffect(e2)
	--cannot ssummon hand
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(aux.FALSE)
	c:RegisterEffect(e3)
	--atk/def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c600000000.adval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e5)
	--Cannot be Targeted by the effects of Spell/Trap Cards except by ra and itself
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c600000000.notargetedval)
	c:RegisterEffect(e6)
    --Cannot be Destroyed by the effects of Spell/Trap Cards except by ra and itself
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e7:SetValue(c600000000.nodestroyedval)
	c:RegisterEffect(e7)
	--atkdown
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_ATKCHANGE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	e8:SetCondition(c600000000.atkcon)
	e8:SetTarget(c600000000.atktg)
	e8:SetOperation(c600000000.atkop)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e9)
	--shuffle
	local e10=Effect.CreateEffect(c)
	e10:SetCategory(CATEGORY_REMOVE)
	e10:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e10:SetCode(EVENT_SPSUMMON_SUCCESS)
	e10:SetTarget(c600000000.tdtg)
	e10:SetOperation(c600000000.tdop)
	c:RegisterEffect(e10)
	--to grave
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_DESTROY)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCountLimit(1)
	e11:SetCode(EVENT_PHASE+PHASE_END)
	e11:SetCondition(c600000000.tgcon)
	e11:SetTarget(c600000000.tgtg)
	e11:SetOperation(c600000000.tgop)
	c:RegisterEffect(e11)
	--draw
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(99899504,1))
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e12:SetCode(EVENT_PREDRAW)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCondition(c600000000.drcon)
	e12:SetOperation(c600000000.drop)
	c:RegisterEffect(e12)
end
function c600000000.spfilter(c,tpe)
	return c:IsFaceup() and c:IsType(tpe) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c600000000.ttcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
		and Duel.CheckReleaseGroup(tp,c600000000.spfilter,1,nil,TYPE_XYZ)
		and Duel.CheckReleaseGroup(tp,c600000000.spfilter,1,nil,TYPE_FUSION)
		and Duel.CheckReleaseGroup(tp,c600000000.spfilter,1,nil,TYPE_SYNCHRO)
end
function c600000000.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c600000000.spfilter,1,1,nil,TYPE_XYZ)
	local g2=Duel.SelectReleaseGroup(tp,c600000000.spfilter,1,1,nil,TYPE_FUSION)
	local g3=Duel.SelectReleaseGroup(tp,c600000000.spfilter,1,1,nil,TYPE_SYNCHRO)
	g1:Merge(g2)
	g1:Merge(g3)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_SUMMON+REASON_MATERIAL)
end
function c600000000.setcon(e,c)
	if not c then return true end
	return false
end
function c600000000.adval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)*1000
end
function c600000000.notargetedval(e,te)
	return not te:GetHandler():IsCode(10000010)-- and not te:GetHandler()==e:GetHandler()
end
function c600000000.nodestroyedval(e,te)
	return not te:GetHandler():IsCode(10000010)-- and not te:GetHandler()==e:GetHandler()
end
function c600000000.atkfilter(c,e,tp)
	return c:IsControler(tp) and c:IsPosition(POS_FACEUP_ATTACK) and (not e or c:IsRelateToEffect(e))
end
function c600000000.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c600000000.atkfilter,1,nil,nil,1-tp)
end
function c600000000.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetCard(eg)
end
function c600000000.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c600000000.atkfilter,nil,e,1-tp)
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		local preatk=tc:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-2000)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		if preatk~=0 and tc:GetAttack()==0 then dg:AddCard(tc) end
		tc=g:GetNext()
	end
	Duel.Destroy(dg,REASON_EFFECT)
end
function c600000000.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,0,0xe)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c600000000.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,0xe)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	Duel.ShuffleDeck(1-tp)
end
function c600000000.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c600000000.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c600000000.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c600000000.drcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.IsPlayerCanDraw(tp,10)
end
function c600000000.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,11)
	local tc=g:GetFirst()
	while tc do
	tc:RegisterFlagEffect(600000000,RESET_TODECK,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,3)
	e1:SetCondition(c600000000.thcon)
	e1:SetCondition(c600000000.thcon)
	e1:SetOperation(c600000000.thop)
	tc:RegisterEffect(e1)
	tc=g:GetNext()
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_DP)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END,21)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DRAW_COUNT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetValue(10)
	e2:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetOperation(c600000000.disop)
	e3:SetCountLimit(1)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c600000000.bfilter(c)
	Debug.Message("Iciai.")
	return c:GetFlagEffect(600000000)>0 and c:IsAbleToRemove()
end
function c600000000.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local g1=g:Filter(c600000000.bfilter,nil,nil)
	Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
end
function c600000000.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c600000000.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local ct=ct+1
	if ct==1 then
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
	else e:SetLabel(1) end
end