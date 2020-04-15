Class {
	#name : #MbndPublicProgramEntityAccessor,
	#superclass : #MbndAbstractMacro,
	#instVars : [
		'programEntity'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Macro'
}

{ #category : #serialization }
MbndPublicProgramEntityAccessor class >> messagePackTypeName [
	^ #MacroPublicProgramEntityAccessors
]

{ #category : #serialization }
MbndPublicProgramEntityAccessor >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#programEntity . programEntity encodeGraphForMessagePackWith: graphEncoder
	}
]

{ #category : #'as yet unclassified' }
MbndPublicProgramEntityAccessor >> expandMessageNode: node with: analyzer [
	^ programEntity analyzeReferenceNode: node with: analyzer
]

{ #category : #testing }
MbndPublicProgramEntityAccessor >> isPublicProgramEntityAccessor [
	^ true
]

{ #category : #serialization }
MbndPublicProgramEntityAccessor >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	programEntity := encodedFields at: #programEntity.
]

{ #category : #accessing }
MbndPublicProgramEntityAccessor >> programEntity [
	^ programEntity
]

{ #category : #accessing }
MbndPublicProgramEntityAccessor >> programEntity: anObject [
	programEntity := anObject
]
