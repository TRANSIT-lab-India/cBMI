%% lOGISTIC REGRESSION

clear
clc

% Loading Connectivity
load('...\FPN_CON_Pre_BS_with_all_sessions.mat');
load('...\FPN_CON_Post_BS_with_all_sessions.mat');

% Loading POWER
load('...\FPN_Pre_Power_rmANOVA_tabl_BS.mat');
load('...\FPN_Post_Power_rmANOVA_tabl_BS.mat');
load('...\CON_Pre_Power_rmANOVA_tabl_BS.mat');
load('...\CON_Post_Power_rmANOVA_tabl_BS.mat');

load('...\ACC_Pre_BS.mat');

%%
% A way to organize all sessions in each feature to a single column
start = [1,61,121]; 

for i=1:3
    % FPN-CON Pre
    j = start(i);
    data(j   : j+9,1) = FPN_CON_Pre_BS{1:10,i}; % theta succ
    data(j+10: j+19,1) = FPN_CON_Pre_BS{11:20,i}; % theta intent
    data(j+20: j+29,1) = FPN_CON_Pre_BS{21:30,i}; % theta attempt
    
    data(j+30: j+39,1) = FPN_CON_Pre_BS{1:10,i+3}; % beta succ
    data(j+40: j+49,1) = FPN_CON_Pre_BS{11:20,i+3}; % beta intent
    data(j+50: j+59,1) = FPN_CON_Pre_BS{21:30,i+3}; % beta attempt

    % FPN-CON Post
    data(j   : j+9,2) = FPN_CON_Post_BS{1:10,i}; % theta succ
    data(j+10: j+19,2) = FPN_CON_Post_BS{11:20,i}; % theta intent
    data(j+20: j+29,2) = FPN_CON_Post_BS{21:30,i}; % theta attempt
    
    data(j+30: j+39,2) = FPN_CON_Post_BS{1:10,i+3}; % beta succ
    data(j+40: j+49,2) = FPN_CON_Post_BS{11:20,i+3}; % beta intent
    data(j+50: j+59,2) = FPN_CON_Post_BS{21:30,i+3}; % beta attempt
    
    % FPN POwer Pre
    data(j   : j+9,3) = fpn_pre_powTable_rmANOVA{1:10,i}; % theta succ
    data(j+10: j+19,3) = fpn_pre_powTable_rmANOVA{11:20,i}; % theta intent
    data(j+20: j+29,3) = fpn_pre_powTable_rmANOVA{21:30,i}; % theta attempt
    
    data(j+30: j+39,3) = fpn_pre_powTable_rmANOVA{1:10,i+3}; % beta succ
    data(j+40: j+49,3) = fpn_pre_powTable_rmANOVA{11:20,i+3}; % beta intent
    data(j+50: j+59,3) = fpn_pre_powTable_rmANOVA{21:30,i+3}; % beta attempt

     % FPN POwer Post
    data(j   : j+9,4) = fpn_post_powTable_rmANOVA{1:10,i}; % theta succ
    data(j+10: j+19,4) = fpn_post_powTable_rmANOVA{11:20,i}; % theta intent
    data(j+20: j+29,4) = fpn_post_powTable_rmANOVA{21:30,i}; % theta attempt
    
    data(j+30: j+39,4) = fpn_post_powTable_rmANOVA{1:10,i+3}; % beta succ
    data(j+40: j+49,4) = fpn_post_powTable_rmANOVA{11:20,i+3}; % beta intent
    data(j+50: j+59,4) = fpn_post_powTable_rmANOVA{21:30,i+3}; % beta attempt
    
    % CON POwer Pre
    data(j   : j+9,5) = con_pre_powTable_rmANOVA{1:10,i}; % theta succ
    data(j+10: j+19,5) = con_pre_powTable_rmANOVA{11:20,i}; % theta intent
    data(j+20: j+29,5) = con_pre_powTable_rmANOVA{21:30,i}; % theta attempt
    
    data(j+30: j+39,5) = con_pre_powTable_rmANOVA{1:10,i+3}; % beta succ
    data(j+40: j+49,5) = con_pre_powTable_rmANOVA{11:20,i+3}; % beta intent
    data(j+50: j+59,5) = con_pre_powTable_rmANOVA{21:30,i+3}; % beta attempt

    % CON POwer Post
    data(j   : j+9,6) = con_post_powTable_rmANOVA{1:10,i}; % theta succ
    data(j+10: j+19,6) = con_post_powTable_rmANOVA{11:20,i}; % theta intent
    data(j+20: j+29,6) = con_post_powTable_rmANOVA{21:30,i}; % theta attempt
    
    data(j+30: j+39,6) = con_post_powTable_rmANOVA{1:10,i+3}; % beta succ
    data(j+40: j+49,6) = con_post_powTable_rmANOVA{11:20,i+3}; % beta intent
    data(j+50: j+59,6) = con_post_powTable_rmANOVA{21:30,i+3}; % beta attempt
    
