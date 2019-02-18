Extension { #name : #SAsmBinaryObjectSection }

{ #category : #'*Sysmel-ImageFormat' }
SAsmBinaryObjectSection >> convertSymbol: originalSymbol intoSysmelImageSymbolEntry: symbolEntry with: imageBuilder [
	symbolEntry
		sectionDescriptor: (imageBuilder sectionDescriptorFor: originalSymbol section);
		sectionOffset: originalSymbol value

]
