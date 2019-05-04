"
I am a MoebiusBand basic type that is not necesarily a Smalltalk Behavior.
"
Class {
	#name : #MbndBasicType,
	#superclass : #Object,
	#traits : 'TMbndBasicType',
	#classTraits : 'TMbndBasicType classTrait',
	#instVars : [
		'name',
		'children'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndBasicType class >> typeName [
	^ self == MbndBasicType ifTrue: [ #AnyValue ] ifFalse: [ nil ]
]

{ #category : #adding }
MbndBasicType >> addChild: aChild [
	self assert: aChild parent isNil.
	aChild parent: self.
	self children add: aChild.
]

{ #category : #'as yet unclassified' }
MbndBasicType >> analyzeExpandedMessageNode: node with: analyzer [
	| method |
	method := self lookupOverloadedSelector: node selector value.
	method ifNotNil: [
		^ method analyzeExpandedMessageSendNode: node with: analyzer
	].
	
	"We failed to find the method, then ask the receiver type to interpret this message."
	^ self analyzeUnboundExpandedMessageSendNode: node with: analyzer

]

{ #category : #adding }
MbndBasicType >> children [
	^ children ifNil: [ children := SLVMOrderedInsertionSet new ]
]

{ #category : #accessing }
MbndBasicType >> fullName [
	^ name ifNil: [ ^ self printString ]
]

{ #category : #initialization }
MbndBasicType >> initializeBasicTypeTrait [
	super initialize.
	name := self class typeName.
	flags := #(trait).
]

{ #category : #initialization }
MbndBasicType >> initializeNonTraitType [
	flags ifNil: [ flags := #() ].
	self addDefaultConversionRules.
	self isTrait ifFalse: [
		self initialize
	].
	
]

{ #category : #accessing }
MbndBasicType >> name [
	^ name
]

{ #category : #accessing }
MbndBasicType >> name: anObject [
	name := anObject
]

{ #category : #printing }
MbndBasicType >> printOn: aStream [
	self name ifNotNil: [ :name |
		aStream nextPutAll: name
	] ifNil: [
		^ super printOn: aStream
	]
	
]
