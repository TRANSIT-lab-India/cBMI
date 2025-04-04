
% Creating the tables for data analysis. TE values are arranged into a
% table for rmANOVA

clear
clc

load('...\All_sub_TE_CON_FPN_post_with_all_sessions.mat');
load('...\All_sub_TE_CON_FPN_pre_with_all_sessions.mat');

%% Extracting the values from PRE

all_sub_te_con_fpn = all_sub_te_con_fpn_pre;

conditions_beta = {all_sub_te_con_fpn.te_succB,all_sub_te_con_fpn.te_IntentB,all_sub_te_con_fpn.te_AttemptB,...
    all_sub_te_con_fpn.te_baseB};

conditions_theta = {all_sub_te_con_fpn.te_succT,all_sub_te_con_fpn.te_IntentT,all_sub_te_con_fpn.te_AttemptT,...
    all_sub_te_con_fpn.te_baseT};

for sub=1:10

    % getting max value index corresponds to success
    for ses=1:3
        [max_succB(ses,:),ind_succB(ses,:)] = max(conditions_beta{1}(sub,:,ses));
        [max_succT(ses,:),ind_succT(ses,:)] = max(conditions_theta{1}(sub,:,ses));
    end
    
    tlag(sub,:) = ind_succT';
    blag(sub,:) = ind_succB';

    for cond = 1:4
        theta_3to6(sub,cond,:) = conditions_theta{cond}(sub,tlag(1),1);
        theta_7to10(sub,cond,:) = conditions_theta{cond}(sub,tlag(2),2);
        theta_11to14(sub,cond,:) = conditions_theta{cond}(sub,tlag(3),3);
    
        beta_3to6(sub,cond,:) = conditions_beta{cond}(sub,blag(1),1);
        beta_7to10(sub,cond,:) = conditions_beta{cond}(sub,blag(2),2);
        beta_11to14(sub,cond,:) = conditions_beta{cond}(sub,blag(3),3);
    end
    
end

fpn_con_all_connectivities.fpn_con_pre.theta_3to6 = theta_3to6;
fpn_con_all_connectivities.fpn_con_pre.theta_7to10 = theta_7to10;
fpn_con_all_connectivities.fpn_con_pre.theta_11to14 = theta_11to14;

fpn_con_all_connectivities.fpn_con_pre.beta_3to6 = beta_3to6;
fpn_con_all_connectivities.fpn_con_pre.beta_7to10 = beta_7to10;
fpn_con_all_connectivities.fpn_con_pre.beta_11to14 = beta_11to14;

clearvars -except fpn_con_all_connectivities all_sub_te_con_fpn_post all_sub_te_con_fpn_pre
 
%% Extracting values from POST

all_sub_te_con_fpn = all_sub_te_con_fpn_post;

conditions_beta = {all_sub_te_con_fpn.te_succB,all_sub_te_con_fpn.te_IntentB,all_sub_te_con_fpn.te_AttemptB,...
    all_sub_te_con_fpn.te_baseB};

conditions_theta = {all_sub_te_con_fpn.te_succT,all_sub_te_con_fpn.te_IntentT,all_sub_te_con_fpn.te_AttemptT,...
    all_sub_te_con_fpn.te_baseT};

for sub=1:10

    % getting max value index corresponds to success
    for ses=1:3
        [max_succB(ses,:),ind_succB(ses,:)] = max(conditions_beta{1}(sub,:,ses));
        [max_succT(ses,:),ind_succT(ses,:)] = max(conditions_theta{1}(sub,:,ses));
    end
    
    tlag(sub,:) = ind_succT';
    blag(sub,:) = ind_succB';

    for cond = 1:4
        theta_3to6(sub,cond,:) = conditions_theta{cond}(sub,tlag(1),1);
        theta_7to10(sub,cond,:) = conditions_theta{cond}(sub,tlag(2),2);
        theta_11to14(sub,cond,:) = conditions_theta{cond}(sub,tlag(3),3);
    
        beta_3to6(sub,cond,:) = conditions_beta{cond}(sub,blag(1),1);
        beta_7to10(sub,cond,:) = conditions_beta{cond}(sub,blag(2),2);
        beta_11to14(sub,cond,:) = conditions_beta{cond}(sub,blag(3),3);
    end
    
end
% Post
fpn_con_all_connectivities.fpn_con_post.theta_3to6 = theta_3to6;
fpn_con_all_connectivities.fpn_con_post.theta_7to10 = theta_7to10;
fpn_con_all_connectivities.fpn_con_post.theta_11to14 = theta_11to14;

fpn_con_all_connectivities.fpn_con_post.beta_3to6 = beta_3to6;
fpn_con_all_connectivities.fpn_con_post.beta_7to10 = beta_7to10;
fpn_con_all_connectivities.fpn_con_post.beta_11to14 = beta_11to14;

% Saved the variable

%%
%% MAking the tables - FPN-CON PRE

clear
clc

load('...\fpn_con_all_connectivities_with_all_sessions.mat');

% Including the median splitted ARAT and FMA scores to the table
load("...\Med_Splited_ARAT.mat");
load("...\Med_Splited_FMA.mat");

