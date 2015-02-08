const 
  DBname: string = "test.db"

var
  testOpts: Options = leveldb_options_create()
  db: LevelDB
  err: cstringArray
  haveReadInput: bool = false
  input: cstring
  j: int
  read_length: csize
  WriteOpts: WriteOptions = leveldb_writeoptions_create()
  ReadOpts:  ReadOptions  = leveldb_readoptions_create()

proc `$`(x: cstring, length: csize): string=
  result = newString(length)
  copyMem(addr result[0], x, length)

proc doCleanup(){.noConv.}=
  leveldb_free(db)
  leveldb_free(err)
  leveldb_free(WriteOpts)
  leveldb_free(ReadOpts)
  leveldb_free(testOpts)
  if haveReadInput:
    leveldb_free(input)

proc doTests()=
  addQuitProc(doCleanup)
  echo "Testing LevelDB: " & $leveldb_major_version() & "." & $leveldb_minor_version()
  echo "Creating temp database: " & DBname
  leveldb_options_set_create_if_missing(testOpts,cuchar(1))
  db = leveldb_open(testOpts,DBname,err)

  if (not isNil(err)):
    echo "Error opening DB!"
    quit(QuitFailure)
  
  echo """Database created... inserting 1 to 100 as array of test
          keys, with values equal to the number squared..."""

  ## Think I know that size parameter is wrong, needs to be something like:
  ## siezeof(char) * length

  for i in 1..100:
    j = i*i
    echo "Writing key: " & $i & " with value " & $j
    leveldb_put(db,WriteOpts,cstring($i),csize(len($i)),cstring($j),csize(len($j)),err)
    if (not isNil(err)):
      echo "Error writing key " & $i & " with value " & $j
      quit(QuitFailure)

  echo """Reading values back (quit on not getting expected result, or on
  having an error returned."""

  haveReadInput = true

  for i in 1..100:
    j = i*i
    input = leveldb_get(db,ReadOpts,$i,($i).len.csize,addr read_length,err)
    if ((input $ read_length) != $j) or (not isNil(err)):
      echo "Expected: " & $j & ", but got: " & ( input $ read_length)
      quit(QuitFailure)
    echo "Looked up " & $i & " and got " & (input $ read_length) & " successfully"

  quit(QuitSuccess)
