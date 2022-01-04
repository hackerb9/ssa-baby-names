# ssa-baby-names

List of baby names from 1880 to the present from the US Social
Security Administration

## Overview

This is a corpus of all the first names that were given to five or
more babies in the United States for every year from 1880 to the
present. It includes scripts for retrieving and processing the
database from https://www.ssa.gov/oact/babynames/names.zip.


## Data Files

* [alldata.txt](alldata.txt): All the Social Security Administration
  birthname data merged into a single file, instead of having a
  separate yob*.txt file for each year. Sorted by year then sex then
  popularity. Format is comma separated values, delimited by newlines:

  > &lt;_name_>,&lt;_sex_>,&lt;_occurances_>,&lt;_year_>

  Note: SSA data only includes names given to at least five babies in
  a single year and does not include single letter names.

  2,020,863 entries, 33 MiB.

* [maxoccurances.txt](maxoccurances.txt): The maximum number of
  occurances of each name (merged sex) and the year that maximum was
  found. (In case of ties, the earlier year is listed).
    
  > &lt;_name_>,&lt;_sex_>,&lt;_max occurances_>,&lt;_max year_>

  File is sorted by most babies named in a single year.
  Each name is listed only once, under the sex that had the most
  occurances. For example, `Charlie` occurs as male, but not female.

* [maxoccurbysex.txt](maxoccurbysex.txt): The maximum number of
  occurances of each name (separated by sex) and the year that maximum
  was found. (In case of ties, the earlier year is listed).
    
  > &lt;_name_>,&lt;_sex_>,&lt;_max occurances_>,&lt;_max year_>

  <details>
  
  File is sorted by number of occurances, from most to least.

  The top five entries:

      Linda,F,99693,1947
      James,M,94764,1947
      Michael,M,92718,1957
      Robert,M,91647,1947
      John,M,88319,1947

  Names are counted separately by sex, for example:

      Charlie,M,2891,1919
      Charlie,F,2219,2020

  </details>

  111,472 entries, 2 MiB.
  
* [allnames.txt](allnames.txt): A simple list of every name seen since
  1880. Sexes are merged, so each name is listed only once. Sorted by
  most babies in a single year to the least.

  Currently there are 100,364 names, from Aaban to Zzyzx.

* [identifiers.txt](identifiers.txt): Based on allnames.txt, a list of
  over 100k valid, unique, memorable identifiers. Every line contains
  a sequence of 2 to most 15 lowercase ASCII characters. Most will be
  recognized by English speakers as given names.

  <details>

  This differs from [allnames.txt](allnames.txt) in two ways:

  1. The "NATO Phonetic Alphabet" has been prepended at the beginning.
  2. Names are lower case.

  While this file could be handy for many things, the idea is that a
  project which is trying to deobfuscate code can simply grab an
  identifier from this list to use as a function name. This will
  hopefully make reading such source code easier.

  Note that no attempt has been made to remove homophones (names that
  are spelled differently but sound similar). If this turns out to be
  a problem in practice, we can turn to phonetic algorithms, like
  Soundex, to keep only one. (More popular spellings appear earlier in
  the list, so we'd keep "Aaron", name number 159, and toss "Erin",
  name number 161).

  </details>

* [atleast1000.txt](atleast1000.txt),
  [atleast500.txt](atleast500.txt), [atleast100.txt](atleast100.txt):
  Simple list, restricted to names that have been given to at least
  _x_ number of babies in a single year. Sorted from greatest number
  of occurances to least.

* [raw-data](raw-data): A directory for the unzipped data files from
  the SSA's [names.zip](raw-data/names.zip). The files are named by
  year of birth, for example
  [raw-data/yob2020.txt](raw-data/yob2020.txt). The format is
  described by the SSA like so:

  > National Data on the relative frequency of given names in the population
  > of U.S. births where the individual has a Social Security Number
  > 
  > (Tabulated based on Social Security records as of March 7, 2021)
  > 
  > For each year of birth YYYY after 1879, we created a comma-delimited file
  > called yobYYYY.txt. Each record in the individual annual files has the
  > format "name,sex,number," where name is 2 to 15 characters, sex is M
  > (male) or F (female) and "number" is the number of occurrences of the
  > name. Each file is sorted first on sex and then on number of occurrences
  > in descending order. When there is a tie on the number of occurrences,
  > names are listed in alphabetical order. This sorting makes it easy to
  > determine a name's rank. The first record for each sex has rank 1, the
  > second record for each sex has rank 2, and so forth. To safeguard
  > privacy, we restrict our list of names to those with at least 5
  > occurrences.

## Scripts

### bin/getlatest.sh

