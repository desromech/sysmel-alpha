Extension { #name : #Object }

{ #category : #'*Sysmel-Metamodel' }
Object >> asSysmelValueInEnvironment: anEnvironment [
	^ self sysmelValueWithType: anEnvironment compilationTarget compilerObjectType inEnvironment: anEnvironment
]

{ #category : #'*Sysmel-Metamodel' }
Object >> isSYMLAPSGNode [
	^ false
]

{ #category : #'*Sysmel-Metamodel' }
Object >> sysmelValueWithType: aType inEnvironment: anEnvironment [
	^ SYMLValue new
		value: self;
		type: aType;
		environment: anEnvironment;
		yourself
]
