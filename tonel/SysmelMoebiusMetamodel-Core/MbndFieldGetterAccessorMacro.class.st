Class {
	#name : #MbndFieldGetterAccessorMacro,
	#superclass : #MbndAbstractFieldAccessorMacro,
	#category : #'SysmelMoebiusMetamodel-Core-Macro'
}

{ #category : #'as yet unclassified' }
MbndFieldGetterAccessorMacro >> expandMessageNode: node with: analyzer [
	| receiverType |
	receiverType := node receiver type withoutTopDecorations.
	receiverType isReferenceType ifTrue: [
		^ analyzer visitNode: (MbndAstGetFieldReferenceNode new
			aggregate: node receiver;
			field: field;
			yourself)
	].
	
	^ analyzer visitNode: (MbndAstGetFieldValueNode new
		aggregate: node receiver;
		field: field;
		yourself)

]
