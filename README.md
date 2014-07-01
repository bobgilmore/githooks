githooks
========

My personal githooks, which help me avoid silly or obvious mistakes.

I started writing these at a full-stack Ruby on Rails -based position, so most of the checks are for Ruby, JavaScript, or general git use.  I've sprinkled a few checks here and there for problems in other languages, and I'll add more.

If you know of a common mistake, please create an issue, or better yet, a pull request.  See [Advice for Committers](#advice-for-committers) below.

pre-commit
----------
### Unconditional Checks ###
These checks should be completely non-controversial, and are therefore non-configurable.

1. Catch common errors, such as checking in...
    1. git merge conflict markers
    2. Personalized debugging statements
    3. Calls to invoke the debugger, either in Ruby or in JavaScript
2. Catch other suspicious code, such as the addition of calls to `alert` (very uncommon for me)
3. ~~Syntax-check all .rb files~~ Temporarily deactivated
4. Check for probable private key commits.

### Conditional Checks ###
Conditional checks may be controversial or inappropriate for some projects, and so can be deactivated via `git config`.

They are configured to be as strict as possible, and include instructions for turning them off on a project-wide or machine-wide basis.

1. Prevent changes to `.ruby-version` (and `.rbenv-version`).  In my experience, those files are committed *accidentally* (by developers who changed them locally with no intention of committing the changes) far more often then they are committed intentionally.
    * Run `git config hooks.allowrubyversionchange true` in a project directory to always allow it.
    * In my opinion, you should leave this alone and simply make a `--no-verify` commit when necessary.
2. Ensure that changes to assets are accompanied by a change to production.rb (required in my former employer's main work environment).  Does *not* prevent these changes by default.
    * Run `git config hooks.newassetsrequireproductionchange true` in a project directory to prevent it for that particular project.
3. Ensure that there are no spaces after `[` and `(`, or before `]` and `)`.
    * Run `git config hooks.requirepedanticparenspacing false` in a project directory to always allow it.

Bypassing the Checks
--------------------
Call git commit with the `--no-verify flag` to ignore all of these checks.

There's no way to turn off individual checks (other than the "conditional" ones mentioned above).  That's why this script goes to pains to display *all* errors, rather than just the first one.  If you want to throw the `--no-verify` flag, you should clean up your code to the point where the **only** errors are the ones you feel safe ignoring, **then** throw the flag.

Installation
============
Clone this repository locally into some central location.  Then run its setup script, passing the location of *the repo that you want to add hooks to* as an input argument.
    
    cd (someplace "central." For me, that's usually ~/code)
    git clone git@github.com:bobgilmore/githooks.git
    cd (into the newly-created repository directory)
    ./setup.sh path_to_repo_that_you_want_to_add_hooks_to

This will create symbolic links in the `.git` directory of the repo that you're adding to, which will point to this githooks repo.  

It will also write to the git config variable `hooks.symlinksourcerepo`, used by the git hooks in https://github.com/bobgilmore/dotfiles to provide effective instructions for leveraging the original installation of this repo, rather than prompting the user to re-clone.

Updating the Hooks
==================
Since the githook files that you'll be creating in your individual repos are all symbolic links into your (presumably) one local copy of this repo, updating or changing your local copy of this repo will affect *all repos that you set this up for, all at once.*  Note; this goes both ways:

- If you pull updates from Github to your local copy, all of your repos will instantaneously get the updates.
- If you edit your local copy to make a change in one of your project, you'll effect *all* of your projects.  Of course, you *could* set up multiple local copies of this repo for different "styles" of project, but read the next section for a better approach.

Advice for Committers
======================

Add Repo-Specific Changes *Conditionally*
---------
Since all of your affected repos have symlinks to one shared set of hooks, don't make project-specific changes to the hook files.  Rather, make the behavior change based on an **optional** git configuration variable, and then set that variable for the projects where it's necessary.

See how I handle `newassetsrequireproductionchange` in the `pre-commit` file for an example of how to do this.

Writing Checks to Run (or Ignore) for Some Extensions or Directories
---------
I don't have many examples of checks that should be run (or ignored) based on extension or directory, so that code isn't really designed to scale.

If you want to add more checks like that, talk to me - we should probably fix that.
