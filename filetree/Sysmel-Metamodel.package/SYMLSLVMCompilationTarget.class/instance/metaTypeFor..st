composite types
metaTypeFor: aType
	^ metaTypes at: aType ifAbsentPut: [ SYMLMetaType new target: self; instanceType: aType; yourself ]