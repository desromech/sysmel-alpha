import functools

Blacklist = [
    'NativeMethodDispatchTrampoline',
    'ObjectMethodDispatchTrampoline',
    'DynamicFunctionCallAdapter',
]

SpecialNameSubstituion = {
    '..meta..' : '[[Meta]]',
    '..m..' : '[[Module]]',
    '..sysmel.module.startUp..' : '[[ModuleStartup]]',
}

TypeSubstitutionDictionary = {
    'Sysmel.Core::Smalltalk::ProtoObject*' : '_Dynobject',

    'void' : 'Void',
    'unsigned long' : 'UInt64',
}

def isBlackListed(string):
    if string is None:
        return False
    for prefix in Blacklist:
        if string.startswith(prefix):
            return True
    return False

def cleanEntityNameComponent(component):
    if component.startswith('..'):
        return SpecialNameSubstituion.get(component, component)
    if component.startswith('.'):
        return '[' + component[1:].replace('.', ':') + ']'
    return component

def cleanEntityNameComponents(nameComponents):
    if len(nameComponents) <= 1:
        return nameComponents[0]
    return '[' + nameComponents[0] + ']' + functools.reduce(lambda a,b: a + "::" + b, map(cleanEntityNameComponent, nameComponents[1:]))

def cleanType(typeStr):
    if typeStr in TypeSubstitutionDictionary:
        return TypeSubstitutionDictionary[typeStr]

    typeComponents = typeStr \
        .replace('*', ' pointer') \
        .replace('&&', ' tempRef') \
        .replace('&', ' ref') \
        .split('::')
    return cleanEntityNameComponents(typeComponents)

def cleanFrameArguments(arguments):
    return functools.reduce(lambda a,b: a + ", " + b, map(cleanType, arguments.split(', ')))

class SysmelFrameDecorator(gdb.frames.FrameDecorator):
    def function(self):
        name = self.inferior_frame().name()
        if '.' not in name:
            return gdb.frames.FrameDecorator.function(self)

        methodName, lparent, arguments = name.partition('(')
        if methodName in SpecialNameSubstituion:
            return SpecialNameSubstituion[methodName]

        nameComponents = methodName.split('::')
        if lparent == '(':
            return cleanEntityNameComponents(nameComponents) + ' => (' + cleanFrameArguments(arguments[:-1])
        else:
            return cleanEntityNameComponents(nameComponents)

class SysmelTrampolineRemover:
  def __init__(self):
    self.name = "SysmelTrampolineRemover"
    self.enabled = True
    self.priority = 100
    gdb.frame_filters[self.name] = self

  def filter(self, frames):
    for frame in frames:
        name = frame.inferior_frame().name()
        if not isBlackListed(name):
            yield SysmelFrameDecorator(frame)

SysmelTrampolineRemover()
