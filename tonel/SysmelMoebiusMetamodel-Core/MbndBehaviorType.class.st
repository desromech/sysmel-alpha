Class {
	#name : #MbndBehaviorType,
	#superclass : #MbndBasicType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndBehaviorType class >> typeName [
	^ #_BehaviorType
]

{ #category : #visiting }
MbndBehaviorType >> accept: aVisitor [
	^ aVisitor visitBehaviorType: self
]

{ #category : #initialization }
MbndBehaviorType >> addInstanceMacros [
	self class == MbndBehaviorType ifFalse: [ ^ self ].
	self isTrait ifFalse: [ ^ self ].
	
	self
		onMacroSelectors: #( definition: extend: )do: [ :node :builder |
			builder programEntity: node receiver extension: node arguments first
		]
]
