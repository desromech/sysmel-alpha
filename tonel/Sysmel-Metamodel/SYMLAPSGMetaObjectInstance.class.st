Class {
	#name : #SYMLAPSGMetaObjectInstance,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'metaObject'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #'meta evaluation' }
SYMLAPSGMetaObjectInstance >> evaluateInEnvironment: anEnvironment [
	^ metaObject sysmelValueWithType: anEnvironment compilationTarget compilerObjectType inEnvironment: anEnvironment
]

{ #category : #testing }
SYMLAPSGMetaObjectInstance >> isMetaObjectInstance [
	^ true
]

{ #category : #accessing }
SYMLAPSGMetaObjectInstance >> metaObject [
	^ metaObject
]

{ #category : #accessing }
SYMLAPSGMetaObjectInstance >> metaObject: anObject [
	metaObject := anObject
]

{ #category : #printing }
SYMLAPSGMetaObjectInstance >> printOn: aStream [
	aStream nextPutAll: 'metaObject '; print: metaObject
]
