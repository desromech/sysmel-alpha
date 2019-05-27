Class {
	#name : #MbndFieldSetterAccessorMacro,
	#superclass : #MbndAbstractFieldAccessorMacro,
	#category : #'SysmelMoebiusMetamodel-Core-Macro'
}

{ #category : #'as yet unclassified' }
MbndFieldSetterAccessorMacro >> expandMessageNode: node with: analyzer [
	self assert: node arguments size = 1.
	^ analyzer visitNode: (MbndAstSetFieldValueNode new
		aggregate: node receiver;
		field: field;
		newValue: node arguments first;
		yourself)
]
