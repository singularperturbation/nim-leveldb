{.deadCodeElim: on.}
when defined(windows):
  const libleveldb="libleveldb.dll"
elif defined(macosx):
  const libleveldb="libleveldb.dylib"
else:
  const libleveldb="libleveldb.so"

{.push pure, final.}
type 
  leveldb_t              = object
  leveldb_cache_t        = object
  leveldb_comparator_t   = object
  leveldb_env_t          = object
  leveldb_filelock_t     = object
  leveldb_filterpolicy_t = object
  leveldb_iterator_t     = object
  leveldb_logger_t       = object
  leveldb_options_t      = object
  leveldb_randomfile_t   = object
  leveldb_readoptions_t  = object
  leveldb_seqfile_t      = object
  leveldb_snapshot_t     = object
  leveldb_writablefile_t = object
  leveldb_writebatch_t   = object
  leveldb_writeoptions_t = object
{.pop.}

type
  LevelDB*      = ptr leveldb_t
  Cache*        = ptr leveldb_cache_t
  Comparator*   = ptr leveldb_comparator_t
  Environment*  = ptr leveldb_env_t
  FileLock*     = ptr leveldb_filelock_t
  FilterPolicy* = ptr leveldb_filterpolicy_t
  Iterator*     = ptr leveldb_iterator_t
  Logger*       = ptr leveldb_logger_t
  Options*      = ptr leveldb_options_t
  RandomFile*   = ptr leveldb_randomfile_t
  ReadOptions*  = ptr leveldb_readoptions_t
  SeqFile*      = ptr leveldb_seqfile_t
  Snapshot*     = ptr leveldb_snapshot_t
  WriteFile*    = ptr leveldb_writablefile_t
  WriteBatch*   = ptr leveldb_writebatch_t
  WriteOptions* = ptr leveldb_writeoptions_t

type
  uint64_t = uint64

const
  leveldb_no_compression*     = 0
  leveldb_snappy_compression* = 1

## DB operations

proc leveldb_open*(options: Options; name: cstring;
                   errptr: cstringArray): LevelDB {.
                                          importc: "leveldb_open",
                                          dynlib: libleveldb.}

proc leveldb_close*(db: LevelDB) {.
     importc: "leveldb_close", dynlib: libleveldb.}

proc leveldb_put*(db: LevelDB; options: WriteOptions;
                  key: cstring; keylen: csize; val: cstring; vallen: csize;
                  errptr: cstringArray) {.
     importc: "leveldb_put", dynlib: libleveldb.}

proc leveldb_delete*(db: LevelDB; options: WriteOptions;
                     key: cstring; keylen: csize; errptr: cstringArray) {.
     importc: "leveldb_delete", dynlib: libleveldb.}

proc leveldb_write*(db: LevelDB; options: WriteOptions;
                    batch: WriteBatch; errptr: cstringArray) {.
     importc: "leveldb_write", dynlib: libleveldb.}

# Returns NULL if not found.  A malloc()ed array otherwise.
#   Stores the length of the array in *vallen. 

proc leveldb_get*(db: LevelDB; options: ReadOptions;
                  key: cstring; keylen: csize; vallen: ptr csize;
                  errptr: cstringArray): cstring {.
     importc: "leveldb_get", dynlib: libleveldb.}

proc leveldb_create_iterator*(db: LevelDB;
                              options: ReadOptions): Iterator {.
     importc: "leveldb_create_iterator", dynlib: libleveldb.}

proc leveldb_create_snapshot*(db: LevelDB): Snapshot {.
     importc: "leveldb_create_snapshot", dynlib: libleveldb.}

proc leveldb_release_snapshot*(db: LevelDB;
                               snapshot: Snapshot) {.
     importc: "leveldb_release_snapshot", dynlib: libleveldb.}

# Returns NULL if property name is unknown.
#   Else returns a pointer to a malloc()-ed null-terminated value. 
proc leveldb_property_value*(db: LevelDB; propname: cstring): cstring {.
    importc: "leveldb_property_value", dynlib: libleveldb.}

proc leveldb_approximate_sizes*(db: LevelDB; num_ranges: cint;
                                range_start_key: cstringArray;
                                range_start_key_len: ptr csize;
                                range_limit_key: cstringArray;
                                range_limit_key_len: ptr csize;
                                sizes: ptr uint64_t) {.
    importc: "leveldb_approximate_sizes", dynlib: libleveldb.}

proc leveldb_compact_range*(db: LevelDB; start_key: cstring;
                            start_key_len: csize; limit_key: cstring;
                            limit_key_len: csize) {.
     importc: "leveldb_compact_range", dynlib: libleveldb.}


## Management operations
proc leveldb_destroy_db*(options: Options; name: cstring;
                         errptr: cstringArray) {.
     importc: "leveldb_destroy_db", dynlib: libleveldb.}

