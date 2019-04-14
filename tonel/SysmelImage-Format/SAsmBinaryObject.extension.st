Extension { #name : #SAsmBinaryObject }

{ #category : #'*SysmelImage-Format' }
SAsmBinaryObject >> buildSysmelImageOn: builder [
	sections do: [ :section |
		builder addBinaryObjectSection: section
	].

	symbols do: [ :symbol |
		builder addBinaryObjectSymbol: symbol
	].

	sections do: [ :section |
		builder convertSectionRelocations: section
	]
]

{ #category : #'*SysmelImage-Format' }
SAsmBinaryObject >> generateSysmelImage32 [
	| stream |
	stream := SAsmLirBinaryStream on: (ByteArray new: 100).
	self writeSysmelImage32ToStream: stream.
	^ stream contents
]

{ #category : #'*SysmelImage-Format' }
SAsmBinaryObject >> generateSysmelImage64 [
	| stream |
	stream := SAsmLirBinaryStream on: (ByteArray new: 100).
	self writeSysmelImage64ToStream: stream.
	^ stream contents
]

{ #category : #'*SysmelImage-Format' }
SAsmBinaryObject >> writeSysmelImage32ToFileNamed: aFileName [
	aFileName asFileReference binaryWriteStreamDo: [ :out |
		out
			truncate;
			nextPutAll: self generateSysmelImage32
	]
]

{ #category : #'*SysmelImage-Format' }
SAsmBinaryObject >> writeSysmelImage32ToStream: stream [
	| builder |
	builder := SYMLImageFileBuilder32 new.
	self buildSysmelImageOn: builder.
	builder writeToStream: stream
]

{ #category : #'*SysmelImage-Format' }
SAsmBinaryObject >> writeSysmelImage64ToFileNamed: aFileName [
	aFileName asFileReference binaryWriteStreamDo: [ :out |
		out
			truncate;
			nextPutAll: self generateSysmelImage64
	]
]

{ #category : #'*SysmelImage-Format' }
SAsmBinaryObject >> writeSysmelImage64ToStream: stream [
	| builder |
	builder := SYMLImageFileBuilder64 new.
	self buildSysmelImageOn: builder.
	builder writeToStream: stream
]

{ #category : #'*SysmelImage-Format' }
SAsmBinaryObject >> writeSysmelImageToFileNamed: aFileReference [
	compilationTarget pointerSize = 4 ifTrue: [
		^ self writeSysmelImage32ToFileNamed: aFileReference
	] ifFalse: [
		^ self writeSysmelImage64ToFileNamed: aFileReference
	]
]
