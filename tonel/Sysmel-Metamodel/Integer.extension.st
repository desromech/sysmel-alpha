Extension { #name : #Integer }

{ #category : #'*Sysmel-Metamodel' }
Integer >> asSysmelValueInEnvironment: anEnvironment [
	^ self sysmelValueWithType: anEnvironment compilationTarget literalIntegerType inEnvironment: anEnvironment
]

{ #category : #'*Sysmel-Metamodel' }
Integer >> generateSysmelSSAPointerConstantOfType: pointerType forModule: module [
	^ SLVMConstant type: pointerType ssaType value: self
]

{ #category : #'*Sysmel-Metamodel' }
Integer >> generateSysmelSSAPointerValueOfType: pointerType with: builder [
	^ builder const: self type: pointerType ssaType.
]

{ #category : #'*Sysmel-Metamodel' }
Integer >> sysmelMangledValue [
	^ 'i' , self printString
]
