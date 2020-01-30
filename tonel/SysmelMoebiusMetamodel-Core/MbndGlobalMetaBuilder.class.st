Class {
	#name : #MbndGlobalMetaBuilder,
	#superclass : #MbndAbstractVariableMetaBuilder,
	#traits : 'TMbndEntityWithVisibility',
	#classTraits : 'TMbndEntityWithVisibility classTrait',
	#instVars : [
		'constructionPriority'
	],
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndGlobalMetaBuilder class >> globalBindingName [
	^ #global
]

{ #category : #'semantic analysis' }
MbndGlobalMetaBuilder >> concretizeNode: node withAnalyzer: analyzer [
	| result |
	result := (analyzer astBuilder
		defineGlobalVariable: name withValueType: valueType withInitialValue: initialValueNode)
		position: position;
		minimalAlignment: alignment;
		flags: flags;
		constructionPriority: constructionPriority;
		yourself.
	^ analyzer visitNode: result
]

{ #category : #accessing }
MbndGlobalMetaBuilder >> constructionPriority [
	^ constructionPriority
]

{ #category : #accessing }
MbndGlobalMetaBuilder >> constructionPriority: anObject [
	constructionPriority := anObject
]

{ #category : #flags }
MbndGlobalMetaBuilder >> dllexport [
	<compileTime>
	self addFlag: #dllexport
]

{ #category : #flags }
MbndGlobalMetaBuilder >> dllimport [
	<compileTime>
	self addFlag: #dllimport
]

{ #category : #flags }
MbndGlobalMetaBuilder >> externC [
	<compileTime>
	self addFlag: #externC
]

{ #category : #flags }
MbndGlobalMetaBuilder >> threadLocal [
	<compileTime>
	self addFlag: #threadLocal
]
