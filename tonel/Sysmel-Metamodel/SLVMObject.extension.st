Extension { #name : #SLVMObject }

{ #category : #'*Sysmel-Metamodel' }
SLVMObject >> generateSysmelSSAPointerConstantOfType: pointerType forModule: targetModule [
	^ SLVMConstant value: self bitcast: pointerType ssaType
]
