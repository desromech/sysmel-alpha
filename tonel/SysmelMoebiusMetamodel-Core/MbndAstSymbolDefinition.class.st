Class {
	#name : #MbndAstSymbolDefinition,
	#superclass : #MbndAstNode,
	#instVars : [
		'name',
		'flags',
		'binding'
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

{ #category : #accessing }
MbndAstSymbolDefinition >> flags [
	^ flags
]

{ #category : #accessing }
MbndAstSymbolDefinition >> flags: anObject [
	flags := anObject
]

{ #category : #testing }
MbndAstSymbolDefinition >> hasFlag: aFlag [
	^ flags includes: aFlag
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
