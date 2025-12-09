/* Global operator ignores/renames */

//CSharp,being a reference semantic language, doesn't really have a concept of copy-assignment.
%ignore operator=;

// CSharp tends to use !Equals() for this, rather than !=, arguably there could be variant native
// implementations but I don't think that theoretical is worth the complexity tradeoff.
%ignore operator!=;