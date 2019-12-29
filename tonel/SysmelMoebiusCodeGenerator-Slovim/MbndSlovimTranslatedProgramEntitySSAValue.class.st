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
	programEntity pragmaAt: #intrinsic: ifPresent: [ :pragma |
		^ codeGenerator generateExpandedMessageSendNode: node withIntrinsicName: pragma arguments first value
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
