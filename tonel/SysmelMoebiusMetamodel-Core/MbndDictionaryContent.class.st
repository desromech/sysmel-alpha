Class {
	#name : #MbndDictionaryContent,
	#superclass : #Object,
	#instVars : [
		'tally',
		'keys',
		'values'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Values'
}

{ #category : #'instance creation' }
MbndDictionaryContent class >> for: requiredSize [
	| requiredCapacity |
	requiredCapacity := (requiredSize / 0.8) ceiling.
	^ self new
		tally: 0;
		keys: (Array new: requiredCapacity);
		values: (Array new: requiredCapacity);
		yourself
]

{ #category : #'as yet unclassified' }
MbndDictionaryContent >> classForCompilationTarget: compilationTarget [
	self subclassResponsibility
]

{ #category : #accessing }
MbndDictionaryContent >> keys [
	^ keys
]

{ #category : #accessing }
MbndDictionaryContent >> keys: anObject [
	keys := anObject
]

{ #category : #'as yet unclassified' }
MbndDictionaryContent >> makeInstanceForCompilationTarget: compilationTarget [
	| instance |
	instance := (self classForCompilationTarget: compilationTarget) makeInstance: 0 identityHash: 0.
	instance
		setField: #tally value: tally;
		setField: #array value: values.
	^ instance
]

{ #category : #accessing }
MbndDictionaryContent >> tally [
	^ tally
]

{ #category : #accessing }
MbndDictionaryContent >> tally: anObject [
	tally := anObject
]

{ #category : #accessing }
MbndDictionaryContent >> values [
	^ values
]

{ #category : #accessing }
MbndDictionaryContent >> values: anObject [
	values := anObject
]

{ #category : #'as yet unclassified' }
MbndDictionaryContent >> withHash: keyHash putKey: key value: value [
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