% PRE ################################################################################################################

        theta_3to6 = fpn_con_all_connectivities.fpn_con_pre.theta_3to6;
        theta_7to10 = fpn_con_all_connectivities.fpn_con_pre.theta_7to10;
        theta_11to14 = fpn_con_all_connectivities.fpn_con_pre.theta_11to14 ;
        
        beta_3to6 = fpn_con_all_connectivities.fpn_con_pre.beta_3to6 ;
        beta_7to10 = fpn_con_all_connectivities.fpn_con_pre.beta_7to10 ;
        beta_11to14 = fpn_con_all_connectivities.fpn_con_pre.beta_11to14 ;
        
        % ANOVA------------------------------------------------------------
        succ_ = [theta_3to6(:,1), theta_7to10(:,1),theta_11to14(:,1), beta_3to6(:,1), beta_7to10(:,1),beta_11to14(:,1)];
        intent_ = [theta_3to6(:,2), theta_7to10(:,2),theta_11to14(:,2),beta_3to6(:,2), beta_7to10(:,2),beta_11to14(:,2)];
        attempt_ = [theta_3to6(:,3), theta_7to10(:,3),theta_11to14(:,3),beta_3to6(:,3), beta_7to10(:,3),beta_11to14(:,3)];
        base_ = [theta_3to6(:,4), theta_7to10(:,4),theta_11to14(:,4),beta_3to6(:,4), beta_7to10(:,4),beta_11to14(:,4)];
        combined_data = [succ_; intent_; attempt_; base_];
        
        cond = [ones(10,1);2*ones(10,1);3*ones(10,1);4*ones(10,1)];
        FPN_CON_Pre_EC_TableRmANOVA = array2table([combined_data, cond, repmat(med_splited_arat,4,1), repmat(med_splited_fma,4,1)],...
            'VariableNames', {'B1Ses1', 'B1Ses2', 'B1Ses3','B2Ses1', 'B2Ses2', 'B2Ses3', 'condition','MedARAT','MedFMA'});

        save('...\FPN_CON_Pre_EC_TableRmANOVA_with_all_sessions.mat',"FPN_CON_Pre_EC_TableRmANOVA");

        % LR --------------------------------------------------------------
        data2(:,1) = repmat([1:10],1,24) ; 
        data2(:,2) = cat(1,ones(120,1),2*ones(120,1)) ; 
        data2(:,3) = repmat(cat(1,ones(30,1),2*ones(30,1),3*ones(30,1),4*ones(30,1)),2,1)';
        data2(:,4) = repmat(cat(1,ones(10,1),2*ones(10,1),3*ones(10,1)),[8,1])';
        data2(:,5) = cat(1,theta_3to6(:,1),theta_7to10(:,1),theta_11to14(:,1),theta_3to6(:,2),theta_7to10(:,2),...
            theta_11to14(:,2),theta_3to6(:,3),theta_7to10(:,3),theta_11to14(:,3),theta_3to6(:,4),theta_7to10(:,4),...
            theta_11to14(:,4),beta_3to6(:,1),beta_7to10(:,1),beta_11to14(:,1),beta_3to6(:,2),beta_7to10(:,2),...
            beta_11to14(:,2),beta_3to6(:,3),beta_7to10(:,3),beta_11to14(:,3),beta_3to6(:,4),beta_7to10(:,4),...
            beta_11to14(:,4));
        
        data2(:,6) = repmat(med_splited_arat,24,1);
        data2(:,7) = repmat(med_splited_fma,24,1);
        
       FPN_CON_Pre_EC_TableLR = array2table(data2, 'VariableNames', {'Sub','Band','Condition','Session','TE','MedARAT','MedFMA'});
       save('...\FPN_CON_Pre_EC_TableLR_with_all_sessions.mat',"FPN_CON_Pre_EC_TableLR");

