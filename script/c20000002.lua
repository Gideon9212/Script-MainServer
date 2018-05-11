-- c20000000.initial_effect(c)
function c20000002.initial_effect(c)

	--dd d' ark giovanna darco
	--fustion material
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x10fa),2,true)
	c:EnableReviveLimit()
	
	-- freya + 82
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetCondition(c20000002.con)
	e1:SetValue(aux.imval1)
	c:RegisterEffect(e1)
	
	-- ruler archfiend + belzeus + alternative blue eyes
	-- + mystic wok + treno lv4
	--recover
	local e2=Effect.CreateEffect(c)
	--e2:SetDescription(aux.Stringid(70780151,0))
	e2:SetCategory(CATEGORY_RECOVER)
	--e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetCost(c20000002.descost)
	e1:SetTarget(c20000002.damtg)
	e2:SetOperation(c20000002.operation)
	c:RegisterEffect(e2)
	
	--scrap king + seed +m7 constellar
	local e3=Effect.CreateEffect(c)
	--e3:SetDescription(aux.Stringid(97000273,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	--e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	--e3:SetCondition(c20000002.thcon)

	e3:SetTarget(c20000002.thtg)
	e3:SetOperation(c20000002.thop)
	c:RegisterEffect(e3)
	
end
-------------------
function c20000002.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end


--non usata
function c20000002.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetReason(),0x41)==0x41 and re:GetOwner():IsSetCard(0x24)
end
-----------
function c20000002.thfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function c38495396.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c20000002.thfilter2(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(38495396)==0
		and Duel.IsExistingTarget(c38495396.thfilter,tp,LOCATION_REMOVED,nil,1,nil) end
	local b1=Duel.IsExistingTarget(c38495396.thfilter,tp,LOCATION_REMOVED,nil,1,nil)
	
	local op=0
	
		op=Duel.SelectOption(tp,aux.Stringid(38495396,2),aux.Stringid(38495396,3))
	
		op=2
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=nil
	if op==0 then
		g=Duel.SelectTarget(tp,c20000002.thfilter2,tp,LOCATION_REMOVED,nil,1,1,nil)
	elseif op==1 then
		g=Duel.SelectTarget(tp,c20000002.thfilter2,tp,LOCATION_REMOVED,nil,1,1,nil)
	else
		g=Duel.SelectTarget(tp,c20000002.thfilter2,tp,LOCATION_REMOVED,nil,1,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
----------------------



function c20000002.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	local sg=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
	local tc=sg:GetFirst()
	local atk=tc:GetAttack()
	e:setlable(atk)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,e:GetLabel())
end

function c20000002.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--local tc=Duel.GetFirstTarget()
	--if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:GetAttack()>0 and not tc:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		--e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		--e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		Duel.Recover(tp,tc: c:GetAttack(),REASON_EFFECT)
	--end

end


function c20000002.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end

function c20000002.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MOSTER) and c:IsCode(0xfa)
end
function c20000002.con(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c20000002.filter,c:GetControler(),LOCATION_MZONE,0,1,c)
end