[bin/getlatest.sh](bin/getlatest.sh) downloads the corpus of baby
names from the US Social Security Administration, if it has not
already been downloaded. It is essentially just

    wget https://www.ssa.gov/oact/babynames/names.zip

but with lots of error checking.

### bin/processnames.sh

[bin/processnames.sh](bin/processnames.sh) reads the raw data and creates
the more easily digested text files, such as [allnames.txt](allnames.txt).

In the future, it will also create shorter lists by restricting names to the
top _x_ percent.

Another possible addition is merging names that sound the same onto a single
line. This could be done using Knuth's soundex or other phonetic algorithm.
(See James Turk's [Jellyfish library](https://github.com/jamesturk/jellyfish).)

## Munging

Note that the database SSA provides has the data munged in various
ways which they have not documented. This appears to include:

* One letter names are not recorded
* ASCII alphabetic characters only (no é, ñ, etc)
* First letter is capital and the rest lowercase
* Names longer than fifteen letters are truncated
* Spaces and hyphens removed ("Anna Marie" → "Annamarie")

Take the name _María de los Ángeles_ which suffers from all of the
above restrictions and is rendered in the database as:
`Mariadelosangel` and `Mariadelosang`.

### How have munging policies changed over time?

It is not clear what the SSA policies are concerning the name format
and how they have changed over the years. Some open questions:

* Is there a better database that the SSA has available? 

* The SSA surely has a document describing the precise formatting of names.
  Where is it?

* Are there other munging operations occuring that are not listed here?

* What is the order of the operations? For examples, the name _María
  de los Ángeles_ is rendered in three different ways in the database:

  <details><summary>$ grep Mariadelos raw-data/yob*</summary>

  ```grep
  raw-data/yob1982.txt:Mariadelosangel,F,6
  raw-data/yob1986.txt:Mariadelosangel,F,8
  raw-data/yob1987.txt:Mariadelosangel,F,7
  raw-data/yob1988.txt:Mariadelosangel,F,7
  raw-data/yob1989.txt:Mariadelosang,F,6
  raw-data/yob1994.txt:Mariadelos,F,5
  raw-data/yob1995.txt:Mariadelosang,F,6
  raw-data/yob1996.txt:Mariadelosang,F,6
  raw-data/yob1997.txt:Mariadelosang,F,14
  raw-data/yob1998.txt:Mariadelosang,F,8
  raw-data/yob1999.txt:Mariadelosang,F,6
  raw-data/yob2000.txt:Mariadelosang,F,14
  raw-data/yob2001.txt:Mariadelosang,F,13
  raw-data/yob2002.txt:Mariadelosang,F,12
  raw-data/yob2003.txt:Mariadelosang,F,12
  raw-data/yob2004.txt:Mariadelosang,F,8
  raw-data/yob2005.txt:Mariadelosang,F,12
  raw-data/yob2006.txt:Mariadelosang,F,8
  raw-data/yob2007.txt:Mariadelosang,F,11
  raw-data/yob2008.txt:Mariadelosang,F,6
  raw-data/yob2010.txt:Mariadelosang,F,6
  ```

  </details>

  1. `Mariadelosangel` (1982 to 1988)
  2. `Mariadelosang  ` (1989 and 1995 to 2010)
  3. `Mariadelos     ` (1994)

It looks like something odd changed in 1989. One hypothesis that could
  explain that change is that the transliteration to alphabetic ASCII is
  happening after the restriction of fifteen characters. Perhaps, because
  _María de los Ángeles_ has two diacritics, the maximum length is shortened
  by two.

      María de los Ángeles
      Mari´a de los A´ngeles
      Mari´adelosa´ngeles
      Mari´adelosa´ng          <-- truncate to fifteen characters
      Mariadelosang

  Supporting evidence: _María del Rosario_ is recorded as
  `Mariadelrosario` in the 1980s, but is only seen as `Mariadelrosari`
  after that. It makes sense it would lose only one character because
  it has only one diacritical mark.

      $ grep Mariadelros raw-data/yob*
      raw-data/yob1981.txt:Mariadelrosario,F,5
      raw-data/yob1986.txt:Mariadelrosario,F,6
      raw-data/yob1987.txt:Mariadelrosario,F,5
      raw-data/yob1998.txt:Mariadelrosari,F,5
      raw-data/yob2001.txt:Mariadelrosari,F,6
      raw-data/yob2002.txt:Mariadelrosari,F,5
      raw-data/yob2003.txt:Mariadelrosari,F,5
      raw-data/yob2006.txt:Mariadelrosari,F,5
      raw-data/yob2007.txt:Mariadelrosari,F,6
