githooks
========

My personal githooks

pre-commit
----------
1. Catches common errors, such as checking in...
    1. git merge conflict markers
    2. personalized debug statements
2. Catches other suspicious code, such as...
    1. Calls to alert (very uncommon for me),
    2. Calls to flatten (because Hash.flatten is not available in Ruby 1.8.7)
3. Syntax-check all .rb files
4. Prevents accidental changes to .ruby-version (and .rbenv-version)
5. Ensures that changes to assets are accompanied by a change to production.rb (required in my main work environment).
6. Check for probable private key commits.

Bypassing the Checks
--------------------
Call git commit with the --no-verify flag
