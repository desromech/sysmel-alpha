Class {
	#name : #MbndMethodDictionaryContent,
	#superclass : #MbndIdentityDictionaryContent,
	#category : #'SysmelMoebiusMetamodel-Core-Values'
}

{ #category : #'as yet unclassified' }
MbndMethodDictionaryContent >> classForCompilationTarget: compilationTarget [
	^ compilationTarget managedObjectModel methodDictionaryClass
]

{ #category : #'as yet unclassified' }
MbndMethodDictionaryContent >> makeInstanceForCompilationTarget: compilationTarget [
	| instance |
	instance := (self classForCompilationTarget: compilationTarget) makeInstance: 0 identityHash: 0.
	instance
		setField: #tally value: tally;
		setField: #array value: keys;
		setField: #values value: values.
	^ instance
]
