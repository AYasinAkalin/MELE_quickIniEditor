#!/usr/bin/env python
"""editors.py: Defines two classes: Editor and EditorPlus
cls Editor parses content of a single `.txt` file at ./MOD/ directory
    and apply changes to respective temporary copy of original `.ini` file.
cls EditorPlus parses several files given at it, changes several `.ini` files.
"""
__version__ = "1.1"
__author__ = "A. Yasin Akalın"
__credits__ = ""
__license__ = "GNU General Public License v3.0"
__date__ = "2021-05-18"


class Editor(object):
    """Editor reflects changes of one `.txt` file inside MOD folder
    to respective `.ini` file currently hold at TEMP folder.
    An Editor object takes two arguments.
    str targetFile: Path to file to be modified.
    list modificationList: List of tuples read from a `.txt` file ./MOD
        These tuples have string pairs called vanillaString, modificationString (or modString).
        vanillaString + ";;" + modString produces one line inside the `.txt` file
    """

    def __init__(self, targetFile="", modificationList=[]):
        super(Editor, self).__init__()
        self.targetFile = targetFile
        self.modificationList = modificationList
        self.fileContent = ""

    def change_file(self, targetFile):
        self.targetFile = targetFile

    def change_modifications(self, modificationList):
        self.modificationList = modificationList

    def _parse_single_modification_line(self, *args):
        '''
        Either pass two strings or one tuple of two strings to this method
        '''
        findings = {
            "willDiscard": False,
            "isAddition": False,
            "isSnipeModification": False,
            "vanilla": "",
            "modification": "",
            "section": ""
        }
        v = m = ""
        if len(args) == 1 and type(args[0]) is tuple:
            v = args[0][0]
            m = args[0][1]
        elif len(args) == 2 and isinstance(args[1], str):
            v = args[0]
            m = args[1]
        else:
            # Passed arguments are incorrect.
            # TODO 006: Throw an exception here
            return False
        m = m.rstrip()  # Clean whitespace at the end if any
        delimiterIndex = m.find("@[")
        if len(v) == 0 or v.isspace():
            # Could be add new option
            findings["isAddition"] = True
            if len(m) < 7:
                # Mod line is too short. A minimum mod string is 7 chars long if addition will occur.
                '''Example mod string for addition:                bEnableFireworks=True@[DLC05.Celebrations]
                Shortest possible example mod string for addition: k=1@[S]
                "k" is the key
                "1" is the value
                "@" is a part of syntax signalling a section name is coming
                "S" is the name of the section in .ini file that this new key and value should be added to'''
                findings["willDiscard"] = True
                # TODO 003: Add an throw exception here
                pass
            elif delimiterIndex == -1 and m[-1] != "]":
                # Either a section name is not given or the syntax is wrong
                findings["willDiscard"] = True
                # TODO 004: Add an throw exception here
                pass
            else:
                sectionName = m[delimiterIndex+2:-1]
                if not sectionName.isspace() and len(sectionName) > 0:
                    findings["modification"] = m[:delimiterIndex]
                    findings["section"] = sectionName
                else:
                    findings["willDiscard"] = True
        elif len(m) == 0 or m.isspace() or len(m[:delimiterIndex]) == 0 or m[:delimiterIndex].isspace():
            # Modification part is empty or there is not key-value pair in there
            findings["willDiscard"] = True
        else:
            # Standard single line modification. There is vanilla string. There is mod string.
            findings["vanilla"] = v
            if m.rfind("@[") != -1 and m[-1] == "]":
                # Mod string has section name attached.
                findings["modification"] = m[:delimiterIndex]
                findings["section"] = m[delimiterIndex+2:-1]
                findings["isSnipeModification"] = True
            else:
                # Mod string has section no name attached.
                findings["modification"] = m
        return findings

    def process(self, resetAfter=True):
        self._read(self.targetFile)
        for m in self.modificationList:
            dic = self._parse_single_modification_line(m)
            if dic == False or dic["willDiscard"]:
                # Status: Omitting modicifation
                # Reason: Either no parsed dictionary to process or this line's syntax is wrong
                continue

            if dic["isAddition"]:
                # Status: Add a new option
                # Reason: Vanilla string is empty, mod string is present, section name is present
                self._add_option(dic["section"], dic["modification"])
                continue
            # if dic["section"] is present it means user wants to replace an option under a certain section
            # TODO: Search for option under that section
            '''
            DONE 1) Check if dic[section] is present
            DONE 2a) If not present, continue with classic modification. Search the whole document. Don't go to step 3.
            DONE 2b) if so, find the section header
            DONE 3) Find the next section.
            DONE 4) If next section is not found put the next_section_pointer to the end of the document
            DONE 5) Search for option between this_section_pointer and next_section_pointer
            DONE 6) If found, do this check and proceed with modification: `if index != -1 and self.fileContent[index+len(dic["vanilla"])] == "\n":`
            '''
            if dic["isSnipeModification"]:
                # This If block is when modification will be made in a specific
                # section
                # It requires several more steps than normal modification.
                # First we search for the section header, then we find the next
                # section header to know where our section starts and end.
                # Then we search for our vanillaString in substring of fileString
                # If found we split the fileString into parts,
                # do the replacement where our section is, then combine the parts
                # DEBUG
                # print("SNIPE MODIFICATION WILL BE MADE")
                thisSection = self._find_section(dic["section"])
                if thisSection == -1:
                    # TODO: Section not found, raise error
                    # DEBUG
                    # print("Section", dic["section"], "is not found!")
                    continue
                nextSection = self.__go_to_next_section(thisSection)
                if nextSection > thisSection:
                    # Next section is found. Searching as usual.
                    iRelative = self.fileContent[thisSection:nextSection].find(
                        dic["vanilla"])
                else:
                    # Current section is the last section. Searching until end of file.
                    iRelative = self.fileContent[thisSection:].find(
                        dic["vanilla"])
                    nextSection
                # An index is found but it is relative, to section header's pos
                if iRelative != -1 and self.fileContent[thisSection+iRelative+len(dic["vanilla"])] == "\n":
                    # Status: Proceeding with modicifation
                    # Reason: Given vanilla string's exact copy in given
                    #   section is found
                    # DEBUG
                    # print("All checks are done. Proceeding to replacement.")
                    if nextSection > thisSection:
                        # Split fileContent into three parts
                        # make modification in the middle part
                        # then combine all
                        self.fileContent = self.fileContent[:thisSection] \
                            + self.fileContent[thisSection:nextSection].replace(
                                dic["vanilla"], dic["modification"]) \
                            + self.fileContent[nextSection:]
                    else:
                        # Split fileContent into two
                        # make modification in the last part
                        # then combine
                        self.fileContent = self.fileContent[:thisSection] \
                            + self.fileContent[thisSection:].replace(
                                dic["vanilla"], dic["modification"])
                    # DEBUG
                    # print("Replacement done!")
                elif iRelative != -1:
                    # Status: Omitting modification
                    # Reason: Given vanilla string in given section is found
                    #   but original value is longer
                    # DEBUG
                    # print("Omitting modification. Given vanillaString is found but it's value is different in the file")
                    pass
                else:
                    # Status: Omitting modicifation
                    # Reason: Given vanilla line is not found in given section
                    # DEBUG
                    # print("Omitting modification. Given vanillaString is NOT found")
                    pass
                continue
            # DEBUG, use to debug SNIPE MODIFICATION
            # print("Out of SNIPE MODIFICATION SCOPE.")
            # print("You shouldn't have seen this messages.")
            index = self.fileContent.find(dic["vanilla"])
            if index != -1 and self.fileContent[index+len(dic["vanilla"])] == "\n":
                # Status: Proceeding with modicifation
                # Reason: Given vanilla string's exact copy is found
                self.fileContent = self.fileContent.replace(
                    dic["vanilla"], dic["modification"])
            elif index != -1:
                # Status: Omitting modification
                # Reason: Given vanilla string is found but original value is longer
                pass
            else:
                # Status: Omitting modicifation
                # Reason: Given vanilla line is not found
                pass
            '''
            .replace() function is not robust. it doesn't look for whole line. It can omit extra info
            For example using the modification line "GameName=Mass Effect;;GameName=Mass Effect 655",
            program changes "GameName=Mass Effect" to "GameName=Mass Effect 655" as intented.

            Now if the program runs again with the same modification line, one would expect this modification
            to not be done because (1) in the game ini file, there isn't a "GameName=Mass Effect" line but
            "GameName=Mass Effect 655"; (2) that modification is already been made before.

            Yet when the program runs, and when m is ("GameName=Mass Effect", "GameName=Mass Effect 655")
            .replace(m[0], m[1]) function looks for "GameName=Mass Effect" inside .ini file and finds it
            as a part of "GameName=Mass Effect 655", changes the whole line inside .ini to
            "GameName=Mass Effect 655 655"

            This is an unwanted behaviour and should be fixed.
            '''
        self._write(self.targetFile, self.fileContent)
        if resetAfter:
            self._reset()

    def _read(self, file, mode="r+"):
        with open(file, mode) as f:
            self.fileContent = f.read()

    def _write(self, file, content, mode="w"):
        with open(file, mode) as f:
            f.write(content)

    def _reset(self):
        self.targetFile = ""
        self.modificationList = []
        self.fileContent = ""

    def _move_cursor_to_header_end(self, cursorPosition, sectionName):
        '''Moves cursor position to end section header
        assuming given cursorPosition is at the beginning of the section header.'''
        return cursorPosition+len(sectionName)+2  # +2 is for right and left brackets in a section header

    def _find_section(self, sectionName):
        # pos is pointing at the beginning of section head
        pos = self.fileContent.find("["+sectionName+"]")
        if pos != -1:
            return self._move_cursor_to_header_end(pos, sectionName)
        else:
            return pos  # No section is found. Returning -1.

    def __go_to_next_section(self, cursorPosition):
        ''' Finds the index of starting point of the next section from given position.
        Returns cursorPosition-1 if current section is the last.'''
        return cursorPosition + self.fileContent[cursorPosition:].find("\n[")

    def _create_section(self, sectionName):
        '''Creates a section header with given name at the end'''
        self.fileContent = self.fileContent + "\n["+sectionName+"]"

    def _add_option(self, sectionName, modificationString):
        '''An option is a key-value pair under a section in a .ini file.
        This method adds a new option under a given section.
        An option must passed as a string called modificationString in "somerandomkeyname=value" format.'''
        pos = self._find_section(sectionName)
        if pos == -1:
            # New section. No duplicates. Proceed.
            self._create_section(sectionName)
            self.fileContent = self.fileContent + "\n"+modificationString+"\n"
        else:
            # Addition to existing section. There might be duplicates.
            nextSection = self.__go_to_next_section(pos)
            if nextSection > pos:
                # Next section is found. Searching as usual.
                duplicateGuard = self.fileContent[pos:nextSection].find(
                    modificationString)
            else:
                # Current section is the last section. Searching until end of file.
                duplicateGuard = self.fileContent[pos:].find(
                    modificationString)
            if duplicateGuard == -1:
                # Status: Proceeding to add a new option
                # Reason: Section exists. No duplicate of mod string in this section.
                self.fileContent = self.fileContent[:pos] + \
                    "\n"+modificationString + self.fileContent[pos:]
            else:
                # Status: Omitting addition
                # Reason: A duplicate of mod string in this section exists
                pass

    def get_file(self):
        return self.targetFile

    def get_modificationList(self):
        return self.modificationList


class EditorPlus(Editor):
    """Extended class from cls Editor.
    EditorPlus is created to process several files at once."""

    def __init__(self):
        super(EditorPlus, self).__init__()
        self.files = []
        self.modLists = []

    def add_file(self, file):
        self.files.append(file)

    def add_modifications(self, modificationList):
        self.modLists.append(modificationList)

    def import_editor_info(self, editor):
        self.add_file(editor.get_file())
        self.add_modifications(editor.get_modificationList())

    def process_many(self, resetAfter=True):
        for f, mList in zip(self.files, self.modLists):
            self.change_file(f)
            self.change_modifications(mList)
            self.process()
        self._reset_plus()

    def _reset_plus(self):
        self._reset()
        self.files = []
        self.modLists = []
