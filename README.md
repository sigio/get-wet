# Get-Wet

Script to download (plain-text) versions of dutch law-texts from wetten.overheid.nl
and version these in a git repo.

Commits are backdated on the day the law goes into effect.

Examples of the output of this script can be found in the following github repos:

  - https://github.com/sigio/burgerlijk-wetboek-1
  - https://github.com/sigio/burgerlijk-wetboek-2
  - https://github.com/sigio/burgerlijk-wetboek-3
  - https://github.com/sigio/burgerlijk-wetboek-4
  - https://github.com/sigio/burgerlijk-wetboek-5
  - etc...

# Usage

  ./get-wet.sh ID STARTDATE

ID is the identifier used on wetten.overheid.nl, and start-date is the date for the first
version to download. For many laws this is 2002-01-01, and this date can be found by
browsing old revisions on wetten.overheid.nl
