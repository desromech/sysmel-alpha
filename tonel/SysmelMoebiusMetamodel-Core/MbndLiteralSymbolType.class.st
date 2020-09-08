Class {
	#name : #MbndLiteralSymbolType,
	#superclass : #MbndLiteralValueType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralSymbolType class >> typeName [
	^ #_LiteralSymbol
]

{ #category : #converting }
MbndLiteralSymbolType >> asDynamicObjectTypeForLiteral [
	^ self compilationTarget managedObjectModel symbolClass ifNil: [ super asDynamicObjectTypeForLiteral ]
]

{ #category : #'testing methods' }
MbndLiteralSymbolType >> isLiteralSymbolType [
	^ true
]

{ #category : #'semantic analysis' }
MbndLiteralSymbolType >> standardConcreteTypeForLiteralValueNode: literalValueNode inScope: scope [
	^ self compilationTarget standardConcreteTypeForSymbolInScope: scope
]