% POST ################################################################################################################

        theta_3to6 = fpn_con_all_connectivities.fpn_con_post.theta_3to6;
        theta_7to10 = fpn_con_all_connectivities.fpn_con_post.theta_7to10;
        theta_11to14 = fpn_con_all_connectivities.fpn_con_post.theta_11to14 ;
        
        beta_3to6 = fpn_con_all_connectivities.fpn_con_post.beta_3to6 ;
        beta_7to10 = fpn_con_all_connectivities.fpn_con_post.beta_7to10 ;
        beta_11to14 = fpn_con_all_connectivities.fpn_con_post.beta_11to14 ;
        
        % ANOVA------------------------------------------------------------
        succ_ = [theta_3to6(:,1), theta_7to10(:,1),theta_11to14(:,1), beta_3to6(:,1), beta_7to10(:,1),beta_11to14(:,1)];
        intent_ = [theta_3to6(:,2), theta_7to10(:,2),theta_11to14(:,2),beta_3to6(:,2), beta_7to10(:,2),beta_11to14(:,2)];
        attempt_ = [theta_3to6(:,3), theta_7to10(:,3),theta_11to14(:,3),beta_3to6(:,3), beta_7to10(:,3),beta_11to14(:,3)];
        base_ = [theta_3to6(:,4), theta_7to10(:,4),theta_11to14(:,4),beta_3to6(:,4), beta_7to10(:,4),beta_11to14(:,4)];
        combined_data = [succ_; intent_; attempt_; base_];
        
        cond = [ones(10,1);2*ones(10,1);3*ones(10,1);4*ones(10,1)];
        FPN_CON_Post_EC_TableRmANOVA = array2table([combined_data, cond, repmat(med_splited_arat,4,1), repmat(med_splited_fma,4,1)],...
            'VariableNames', {'B1Ses1', 'B1Ses2', 'B1Ses3','B2Ses1', 'B2Ses2', 'B2Ses3', 'condition','MedARAT','MedFMA'});
        save('...\FPN_CON_Post_EC_TableRmANOVA_with_all_sessions.mat',"FPN_CON_Post_EC_TableRmANOVA");

        % LR --------------------------------------------------------------
        data2(:,1) = repmat([1:10],1,24) ; 
        data2(:,2) = cat(1,ones(120,1),2*ones(120,1)) ; 
        data2(:,3) = repmat(cat(1,ones(30,1),2*ones(30,1),3*ones(30,1),4*ones(30,1)),2,1)';
        data2(:,4) = repmat(cat(1,ones(10,1),2*ones(10,1),3*ones(10,1)),[8,1])';
        data2(:,5) = cat(1,theta_3to6(:,1),theta_7to10(:,1),theta_11to14(:,1),theta_3to6(:,2),theta_7to10(:,2),...
            theta_11to14(:,2),theta_3to6(:,3),theta_7to10(:,3),theta_11to14(:,3),theta_3to6(:,4),theta_7to10(:,4),...
            theta_11to14(:,4),beta_3to6(:,1),beta_7to10(:,1),beta_11to14(:,1),beta_3to6(:,2),beta_7to10(:,2),...
            beta_11to14(:,2),beta_3to6(:,3),beta_7to10(:,3),beta_11to14(:,3),beta_3to6(:,4),beta_7to10(:,4),...
            beta_11to14(:,4));
        
        data2(:,6) = repmat(med_splited_arat,24,1);
        data2(:,7) = repmat(med_splited_fma,24,1);
        
       FPN_CON_Post_EC_TableLR = array2table(data2, 'VariableNames', {'Sub','Band','Condition','Session','TE','MedARAT','MedFMA'});
       save('...\FPN_CON_Post_EC_TableLR_with_all_sessions.mat',"FPN_CON_Post_EC_TableLR");

%%
%% Baseline correcting for logistic regression

clear
clc

% Importing FPN-CON
% PRE
load('...\FPN_CON_Pre_EC_TableLR_with_all_sessions.mat');
load('...\FPN_CON_Pre_EC_TableRmANOVA_with_all_sessions.mat');
% POST
load('...\FPN_CON_Post_EC_TableLR_with_all_sessions.mat');
load('...\FPN_CON_Post_EC_TableRmANOVA_with_all_sessions.mat');

%% Baseline correction

FPN_CON_Pre_BS(1:10,:) = FPN_CON_Pre_EC_TableRmANOVA{1:10,1:6} - FPN_CON_Pre_EC_TableRmANOVA{31:40,1:6};
FPN_CON_Pre_BS(11:20,:) = FPN_CON_Pre_EC_TableRmANOVA{11:20,1:6} - FPN_CON_Pre_EC_TableRmANOVA{31:40,1:6};
FPN_CON_Pre_BS(21:30,:) = FPN_CON_Pre_EC_TableRmANOVA{21:30,1:6} - FPN_CON_Pre_EC_TableRmANOVA{31:40,1:6};
FPN_CON_Pre_BS(:,[7,8,9]) = FPN_CON_Pre_EC_TableRmANOVA{1:30,[7,8,9]};
FPN_CON_Pre_BS = array2table(FPN_CON_Pre_BS,'VariableNames',FPN_CON_Pre_EC_TableRmANOVA.Properties.VariableNames);

FPN_CON_Post_BS(1:10,:) = FPN_CON_Post_EC_TableRmANOVA{1:10,1:6} - FPN_CON_Post_EC_TableRmANOVA{31:40,1:6};
FPN_CON_Post_BS(11:20,:) = FPN_CON_Post_EC_TableRmANOVA{11:20,1:6} - FPN_CON_Post_EC_TableRmANOVA{31:40,1:6};
FPN_CON_Post_BS(21:30,:) = FPN_CON_Post_EC_TableRmANOVA{21:30,1:6} - FPN_CON_Post_EC_TableRmANOVA{31:40,1:6};
FPN_CON_Post_BS(:,[7,8,9]) = FPN_CON_Post_EC_TableRmANOVA{1:30,[7,8,9]};
FPN_CON_Post_BS = array2table(FPN_CON_Post_BS,'VariableNames',FPN_CON_Post_EC_TableRmANOVA.Properties.VariableNames);

save('...\FPN_CON_Pre_BS_with_all_sessions.mat',"FPN_CON_Pre_BS");
save('...\FPN_CON_Post_BS_with_all_sessions.mat',"FPN_CON_Post_BS");



