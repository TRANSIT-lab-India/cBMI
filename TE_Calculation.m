%% TE (ONE TIME RUN)

% PRE #####################################################################

clear 
clc

sourceDir = '...sled_data_folder'; 
files = dir(fullfile(sourceDir, '*.set'));

for file_num=1:10
    disp(file_num);
    path = fullfile(sourceDir,files(file_num).name);
    eeg = pop_loadset(path);
    
    % Loading network file
    load('...Network.mat');
    roi_idx = Network.roi_idx;
    netPower = [];
    for cond = 1:size(eeg.etc.src.act,3)
        for i=1:8
                k = roi_idx(i,:) ~=0;
                ind_without_zeros1 = roi_idx(i,k);

                netPower(i,cond,:) = mean(eeg.etc.src.act(ind_without_zeros1,:,cond),1); 
        end
    end
    

    pre = 1:250; 
    
    succ = netPower(:,1:9,:);
    intent = netPower(:,10:18,:);
    attempt = netPower(:,19:27,:);
    base = netPower(:,28:36,:);

    %Con -- Betas
    succ_consB = {squeeze(succ(1,2,pre)),squeeze(succ(1,5,pre)),squeeze(succ(1,8,pre))};
    intent_consB = {squeeze(intent(1,2,pre)),squeeze(intent(1,5,pre)),squeeze(intent(1,8,pre))};
    attempt_consB = {squeeze(attempt(1,2,pre)),squeeze(attempt(1,5,pre)),squeeze(attempt(1,8,pre))};
    base_consB = {squeeze(base(1,2,pre)),squeeze(base(1,5,pre)),squeeze(base(1,8,pre))};
    
    %FPN -- Betas
    succ_fpnsB = {squeeze(succ(2,2,pre)),squeeze(succ(2,5,pre)),squeeze(succ(2,8,pre))};
    intent_fpnsB = {squeeze(intent(2,2,pre)),squeeze(intent(2,5,pre)),squeeze(intent(2,8,pre))};
    attempt_fpnsB = {squeeze(attempt(2,2,pre)),squeeze(attempt(2,5,pre)),squeeze(attempt(2,8,pre))};
    base_fpnsB = {squeeze(base(2,2,pre)),squeeze(base(2,5,pre)),squeeze(base(2,8,pre))};
    
    %Con -- Thetas
    succ_consT = {squeeze(succ(1,3,pre)),squeeze(succ(1,6,pre)),squeeze(succ(1,9,pre))};
    intent_consT = {squeeze(intent(1,3,pre)),squeeze(intent(1,6,pre)),squeeze(intent(1,9,pre))};
    attempt_consT = {squeeze(attempt(1,3,pre)),squeeze(attempt(1,6,pre)),squeeze(attempt(1,9,pre))};
    base_consT = {squeeze(base(1,3,pre)),squeeze(base(1,6,pre)),squeeze(base(1,9,pre))};
    
    %FPN -- Thetas
    succ_fpnsT = {squeeze(succ(2,3,pre)),squeeze(succ(2,6,pre)),squeeze(succ(2,9,pre))};
    intent_fpnsT = {squeeze(intent(2,3,pre)),squeeze(intent(2,6,pre)),squeeze(intent(2,9,pre))};
    attempt_fpnsT = {squeeze(attempt(2,3,pre)),squeeze(attempt(2,6,pre)),squeeze(attempt(2,9,pre))};
    base_fpnsT = {squeeze(base(2,3,pre)),squeeze(base(2,6,pre)),squeeze(base(2,9,pre))};

    lags = 1:1:50;
    for i=1:length(lags)
        for cond=1:length(succ_fpnsT)
            
            te_succB(file_num,i,cond,:) = transferEntropy(succ_fpnsB{cond}, succ_consB{cond},lags(i));
            te_IntentB(file_num,i,cond,:) = transferEntropy(intent_fpnsB{cond}, intent_consB{cond},lags(i));
            te_AttemptB(file_num,i,cond,:) = transferEntropy(attempt_fpnsB{cond}, attempt_consB{cond},lags(i));
            te_baseB(file_num,i,cond,:) = transferEntropy(base_fpnsB{cond}, base_consB{cond},lags(i));
    
            te_succT(file_num,i,cond,:) = transferEntropy(succ_fpnsT{cond}, succ_consT{cond},lags(i));
            te_IntentT(file_num,i,cond,:) = transferEntropy(intent_fpnsT{cond}, intent_consT{cond},lags(i));
            te_AttemptT(file_num,i,cond,:) = transferEntropy(attempt_fpnsT{cond}, attempt_consT{cond},lags(i));
            te_baseT(file_num,i,cond,:) = transferEntropy(base_fpnsT{cond}, base_consT{cond},lags(i));
        end
    end
end

all_sub_te_con_fpn_pre. te_succB = te_succB;
all_sub_te_con_fpn_pre. te_IntentB = te_IntentB;
all_sub_te_con_fpn_pre. te_AttemptB = te_AttemptB;
all_sub_te_con_fpn_pre. te_baseB = te_baseB;

all_sub_te_con_fpn_pre. te_succT = te_succT;
all_sub_te_con_fpn_pre. te_IntentT = te_IntentT;
all_sub_te_con_fpn_pre. te_AttemptT = te_AttemptT;
all_sub_te_con_fpn_pre. te_baseT = te_baseT;

