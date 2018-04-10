Class {
	#name : #SYMLStructureScope,
	#superclass : #SYMLAbstractTypeScope,
	#category : #'Sysmel-Metamodel-Scope'
}

{ #category : #adding }
SYMLStructureScope >> addFieldVariable: field at: aPosition [
	^ programEntity addFieldVariable: field at: aPosition
]

{ #category : #accessing }
SYMLStructureScope >> fillSymbols [
	super fillSymbols.
	symbols at: #field put: (SYMLMetaBuilder for: SYMLFieldVariable module: programEntity module parent: programEntity)
]
