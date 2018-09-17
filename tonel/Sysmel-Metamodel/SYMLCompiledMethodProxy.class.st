Class {
	#name : #SYMLCompiledMethodProxy,
	#superclass : #SYMLReflectionProxy,
	#instVars : [
		'type'
	],
	#category : #'Sysmel-Metamodel-Reflection'
}

{ #category : #'as yet unclassified' }
SYMLCompiledMethodProxy >> generateSSAValueForModule: aModule [
	^ (proxiedObject ssaValue compiledMethodMetaDataValue)
		type: type ssaType
]

{ #category : #accessing }
SYMLCompiledMethodProxy >> type [
	^ type
]

{ #category : #accessing }
SYMLCompiledMethodProxy >> type: anObject [
	type := anObject
]
