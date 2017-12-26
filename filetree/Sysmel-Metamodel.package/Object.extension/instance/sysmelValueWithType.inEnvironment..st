*Sysmel-Metamodel
sysmelValueWithType: aType inEnvironment: anEnvironment
	^ SYMLValue new
		value: self;
		type: aType;
		environment: anEnvironment;
		yourself