end

data(:,7) = repmat([zeros(30,1);ones(30,1)],3,1); % Dummy coding band

% % Getting demographics for the table
data(:,8) = [repmat(all_data{1:10,10},18,1)]; % AGE
data(:,9) = [repmat(all_data{1:10,11},18,1)]; % BASE ARAT
data(:,10) = [repmat(all_data{1:10,12},18,1)]; % BASE FMA
data(:,11) = [repmat(all_data{1:10,14},18,1)]; % STROKE MONTHS
data(:,12) = [repmat(all_data{1:10,13},18,1)]; %  GEN

data(:,8) = repmat([ones(10,1);zeros(20,1);ones(10,1);zeros(20,1)],3,1); % Dummy coding succ/unsucc

table_for_logistic_reg_sessionWise = array2table(data,'VariableNames',{'FpnConPre','FpnConPost','FpnPowPre','FpnPowPost','ConPowPre','ConPowPost','Band',...
    'Age', 'Base_ARAT','Base_FMA','Months_since_Stroke','Gen','SuccOrUnsucc'});

% Adding power values
plotFpnConPre = table_for_logistic_reg_sessionWise.FpnConPre;
plotFpnConPost = table_for_logistic_reg_sessionWise.FpnConPost;
plotFpnPowPre = table_for_logistic_reg_sessionWise.FpnPowPre;
plotFpnPowPost = table_for_logistic_reg_sessionWise.FpnPowPost;
plotConPowPre = table_for_logistic_reg_sessionWise.ConPowPre;
plotConPowPost = table_for_logistic_reg_sessionWise.ConPowPost;

%% Normalization

table_for_logistic_reg_sessionWise.FpnConPre = zscore(table_for_logistic_reg_sessionWise.FpnConPre);
table_for_logistic_reg_sessionWise.FpnConPost = zscore(table_for_logistic_reg_sessionWise.FpnConPost);
table_for_logistic_reg_sessionWise.FpnPowPre = zscore(table_for_logistic_reg_sessionWise.FpnPowPre);
table_for_logistic_reg_sessionWise.FpnPowPost = zscore(table_for_logistic_reg_sessionWise.FpnPowPost);
table_for_logistic_reg_sessionWise.ConPowPre = zscore(table_for_logistic_reg_sessionWise.ConPowPre);
table_for_logistic_reg_sessionWise.ConPowPost = zscore(table_for_logistic_reg_sessionWise.ConPowPost);

table_for_logistic_reg_sessionWise.Age = zscore(table_for_logistic_reg_sessionWise.Age);
table_for_logistic_reg_sessionWise.Base_ARAT = zscore(table_for_logistic_reg_sessionWise.Base_ARAT);
table_for_logistic_reg_sessionWise.Base_FMA = zscore(table_for_logistic_reg_sessionWise.Base_FMA);
table_for_logistic_reg_sessionWise.Months_since_Stroke = zscore(table_for_logistic_reg_sessionWise.Months_since_Stroke);

