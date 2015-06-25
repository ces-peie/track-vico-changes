#-----------------------------------------------------------------
# Apply first set of changes - stool sample questions
#-----------------------------------------------------------------
mv ./changes/change_1.csv ./changes/section-item-changes.csv
git add ./changes/section-item-changes.csv
git commit -m 'Order and update stool sample questions'
echo >> changes/descriptive-log.md
echo ---  >> changes/descriptive-log.md
echo >> changes/descriptive-log.md
echo \# `git log -1 --pretty=%B` >> changes/descriptive-log.md
echo \#\# \``git log -1 --pretty=%H`\` >> changes/descriptive-log.md
echo \#\#\# `git log -1 --pretty=%an` >> changes/descriptive-log.md
echo \#\#\#\# `git log -1 --pretty=%ad --date=iso8601` >> changes/descriptive-log.md
echo `git log -1 --pretty=%B` >> changes/descriptive-log.md
echo Changed the order of questions pertaining to stool sample collection, added specification of sample type collected in H3-Muestra >> changes/descriptive-log.md
echo >> changes/descriptive-log.md
git add ./changes/descriptive-log.md
git commit -m 'Update descriptive-log'

#-----------------------------------------------------------------
# Apply second set of changes - remove zinc questions
#-----------------------------------------------------------------
mv ./changes/change_2.csv ./changes/section-item-changes.csv
git add ./changes/section-item-changes.csv
git commit -m 'Removed questions on zinc'
echo >> changes/descriptive-log.md
echo ---  >> changes/descriptive-log.md
echo >> changes/descriptive-log.md
echo \# `git log -1 --pretty=%B` >> changes/descriptive-log.md
echo \#\# \``git log -1 --pretty=%H`\` >> changes/descriptive-log.md
echo \#\#\# `git log -1 --pretty=%an` >> changes/descriptive-log.md
echo \#\#\#\# `git log -1 --pretty=%ad --date=iso8601` >> changes/descriptive-log.md
echo `git log -1 --pretty=%B` >> changes/descriptive-log.md
echo Removed questions on zinc, B-Treatment >> changes/descriptive-log.md
echo >> changes/descriptive-log.md
git add ./changes/descriptive-log.md
git commit -m 'Update descriptive-log'

#-----------------------------------------------------------------
# Apply third set of changes - add and update TRAction questions
#-----------------------------------------------------------------
mv ./changes/change_3.csv ./changes/section-item-changes.csv
git add ./changes/section-item-changes.csv
git commit -m 'Add and update TRAction questions'
echo >> changes/descriptive-log.md
echo ---  >> changes/descriptive-log.md
echo >> changes/descriptive-log.md
echo \# `git log -1 --pretty=%B` >> changes/descriptive-log.md
echo \#\# \``git log -1 --pretty=%H`\` >> changes/descriptive-log.md
echo \#\#\# `git log -1 --pretty=%an` >> changes/descriptive-log.md
echo \#\#\#\# `git log -1 --pretty=%ad --date=iso8601` >> changes/descriptive-log.md
echo `git log -1 --pretty=%B` >> changes/descriptive-log.md
echo Added questions from TRAction analysis on WASH, modified some of the questions Beatriz added. >> changes/descriptive-log.md
echo >> changes/descriptive-log.md
git add ./changes/descriptive-log.md
git commit -m 'Update descriptive-log'

#-----------------------------------------------------------------
# Clean up coded fixes
#-----------------------------------------------------------------
rm ./scripts/cjarquin-changes.sh
rm ./cjarquin-changes.bat
git add --all ./scripts/cjarquin-changes.sh
git add --all ./cjarquin-changes.bat
git add --all ./changes/change_*.csv
git commit -m 'Clean up coded fixes'
