Class {
	#name : #MbndSlovimTranslatedTargetSpecificIntrinsic,
	#superclass : #MbndSlovimTranslatedIntrinsicOperation,
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
	^ codeGenerator generateExpandedMessageSendNode: node withIntrinsicName: self intrinsicName
]
