"
I am a type conversion rule that does not change thet itself, but it only changes its type.
"
Class {
	#name : #MbndIdentityTypeConversionRule,
	#superclass : #MbndAbstractTypeConversionRule,
	#category : #'SysmelMoebiusMetamodel-Core-TypeConversion'
}

{ #category : #visiting }
MbndIdentityTypeConversionRule >> accept: aVisitor [
	^ aVisitor visitIdentityTypeConversionRule: self
]

{ #category : #accessing }
MbndIdentityTypeConversionRule >> coercionCost [
	^ 0
]

{ #category : #'as yet unclassified' }
MbndIdentityTypeConversionRule >> postProcessCastNode: node [
	node expression isLiteralValueNode ifTrue: [ 
		^ node expression copy
			type: node targetType;
			yourself
	].
	^ super postProcessCastNode: node
]