table_for_logistic_reg_sessionWise = array2table(data,'VariableNames',{'FpnConPre','FpnConPost','FpnPowPre','FpnPowPost','ConPowPre','ConPowPost','Band','SuccOrUnsucc'});

%% Logistic regression model

formula = 'SuccOrUnsucc ~ FpnConPre + FpnConPost + FpnPowPre + FpnPowPost + ConPowPre + ConPowPost + Band + Age + Base_ARAT + Base_FMA + Months_since_Stroke'; % + FpnConPre * FpnConPost' ; % *Band*FpnPowPre'; % * DMNpost * ACCpre * ACCpost * Band';
step_wised_mdl = stepwiseglm(table_for_logistic_reg_sessionWise, formula,'Distribution', 'binomial', 'Link', 'logit',Criterion='Deviance');

% Model summary
disp(step_wised_mdl);


%% Plotting interactions

FpnConPre_val   = table_for_logistic_reg_sessionWise{:,1};
FpnConPost_val  = table_for_logistic_reg_sessionWise{:,2};
FpnPowPost_val  = table_for_logistic_reg_sessionWise{:,4};
ConPowPre_val   = table_for_logistic_reg_sessionWise{:,5};

mean_FpnConPre_val   = mean( FpnConPre_val  );
mean_FpnConPost_val  = mean( FpnConPost_val );
mean_FpnPowPost_val  = mean( FpnPowPost_val );
mean_ConPowPre_val   = mean( ConPowPre_val  );

% eXTRACTING COEFFS
coefs = step_wised_mdl.Coefficients.Estimate;

% Understanding Interactions

% 1) FpnConPre*FpnConPost 

FpnConPre_linspaced  =  linspace(min(FpnConPre_val),max(FpnConPre_val),20);
FpnConPost_linspaced = linspace(min(FpnConPost_val),max(FpnConPost_val),20);

for i=1:length(FpnConPre_linspaced)
    for j=1:length(FpnConPost_linspaced)

        equa = coefs(1) + coefs(2)*mean_FpnConPre_val + coefs(3)*mean_FpnConPost_val + coefs(4)*mean_FpnPowPost_val + ...
            coefs(5)*mean_ConPowPre_val + coefs(6)*FpnConPre_linspaced(i)*FpnConPost_linspaced(j) + coefs(7)*mean_FpnPowPost_val*mean_ConPowPre_val;

        prob_FpnConPre_FpnConPost(i,j) = 1/(1 + exp(-equa));
    end
end

% 2) FpnPowPost*ConPowPre

FpnPowPost_linspaced =  linspace(min(FpnPowPost_val),max(FpnPowPost_val),20);
ConPowPre_linspaced  = linspace(min(ConPowPre_val),max(ConPowPre_val),20);

for i=1:length(FpnPowPost_linspaced)
    for j=1:length(ConPowPre_linspaced)

        equa = coefs(1) + coefs(2)*mean_FpnConPre_val + coefs(3)*mean_FpnConPost_val + coefs(4)*mean_FpnPowPost_val + ...
            coefs(5)*mean_ConPowPre_val + coefs(6)*mean_FpnConPre_val*mean_FpnConPost_val + coefs(7)*FpnPowPost_linspaced(i)*ConPowPre_linspaced(j);

        prob_FpnPowPost_ConPowPre(i,j) = 1/(1 + exp(-equa));
    end
end

%% Plotting 

