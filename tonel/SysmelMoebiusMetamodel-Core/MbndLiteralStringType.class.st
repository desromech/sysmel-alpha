Class {
	#name : #MbndLiteralStringType,
	#superclass : #MbndLiteralValueType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralStringType class >> typeName [
	^ #_LiteralString
]

{ #category : #casting }
MbndLiteralStringType >> createNode: node implicitCastTo: target with: analyzer [
	self flag: 'HACK: Implicit literal string -> to C-String. Implement this properly!!'.
	node isLiteralValueNode ifTrue: [
		(target isPointerType and:
		[ target baseType isConstantType and:
		[ target baseType withoutDecorations isPrimitiveIntegerType and:
		[ target baseType withoutDecorations instanceSize = 1 ]]]) ifTrue: [
			^ node copy
				type: target;
				yourself
		]
	].

	
	^ super createNode: node implicitCastTo: target with: analyzer
]

{ #category : #'testing methods' }
MbndLiteralStringType >> isLiteralStringType [
	^ true
]
