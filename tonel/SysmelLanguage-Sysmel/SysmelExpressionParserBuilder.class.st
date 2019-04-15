Class {
	#name : #SysmelExpressionParserBuilder,
	#superclass : #Object,
	#instVars : [
		'currentTerm',
		'operators',
		'currentGroupType'
	],
	#category : #'SysmelLanguage-Sysmel-Parser'
}

{ #category : #specifying }
SysmelExpressionParserBuilder >> buildLeftOperatorGroup [
	| operatorChoice group |
	operators ifEmpty: [ ^ self ].
	
	operatorChoice := self buildOperatorChoice.

	group := PP2DelegateNode new.
	group child: (currentTerm , (operatorChoice , currentTerm) star ==> [ :terms |
		| result operatorWithAction operator action nextTerm |
		result := terms first.
		terms second do: [ :operatorWithActionAnTerm |
			operatorWithAction := operatorWithActionAnTerm first.
			operator := operatorWithAction first.
			action := operatorWithAction second.
			nextTerm := operatorWithActionAnTerm second.
			
			result := action value: result value: operator value: nextTerm
		].
		result
	]).
	currentTerm := group
]

{ #category : #specifying }
SysmelExpressionParserBuilder >> buildOperatorChoice [
	| operatorChoice |
	operatorChoice := PP2ChoiceNode new.
	operators do: [ :op |
		operatorChoice := operatorChoice / (op first ==> [ :operator | {operator . op second} ])
	].
	^ operatorChoice
]

{ #category : #specifying }
SysmelExpressionParserBuilder >> buildOperatorGroup [
	currentGroupType == #prefix ifTrue: [ ^ self buildPrefixOperatorGroup ].
	currentGroupType == #left ifTrue: [ ^ self buildLeftOperatorGroup ].
	self error
]

{ #category : #specifying }
SysmelExpressionParserBuilder >> buildPrefixOperatorGroup [
	| operatorChoice group |
	operators ifEmpty: [ ^ self ].
	
	operatorChoice := self buildOperatorChoice.
	
	group := PP2DelegateNode new.
	group child: currentTerm / (operatorChoice , group ==> [:terms |
		| operatorAndAction operator action term |
		operatorAndAction := terms first.
		operator := operatorAndAction first.
		action := operatorAndAction second.
		term := terms second.
		
		action value: operator value: term
	]).
	currentTerm := group.

]

{ #category : #specifying }
SysmelExpressionParserBuilder >> finish [
	^ currentTerm
]

{ #category : #specifying }
SysmelExpressionParserBuilder >> group: aBlock [
	operators := OrderedCollection new.
	currentGroupType := nil.
	aBlock value: self.
	self buildOperatorGroup
]

{ #category : #specifying }
SysmelExpressionParserBuilder >> left: operator do: anAction [
	self assert: (currentGroupType isNil or: [currentGroupType == #left]).
	currentGroupType := #left.
	operators add: { operator . anAction }
]

{ #category : #specifying }
SysmelExpressionParserBuilder >> prefix: operator do: anAction [
	self assert: (currentGroupType isNil or: [currentGroupType == #prefix]).
	currentGroupType := #prefix.
	operators add: { operator . anAction }
]

{ #category : #specifying }
SysmelExpressionParserBuilder >> term: aTerm [
	currentTerm := aTerm
]
