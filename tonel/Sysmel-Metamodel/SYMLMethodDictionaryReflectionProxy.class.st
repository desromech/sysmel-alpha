Class {
	#name : #SYMLMethodDictionaryReflectionProxy,
	#superclass : #SYMLTypeReflectionMetadataProxy,
	#category : #'Sysmel-Metamodel-Reflection'
}

{ #category : #'as yet unclassified' }
SYMLMethodDictionaryReflectionProxy >> generateObjectInstance [
	| methodDictionaryClass result methodDictionary allMethods initialCapacity keys values tally |
	methodDictionaryClass := proxiedObject compilationTarget objectModel methodDictionaryClass.
	methodDictionary := proxiedObject methodDictionary.
	
	allMethods := OrderedCollection new.
	methodDictionary keysAndValuesDo: [ :k :v |
		v addAllAlternativesWithPublicSelector: k into: allMethods
	].
	
	initialCapacity := (allMethods size / 0.8 + 0.5) asInteger.
	result := methodDictionaryClass makeInstance.
	result sysmelPerform: #initializeForCapacity: withArguments: { initialCapacity }.
	
	keys := result slotNamed: #array.
	values := result slotNamed: #values.
	
	tally := 0.
	allMethods do: [ :assoc |
		tally := tally + (self keys: keys slots last values: values slots last put: assoc)
		"result sysmelPerform: #at:putNoSpaceCheck: withArguments: { assoc key . assoc value asCompiledMethod }"
	].
	result slotNamed: #tally put: tally.
	
	^ result
]

{ #category : #'as yet unclassified' }
SYMLMethodDictionaryReflectionProxy >> keys: keys values: values put: assoc [
	| dictionarySlot key value environment dynobjectType isNewKey |
	environment := proxiedObject definitionEnvironment.
	dynobjectType := environment compilationTarget dynamicObjectType.
	key := ((assoc key asSysmelValueInEnvironment: environment)
				coercedIntoType: dynobjectType at: proxiedObject definitionPosition) value.
	value := assoc value asCompiledMethod.
	
	dictionarySlot := self scanKeys: keys for: key.
	self assert: dictionarySlot > 0.
	
	isNewKey := (keys at: dictionarySlot) isNil.
	
	keys at: dictionarySlot put: key.
	values at: dictionarySlot put: value.
	
	^ isNewKey asBit

]

{ #category : #'as yet unclassified' }
SYMLMethodDictionaryReflectionProxy >> scanKeys: keys for: key [
	| startIndex slotKey |
	startIndex := (key sysmelIdentityHash % keys size) + 1.
	startIndex to: keys size do: [ :i |
		slotKey := keys at: i.
		(slotKey isNil or: [slotKey == key]) ifTrue: [
			^ i
		]
	].

	1 to: startIndex - 1 do: [ :i |
		slotKey := keys at: i.
		(slotKey isNil or: [slotKey == key]) ifTrue: [
			^ i
		]
	].

	^ -1
]
