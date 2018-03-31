Class {
	#name : #SYMLOrderedDictionary,
	#superclass : #OrderedDictionary,
	#category : #Sysmel-Metamodel
}

{ #category : #accessing }
SYMLOrderedDictionary >> at: aKey ifPresent: aPresentBlock ifAbsentPut: anAbsentBlock [
	^ dictionary
		at: aKey
		ifPresent: aPresentBlock
		ifAbsent: [self at: aKey put: anAbsentBlock value]
]
