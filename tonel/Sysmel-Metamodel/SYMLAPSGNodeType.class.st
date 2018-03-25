Class {
	#name : #SYMLAPSGNodeType,
	#superclass : #SYMLCompilationTimeType,
	#category : #Sysmel-Metamodel-Types
}

{ #category : #'as yet unclassified' }
SYMLAPSGNodeType >> evaluateType: aValue inEnvironment: anEnvironment [
	^ aValue value evaluateTypeInEnvironment: anEnvironment
]

{ #category : #'as yet unclassified' }
SYMLAPSGNodeType >> evaluateValue: aValue inEnvironment: anEnvironment [
	^ aValue value evaluateInEnvironment: anEnvironment
]

{ #category : #testing }
SYMLAPSGNodeType >> isAPSGNode [
	^ true
]

{ #category : #accessing }
SYMLAPSGNodeType >> name [
	^ #_APSGNode
]

{ #category : #printing }
SYMLAPSGNodeType >> printOn: aStream [
	aStream nextPutAll: self name
]
