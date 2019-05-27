Class {
	#name : #MbndFieldMetaBuilder,
	#superclass : #MbndAbstractVariableMetaBuilder,
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'semantic analysis' }
MbndFieldMetaBuilder >> concretizeNode: node withAnalyzer: analyzer [
	| result |
	result := (analyzer astBuilder
		defineField: name withValueType: valueType withInitialValue: initialValueNode)
		position: position;
		flags: flags;
		yourself.
	^ analyzer visitNode: result
]

{ #category : #'as yet unclassified' }
MbndFieldMetaBuilder >> private [
	<compileTime>
	self addFlag: #private
]

{ #category : #'as yet unclassified' }
MbndFieldMetaBuilder >> protected [
	<compileTime>
	self addFlag: #protected
]

{ #category : #'as yet unclassified' }
MbndFieldMetaBuilder >> public [
	<compileTime>
	self addFlag: #public
]
