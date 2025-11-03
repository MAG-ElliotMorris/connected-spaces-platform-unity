/* 
 * Actual black magic. This kills the commas and ressurects them ... wild. Stolen from SWIGS internal macros.
 * #define COMMA , dosen't work in SWIGS preprocessor, tbh this is sort of nicer, does this work in every C preprocessor? 
 */
#define ARGLIST(X...) X
