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

{ #category : #accessing }
MbndImageBehaviorType >> behavior [
	^ behavior
]

{ #category : #accessing }
MbndImageBehaviorType >> behavior: aBehavior [
	behavior := aBehavior
]

{ #category : #'type hierarchy' }
MbndImageBehaviorType >> supertype [
	^ behavior superclass ifNotNil: [ :st | st asMoebiusType ]
]

{ #category : #'type hierarchy' }
MbndImageBehaviorType >> type [
	^ behavior class ifNotNil: [ :st | st asMoebiusType ]
]
