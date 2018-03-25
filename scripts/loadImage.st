Metacello new
  baseline: 'Sysmel';
  repository: 'tonel://tonel';
  load.

"Save the image"
(Smalltalk saveAs: 'sysmel')
    ifFalse: [ Smalltalk snapshot: false andQuit: true ].
