accessing
scapedLanguageContent
	^ (self scapeLanguageContentOpen: $[ close: $]) /
		(self scapeLanguageContentOpen: $( close: $)) /
		(self scapeLanguageContentOpen: ${ close: $})