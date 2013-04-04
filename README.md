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

Bypassing the Checks
--------------------
Call git commit with the --no-verify flag

Installation
============
Clone the repository locally, then run the setup script, passing the location of the
 repo that you want to add hooks to as an input argument:
    
    git clone git@github.com:bobgilmore/githooks.git
    cd (into the newly-created repository directory)
    ./setup.sh path_to_repo_that_you_want_to_add_hooks_to
