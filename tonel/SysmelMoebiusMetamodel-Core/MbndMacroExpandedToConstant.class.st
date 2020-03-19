Class {
	#name : #MbndMacroExpandedToConstant,
	#superclass : #MbndAbstractMacro,
	#instVars : [
		'constantValue'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Macro'
}

{ #category : #serialization }
MbndMacroExpandedToConstant class >> messagePackTypeName [
	^ #MacroExpandedToConstant
]

{ #category : #accessing }
MbndMacroExpandedToConstant >> constantValue [
	^ constantValue
]

{ #category : #accessing }
MbndMacroExpandedToConstant >> constantValue: anObject [
	constantValue := anObject
]

{ #category : #serialization }
MbndMacroExpandedToConstant >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#constantValue . constantValue encodeGraphForMessagePackWith: graphEncoder
	}
]

{ #category : #'as yet unclassified' }
MbndMacroExpandedToConstant >> expandMessageNode: node with: analyzer [
	^ (constantValue asMoebiusLiteralValueNodeWithTarget: analyzer compilationTarget)
		position: node;
		yourself.
]

{ #category : #serialization }
MbndMacroExpandedToConstant >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	constantValue := encodedFields at: #constantValue.
]
