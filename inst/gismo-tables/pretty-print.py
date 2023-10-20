from os import walk
from re import search
from json import load, dumps

def prettyPrint(i, o):
    with open(i, encoding = 'utf-8-sig') as iFile:
        data = load(iFile)
        json = dumps(data, indent = 4)
        with open(o, 'w', encoding = 'utf8') as oFile:
            oFile.write(json)

for root, dirs, files in walk('.'):
    for file in files:
        if (search(r"\.json$", file)):
            prettyPrint(file, file)

