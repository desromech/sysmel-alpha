Class {
	#name : #MbndClassType,
	#superclass : #MbndAbstractClassType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndClassType class >> typeName [
	^ #_ClassType
]

{ #category : #visiting }
MbndClassType >> accept: aVisitor [
	^ aVisitor visitClassType: self
]

{ #category : #adding }
MbndClassType >> addConversionRulesToPointerType: pointerType [
	pointerType
		addExplicitConversionRule: MbndClassPointerTypeConversionRule new;
		addImplicitConversionRule: MbndClassImplicitUpcastTypeConversionRule new
]

{ #category : #adding }
MbndClassType >> addConversionRulesToReferenceType: referenceType [
	referenceType addImplicitConversionRule: MbndClassImplicitUpcastTypeConversionRule new
]

{ #category : #'testing methods' }
MbndClassType >> isClassType [
	^ true
]
