Class {
	#name : #MbndBlockClosureMacro,
	#superclass : #MbndAbstractMacro,
	#instVars : [
		'block'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Macro'
}

{ #category : #serialization }
MbndBlockClosureMacro class >> messagePackTypeName [
	^ #BlockClosureMacro
]

{ #category : #accessing }
MbndBlockClosureMacro >> block [
	^ block
]

{ #category : #accessing }
MbndBlockClosureMacro >> block: anObject [
	block := anObject
]

{ #category : #serialization }
MbndBlockClosureMacro >> encodeFieldsForMessagePackWith: graphEncoder [
	^ #()
]

{ #category : #accessing }
MbndBlockClosureMacro >> expandMessageNode: node with: analyzer [
	| result |
	result := block cull: node cull: analyzer astBuilder cull: analyzer.
	self assert: result isMbndAstNode.
	block numArgs >= 3 ifFalse: [
		^ analyzer visitNode: result
	].
	^ result
]

{ #category : #testing }
MbndBlockClosureMacro >> isNeverExported [
	^ true
]

{ #category : #serialization }
MbndBlockClosureMacro >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
]
