Class {
	#name : #SYMLTypeReflectionMetadataProxy,
	#superclass : #SYMLObject,
	#instVars : [
		'proxiedType',
		'ssaInstanceValue',
		'metadataObjectInstance'
	],
	#category : #'Sysmel-Metamodel-Reflection'
}

{ #category : #'instance creation' }
SYMLTypeReflectionMetadataProxy class >> for: aType [
	^ self new proxiedType: aType
]

{ #category : #'semantic analysis' }
SYMLTypeReflectionMetadataProxy >> evaluateMetaObjectTypeInEnvironment: anEnvironment [
	^ self metadataObjectInstance evaluateMetaObjectTypeInEnvironment: anEnvironment
]

{ #category : #'as yet unclassified' }
SYMLTypeReflectionMetadataProxy >> generateMetadataObjectInstance [
	self subclassResponsibility
]

{ #category : #'code generation' }
SYMLTypeReflectionMetadataProxy >> generateSSAReferenceWith: builder [
	^ self metadataObjectInstance generateSSAReferenceWith: builder
]

{ #category : #'as yet unclassified' }
SYMLTypeReflectionMetadataProxy >> generateSSAValueForModule: aModule [
	^ self metadataObjectInstance generateSSAValueForModule: aModule
]

{ #category : #accessing }
SYMLTypeReflectionMetadataProxy >> metadataObjectInstance [
	^ metadataObjectInstance ifNil: [ metadataObjectInstance := self generateMetadataObjectInstance ]
]

{ #category : #accessing }
SYMLTypeReflectionMetadataProxy >> proxiedType [
	^ proxiedType
]

{ #category : #accessing }
SYMLTypeReflectionMetadataProxy >> proxiedType: anObject [
	proxiedType := anObject
]

{ #category : #accessing }
SYMLTypeReflectionMetadataProxy >> type [
	^ self metadataObjectInstance type
]
