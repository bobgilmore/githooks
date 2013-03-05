githooks
========

My personal githooks

pre-commit
----------
1. Catches common errors, such as checking in...
    1. git merge conflict markers
    2. personalized debug statements
2. Catches other suspicious code, such as calls to alert (very uncommon for me)
3. Syntax-check all .rb files
4. Prevents accidental changes to .ruby-version (and .rbenv-version)
5. Ensures that changes to assets are accompanied by a change to production.rb (required in my main work environment).
6. Check for probable private key commits.

Installation
------------
cd into the top level of a project that you want to check commits for.  Then,

    cd .git
    git clone git@github.com:bobgilmore/githooks.git
    rm -rf hooks # assuming there's nothing interesting in there already
    mv githooks hooks

Bypassing the Checks
--------------------
Call git commit with the --no-verify flag
