Class {
	#name : #SYMLClass,
	#superclass : #SYMLAbstractClass,
	#category : #'Sysmel-Metamodel-Type'
}

{ #category : #'as yet unclassified' }
SYMLClass >> typeKindBaseTrait [
	^ self compilationTarget classTypeTrait
]
