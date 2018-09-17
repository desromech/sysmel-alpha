Class {
	#name : #SYMLMethodDictionaryReflectionProxy,
	#superclass : #SYMLTypeReflectionMetadataProxy,
	#category : #'Sysmel-Metamodel-Reflection'
}

{ #category : #'as yet unclassified' }
SYMLMethodDictionaryReflectionProxy >> generateMetadataObjectInstance [
	| methodDictionaryClass result |
	methodDictionaryClass := proxiedType compilationTarget objectModel methodDictionaryClass.
	result := methodDictionaryClass makeInstance.
	^ result
]
