"
I am a type that implements the following common functionality:
- Access to the definition module.
- Macro method dictionary.
- Macro method lookup.

"
Trait {
	#name : #TMbndType,
	#instVars : [
		'definitionModule',
		'subtypes'
	],
	#traits : 'TMbndAbstractType + TMbndMacroMethodContainer',
	#classTraits : 'TMbndAbstractType classTrait + TMbndMacroMethodContainer classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
TMbndType >> analyzeExpandedMessageNode: node with: analyzer [
	| method |
	method := self lookupOverloadedSelector: node selector value.
	method ifNotNil: [
		^ method analyzeExpandedMessageSendNode: node with: analyzer
	].
	
	"We failed to find the method, then ask the receiver type to interpret this message."
	^ self analyzeUnboundExpandedMessageSendNode: node with: analyzer

]

{ #category : #accessing }
TMbndType >> definitionModule: aModule [
	definitionModule := aModule
]

{ #category : #'as yet unclassified' }
TMbndType >> lookupMacroSelector: aSelector [
	| macro |
	macro := self macroMethodDict at: aSelector ifAbsent: [ nil ]..
	macro ifNotNil: [ ^ macro ].
	^ self supertype ifNotNil: [ :st | st lookupMacroSelector: aSelector ]
]

{ #category : #accessing }
TMbndType >> module [
	^ definitionModule
]

{ #category : #'type hierarchy' }
TMbndType >> subtypeAdded: aSubtype [
	^ subtypes := (self subtypes copyWithout: aSubtype) copyWith: aSubtype
]

{ #category : #'type hierarchy' }
TMbndType >> subtypeRemoved: aSubtype [
	^ subtypes := self subtypes copyWithout: aSubtype
]

{ #category : #accessing }
TMbndType >> subtypes [
	^ subtypes ifNil: [ subtypes := #() ]
]
