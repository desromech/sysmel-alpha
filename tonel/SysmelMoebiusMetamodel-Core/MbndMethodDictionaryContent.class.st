Class {
	#name : #MbndMethodDictionaryContent,
	#superclass : #Object,
	#instVars : [
		'tally',
		'keys',
		'values'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Values'
}

{ #category : #'instance creation' }
MbndMethodDictionaryContent class >> for: requiredSize [
	| requiredCapacity |
	requiredCapacity := (requiredSize / 0.8) ceiling.
	^ self new
		tally: 0;
		keys: (Array new: requiredCapacity);
		values: (Array new: requiredCapacity);
		yourself
]

{ #category : #accessing }
MbndMethodDictionaryContent >> keys [
	^ keys
]

{ #category : #accessing }
MbndMethodDictionaryContent >> keys: anObject [
	keys := anObject
]

{ #category : #'as yet unclassified' }
MbndMethodDictionaryContent >> makeInstanceForCompilationTarget: compilationTarget [
	| instance |
	instance := compilationTarget managedObjectModel methodDictionaryClass makeInstance: 0 identityHash: 0.
	instance
		setField: #tally value: tally;
		setField: #array value: keys;
		setField: #values value: values.
	^ instance
]

{ #category : #accessing }
MbndMethodDictionaryContent >> tally [
	^ tally
]

{ #category : #accessing }
MbndMethodDictionaryContent >> tally: anObject [
	tally := anObject
]

{ #category : #accessing }
MbndMethodDictionaryContent >> values [
	^ values
]

{ #category : #accessing }
MbndMethodDictionaryContent >> values: anObject [
	values := anObject
]

{ #category : #'as yet unclassified' }
MbndMethodDictionaryContent >> withHash: keyHash putKey: key value: value [
	| elementIndex capacity setKeyBlock |
	capacity := keys size.
	elementIndex := (keyHash % capacity) + 1.
	setKeyBlock := [ :i |
		(keys at: i) ifNil: [ 
			keys at: i put: key.
			values at: i put: value.
			tally := tally + 1.
			^ self
		].
		(keys at: i) = key ifTrue: [ 
			keys at: i put: key.
			values at: i put: value..
			^ self
		].
	].

	elementIndex to: capacity do: setKeyBlock.
	1 to: elementIndex - 1 do: setKeyBlock.

]
