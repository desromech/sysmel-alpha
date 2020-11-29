Class {
	#name : #MbndAbstractGPUBindings,
	#superclass : #Object,
	#category : #'SysmelMoebiusMetamodel-Core-Directories'
}

{ #category : #accessing }
MbndAbstractGPUBindings class >> location [
	^ MbndAbstractGPUAssets location / 'bindings' / 'sysmel'
]
