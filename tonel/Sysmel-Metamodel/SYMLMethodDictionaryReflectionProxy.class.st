Class {
	#name : #SYMLMethodDictionaryReflectionProxy,
	#superclass : #SYMLTypeReflectionMetadataProxy,
	#category : #'Sysmel-Metamodel-Reflection'
}

{ #category : #'as yet unclassified' }
SYMLMethodDictionaryReflectionProxy >> generateMetadataObjectInstance [
	| methodDictionaryClass result methodDictionary allMethods initialCapacity |
	methodDictionaryClass := proxiedType compilationTarget objectModel methodDictionaryClass.
	methodDictionary := proxiedType methodDictionary.
	
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