proc leveldb_repair_db*(options: Options; name: cstring;
                        errptr: cstringArray) {.
     importc: "leveldb_repair_db", dynlib: libleveldb.}

## Iterator
proc leveldb_iter_destroy*(a2: Iterator) {.
     importc: "leveldb_iter_destroy", dynlib: libleveldb.}

proc leveldb_iter_valid*(a2: Iterator): cuchar {.
     importc: "leveldb_iter_valid", dynlib: libleveldb.}

proc leveldb_iter_seek_to_first*(a2: Iterator) {.
     importc: "leveldb_iter_seek_to_first", dynlib: libleveldb.}

proc leveldb_iter_seek_to_last*(a2: Iterator) {.
     importc: "leveldb_iter_seek_to_last", dynlib: libleveldb.}

proc leveldb_iter_seek*(a2: Iterator; k: cstring; klen: csize) {.
     importc: "leveldb_iter_seek", dynlib: libleveldb.}

proc leveldb_iter_next*(a2: Iterator) {.
     importc: "leveldb_iter_next", dynlib: libleveldb.}

proc leveldb_iter_prev*(a2: Iterator) {.
     importc: "leveldb_iter_prev", dynlib: libleveldb.}

proc leveldb_iter_key*(a2: Iterator; klen: ptr csize): cstring {.
     importc: "leveldb_iter_key", dynlib: libleveldb.}

proc leveldb_iter_value*(a2: Iterator; vlen: ptr csize): cstring {.
     importc: "leveldb_iter_value", dynlib: libleveldb.}

proc leveldb_iter_get_error*(a2: Iterator; errptr: cstringArray) {.
     importc: "leveldb_iter_get_error", dynlib: libleveldb.}


## Write batch 
proc leveldb_writebatch_create*(): WriteBatch {.
     importc: "leveldb_writebatch_create", dynlib: libleveldb.}
proc leveldb_writebatch_destroy*(a2: WriteBatch) {.
     importc: "leveldb_writebatch_destroy", dynlib: libleveldb.}
proc leveldb_writebatch_clear*(a2: WriteBatch) {.
     importc: "leveldb_writebatch_clear", dynlib: libleveldb.}
proc leveldb_writebatch_put*(a2: WriteBatch; key: cstring;
                             klen: csize; val: cstring; vlen: csize) {.
     importc: "leveldb_writebatch_put", dynlib: libleveldb.}
proc leveldb_writebatch_delete*(a2: WriteBatch; key: cstring;
                                klen: csize) {.
    importc: "leveldb_writebatch_delete", dynlib: libleveldb.}
proc leveldb_writebatch_iterate*(a2: WriteBatch; state: pointer;
     put: proc (a2: pointer; k: cstring; klen: csize; v: cstring; vlen: csize);
     deleted: proc (a2: pointer; k: cstring; klen: csize)) {.
     importc: "leveldb_writebatch_iterate", dynlib: libleveldb.}

## Options
proc leveldb_options_create*(): Options {.
     importc: "leveldb_options_create", dynlib: libleveldb.}
proc leveldb_options_destroy*(a2: Options) {.
     importc: "leveldb_options_destroy", dynlib: libleveldb.}

proc leveldb_options_set_comparator*(a2: Options;
                                     a3: ptr leveldb_comparator_t) {.
     importc: "leveldb_options_set_comparator", dynlib: libleveldb.}

proc leveldb_options_set_filter_policy*(a2: Options; a3: FilterPolicy) {.
     importc: "leveldb_options_set_filter_policy", dynlib: libleveldb.}

proc leveldb_options_set_create_if_missing*(a2: Options; a3: cuchar) {.
     importc: "leveldb_options_set_create_if_missing", dynlib: libleveldb.}

proc leveldb_options_set_error_if_exists*(a2: Options; a3: cuchar) {.
     importc: "leveldb_options_set_error_if_exists",dynlib: libleveldb.}

proc leveldb_options_set_paranoid_checks*(a2: Options; a3: cuchar) {.
     importc: "leveldb_options_set_paranoid_checks", dynlib: libleveldb.}

proc leveldb_options_set_env*(a2: Options; a3: Environment) {.
     importc: "leveldb_options_set_env", dynlib: libleveldb.}

proc leveldb_options_set_info_log*(a2: Options; a3: Logger) {.
     importc: "leveldb_options_set_info_log", dynlib: libleveldb.}

proc leveldb_options_set_write_buffer_size*(a2: Options; a3: csize) {.
     importc: "leveldb_options_set_write_buffer_size", dynlib: libleveldb.}

proc leveldb_options_set_max_open_files*(a2: Options; a3: cint) {.
     importc: "leveldb_options_set_max_open_files", dynlib: libleveldb.}

proc leveldb_options_set_cache*(a2: Options; a3: ptr leveldb_cache_t) {.
     importc: "leveldb_options_set_cache", dynlib: libleveldb.}

