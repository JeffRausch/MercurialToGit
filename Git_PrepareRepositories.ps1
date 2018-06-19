
cd C:\Temp\Git

#Turn off the warning about LF being updated to CRLF
git config core.autocrlf false

#Loop through and for every repository that doesn't exist create it and set the local repository to have it as the origin
$allDirectories = Get-ChildItem -Directory
$curDirIdx = 0;
$allDirectories | ForEach-Object {
    $curDirIdx++;
    $curFolder = $_;
    $folderPctComplete = $($curDirIdx/$allDirectories.Length*100)
    Write-Progress -Activity "Processing $_" -PercentComplete $folderPctComplete
    cd C:\Temp\Git\$_

    if (!(git tag -l -n mercurial_to_git)){
        Write-Host "Processing $curFolder..."
        Write-Progress -Activity "Processing $curFolder" -Status "Committing and Tagging..." -PercentComplete $folderPctComplete

        #Rename .hgignore to .gitignore
        if (Test-Path .hgignore){
            Rename-Item .hgignore .gitignore
            git add .gitignore
        }

        #Commit the changes with a comment, commit will be empty if the .hgignore file was missing
        git commit -a --allow-empty -m "Conversion from Mercurial to Git" > $null
        git tag -a mercurial_to_git -m "Conversion from Mercurial to Git" > $null

        #Update all existing release tags to replace the dash with a slash   
        $allTags = git tag
        $curTagIdx = 0;

        $allTags | ForEach-Object {
            $curTagIdx++;
            Write-Progress -Activity "Processing $curFolder" -PercentComplete $($curTagIdx/$allTags.Count*100) -Status "Updating Tags: $_"

            if (!($_ -like "release-*")){return;}; 

            $tagParts = $_.split('-');
            $newTag = $null;

            if ($tagParts.length -eq 3 -and $tagParts[1] -eq "source"){
                #Switch so the source will be a child of the release version
                $newTag += "$($tagParts[0])/$($tagParts[2])-$($tagParts[1])"
            }
            elseif($tagParts.Length -eq 2 -and $tagParts[1] -match '^\d+$'){
                $newTag = "$($tagParts[0])/old/$($tagParts[1].PadLeft(4, '0'))"
            }
            else{
                #Just replace all
                $newTag = $_.replace("-", "/"); 
            }
            
            git tag $newTag $_; #Create the new tag on the same commit as the old tag
            git tag -d $_ > $null #Remove the old tag
        }
        
        Write-Progress -Activity "Processing $curFolder" -Completed
    }
    else {
        Write-Host "$_ : Already Converted."
    }
}



