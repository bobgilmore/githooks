githooks
========

My personal githooks, which help me avoid silly or obvious mistakes.

If you know of a common mistake, please create an issue, or better yet, a pull request. 

pre-commit
----------
1. Catches common errors, such as checking in...
    1. git merge conflict markers
    2. Personalized debugging statements
    3. Calls to invoke the debugger, either in Ruby or in JavaScript
2. Catches other suspicious code, such as the addition of calls to `alert` (very uncommon for me)
3. ~~Syntax-check all .rb files~~ Temporarily deactivated
6. Check for probable private key commits. 
4. *Conditionally* prevents changes to `.ruby-version` (and `.rbenv-version`).  In my experience, those files are committed *accidentally* (by developers who changed them locally with no intention of committing the changes) far more often then they are committed intentionally.  Prevents these changes by default. 
    * Run `git config hooks.allowrubyversionchange true` in a project directory to allow it for that particular project.
5. *Conditionally* ensures that changes to assets are accompanied by a change to production.rb (required in my former employer's main work environment).  Does *not* prevent these changes by default.
    * Run `git config hooks.newassetsrequireproductionchange true` in a project directory to prevent it for that particular project.

Bypassing the Checks
--------------------
Call git commit with the `--no-verify flag` to ignore all of these checks.

There's no way to turn off individual checks (other than the "conditional" ones mentioned above).  That's why this script goes to pains to display *all* errors, rather than just the first one.  If you want to throw the `--no-verify` flag, you should clean up your code to the point where the **only** errors are the ones you feel safe ignoring, **then** throw the flag.

Installation
============
1. Clone the repository locally.
    git clone git@github.com:bobgilmore/githooks.git
2. Run the setup script.  This will configure git to create all *new* git repos with *this* repo for its githooks.
    cd (into the newly-created repository directory)
    ./setup.sh
3. If you want to configure any previously existing repos to use these githooks, cd into that repo and run
    git init