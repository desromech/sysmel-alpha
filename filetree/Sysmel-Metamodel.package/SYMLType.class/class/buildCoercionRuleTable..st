as yet unclassified
buildCoercionRuleTable: aClass
	| result pragma leftClass rightClass normalBlock reverseBlock |
	result := SYMLTypeCoercionTable new ruleClass: aClass; yourself.
	aClass methodDict values select: [ :method | method hasPragmaNamed: #coerce:with: ] thenDo: [ :method |
		pragma := method pragmaAt: #coerce:with:.
		leftClass := Smalltalk globals at: (#SYML , pragma arguments first) asSymbol.
		rightClass := Smalltalk globals at: (#SYML , pragma arguments second) asSymbol.
		normalBlock := [ :receiver :left :right | method valueWithReceiver: receiver arguments: { left . right } ].
		reverseBlock := [ :receiver :left :right | method valueWithReceiver: receiver arguments: { right . left } ].
		
		result
			addLeftType: leftClass rightType: rightClass action: normalBlock;
			addLeftType: rightClass rightType: leftClass action: reverseBlock
	].

	^ result