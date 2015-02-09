# Nim Wrapper for LevelDB (HIGH LEVEL WRAPPER STILL NEEDS TO BE WRITTEN)

This is a wrapper for the key-value store 
[LevelDB](https://github.com/google/leveldb), and wraps the C API to provide
basic support for working with LevelDB in Nim.  It's been tested with
LevelDB v1.15 and v1.18 in Linux x86-64.  You have to have the LevelDB library
installed (.so,.dll, etc.) in order for this to work.

## About efficiency of get operations
As has been noted [elsewhere][c-sharp-ldb], the way that LevelDB implements the
C API for looking up values is to:

* Look up the value from the database as a C++ function call
* Copy this value to a non-null terminated char array
* Return the char array with length passed back as in a `size_t` pointer

This is problematic because we're unavoidably doing (if using the C API which
is a stable ABI) an extra copy of the value stored.  On passing this back to Nim,
we will probably want to do a second copy of this so that we can have it as a 
'normal' string type, which is null-terminated, managed by Nim, and has all of
the nice, normal library operations defined.

There's no clean way around this without either wrapping the C++ functions
(and risking breakage), or having a wrapper struct for Nim and losing many
of the pleasant string library functions.  I've chosen to go ahead and do the
extra copy anyway, for two reasons:

1. Most users will not be using LevelDB for intensive, performance-critical 
applications, but instead filling the same role as SQLite (prototyping and
persistence for applications vs. flat files).

2. If implemented as a struct that wraps the value returned from `leveldb_get`,
the first thing that most people would do would be to display the value or pass
it to a another function that takes a string, which would do an implicit
conversion *anyway*.

## Project structure
The wrapper generated from LevelDB's C API is in the `internal` directory, with
tests included; to run tests, compile `leveldb_wrapper.nim` as the main module:
```sh
cd src/internal
nim c -r leveldb_wrapper.nim
```

[c-sharp-ldb]: http://codeofrob.com/entries/the-price-of-abstraction---using-leveldb-in-ravendb.html
