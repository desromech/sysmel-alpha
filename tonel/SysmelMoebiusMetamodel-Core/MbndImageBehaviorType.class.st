Class {
	#name : #MbndImageBehaviorType,
	#superclass : #Object,
	#traits : 'TMbndType',
	#classTraits : 'TMbndType classTrait',
	#instVars : [
		'behavior'
	],
	#category : #'SysmelMoebiusMetamodel-Core-In-Image'
}

{ #category : #'as yet unclassified' }
MbndImageBehaviorType >> analyzeExpandedMessageNode: node with: analyzer [
	| method |
	method := self lookupOverloadedSelector: node selector value.
	method ifNotNil: [
		^ method analyzeExpandedMessageSendNode: node with: analyzer
	].
	
	"We failed to find the method, then ask the receiver type to interpret this message."
	^ self analyzeUnboundExpandedMessageSendNode: node with: analyzer

]

{ #category : #'semantic analysis' }
MbndImageBehaviorType >> analyzeInitializationFromCopyNode: node with: analyzer [
	self hasTrivialInitializationCopyingFrom ifTrue: [
		^ analyzer visitNode: (node asUnexpandedMessageSend
			selector: ((analyzer astBuilder literalSymbol: #assignValue:)
				position: node))
	].
	^ analyzer visitNode: node asExpandedMessageSend
]

{ #category : #accessing }
MbndImageBehaviorType >> behavior [
	^ behavior
]

{ #category : #accessing }
MbndImageBehaviorType >> behavior: aBehavior [
	behavior := aBehavior
]

{ #category : #testing }
MbndImageBehaviorType >> hasTrivialInitializationCopyingFrom [
	^ self hasTrivialInstanceInitializationCopyingFrom
]

{ #category : #testing }
MbndImageBehaviorType >> isPOD [
	^ self hasTrivialBasicInitialization and: [
	  self hasTrivialInitialization and: [
	  self hasTrivialFinalization and: [
	  self hasTrivialInitializationCopyingFrom and: [
	  self hasTrivialInitializationMovingFrom ]]]]
]

{ #category : #testing }
MbndImageBehaviorType >> isPODInstance [
	^ self hasTrivialInstanceBasicInitialization and: [
	  self hasTrivialInstanceInitialization and: [
	  self hasTrivialInstanceFinalization and: [
	  self hasTrivialInstanceInitializationCopyingFrom and: [
	  self hasTrivialInstanceInitializationMovingFrom ]]]]
]

{ #category : #'as yet unclassified' }
MbndImageBehaviorType >> programEntitionInformationData [
	^ self programEntityInformationData
]

{ #category : #'type hierarchy' }
MbndImageBehaviorType >> supertype [
	^ behavior superclass ifNotNil: [ :st | st asMoebiusType ]
]

{ #category : #'type hierarchy' }
MbndImageBehaviorType >> type [
	<compileTime>
	^ behavior class ifNotNil: [ :st | st asMoebiusType ]
]
