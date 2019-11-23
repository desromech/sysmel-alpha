Class {
	#name : #MbndSlovimTranslatedTargetSpecificIntrinsic,
	#superclass : #MbndSlovimTranslatedIntrinsicOperation,
	#instVars : [
		'intrinsicConstantBuiltInFunction'
	],
	#classVars : [
		'AdditionalIntrinsicsDictionary',
		'PointerOperationMap'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #'class initialization' }
MbndSlovimTranslatedTargetSpecificIntrinsic class >> initialize [
	AdditionalIntrinsicsDictionary := Dictionary newFromPairs: #(
		#'vector.length2' generateVectorLength2Intrinsic:
		#'vector.cross.2d' generateVectorCross2DIntrinsic:
	).
]

{ #category : #'as yet unclassified' }
MbndSlovimTranslatedTargetSpecificIntrinsic >> generateExpandedMessageSendNode: node with: codeGenerator [
	AdditionalIntrinsicsDictionary at: self intrinsicName ifPresent: [ :selector |
		^ codeGenerator perform: selector with: node
	].
	^ codeGenerator generateExpandedMessageSendNode: node withStaticMethodBoundTo: (self intrinsicConstantBuiltInFunctionWith: codeGenerator)
]

{ #category : #'as yet unclassified' }
MbndSlovimTranslatedTargetSpecificIntrinsic >> intrinsicConstantBuiltInFunctionWith: codeGenerator [
	^ intrinsicConstantBuiltInFunction ifNil: [
		SLVMConstantBuiltInFunction pointerSize: codeGenerator slvmCompilationTarget pointerSize
			name: self intrinsicName
			functionType: (codeGenerator translateType: programEntity boundType).
	]
]
