Class {
	#name : #MbndAstSymbolDefinition,
	#superclass : #MbndAstNode,
	#traits : 'TMbndObjectWithFlags',
	#classTraits : 'TMbndObjectWithFlags classTrait',
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

{ #category : #initialization }
MbndAstSymbolDefinition >> initialize [
	super initialize.
	flags := #().
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
