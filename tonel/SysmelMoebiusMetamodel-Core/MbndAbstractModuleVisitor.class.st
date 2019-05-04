Class {
	#name : #MbndAbstractModuleVisitor,
	#superclass : #Object,
	#traits : 'TMbndObject',
	#classTraits : 'TMbndObject classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-Module'
}

{ #category : #visiting }
MbndAbstractModuleVisitor >> visitArrayType: type [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAbstractModuleVisitor >> visitCompileTimeConstant: compileTimeConstant [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAbstractModuleVisitor >> visitCompilerObjectType: type [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAbstractModuleVisitor >> visitConcreteFunctionMethod: method [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAbstractModuleVisitor >> visitConcreteMessageMethod: method [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAbstractModuleVisitor >> visitDecoratedType: type [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAbstractModuleVisitor >> visitFunctionGroupType: type [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAbstractModuleVisitor >> visitFunctionType: type [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAbstractModuleVisitor >> visitGlobalVariable: globalVariable [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAbstractModuleVisitor >> visitModule: module [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAbstractModuleVisitor >> visitNamespace: namespace [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAbstractModuleVisitor >> visitNamespaceType: type [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAbstractModuleVisitor >> visitPointerType: type [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAbstractModuleVisitor >> visitPrimitiveBooleanType: type [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAbstractModuleVisitor >> visitPrimitiveFloatType: type [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAbstractModuleVisitor >> visitPrimitiveIntegerType: type [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAbstractModuleVisitor >> visitReferenceType: type [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAbstractModuleVisitor >> visitReturnType: type [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAbstractModuleVisitor >> visitSimpleMetaType: type [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAbstractModuleVisitor >> visitStructureType: type [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAbstractModuleVisitor >> visitUndefinedType: type [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAbstractModuleVisitor >> visitUnionType: type [
	self subclassResponsibility
]

{ #category : #visiting }
MbndAbstractModuleVisitor >> visitVoidType: type [
	self subclassResponsibility
]