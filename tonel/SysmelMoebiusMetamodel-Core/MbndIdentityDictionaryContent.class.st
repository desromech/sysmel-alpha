Class {
	#name : #MbndIdentityDictionaryContent,
	#superclass : #MbndDictionaryContent,
	#category : #'SysmelMoebiusMetamodel-Core-Values'
}

{ #category : #'as yet unclassified' }
MbndIdentityDictionaryContent >> classForCompilationTarget: compilationTarget [
	^ compilationTarget managedObjectModel identityDictionaryClass
]
