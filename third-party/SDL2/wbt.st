self platform name selectCase: {
    #linux -> [
        self importLibrary: 'SDL2' fromDebianPackage: 'libsdl2-dev'.
    ].
    #osx -> [

    ].
    #windows -> [

    ].
    [true] -> [].
}.
