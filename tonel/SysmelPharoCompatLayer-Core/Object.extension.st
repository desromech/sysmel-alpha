Extension { #name : #Object }

{ #category : #'*SysmelPharoCompatLayer-Core' }
Object >> castTo: targetType [
	^ targetType validateExplicitCastOfValue: self
]

{ #category : #'*SysmelPharoCompatLayer-Core' }
Object >> implicitCastTo: targetType [
	^ targetType validateImplicitCastOfValue: self
]