subplot(1,2,1)
    [X1, X2] = meshgrid(FpnConPre_linspaced, FpnConPost_linspaced); 
    surf(X1, X2, prob_FpnConPre_FpnConPost');
    colormap(turbo); 
    shading interp; 
    material shiny; 
    grid off;
    colorbar; 
    axis square
    
    xlabel('FpnConPre', 'FontSize', 14);
    ylabel('FpnConPost', 'FontSize', 14);
    zlabel('Probability', 'FontSize', 14);
    ylim([-1 3]);
    xlim([-1 3]);
    % title('Interaction between Connectivity measures', 'FontSize', 16);

subplot(1,2,2)
    [X1, X2] = meshgrid(FpnPowPost_linspaced, ConPowPre_linspaced); 
    surf(X1, X2, prob_FpnPowPost_ConPowPre');
        colormap(turbo); 
    shading interp; 
    material shiny; 
    grid off;
    colorbar; 
    axis square
    xlim([-1 3])
    ylim([-1.9 1.9])
    
    xlabel('Fpn Power Post', 'FontSize', 14);
    ylabel('Con Power Pre', 'FontSize', 14);
    zlabel('Probability', 'FontSize', 14);

%% cross validation

c = cvpartition(table_for_logistic_reg_sessionWise{:,8}, 'KFold', 3, 'Stratify', true);  % Input is succ or unsucc

% From stepwise logistic regression
formula = 'SuccOrUnsucc ~ 1 + FpnConPre*FpnConPost + FpnPowPost*ConPowPre';


for i = 1:3

    trainIdx = training(c, i);
    testIdx = test(c, i);
    
    dataTable = table_for_logistic_reg_sessionWise(trainIdx,1:8); % full data table

    mdl = fitglm(dataTable, formula,'Distribution', 'binomial', 'Link', 'logit' );
    
    % Predict on test set
    scores = predict(mdl, table_for_logistic_reg_sessionWise(testIdx,1:7));
    predictions = scores >= 0.5;  % Convert probabilities to binary
    
    % Calculate metrics
    cm(i,:,:) = confusionmat(logical(table_for_logistic_reg_sessionWise{testIdx,8}), predictions); % just outcome
    mat = squeeze(cm(i,:,:));
    accuracy(i) = sum(diag(mat))/sum(mat(:));
    sensitivity(i) = cm(i,2,2)/(cm(i,2,1) + cm(i,2,2));
    specificity(i) = cm(i,1,1)/(cm(i,1,1) + cm(i,1,2));
    [~,~,~,auc(i)] = perfcurve(logical(table_for_logistic_reg_sessionWise{testIdx,8}), scores, 1); % just outcome
    
    precison(i) = cm(i,2,2)/(cm(i,2,2) + cm(i,1,2));
    recall(i)   = cm(i,2,2)/(cm(i,2,2) + cm(i,2,1));

    f_score(i) = (2*precison(i)*recall(i))/(precison(i) + recall(i));
    
end

% Plotting confusion matrix
clc
close all
for s = 1:3
    subplot(3,1,s)
    lab2 = {'0','1'};
    h = confusionchart(squeeze(cm(s,:,:)),lab2);
    xlabel('Predicted');
    ylabel('Actual');
    title(['Fold: ' num2str(s) ', Accuracy: ' num2str(sum(diag(squeeze(cm(s,:,:))))/sum(squeeze(cm(s,:,:)),'all'))])
end

% Plot ROC curve for the last fold (as an example)
[x,y,~,auc_last] = perfcurve(logical(table_for_logistic_reg_sessionWise{testIdx,8}), scores, 1); % just outcome
figure;
plot(x,y)
xlabel('False Positive Rate')
ylabel('True Positive Rate')
title(sprintf('ROC Curve (AUC = %.3f)', auc_last))

% Display results
fprintf('Mean Accuracy: %.3f (±%.3f)\n', mean(accuracy), std(accuracy));
fprintf('Mean Sensitivity: %.3f (±%.3f)\n', mean(sensitivity), std(sensitivity));
fprintf('Mean Specificity: %.3f (±%.3f)\n', mean(specificity), std(specificity));
fprintf('Mean AUC: %.3f (±%.3f)\n', mean(auc), std(auc));
fprintf('Mean F score: %.3f (±%.3f)\n', mean(f_score), std(f_score));

