Class {
	#name : #MbndSystemDictionaryContent,
	#superclass : #MbndIdentityDictionaryContent,
	#category : #'SysmelMoebiusMetamodel-Core-Values'
}

{ #category : #'as yet unclassified' }
MbndSystemDictionaryContent >> classForCompilationTarget: compilationTarget [
	^ compilationTarget managedObjectModel systemDictionaryClass
]
