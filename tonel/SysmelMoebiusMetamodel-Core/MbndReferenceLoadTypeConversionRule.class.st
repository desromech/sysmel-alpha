Class {
	#name : #MbndReferenceLoadTypeConversionRule,
	#superclass : #MbndAstRewriteTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #'as yet unclassified' }
MbndReferenceLoadTypeConversionRule >> postProcessCastNode: node [
	^ MbndAstReferenceLoadNode new
		position: node position;
		reference: node expression;
		type: node type;
		yourself
]
