Class {
	#name : #SYMLTypeReflectionMetadataProxy,
	#superclass : #SYMLReflectionProxy,
	#category : #'Sysmel-Metamodel-Reflection'
}

{ #category : #accessing }
SYMLTypeReflectionMetadataProxy >> type [
	^ self objectInstance type
]
