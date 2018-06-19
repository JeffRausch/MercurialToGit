# MercurialToGit
Steps and scripts I used to convert all of our Mercurial repositories to Git while maintaining history

This conversion was done on a Windows server.

Will convert Mercurial repositories to Git, normalizes author names if required, and removes all closed branches.

Some of these script are bash scripts, ending with ".sh".  At the time I made this bash was not included with Windows so I installed the cygwin terminal for the bash shell.  Newer versions of Windows may have bash already installed.

## Prepare
### BuildScript_CloneAllRepositories.ps1
> This script will create two other scripts, one to Clone and one to Pull all of the Mercurial repositories.  They will create the repositories in a "Mercurial" folder.  It uses the Repository.json file that's pulled when you browse the SCM repositories page in a browser.   To get this file open Chrome, then open the Chrome developer toolbar, then load the SCM Repositories page.  You will see a call to get the Repositories.json file.  Just download this file and copy it where the script is looking for it.

### DumpAuthors.sh
> This dumps a list of all authors in all the Mercurial repositories into a file named "authors".  It will then sort and grab unique authors from that file and put them into an "Authors.txt" file.
> The Authors.txt file needs to be updated to convert author names for standardization.  Every name that you want changed must be in this file, if it's not in here then the author name is left as-is.  During conversion if author matches text before the equal sign then it's changed to the text after the equal sign.
First.Last <first.last@email.com>=first.last <first.last@email.com>
First Last <first.last@email.com>=first.last <first.last@email.com>

### DumpTags.sh
> Similar to DumpAuthors.sh.  Nothing is done with this file, I dumped it out because we converted our tag naming in the "Git_PrepareRepositories.ps1" script.


## Convert
### ConvertAllRepositories.sh
> This will take all the repositories from the Mercurial folder and create Git repositories in a Git folder
> Removes all existing branches
> Checks out the HEAD to pull all files into the main repository directory
> This uses another script called "Fast-Export" to convert the repositories while keeping the commit history.

### Git_PrepareRepositories.ps1
> Turns off warning for LF to CRLF (only done once)
> Renames .hgignore to .gitignore
> Create a commit with comment "Conversion from Mercurial to Git".  This commit will be created even if there is no .gitignore file to check in
> Update all tag names to our new convention - this converted our old tags like "release-20170503" to "release/20170503" so tags become organized in folders in git clients.  Basically replaces dashes with slashes, but we also had an older format that we kept.  This could easily be modified to just remove all the tags.

At this point all of the repositories in the Git folder should be ready to be loaded to your git origin.  Use a Git client to validate that the history, tags, etc. are correct.