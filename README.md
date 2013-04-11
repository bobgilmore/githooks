githooks
========

My personal githooks

pre-commit
----------
1. Catches common errors, such as checking in...
    1. git merge conflict markers
    2. personalized debugging statements
    3. Debugger calls
2. Catches other suspicious code, such as calls to alert (very uncommon for me)
3. ~~Syntax-check all .rb files~~ Temporarily deactivated
6. Check for probable private key commits. 
4. *Conditionally* prevents accidental changes to .ruby-version (and .rbenv-version).  Prevents these changes by default. 
    * Run `git config hooks.allowrubyversionchange true` in a project directory to allow it for that particular project.
5. *Conditionally* ensures that changes to assets are accompanied by a change to production.rb (required in my main work environment).  Does *not* prevent these changes by default.
    * Run `git config hooks.newassetsrequireproductionchange true` in a project directory to prevent it for that particular project.

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
