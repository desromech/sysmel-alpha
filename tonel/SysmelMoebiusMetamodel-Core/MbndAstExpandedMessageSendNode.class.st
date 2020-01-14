Class {
	#name : #MbndAstExpandedMessageSendNode,
	#superclass : #MbndAstAbstractMessageSendNode,
	#instVars : [
		'method',
		'methodReturnType',
		'storageCreationNode'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstExpandedMessageSendNode >> accept: aVisitor [
	^ aVisitor visitExpandedMessageSendNode: self
]

{ #category : #testing }
MbndAstExpandedMessageSendNode >> isExpandedMessageSendNode [
	^ true
]

{ #category : #'as yet unclassified' }
MbndAstExpandedMessageSendNode >> markStorageCreationNodeForCopyEllision: aStorageCreationNode [
	methodReturnType ifNil: [ ^ self ].
	methodReturnType isMemoryReturnedType ifTrue: [
		storageCreationNode := aStorageCreationNode
	].

]

{ #category : #accessing }
MbndAstExpandedMessageSendNode >> method [
	^ method
]

{ #category : #accessing }
MbndAstExpandedMessageSendNode >> method: anObject [
	method := anObject
]

{ #category : #accessing }
MbndAstExpandedMessageSendNode >> methodReturnType [
	^ methodReturnType
]

{ #category : #accessing }
MbndAstExpandedMessageSendNode >> methodReturnType: anObject [
	methodReturnType := anObject
]

{ #category : #accessing }
MbndAstExpandedMessageSendNode >> storageCreationNode [
	^ storageCreationNode
]
