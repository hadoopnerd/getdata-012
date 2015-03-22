1. Downloaded the dataset and made it available under ./dataProjects directory on my mac\
2. Reading all the files under UCI HAR Dataset
3. checking the list of files
4. Creating data frames for individual data sets
5. Concatenate training and testing datasets
6. Setting the columns names as "Subject"" and "Activity""
7. Reading the feature names from the features.txt
8. Setting the names of dataFeatures that are fetched above from the features file
9. Joining the dataSubject and dataActivity columns
10. Filter the data features and only fetch by mean and standard deviations as required
11. Run a for loop to substitute of activity IDs with their literal names from the activityLabels data frame
Updating the names literals and setting as appropriate
13. Finally need to get the average of each variable for each activity and subject
14. And to the end write final dataset to file tidy data.txt.