save('...\All_sub_TE_CON_FPN_pre_with_all_sessions.mat',"all_sub_te_con_fpn_pre")

% POST #####################################################################

clear 
clc

sourceDir = '...sled_data_folder'; 
files = dir(fullfile(sourceDir, '*.set'));

for file_num=1:10
    disp(file_num);
    path = fullfile(sourceDir,files(file_num).name);
    eeg = pop_loadset(path);

    load('...Network.mat');
    roi_idx = Network.roi_idx;
    netPower = [];
    for cond = 1:size(eeg.etc.src.act,3)
        for i=1:8
                k = roi_idx(i,:) ~=0;
                ind_without_zeros1 = roi_idx(i,k);
                % % disp(ind_without_zeros1);
                netPower(i,cond,:) = mean(eeg.etc.src.act(ind_without_zeros1,:,cond),1); 
        end
    end
    

    post = 251:500;
    

    succ = netPower(:,1:9,:);
    intent = netPower(:,10:18,:);
    attempt = netPower(:,19:27,:);
    base = netPower(:,28:36,:);

    %Con -- Betas
    succ_consB = {squeeze(succ(1,2,post)),squeeze(succ(1,5,post)),squeeze(succ(1,8,post))};
    intent_consB = {squeeze(intent(1,2,post)),squeeze(intent(1,5,post)),squeeze(intent(1,8,post))};
    attempt_consB = {squeeze(attempt(1,2,post)),squeeze(attempt(1,5,post)),squeeze(attempt(1,8,post))};
    base_consB = {squeeze(base(1,2,post)),squeeze(base(1,5,post)),squeeze(base(1,8,post))};
    
    %FPN -- Betas
    succ_fpnsB = {squeeze(succ(2,2,post)),squeeze(succ(2,5,post)),squeeze(succ(2,8,post))};
    intent_fpnsB = {squeeze(intent(2,2,post)),squeeze(intent(2,5,post)),squeeze(intent(2,8,post))};
    attempt_fpnsB = {squeeze(attempt(2,2,post)),squeeze(attempt(2,5,post)),squeeze(attempt(2,8,post))};
    base_fpnsB = {squeeze(base(2,2,post)),squeeze(base(2,5,post)),squeeze(base(2,8,post))};
    
    %Con -- Thetas
    succ_consT = {squeeze(succ(1,3,post)),squeeze(succ(1,6,post)),squeeze(succ(1,9,post))};
    intent_consT = {squeeze(intent(1,3,post)),squeeze(intent(1,6,post)),squeeze(intent(1,9,post))};
    attempt_consT = {squeeze(attempt(1,3,post)),squeeze(attempt(1,6,post)),squeeze(attempt(1,9,post))};
    base_consT = {squeeze(base(1,3,post)),squeeze(base(1,6,post)),squeeze(base(1,9,post))};
    
    %FPN -- Thetas
    succ_fpnsT = {squeeze(succ(2,3,post)),squeeze(succ(2,6,post)),squeeze(succ(2,9,post))};
    intent_fpnsT = {squeeze(intent(2,3,post)),squeeze(intent(2,6,post)),squeeze(intent(2,9,post))};
    attempt_fpnsT = {squeeze(attempt(2,3,post)),squeeze(attempt(2,6,post)),squeeze(attempt(2,9,post))};
    base_fpnsT = {squeeze(base(2,3,post)),squeeze(base(2,6,post)),squeeze(base(2,9,post))};

    lags = 1:1:50;
    for i=1:length(lags)
        for cond=1:length(succ_fpnsT)
            
            te_succB(file_num,i,cond,:) = transferEntropy(succ_fpnsB{cond}, succ_consB{cond},lags(i));
            te_IntentB(file_num,i,cond,:) = transferEntropy(intent_fpnsB{cond}, intent_consB{cond},lags(i));
            te_AttemptB(file_num,i,cond,:) = transferEntropy(attempt_fpnsB{cond}, attempt_consB{cond},lags(i));
            te_baseB(file_num,i,cond,:) = transferEntropy(base_fpnsB{cond}, base_consB{cond},lags(i));
    
            te_succT(file_num,i,cond,:) = transferEntropy(succ_fpnsT{cond}, succ_consT{cond},lags(i));
            te_IntentT(file_num,i,cond,:) = transferEntropy(intent_fpnsT{cond}, intent_consT{cond},lags(i));
            te_AttemptT(file_num,i,cond,:) = transferEntropy(attempt_fpnsT{cond}, attempt_consT{cond},lags(i));
            te_baseT(file_num,i,cond,:) = transferEntropy(base_fpnsT{cond}, base_consT{cond},lags(i));
        end
    end
end

all_sub_te_con_fpn_post. te_succB = te_succB;
all_sub_te_con_fpn_post. te_IntentB = te_IntentB;
all_sub_te_con_fpn_post. te_AttemptB = te_AttemptB;
all_sub_te_con_fpn_post. te_baseB = te_baseB;

all_sub_te_con_fpn_post. te_succT = te_succT;
all_sub_te_con_fpn_post. te_IntentT = te_IntentT;
all_sub_te_con_fpn_post. te_AttemptT = te_AttemptT;
all_sub_te_con_fpn_post. te_baseT = te_baseT;

save('...\All_sub_TE_CON_FPN_post_with_all_sessions.mat',"all_sub_te_con_fpn_post")

