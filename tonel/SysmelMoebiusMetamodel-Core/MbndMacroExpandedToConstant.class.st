Class {
	#name : #MbndMacroExpandedToConstant,
	#superclass : #MbndAbstractMacro,
	#instVars : [
		'constantValue'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Macro'
}

{ #category : #accessing }
MbndMacroExpandedToConstant >> constantValue [
	^ constantValue
]

{ #category : #accessing }
MbndMacroExpandedToConstant >> constantValue: anObject [
	constantValue := anObject
]

{ #category : #'as yet unclassified' }
MbndMacroExpandedToConstant >> expandMessageNode: node with: analyzer [
	^ (constantValue asMoebiusLiteralValueNodeWithTarget: analyzer compilationTarget)
		position: node;
		yourself.
]
