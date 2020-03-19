Class {
	#name : #MbndAstSymbolDefinition,
	#superclass : #MbndAstNode,
	#traits : 'TMbndFlagContainer',
	#classTraits : 'TMbndFlagContainer classTrait',
	#instVars : [
		'name',
		'binding',
		'ownerProgramEntity'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #accessing }
MbndAstSymbolDefinition >> binding [
	^ binding
]

{ #category : #accessing }
MbndAstSymbolDefinition >> binding: anObject [
	binding := anObject
]

{ #category : #serialization }
MbndAstSymbolDefinition >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#flags . flags.
		#name . name encodeGraphForMessagePackWith: graphEncoder.
		#binding. binding encodeGraphForMessagePackWith: graphEncoder.
		#ownerProgramEntity. ownerProgramEntity.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #initialization }
MbndAstSymbolDefinition >> initialize [
	super initialize.
	flags := #().
]

{ #category : #serialization }
MbndAstSymbolDefinition >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	flags := encodedFields at: #flags.
	name := encodedFields at: #name.
	binding := encodedFields at: #binding.
	ownerProgramEntity := encodedFields at: #ownerProgramEntity.
]

{ #category : #accessing }
MbndAstSymbolDefinition >> name [
	^ name
]

{ #category : #accessing }
MbndAstSymbolDefinition >> name: anObject [
	name := anObject
]

{ #category : #accessing }
MbndAstSymbolDefinition >> ownerProgramEntity [
	^ ownerProgramEntity
]

{ #category : #accessing }
MbndAstSymbolDefinition >> ownerProgramEntity: anObject [
	ownerProgramEntity := anObject
]
