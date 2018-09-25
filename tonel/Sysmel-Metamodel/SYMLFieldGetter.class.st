Class {
	#name : #SYMLFieldGetter,
	#superclass : #SYMLFieldAccessor,
	#category : #'Sysmel-Metamodel-Macro'
}

{ #category : #'macro compilation' }
SYMLFieldGetter >> evaluateMessage: message inEnvironment: anEnvironment [
	| receiver |
	receiver := message receiver evaluateInEnvironment: anEnvironment.
	self halt
]

{ #category : #'macro compilation' }
SYMLFieldGetter >> generateMessage: messageNode ssaCodeWith: builder [
	| receiverValue |
	receiverValue := messageNode receiver generateSSACodeWith: builder.
	field parent ensureConcreteStructureSSAType.
	^ field ssaReferenceForReceiverValue: receiverValue builder: builder
]

{ #category : #'macro compilation' }
SYMLFieldGetter >> semanticAnalyzeMessage: message inEnvironment: environment at: aPosition [
	| receiver receiverType valueType |
	receiver := message receiver semanticAnalysisInEnvironment: environment.
	receiverType := (receiver evaluateTypeInEnvironment: environment) cleanType.
	valueType := ((receiverType isPointerOrReferenceType and: [field bits isNil])
		ifTrue: [ field referenceType ]
		ifFalse: [field type]).

	^ message copy
		receiver: receiver;
		metaMethod: self;
		coercionType: receiverType;
		valueType: valueType;
		yourself
]
