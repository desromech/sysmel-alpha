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
	^ codeGenerator generateExpandedMessageSendNode: node withStaticMethodBoundTo: ssaValue
]

{ #category : #accessing }
MbndSlovimTranslatedProgramEntitySSAValue >> ssaValue [
	^ ssaValue
]

{ #category : #accessing }
MbndSlovimTranslatedProgramEntitySSAValue >> ssaValue: anObject [
	ssaValue := anObject
]
