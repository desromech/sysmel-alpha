Class {
	#name : #MbndGlobalMetaBuilder,
	#superclass : #MbndAbstractVariableMetaBuilder,
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
		flags: flags;
		yourself.
	^ analyzer visitNode: result
]

{ #category : #flags }
MbndGlobalMetaBuilder >> externC [
	<compileTime>
	self addFlag: #externC
]

{ #category : #accessing }
MbndGlobalMetaBuilder >> private [
	<compileTime>
	self addFlag: #private
]

{ #category : #accessing }
MbndGlobalMetaBuilder >> protected [
	<compileTime>
	self addFlag: #protected
]

{ #category : #accessing }
MbndGlobalMetaBuilder >> public [
	<compileTime>
	self addFlag: #public
]
