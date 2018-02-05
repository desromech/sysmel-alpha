as yet unclassified
withBreak: newBreakBlock continue: newContinueBlock do: action
	| oldBreak oldContinue |
	oldBreak := breakBlock.
	oldContinue := continueBlock.
	breakBlock := newBreakBlock.
	continueBlock := newContinueBlock.
	action ensure: [
		breakBlock := oldBreak.
		continueBlock := oldContinue.
	]