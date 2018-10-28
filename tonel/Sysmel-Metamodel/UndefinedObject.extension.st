Extension { #name : #UndefinedObject }

{ #category : #'*Sysmel-Metamodel' }
UndefinedObject >> asSysmelSourcePosition [
	^ self
]

{ #category : #'*Sysmel-Metamodel' }
UndefinedObject >> asSysmelValueInEnvironment: anEnvironment [
	^ self sysmelValueWithType: anEnvironment compilationTarget undefinedType inEnvironment: anEnvironment
]

{ #category : #'*Sysmel-Metamodel' }
UndefinedObject >> generateSysmelSSAPointerConstantOfType: pointerType forModule: module [
	^ SLVMConstant type: pointerType ssaType value: 0
]