proc leveldb_options_set_block_size*(a2: Options; a3: csize) {.
     importc: "leveldb_options_set_block_size", dynlib: libleveldb.}

proc leveldb_options_set_block_restart_interval*(a2: Options; a3: cint) {.
     importc: "leveldb_options_set_block_restart_interval", dynlib: libleveldb.}
proc leveldb_options_set_compression*(a2: Options; a3: cint) {.
     importc: "leveldb_options_set_compression", dynlib: libleveldb.}

## Comparator
proc leveldb_comparator_create*(state: pointer; destructor: proc (a2: pointer);
                                compare: proc (a2: pointer; a: cstring;
                                               alen: csize; b: cstring; blen: csize): cint;
                                name: proc (a2: pointer): cstring): ptr leveldb_comparator_t {.
     importc: "leveldb_comparator_create", dynlib: libleveldb.}

proc leveldb_comparator_destroy*(a2: ptr leveldb_comparator_t) {.
     importc: "leveldb_comparator_destroy", dynlib: libleveldb.}

## Filter policy
proc leveldb_filterpolicy_create*(state: pointer; destructor: proc(a2: pointer);
                                  create_filter: proc(a2: pointer;
                                                      key_array: cstringArray;
                                                      key_length_array: ptr csize;
                                                      num_keys: cint;
                                                      filter_length: ptr csize): cstring;
                                  key_may_match: proc (a2: pointer;
                                                       key: cstring;
                                                       length: csize;
                                                       filter: cstring;
                                                       filter_length: csize): cuchar;
                                  name: proc (a2: pointer): cstring): FilterPolicy {.
     importc: "leveldb_filterpolicy_create", dynlib: libleveldb.}

proc leveldb_filterpolicy_destroy*(a2: FilterPolicy) {.
     importc: "leveldb_filterpolicy_destroy", dynlib: libleveldb.}
    
proc leveldb_filterpolicy_create_bloom*(bits_per_key: cint): FilterPolicy {.
     importc: "leveldb_filterpolicy_create_bloom", dynlib: libleveldb.}
    
## Read options
proc leveldb_readoptions_create*(): ReadOptions {.
     importc: "leveldb_readoptions_create", dynlib: libleveldb.}

proc leveldb_readoptions_destroy*(a2: ReadOptions) {.
     importc: "leveldb_readoptions_destroy", dynlib: libleveldb.}

proc leveldb_readoptions_set_verify_checksums*(a2: ReadOptions;
                                               a3: cuchar) {.
     importc: "leveldb_readoptions_set_verify_checksums", dynlib: libleveldb.}

proc leveldb_readoptions_set_fill_cache*(a2: ReadOptions;
                                         a3: cuchar) {.
     importc: "leveldb_readoptions_set_fill_cache", dynlib: libleveldb.}

proc leveldb_readoptions_set_snapshot*(a2: ReadOptions; a3: Snapshot) {.
     importc: "leveldb_readoptions_set_snapshot", dynlib: libleveldb.}

## Write options
proc leveldb_writeoptions_create*(): WriteOptions {.
     importc: "leveldb_writeoptions_create", dynlib: libleveldb.}
proc leveldb_writeoptions_destroy*(a2: WriteOptions) {.
     importc: "leveldb_writeoptions_destroy", dynlib: libleveldb.}
proc leveldb_writeoptions_set_sync*(a2: WriteOptions; a3: cuchar) {.
     importc: "leveldb_writeoptions_set_sync", dynlib: libleveldb.}

## Cache
proc leveldb_cache_create_lru*(capacity: csize): ptr leveldb_cache_t {.
     importc: "leveldb_cache_create_lru", dynlib: libleveldb.}
proc leveldb_cache_destroy*(cache: ptr leveldb_cache_t) {.
     importc: "leveldb_cache_destroy", dynlib: libleveldb.}

## Env
proc leveldb_create_default_env*(): Environment {.
     importc: "leveldb_create_default_env", dynlib: libleveldb.}
proc leveldb_env_destroy*(a2: Environment) {.
     importc: "leveldb_env_destroy", dynlib: libleveldb.}

## Utility

# Calls free(ptr).
#   REQUIRES: ptr was malloc()-ed and returned by one of the routines
#   in this file.  Note that in certain cases (typically on Windows), you
#   may need to call this routine instead of free(ptr) to dispose of
#   malloc()-ed memory returned by this library.
proc leveldb_free*(`ptr`: pointer) {.importc: "leveldb_free",
                                     dynlib: libleveldb.}
# Return the major version number for this release.
proc leveldb_major_version*(): cint {.importc: "leveldb_major_version",
                                      dynlib: libleveldb.}
# Return the minor version number for this release.
proc leveldb_minor_version*(): cint {.importc: "leveldb_minor_version",
                                      dynlib: libleveldb.}

when isMainModule:
  include "internal/tests"
  doTests()
