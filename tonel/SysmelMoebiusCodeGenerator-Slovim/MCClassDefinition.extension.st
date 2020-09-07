Extension { #name : #MCClassDefinition }

{ #category : #'*SysmelMoebiusCodeGenerator-Slovim' }
MCClassDefinition >> buildMbndASTNodeWith: builder [
	^ builder defineGCClassNamed: name
		superclass: (superclassName ifNotNil: [builder identifier: superclassName])
		body: (self buildMbndBehaviorBodyWith: builder)
]

{ #category : #'*SysmelMoebiusCodeGenerator-Slovim' }
MCClassDefinition >> buildMbndBehaviorBodyWith: builder [
	^ builder sequence: (
		(self classVariables collect: [ :each |
			(builder defineGlobalVariable: each name withValueType: (nil) withInitialValue: nil)
				mutable;
				yourself
		]) ,
		(self instanceVariables collect: [ :each |
			| slot |
			slot := each asSlot.
			(builder defineField: slot name withValueType: nil withInitialValue: nil)
				mutable;
				yourself
		]) ,
	
		{builder unexpandedSend: (builder literalSymbol: #definition:) to: (builder identifier: #meta) withArguments: {builder sequence: (
			(self classInstanceVariables collect: [ :each |
				| slot |
				slot := each asSlot.
				(builder defineField: slot name withValueType: nil withInitialValue: nil)
					mutable;
					yourself
			])	
		)}}
	)
]
