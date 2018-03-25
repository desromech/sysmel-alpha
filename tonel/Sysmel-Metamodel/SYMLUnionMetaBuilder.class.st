Class {
	#name : #SYMLUnionMetaBuilder,
	#superclass : #SYMLStructMetaBuilder,
	#category : #Sysmel-Metamodel-MetaBuilders
}

{ #category : #accessing }
SYMLUnionMetaBuilder >> name [
	^ #union
]

{ #category : #'meta methods' }
SYMLUnionMetaBuilder >> structureClass [
	^ SYMLUnion
]
