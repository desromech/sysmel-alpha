Class {
	#name : #SYMLType,
	#superclass : #SYMLTypeBase,
	#traits : 'TSYMLType',
	#classTraits : 'TSYMLType classTrait',
	#instVars : [
		'ssaType'
	],
	#classVars : [
		'ArithmeticCoercionTable',
		'ArithmeticSelectors',
		'BitwiseSelectors',
		'ComparisonSelectors'
	],
	#category : #Sysmel-Metamodel-Types
}

{ #category : #'as yet unclassified' }
SYMLType class >> buildCoercionRuleTable: aClass [
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
]

{ #category : #'as yet unclassified' }
SYMLType class >> buildCoercionTables [
	ArithmeticCoercionTable := self buildCoercionRuleTable: SYMLArithmeticCoercionRules
]

{ #category : #initialization }
SYMLType class >> initialize [
	ArithmeticSelectors := #(+ - * / %).
	BitwiseSelectors := #(& | ^ << >> bitAnd: bitOr: bitXor: bitShift: ).
	ComparisonSelectors := #(< > <= >= = ~= == ~~).
	self buildCoercionTables.
	
]

{ #category : #'as yet unclassified' }
SYMLType >> buildSSAType [
	self subclassResponsibility
]

{ #category : #accessing }
SYMLType >> ssaType [
	ssaType ifNil: [ ssaType := self buildSSAType].
	^ ssaType
]

{ #category : #accessing }
SYMLType >> target [
	^ target
]

{ #category : #accessing }
SYMLType >> target: anObject [
	target := anObject
]
