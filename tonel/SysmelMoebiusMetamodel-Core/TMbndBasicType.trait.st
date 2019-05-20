Trait {
	#name : #TMbndBasicType,
	#instVars : [
		'supertype',
		'type'
	],
	#traits : 'TMbndType + TMbndMethodContainer + TMbndObjectWithFlags + TMbndSymbolContainer',
	#classTraits : 'TMbndType classTrait + TMbndMethodContainer classTrait + TMbndObjectWithFlags classTrait + TMbndSymbolContainer classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
TMbndBasicType >> analyzeExpandedMessageNode: node with: analyzer [
	| method |
	method := self lookupOverloadedSelector: node selector value.
	method ifNotNil: [
		^ method analyzeExpandedMessageSendNode: node with: analyzer
	].
	
	"We failed to find the method, then ask the receiver type to interpret this message."
	^ self analyzeUnboundExpandedMessageSendNode: node with: analyzer

]

{ #category : #testing }
TMbndBasicType >> isTrait [
	^ self hasFlag: #trait
]

{ #category : #'macro expansion' }
TMbndBasicType >> lookupOverloadedSelector: aSelector [
	| method |
	method := self overloadedMethodDict at: aSelector ifAbsent: [ nil ].
	method ifNotNil: [ ^ method ].
	^ self supertype ifNotNil: [ :st | st lookupOverloadedSelector: aSelector ]
]

{ #category : #'macro expansion' }
TMbndBasicType >> lookupSelector: aSelector [
	| method |
	method := self methodDict at: aSelector ifAbsent: [ nil ].
	method ifNotNil: [ ^ method ].
	^ self supertype ifNotNil: [ :st | st lookupSelector: aSelector ]
]

{ #category : #'member symbols' }
TMbndBasicType >> lookupSymbol: aSymbol [
	(self lookupSpecialSymbol: aSymbol) ifNotNil: [ :binding | ^ binding ].
	(self lookupLocalSymbol: aSymbol) ifNotNil: [ :binding | ^ binding ].
	^ self supertype ifNotNil: [ :st | st lookupSymbol: aSymbol ]
]

{ #category : #'type hierarchy' }
TMbndBasicType >> supertype [
	^ supertype
]

{ #category : #accessing }
TMbndBasicType >> supertype: aType [
	supertype ifNotNil: [
		supertype subtypeRemoved: self
	].

	supertype := aType.
	
	supertype ifNotNil: [
		supertype subtypeAdded: self
	].

]

{ #category : #'type hierarchy' }
TMbndBasicType >> type [
	^ type
]

{ #category : #accessing }
TMbndBasicType >> type: aType [
	type := aType
]
