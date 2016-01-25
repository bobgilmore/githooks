githooks
========
[![Build Status](https://travis-ci.org/bobgilmore/githooks.svg?branch=master)](https://travis-ci.org/bobgilmore/githooks)

My personal githooks, which help me avoid mistakes and adhere to  coding guidelines.

I started writing these for use in full-stack Ruby on Rails coding, so most of the checks are for languages in a typical RoR stack.

If you would like to add code to detect another common problem, please create an issue, or better yet, a pull request.  See [Advice for Committers](#advice-for-committers) below.

pre-commit
----------
### Unconditional Checks ###
These checks should be completely non-controversial, and are therefore non-configurable.

1. Catch common errors, such as checking in...
    1. git merge conflict markers
    2. Personalized debugging statements
    3. Calls to invoke the debugger, either in Ruby or in JavaScript
2. Catch other suspicious code, such as the addition of calls to `alert` (very uncommon for me)
3. Check for probable private key commits.
4. Check for *hard-coded* references to your home directory (both Unix and MacOS standards).

### Conditional Checks ###
Conditional checks may be controversial or inappropriate for some projects, and so can be deactivated via `git config`.

They are always to be as strict as possible out-of-the-box, and include instructions for turning them off on a project- or user-wide basis.

1. Check the syntax of Ruby files using ruby -c.
	* In some circumstances (i.e., old Mac OS X versions), an app may use an old version of git that can't handle newer syntax, such as the Ruby 1.9 "JS" hash syntax.  This will result in bogus flags.
2. Prevent changes to `.ruby-version` (and `.rbenv-version`).
	* In my experience, those files are committed *accidentally* (by developers who changed them locally with no intention of committing the changes) far more often then they are committed intentionally.
	* In my opinion, you should leave this alone and simply make a `--no-verify` commit when necessary. (See below.)
3. Several "house style" issues for my employer
	1. Ensure that there are no spaces after `[` and `(`, or before `]` and `)`.
	2. RSpec-Related:
		1. Prefer `should` over `is_expected.to`
		2. Prefer `allow(foo).to receive` and `expect(foo).to have_received` over `expect(foo).to have_received`.
		3. Prefer `should eq` over `should ==`

pre-push
----------
Prevents me from pushing any commits that begin with "foo." ("foo" is my usual commit message for a commit that I intend to rebase into *another* commit before pushing.  This will prevent me from accidentally pushing without rebasing first.) 

Bypassing the Checks
--------------------
Pass the `--no-verify` flag to  `git commit` or `git push` as appropriate to bypass *all* of the checks.

There's no way to turn off individual checks (other than the "conditional" ones mentioned above).  That's why this script goes to pains to display *all* errors, rather than just the first one it encounters.  

If you want to throw the `--no-verify` flag, you should clean up your code to the point where the **only** errors are the ones you feel safe ignoring, and **then** throw the flag.

Installation
============

One-Time Configuration
------------
1. Clone this repository locally into some central location.  
2. Run its setup script, `./setup.sh`

This will set the git config variable `init.templatedir`.  As a result...
1. A custom, *temporary* set of hooks will be installed into any *new* repo.
2. Those temporary hooks will also be installed into any git repo that you run `git init` in (that isn't as destructive as it sounds!)

Then, when you commit to a repo with the *temporary* hooks, the temporary hooks will be overwritten by symlinks to the *final* hooks.

Updating the Hooks
==================
Since the hook files in your individual repos are all symbolic links into your one local copy of this repo, updating or changing your local copy of this repo will affect *all repos that you set this up for, all at once.*  Note; this goes both ways:

- If you pull updates from Github to your local copy, all of your repos will instantaneously get the updates.
- If you edit your "local" copy to make a change in one of your project, you're really editing the symlink.  This, in turn, effects *all* of your projects.  Of course, you *could* set up multiple local copies of this repo for different "styles" of project, but read the next section for a better approach.

Advice for Committers
======================

Add Repo-Specific Changes *Conditionally*
---------
Since all of your affected repos have symlinks to one shared set of hooks, don't make project-specific changes to the hook files.  Rather, make the behavior change based on an **optional** git configuration variable, and then set that variable for the projects where it's necessary.

See how I handle optional checks in, for example, `pre_commit/checkers/spec_is_expected_to_checker.rb`

It's best to add a new checkin its "most stringent" setting, so that people can become aware of if and make an informed decision to deactivate it.

Writing Checks to Run (or Ignore) for Some Extensions or Directories
---------
I don't have many examples of checks that should be run (or ignored) based on extension or directory, so that code isn't really designed to scale.

If you want to add more checks like that, talk to me - we should fix that.
