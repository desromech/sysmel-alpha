Class {
	#name : #MbndLiteralAssociationType,
	#superclass : #MbndLiteralValueType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralAssociationType class >> typeName [
	^ #_LiteralAssociation
]

{ #category : #'as yet unclassified' }
MbndLiteralAssociationType >> correctAssociationTypeForNode: node withAnalyzer: analyzer [
	| keyType valueType concreteKeyType concreteValueType concreteAssociationType |
	keyType := node key type.
	valueType := node value type.
	(keyType isLiteralValueType and: [ valueType isLiteralValueType ]) ifTrue: [ ^ node ].
	
	concreteKeyType := keyType bestConcreteTypeForLiteralValueNode: node key inScope: analyzer scope.
	concreteValueType := valueType bestConcreteTypeForLiteralValueNode: node value inScope: analyzer scope.
	concreteAssociationType := concreteKeyType --> concreteValueType.
	self halt.
	
]

{ #category : #'testing methods' }
MbndLiteralAssociationType >> isLiteralAssociationType [
	^ true
]
