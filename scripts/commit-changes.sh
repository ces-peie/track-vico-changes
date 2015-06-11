git add ./changes/section-item-changes.csv
git commit
git diff HEAD^ changes/section-item-changes.csv > changes/visual-diffs/`git rev-parse HEAD`.diff
echo >> changes/descriptive-log.md
echo ---  >> changes/descriptive-log.md
echo >> changes/descriptive-log.md
echo \# `git log -1 --pretty=%B` >> changes/descriptive-log.md
echo \#\# \``git log -1 --pretty=%H`\` >> changes/descriptive-log.md
echo \#\#\# `git log -1 --pretty=%an` >> changes/descriptive-log.md
echo \#\#\#\# `git log -1 --pretty=%ad --date=iso8601` >> changes/descriptive-log.md
echo `git log -1 --pretty=%B` >> changes/descriptive-log.md
notepad changes/descriptive-log.md
echo >> changes/descriptive-log.md
git add ./changes/descriptive-log.md
git commit -m 'Update descriptive-log'
