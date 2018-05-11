--heartstone
function c75664471.initial_effect(c)
	--Activate	
	local e1=Effect.CreateEffect(c)	
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCountLimit(1)
	e1:SetRange(0xff)
	e1:SetOperation(c75664471.stop)
	c:RegisterEffect(e1)
end
function c75664471.stop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local tc2=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
	if tc==nil then
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_RULE)
		Duel.SetLP(tp,30)
		Duel.SetLP(1-tp,30)	
		if tc2==nil and tc==nil then
			local token=Duel.CreateToken(tp,75664472,nil,nil,nil,nil,nil,nil)		
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fc0000)
			e1:SetValue(TYPE_SPELL+TYPE_FIELD)
			token:RegisterEffect(e1)
			Duel.MoveToField(token,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
			Duel.SpecialSummonComplete()
			local token2=Duel.CreateToken(tp,75664472,nil,nil,nil,nil,nil,nil)		
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fc0000)
			e1:SetValue(TYPE_SPELL+TYPE_FIELD)
			token:RegisterEffect(e1)
			Duel.MoveToField(token2,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			Duel.SpecialSummonComplete()
			local op=0
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(75664471,9))
			op=Duel.SelectOption(tp,aux.Stringid(75664471,0),aux.Stringid(75664471,1),aux.Stringid(75664471,2),aux.Stringid(75664471,3),aux.Stringid(75664471,4),aux.Stringid(75664471,5),aux.Stringid(75664471,6),aux.Stringid(75664471,7),aux.Stringid(75664471,8))
			if op==0 then local tk=10005 e:SetLabel(tk) end
			if op==1 then local tk=10007 e:SetLabel(tk) end
			if op==2 then local tk=10003 e:SetLabel(tk) end
			if op==3 then local tk=10009 e:SetLabel(tk) end
			if op==4 then local tk=10011 e:SetLabel(tk) end
			if op==5 then local tk=10013 e:SetLabel(tk) end
			if op==6 then local tk=10015 e:SetLabel(tk) end
			if op==7 then local tk=10017 e:SetLabel(tk) end
			if op==8 then local tk=10019 e:SetLabel(tk) end
			local token3=Duel.CreateToken(tp,e:GetLabel(),nil,nil,nil,nil,nil,nil)	
			Duel.SpecialSummonStep(token3,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fc0000)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			token3:RegisterEffect(e1)
			Duel.MoveToField(token3,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			Duel.MoveSequence(token3,2)
			Duel.SpecialSummonComplete()
			local token4=Duel.CreateToken(tp,e:GetLabel()+1,nil,nil,nil,nil,nil,nil)		
			Duel.SpecialSummonStep(token4,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fc0000)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			token4:RegisterEffect(e1)
			Duel.MoveToField(token4,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			Duel.MoveSequence(token4,3)
			Duel.SpecialSummonComplete()
			local op=0
			Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(75664471,9))
			op=Duel.SelectOption(1-tp,aux.Stringid(75664471,0),aux.Stringid(75664471,1),aux.Stringid(75664471,2),aux.Stringid(75664471,3),aux.Stringid(75664471,4),aux.Stringid(75664471,5),aux.Stringid(75664471,6),aux.Stringid(75664471,7),aux.Stringid(75664471,8))
			if op==0 then local tk=10005 e:SetLabel(tk) end
			if op==1 then local tk=10007 e:SetLabel(tk) end
			if op==2 then local tk=10003 e:SetLabel(tk) end
			if op==3 then local tk=10009 e:SetLabel(tk) end
			if op==4 then local tk=10011 e:SetLabel(tk) end
			if op==5 then local tk=10013 e:SetLabel(tk) end
			if op==6 then local tk=10015 e:SetLabel(tk) end
			if op==7 then local tk=10017 e:SetLabel(tk) end
			if op==8 then local tk=10019 e:SetLabel(tk) end
			local token5=Duel.CreateToken(tp,e:GetLabel(),nil,nil,nil,nil,nil,nil)	
			Duel.SpecialSummonStep(token5,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fc0000)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			token3:RegisterEffect(e1)
			Duel.MoveToField(token5,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
			Duel.MoveSequence(token5,2)
			Duel.SpecialSummonComplete()
			local token6=Duel.CreateToken(tp,e:GetLabel()+1,nil,nil,nil,nil,nil,nil)		
			Duel.SpecialSummonStep(token6,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fc0000)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			token4:RegisterEffect(e1)
			Duel.MoveToField(token6,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
			Duel.MoveSequence(token6,3)
			Duel.SpecialSummonComplete()
			local g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
			Duel.ShuffleDeck(1-tp)
			Duel.BreakEffect()
			Duel.Draw(tp,3,REASON_EFFECT)
			Duel.Draw(1-tp,3,REASON_EFFECT)
			Duel.SendtoDeck(e:GetHandler(),nil,-2,REASON_EFFECT)
		end
	else
		Duel.SendtoDeck(e:GetHandler(),nil,-2,REASON_EFFECT)
	end
	if e:GetHandler():GetPreviousLocation()==LOCATION_HAND then
		Duel.Draw(tp,1,REASON_RULE)
	end
end