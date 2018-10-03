Class {
	#name : #SYMLSLVMBuilder,
	#superclass : #SLVMBuilder,
	#instVars : [
		'breakBlock',
		'continueBlock',
		'sysmelModule'
	],
	#category : #'Sysmel-Metamodel-CodeGeneration'
}

{ #category : #accessing }
SYMLSLVMBuilder >> breakBlock [
	^ breakBlock
]

{ #category : #accessing }
SYMLSLVMBuilder >> breakBlock: anObject [
	breakBlock := anObject
]

{ #category : #accessing }
SYMLSLVMBuilder >> continueBlock [
	^ continueBlock
]

{ #category : #accessing }
SYMLSLVMBuilder >> continueBlock: anObject [
	continueBlock := anObject
]

{ #category : #accessing }
SYMLSLVMBuilder >> nativeStringLiteral: string type: targetType [
	| bytes target arrayType structType literalStruct |
	bytes := string utf8Encoded.
	target := self compilationTarget.
	arrayType := target arrayOf: target uint8 size: bytes size.
	
	structType := target anonStructure: { target uintPointer . arrayType }.
	
	literalStruct := SLVMConstant structure: structType slots:  { 
		self const: bytes size type: target uintPointer.
		SLVMConstant array: arrayType blob: bytes
	}.
	
	self assert: targetType isPointerType.
	^ SLVMConstantPointer constant: literalStruct pointerType: targetType
]

{ #category : #accessing }
SYMLSLVMBuilder >> sysmelModule [
	^ sysmelModule
]

{ #category : #accessing }
SYMLSLVMBuilder >> sysmelModule: anObject [
	sysmelModule := anObject
]

{ #category : #'as yet unclassified' }
SYMLSLVMBuilder >> withBreak: newBreakBlock continue: newContinueBlock do: action [
	| oldBreak oldContinue |
	oldBreak := breakBlock.
	oldContinue := continueBlock.
	breakBlock := newBreakBlock.
	continueBlock := newContinueBlock.
	action ensure: [
		breakBlock := oldBreak.
		continueBlock := oldContinue.
	]
]

{ #category : #'as yet unclassified' }
SYMLSLVMBuilder >> withDebugPosition: debugPosition do: aBlock [
	| convertedDebugPosition result |
	self compilationTarget emittingDebugInformation ifFalse: [ ^ aBlock value ].
	debugPosition ifNil: [ ^ aBlock value ].
	convertedDebugPosition := sysmelModule convertDebugPosition: debugPosition.
	self pushDebugSourcePosition: convertedDebugPosition.
	
	allocaBuilder ifNotNil: [ allocaBuilder pushDebugSourcePosition: convertedDebugPosition ].
	
	[ 
		result := aBlock value
	] ensure: [
		self popDebugSourcePosition.
		allocaBuilder ifNotNil: [ allocaBuilder popDebugSourcePosition ]
	].

	^ result
]
