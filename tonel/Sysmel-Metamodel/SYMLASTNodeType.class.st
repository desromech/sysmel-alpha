Class {
	#name : #SYMLASTNodeType,
	#superclass : #SYMLCompilationTimeType,
	#category : #Sysmel-Metamodel-Types
}

{ #category : #'meta methods' }
SYMLASTNodeType >> evaluateType: aValue inEnvironment: anEnvironment [
	^ aValue value evaluateTypeInEnvironment: anEnvironment
]

{ #category : #'meta methods' }
SYMLASTNodeType >> evaluateValue: aValue inEnvironment: anEnvironment [
	^ aValue value evaluateInEnvironment: anEnvironment
]

{ #category : #testing }
SYMLASTNodeType >> isASTNode [
	^ true
]

{ #category : #accessing }
SYMLASTNodeType >> name [
	^ #_ASTNode
]
