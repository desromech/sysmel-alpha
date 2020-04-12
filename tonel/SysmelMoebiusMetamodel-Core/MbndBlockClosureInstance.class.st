Class {
	#name : #MbndBlockClosureInstance,
	#superclass : #MbndAbstractValue,
	#traits : 'TMbndSymbolBinding',
	#classTraits : 'TMbndSymbolBinding classTrait',
	#instVars : [
		'closureProgramEntity',
		'capturedValues'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Values'
}

{ #category : #serialization }
MbndBlockClosureInstance class >> messagePackTypeName [
	^ #BlockClosureInstance
]

{ #category : #accessing }
MbndBlockClosureInstance >> capturedValues [
	^ capturedValues
]

{ #category : #accessing }
MbndBlockClosureInstance >> capturedValues: anObject [
	capturedValues := anObject
]

{ #category : #accessing }
MbndBlockClosureInstance >> closureProgramEntity [
	^ closureProgramEntity
]

{ #category : #accessing }
MbndBlockClosureInstance >> closureProgramEntity: anObject [
	closureProgramEntity := anObject
]

{ #category : #serialization }
MbndBlockClosureInstance >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#closureProgramEntity . closureProgramEntity encodeGraphForMessagePackWith: graphEncoder.
		#capturedValues . capturedValues encodeGraphForMessagePackWith: graphEncoder
	}
]

{ #category : #evaluation }
MbndBlockClosureInstance >> evaluateApplicationWithArguments: argumentValues withEvaluator: evaluator at: position [
	^ closureProgramEntity evaluateApplicationWithCapturedValues: capturedValues arguments: argumentValues withEvaluator: evaluator at: position
]

{ #category : #serialization }
MbndBlockClosureInstance >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	closureProgramEntity := encodedFields at: #closureProgramEntity.
	capturedValues := encodedFields at: #capturedValues.
]

{ #category : #accessing }
MbndBlockClosureInstance >> type [
	^ closureProgramEntity type
]

{ #category : #accessing }
MbndBlockClosureInstance >> valueWithArguments: arguments [
	| convertedArguments |
	convertedArguments := arguments collect: [ :each | each asMoebiusValueWithTarget: self compilationTarget ].
	^ self evaluateApplicationWithArguments: convertedArguments withEvaluator: self createEvaluator at: MbndSourcePosition empty
]
