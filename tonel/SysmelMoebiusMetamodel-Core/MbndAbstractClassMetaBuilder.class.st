Class {
	#name : #MbndAbstractClassMetaBuilder,
	#superclass : #MbndAbstractTypeMetaBuilder,
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #accessing }
MbndAbstractClassMetaBuilder >> superclass: superClassNode [
	superTypeNode := superClassNode.
	self ensureTypeDefinitionNode.
]

{ #category : #'as yet unclassified' }
MbndAbstractClassMetaBuilder >> weakSubclass [
	self addFlag: #weakSubclass
]
