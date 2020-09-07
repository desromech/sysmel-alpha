Class {
	#name : #MbndSlovimTranslatedProgramEntitySSAValue,
	#superclass : #MbndSlovimTranslatedProgramEntity,
	#instVars : [
		'ssaValue'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #'as yet unclassified' }
MbndSlovimTranslatedProgramEntitySSAValue >> generateExpandedMessageSendNode: node with: codeGenerator [
	programEntity intrinsicName ifNotNil: [ :intrinsicName |
		^ codeGenerator generateExpandedMessageSendNode: node withIntrinsicName: intrinsicName
	].
	^ codeGenerator generateExpandedMessageSendNode: node withDeclaredMethod: programEntity
]

{ #category : #accessing }
MbndSlovimTranslatedProgramEntitySSAValue >> ssaValue [
	^ ssaValue
]

{ #category : #accessing }
MbndSlovimTranslatedProgramEntitySSAValue >> ssaValue: anObject [
	ssaValue := anObject
]
