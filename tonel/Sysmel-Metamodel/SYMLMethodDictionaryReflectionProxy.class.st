Class {
	#name : #SYMLMethodDictionaryReflectionProxy,
	#superclass : #SYMLTypeReflectionMetadataProxy,
	#category : #'Sysmel-Metamodel-Reflection'
}

{ #category : #'as yet unclassified' }
SYMLMethodDictionaryReflectionProxy >> generateObjectInstance [
	| methodDictionaryClass result methodDictionary allMethods initialCapacity |
	methodDictionaryClass := proxiedObject compilationTarget objectModel methodDictionaryClass.
	methodDictionary := proxiedObject methodDictionary.
	
	allMethods := OrderedCollection new.
	methodDictionary keysAndValuesDo: [ :k :v |
		v addAllAlternativesWithPublicSelector: k into: allMethods
	].
	
	initialCapacity := (allMethods size / 0.8 + 0.5) asInteger.
	result := methodDictionaryClass makeInstance.
	result sysmelPerform: #initializeForCapacity: withArguments: { initialCapacity }.
	
	allMethods do: [ :assoc |
		result sysmelPerform: #at:putNoSpaceCheck: withArguments: { assoc key . assoc value asCompiledMethod }.
	].

	^ result
]
