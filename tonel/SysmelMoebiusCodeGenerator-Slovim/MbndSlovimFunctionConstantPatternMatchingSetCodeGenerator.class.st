Class {
	#name : #MbndSlovimFunctionConstantPatternMatchingSetCodeGenerator,
	#superclass : #MbndAstVisitor,
	#traits : 'TMbndSlovimModulePartTranslator',
	#classTraits : 'TMbndSlovimModulePartTranslator classTrait',
	#instVars : [
		'functionCodeGenerator'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #accessing }
MbndSlovimFunctionConstantPatternMatchingSetCodeGenerator >> functionCodeGenerator [
	^ functionCodeGenerator
]

{ #category : #accessing }
MbndSlovimFunctionConstantPatternMatchingSetCodeGenerator >> functionCodeGenerator: anObject [
	functionCodeGenerator := anObject
]

{ #category : #testing }
MbndSlovimFunctionConstantPatternMatchingSetCodeGenerator >> isIntegerConstantType: type [
	type isEnumType ifTrue: [ ^ type baseType isPrimitiveIntegerType ].

	^ type isPrimitiveIntegerType
]

{ #category : #visiting }
MbndSlovimFunctionConstantPatternMatchingSetCodeGenerator >> visitPatternMatchingAnyPatternNode: pattern [
	^ #()
]

{ #category : #visiting }
MbndSlovimFunctionConstantPatternMatchingSetCodeGenerator >> visitPatternMatchingBindingPatternNode: node [
	node valuePattern ifNil: [ ^ #() ].
	^ self visitNode: node valuePattern
]

{ #category : #visiting }
MbndSlovimFunctionConstantPatternMatchingSetCodeGenerator >> visitPatternMatchingIntervalPatternNode: node [
	| type startConstant endConstant |
	type := node matchedType.
	(self isIntegerConstantType: type) ifFalse: [ ^ #() ].
	
	startConstant := functionCodeGenerator visitNode: node start.
	endConstant := functionCodeGenerator visitNode: node stop.
	self assert: startConstant isConstantValue.
	self assert: endConstant isConstantValue.
	^ (startConstant value to: endConstant value) collect: [ :value |
		SLVMConstant type: startConstant type value: value
	]
]

{ #category : #visiting }
MbndSlovimFunctionConstantPatternMatchingSetCodeGenerator >> visitPatternMatchingLiteralValuePatternNode: node [
	(self isIntegerConstantType: node value type) ifFalse: [ ^ #() ].
	
	^ { functionCodeGenerator visitNode: node value }
]

{ #category : #visiting }
MbndSlovimFunctionConstantPatternMatchingSetCodeGenerator >> visitPatternMatchingNeverPatternNode: pattern [
	^ #()
]

{ #category : #visiting }
MbndSlovimFunctionConstantPatternMatchingSetCodeGenerator >> visitPatternMatchingSameValuePatternNode: node [
	^ #()
]

{ #category : #visiting }
MbndSlovimFunctionConstantPatternMatchingSetCodeGenerator >> visitPatternMatchingSetPatternNode: node [
	| type |
	type := node matchedType.
	(self isIntegerConstantType: type) ifFalse: [ ^ #() ].
	^ node elements collect: [ :each | functionCodeGenerator visitNode: each ]
]
