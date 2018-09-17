Class {
	#name : #SYMLMethodDictionaryReflectionProxy,
	#superclass : #SYMLTypeReflectionMetadataProxy,
	#category : #'Sysmel-Metamodel-Reflection'
}

{ #category : #'as yet unclassified' }
SYMLMethodDictionaryReflectionProxy >> generateMetadataObjectInstance [
	| methodDictionaryClass result methodDictionary initialCapacity |
	methodDictionaryClass := proxiedType compilationTarget objectModel methodDictionaryClass.
	methodDictionary := proxiedType methodDictionary.
	
	initialCapacity := (methodDictionary size /0.8 + 0.5) asInteger.
	result := methodDictionaryClass makeInstance.
	result sysmelPerform: #initializeForCapacity: withArguments: { initialCapacity }.
	^ result
]
