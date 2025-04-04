Assessing the utility of Fronto-Parietal and Cingulo-Opercular networks in predicting the trial success of brain-machine interfaces for upper extremity stroke rehabilitation
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
The pipeline of the analysis:
1) Epoching the data for 4 trial-outcomes (Epoching.m)
2) Creating the headmodel for each patient and do source localization using RSBL algorithm (Source_localization.m)
3) Estimating the transfer entropy between frontoparietal and cingulo-opercular networks in the pre and post-trial (TE_Calculation.m)
4) Analysis using rmANOVA (rmANOVA.m)
5) Fitting a logistic regression model. (Logistic_regression.m)
