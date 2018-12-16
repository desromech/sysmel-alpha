Class {
	#name : #SYMLBasicInitializeFunctionPointerReflectionProxy,
	#superclass : #SYMLReflectionProxy,
	#instVars : [
		'type'
	],
	#category : #'Sysmel-Metamodel-Reflection'
}

{ #category : #'as yet unclassified' }
SYMLBasicInitializeFunctionPointerReflectionProxy >> generateSysmelSSAPointerConstantOfType: constantType forModule: targetModule [
	| method |
	method := proxiedObject methodDictionary at: #basicInitialize ifAbsent: [
		^ SLVMConstant nullPointer: constantType ssaType
	].

	^ SLVMConstant pointer: method ssaValue castTo: constantType ssaType
]

{ #category : #'as yet unclassified' }
SYMLBasicInitializeFunctionPointerReflectionProxy >> type [
	^ type ifNil: [ type := proxiedObject compilationTarget basicInitializeFunctionPointerType ]
]
