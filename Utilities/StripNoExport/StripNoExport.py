# WARNING. Partially written by AI

from pathlib import Path
import argparse

# CSP headers have macros in them that look like CSP_START_IGNORE and CSP_END_IGNORE
# Strip these blocks suck that they're not in the dst_file.
# Throw an error if we find a non-matching macro
def StripStartEndIgnoreBlocks(text: str) -> str:
    START = "CSP_START_IGNORE"
    END = "CSP_END_IGNORE"
    
    i = 0
    ignoring = False
    result = []

    while i < len(text):
        if not ignoring:
            next_start = text.find(START, i)
            next_end = text.find(END, i)
            
            # END before any START -> unmatched end
            if next_end != -1 and (next_start == -1 or next_end < next_start):
                raise ValueError("Unmatched CSP_END_IGNORE found")
                
            if next_start == -1:
                # no more markers, we're done here.
                result.append(text[i:])
                break
                
            # append everything up to the start marker
            result.append(text[i:next_start])
            # skip the start marker itself
            i = next_start + len(START)
            ignoring = True
        else:
            # currently inside an ignore block: look for END
            next_end = text.find(END, i)
            if next_end == -1:
                raise ValueError("Unmatched CSP_START_IGNORE found")

            # skip everything up through the END marker
            i = next_end + len(END)
            ignoring = False

    # result is a list of string fragments, make it a big ol' string.
    return "".join(result)

def RemoveLines(s: str, lines_to_remove: list[int]) -> str:
    lines = s.splitlines()
    return "\n".join(
        line for i, line in enumerate(lines, start=0) if i not in lines_to_remove
    )

def LineEndSignifiesEndOfNoExportDeclaration(line: str) -> bool:
    return (
             line.endswith(");")
             or line.endswith("}")
             or line.endswith("};")
             or line.endswith("const;")
             or line.endswith("const ;")
             or line.endswith("override;")
             or line.endswith("override ;")
             or line.endswith("= 0;")
           )



# Strip CSP_NO_EXPORT declarations, using a simple bracket counting mechanism 
# and assuming semicolon terminations.
# Should be good enough.
def StripNoExportDeclarations(text: str) -> str:

    linesToZap: list[int] = []
    inExportBlock = False
    i = 0;
    
    openNormalBrackets = 0
    openCurlyBrackets = 0

    for line in text.splitlines():
        if not inExportBlock:
            if line.lstrip().startswith("CSP_NO_EXPORT"):
                linesToZap.append(i)
                
                openNormalBrackets += line.count('(')
                openCurlyBrackets += line.count('{')
                
                openNormalBrackets -= line.count(')')
                openCurlyBrackets -= line.count('}')
                
                # Single line declarations are done, don't start a multiline count
                if not LineEndSignifiesEndOfNoExportDeclaration(line):
                    inExportBlock = True
        else:
            linesToZap.append(i)
            
            openNormalBrackets += line.count('(')
            openCurlyBrackets += line.count('{')
            
            openNormalBrackets -= line.count(')')
            openCurlyBrackets -= line.count('}')
            if LineEndSignifiesEndOfNoExportDeclaration(line) :
                if openNormalBrackets <= 0 and openCurlyBrackets <= 0:
                    if openNormalBrackets > 0:
                        raise ValueError("Mismatched count of normal brackets")
                    if openCurlyBrackets > 0:
                        raise ValueError("Mismatched count of curly brackets")
                    
                    inExportBlock = False
                    openNormalBrackets = 0
                    openCurlyBrackets = 0
                
        i = i+1
    
    # Now we've got all the lines that are CSP_NO_EXPORT declarations, remove them
    return RemoveLines(text, linesToZap)

# Stuff we don't care about. Anything that's auto-translated might go here if it becomes a problem
# Actually important for container types as we need the .begin() stuff which is not exported.
filenames_to_ignore = {"CSPCommon.h", "String.h", "Optional.h", "List.h", "Map.h", "Array.h"}

def main():
    parser = argparse.ArgumentParser(
        description="Strip CSP_START_IGNORE / CSP_END_IGNORE blocks, and CSP_NO_EXPORT declarations, from files."
    )
    parser.add_argument("input_root", help="CSP include root directory")
    parser.add_argument("output_root", help="Stripped CSP include output directory to be created")

    args = parser.parse_args()
    
    src_root = Path(args.input_root)
    dst_root = Path(args.output_root)

    for src_file in src_root.rglob("*.h"):

        if src_file.is_file():
            rel_path = src_file.relative_to(src_root)
            dst_file = dst_root / rel_path

            # Make the directories as we go, we're mirroring the directory structure for the output
            dst_file.parent.mkdir(parents=True, exist_ok=True)

            # Do our transformations
            with src_file.open("r", encoding="utf-8") as f_in, dst_file.open("w", encoding="utf-8") as f_out:
                data = f_in.read()
                modified = data    
                # Don't modify any ignored files
                if src_file.name not in filenames_to_ignore:
                    modified = StripStartEndIgnoreBlocks(data)
                    modified = StripNoExportDeclarations(modified)
 
                f_out.write(modified)
                
if __name__ == "__main__":
    main()