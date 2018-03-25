Class {
	#name : #SYMLCompilerObjectType,
	#superclass : #SYMLCompilationTimeType,
	#category : #Sysmel-Metamodel-Types
}

{ #category : #'meta evaluation' }
SYMLCompilerObjectType >> generateSSAValue: value withBuilder: aBuilder [
	^ nil
]

{ #category : #testing }
SYMLCompilerObjectType >> isCompilerObjectType [
	^ true
]

{ #category : #'meta methods' }
SYMLCompilerObjectType >> metaMethodForMessage: messageNode  inEnvironment: anEnvironment at: aSourcePosition [
	| receiverValue |
	receiverValue := (messageNode receiver evaluateInEnvironment: anEnvironment) value value.
	^ self findMetaMethodForSelector: messageNode selector inImageReceiver: receiverValue at: aSourcePosition
]

{ #category : #accessing }
SYMLCompilerObjectType >> name [
	^ #_CompilerObject
]

{ #category : #printing }
SYMLCompilerObjectType >> printOn: aStream [
	aStream nextPutAll: self name
]
