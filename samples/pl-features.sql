/*
 * SQL File to illustrate some of LunaSQL commands equivalent of PL features.
 */

-- Test of existance of MYTABLE global variable
if !$[def -d MYTABLE] {
  exit -1 "MYTABLE variable not set!"
}

-- Turning on exit on errors
opt :EXIT_ON_ERR 1
opt :ON_ERROR {
  print "There was an error : $err_msg"
  -- you can do more error handling (logging, safe closing resources...)
}
print "$<n>Loading up a table named '$MYTABLE'..."  -- $<n> substitutes to new line
CREATE TABLE $MYTABLE (
    i int,
    s varchar
)

/* Insert data with a foreach loop.
   These values could be from a read of another table or from variables
   set on the command line like
*/
print "Inserting some data int our new table (you should see 3 row update messages)"
for value [12 22 24 15] {
  -- at each loop the local variable $value represents the ith value of the array
  if [$value > 23] {
    print "Skipping $value because it is greater than 23"
    next
    print "You will never see this line, because of 'next'"
  }
  INSERT INTO $MYTABLE VALUES ($value, 'String of $value')
  
  if [$value > 30] {
    break
    print "You will never see this line, because of 'break'"
  }
}

/* Storing the return value of a SELECT statement in a variable
*/
print "We are saving the max value for later"
def themax $[SELECT MAX(i) FROM $MYTABLE]   -- You won't see query output here
                                            -- because the statement is embebbed.
-- if the query fails, :EXIT_ON_ERR 1 makes the script to exit
if [$themax == 0] {
  print "Something was wrong during with the INSERT statement"
  exit -2
}

/* Now the results of our work
*/
print "$<n>Results:"
SELECT * FROM $MYTABLE
print "Max value is $themax"

print "$<n>Everything worked fine."
