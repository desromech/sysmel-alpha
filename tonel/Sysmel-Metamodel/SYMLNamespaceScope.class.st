Class {
	#name : #SYMLNamespaceScope,
	#superclass : #SYMLProgramEntityScope,
	#category : #'Sysmel-Metamodel-Scope'
}

{ #category : #'as yet unclassified' }
SYMLNamespaceScope >> definitionProgramEntity [
	^ programEntity
]

{ #category : #'as yet unclassified' }
SYMLNamespaceScope >> lookMetaMethodSelector: selector [
	(programEntity lookMetaMethodSelector: selector) ifNotNil: [ :metaMethod | ^ metaMethod ].
	^ super lookMetaMethodSelector: selector
	
]
