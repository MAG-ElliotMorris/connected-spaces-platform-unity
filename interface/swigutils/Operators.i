/* Global operator ignores/renames */

//CSharp,being a reference semantic language, doesn't really have a concept of copy-assignment.
%ignore operator=;

%rename(Equals) operator==;

// A bit weird exposing this, but it can theoretically be different. 
%rename(NotEquals) operator!=;