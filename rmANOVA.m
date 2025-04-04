clear
clc

% % Importing FPN-CON
% % PRE
load('...\FPN_CON_Pre_EC_TableLR2.mat');
load('...\FPN_CON_Pre_EC_TableRmANOVA2.mat');
% POST
load('...\FPN_CON_Post_EC_TableLR2.mat');
load('...\FPN_CON_Post_EC_TableRmANOVA2.mat');

%% FPN CON Connectivity
 
% PRE  --------------------------------------------------------------------
table_ = FPN_CON_Pre_EC_TableRmANOVA;
table_.condition = categorical(table_.condition);
table_.MedARAT = categorical(table_.MedARAT);
table_.MedFMA = categorical(table_.MedFMA);

factorNames = {'Band','Session'};

within = table({'B1';'B1';'B1';'B2';'B2';'B2';},...
    {'Ses1';'Ses2';'Ses3';'Ses1';'Ses2';'Ses3'},'VariableNames',factorNames);

% MODELS
rm_fpn_con_pre = fitrm(table_,'B1Ses1-B2Ses3 ~ condition + MedARAT + MedFMA','WithinDesign',within);

[ranovatbl_fpn_con_pre] = ranova(rm_fpn_con_pre, 'WithinModel','Band*Session');

display(ranovatbl_fpn_con_pre); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% POST --------------------------------------------------------------------
table_ = FPN_CON_Post_EC_TableRmANOVA;
table_.condition = categorical(table_.condition);
table_.MedARAT = categorical(table_.MedARAT);
table_.MedFMA = categorical(table_.MedFMA);

factorNames = {'Band','Session'};

within = table({'B1';'B1';'B1';'B2';'B2';'B2';},...
    {'Ses1';'Ses2';'Ses3';'Ses1';'Ses2';'Ses3'},'VariableNames',factorNames);

% MODELS
rm_fpn_con_post = fitrm(table_,'B1Ses1-B2Ses3~condition + MedARAT + MedFMA','WithinDesign',within);

[ranovatbl_fpn_con_post] = ranova(rm_fpn_con_post, 'WithinModel','Band*Session');

display(ranovatbl_fpn_con_post);  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Mauchly's test

mauchly(rm_fpn_con_pre)
mauchly(rm_fpn_con_post)

%% GG Correction 
clc
ranovatbl = ranovatbl_fpn_con_post;
e = epsilon(rm_fpn_con_post);        % Change this as well

for i=1:length(ranovatbl.Row)
    if ranovatbl.pValueGG(ranovatbl.Row{i}) < 0.05
        if i<=6 && ~strcmp(ranovatbl.Row{i},'(Intercept)')
            df1 = e.GreenhouseGeisser * ranovatbl.DF(ranovatbl.Row{i});
            df2 = e.GreenhouseGeisser * ranovatbl.DF(ranovatbl.Row{5});
            fprintf('For %s: F(%.2f, %.2f) = %.2f, p = %.4f, GG-corrected) e = %0.2f \n',ranovatbl.Row{i},df1,df2,ranovatbl.F(ranovatbl.Row{i}),ranovatbl.pValueGG(ranovatbl.Row{i}),e.GreenhouseGeisser);
        elseif i >= 6 && i <= 11 && ~strcmp(ranovatbl.Row{i},'(Intercept)')
            df1 = e.GreenhouseGeisser * ranovatbl.DF(ranovatbl.Row{i});
            df2 = e.GreenhouseGeisser * ranovatbl.DF(ranovatbl.Row{10});
             fprintf('For %s: F(%.2f, %.2f) = %.2f, p = %.4f, GG-corrected) e = %0.2f \n',ranovatbl.Row{i},df1,df2,ranovatbl.F(ranovatbl.Row{i}),ranovatbl.pValueGG(ranovatbl.Row{i}),e.GreenhouseGeisser);
        elseif i >= 12 && i <= 16 && ~strcmp(ranovatbl.Row{i},'(Intercept)')
            df1 = e.GreenhouseGeisser * ranovatbl.DF(ranovatbl.Row{i});
            df2 = e.GreenhouseGeisser * ranovatbl.DF(ranovatbl.Row{15});
             fprintf('For %s: F(%.2f, %.2f) = %.2f, p = %.4f, GG-corrected) e = %0.2f \n',ranovatbl.Row{i},df1,df2,ranovatbl.F(ranovatbl.Row{i}),ranovatbl.pValueGG(ranovatbl.Row{i}),e.GreenhouseGeisser);
        elseif i >= 16 && i <= 20 && ~strcmp(ranovatbl.Row{i},'(Intercept)')
            df1 = e.GreenhouseGeisser * ranovatbl.DF(ranovatbl.Row{i});
            df2 = e.GreenhouseGeisser * ranovatbl.DF(ranovatbl.Row{20});
             fprintf('For %s: F(%.2f, %.2f) = %.2f, p = %.4f, GG-corrected) e = %0.2f \n',ranovatbl.Row{i},df1,df2,ranovatbl.F(ranovatbl.Row{i}),ranovatbl.pValueGG(ranovatbl.Row{i}),e.GreenhouseGeisser);
        end
    end
end

%% pOST HOC Figures

%% PRE ####################################################################

% % 1) Condition main effec
multcompare(rm_fpn_con_pre,'condition')
b = boxchart(FPN_CON_Pre_EC_TableLR.Condition,FPN_CON_Pre_EC_TableLR.TE); hold on

        b.BoxFaceColor = 'k';
        b.BoxFaceAlpha = 0.8;
        b.BoxMedianLineColor = [1 1 1];
        b.MarkerStyle = '+';
        b.MarkerColor = 'k';
        b.MarkerSize = 3;
        b.WhiskerLineStyle = '-';

xticks(1:4)
xticklabels({'Succ','Unsucc. Intent','Unsucc. Attempt','Rest'})
ylabel('Connectivity (Transfer Entropy)');

    line([1,4],[0.62,0.62], 'color','k','LineWidth',1.5); 
    line([1,1],[0.62,0.60], 'color','k','LineWidth',1.5);
    line([4,4],[0.62,0.60], 'color','k','LineWidth',1.5);
    text(2.5, 0.63, '****', 'HorizontalAlignment', 'center', 'FontSize', 12);

    line([1,3],[0.58,0.58], 'color','k','LineWidth',1.5); 
    line([1,1],[0.58,0.56], 'color','k','LineWidth',1.5);
    line([3,3],[0.58,0.56], 'color','k','LineWidth',1.5);
    text(2, 0.59, '**', 'HorizontalAlignment', 'center', 'FontSize', 12);

    line([2,3],[0.51,0.51], 'color','k','LineWidth',1.5); 
    line([2,2],[0.51,0.49], 'color','k','LineWidth',1.5);
    line([3,3],[0.51,0.49], 'color','k','LineWidth',1.5);
    text(2.5, 0.52, '*', 'HorizontalAlignment', 'center', 'FontSize', 12);

    line([2,4],[0.47,0.47], 'color','k','LineWidth',1.5); 
    line([2,2],[0.47,0.45], 'color','k','LineWidth',1.5);
    line([4,4],[0.47,0.45], 'color','k','LineWidth',1.5);
    text(3.5, 0.48, '***', 'HorizontalAlignment', 'center', 'FontSize', 12);

ylim([-0.1 0.7])
title('FPN-CON PRE - Trial Outcome (Main Effect)');

% 2) Band main effect
multcompare(rm_fpn_con_pre,'Band')
close all;
b = boxchart(FPN_CON_Pre_EC_TableLR.Band,FPN_CON_Pre_EC_TableLR.TE); hold on

        b.BoxFaceColor = 'k';
        b.BoxFaceAlpha = 0.8;
        b.BoxMedianLineColor = [1 1 1];
        b.MarkerStyle = '+';
        b.MarkerColor = 'k';
        b.MarkerSize = 3;
        b.WhiskerLineStyle = '-';

xticks(1:4)
xticklabels({'Theta','Beta'})
ylabel('Connectivity (Transfer Entropy)');

    line([1,2],[0.62,0.62], 'color','k','LineWidth',1.5); 
    line([1,1],[0.62,0.60], 'color','k','LineWidth',1.5);
    line([2,2],[0.62,0.60], 'color','k','LineWidth',1.5);
    text(1.5, 0.63, '****', 'HorizontalAlignment', 'center', 'FontSize', 12);

ylim([-0.1 0.7])
title('FPN-CON PRE - Band (Main Effect)');

% 3) Condition:Band effect
multcompare(rm_fpn_con_pre,'condition', 'by', 'Band')
close all;
b = boxchart(FPN_CON_Pre_EC_TableLR.Band,FPN_CON_Pre_EC_TableLR.TE,'GroupByColor',FPN_CON_Pre_EC_TableLR.Condition); hold on
        [b(1).MarkerStyle,b(3).MarkerStyle,b(4).MarkerStyle] = deal('+');
        [b(1).MarkerSize,b(3).MarkerSize,b(4).MarkerSize] = deal(3);
xticks(1:2)
xticklabels({'Theta','Beta'})
ylabel('Connectivity (Transfer Entropy)');


% Theta
    % 1 and 4
    line( [0.625,1.375],[0.62,0.62], 'color','k','LineWidth',1.5); 
    line( [0.625,0.625],[0.62,0.60], 'color','k','LineWidth',1.5);
    line( [1.375,1.375],[0.62,0.60], 'color','k','LineWidth',1.5);
    text(1, 0.63, '***', 'HorizontalAlignment', 'center', 'FontSize', 12);
    
    %1 and 3
    line([0.625,1.125] ,[0.58,0.58], 'color','k','LineWidth',1.5); 
    line([0.625,0.625],[0.58,0.56], 'color','k','LineWidth',1.5);
    line([1.125,1.125],[0.58,0.56], 'color','k','LineWidth',1.5);
    text(0.875, 0.59, '*', 'HorizontalAlignment', 'center', 'FontSize', 12);

    % 2 and 4
    line( [0.875,1.375],[0.51,0.51], 'color','k','LineWidth',1.5); 
    line( [0.875,0.875],[0.51,0.49], 'color','k','LineWidth',1.5);
    line( [1.375,1.375],[0.51,0.49], 'color','k','LineWidth',1.5);
    text(1.125, 0.52, '**', 'HorizontalAlignment', 'center', 'FontSize', 12);
    

    % 2 and 3
    line([0.875,1.125],[0.47,0.47], 'color','k','LineWidth',1.5); 
    line([0.875,0.875],[0.47,0.45], 'color','k','LineWidth',1.5);
    line([1.125,1.125],[0.47,0.45], 'color','k','LineWidth',1.5);
    text(1, 0.48, '*', 'HorizontalAlignment', 'center', 'FontSize', 12);

% Beta
    % 1 and 4
    line( [1.625,2.375],[0.42,0.42], 'color','k','LineWidth',1.5); 
    line( [1.625,1.625],[0.42,0.40], 'color','k','LineWidth',1.5);
    line( [2.375,2.375],[0.42,0.40], 'color','k','LineWidth',1.5);
    text(2, 0.43, '****', 'HorizontalAlignment', 'center', 'FontSize', 12);
    
    %1 and 3
    line([1.625,2.125] ,[0.38,0.38], 'color','k','LineWidth',1.5); 
    line([1.625,1.625],[0.38,0.36], 'color','k','LineWidth',1.5);
    line([2.125,2.125],[0.38,0.36], 'color','k','LineWidth',1.5);
    text(1.875, 0.39, '***', 'HorizontalAlignment', 'center', 'FontSize', 12);

    % 1 and 2
    line([1.625,1.875],[0.31,0.31], 'color','k','LineWidth',1.5); 
    line([1.625,1.625],[0.31,0.29], 'color','k','LineWidth',1.5);
    line([1.875,1.875],[0.31,0.29], 'color','k','LineWidth',1.5);
    text(1.75, 0.32, '**', 'HorizontalAlignment', 'center', 'FontSize', 12);   

    % 2 and 4
    line( [1.875,2.375],[0.27,0.27], 'color','k','LineWidth',1.5); 
    line( [1.875,1.875],[0.27,0.25], 'color','k','LineWidth',1.5);
    line( [2.375,2.375],[0.27,0.25], 'color','k','LineWidth',1.5);
    text(2.125, 0.28, '*', 'HorizontalAlignment', 'center', 'FontSize', 12);

    legend({'Success','Unsucc. Intent','Unsucc. Attempt','Rest'});

ylim([-0.1 0.7])
title('FPN-CON PRE - Trial Outcome:Band (Interaction Effect)');

%% POST ####################################################################

% 1) Condition main effect
multcompare(rm_fpn_con_post,'condition')
close all;
b = boxchart(FPN_CON_Post_EC_TableLR.Condition,FPN_CON_Post_EC_TableLR.TE); hold on

        b.BoxFaceColor = 'k';
        b.BoxFaceAlpha = 0.8;
        b.BoxMedianLineColor = [1 1 1];
        b.MarkerStyle = '+';
        b.MarkerColor = 'k';
        b.MarkerSize = 3;
        b.WhiskerLineStyle = '-';

xticks(1:4)
xticklabels({'Succ','Unsucc. Intent','Unsucc. Attempt','Rest'})
ylabel('Connectivity (Transfer Entropy)');

    line([1,4],[0.62,0.62], 'color','k','LineWidth',1.5); 
    line([1,1],[0.62,0.60], 'color','k','LineWidth',1.5);
    line([4,4],[0.62,0.60], 'color','k','LineWidth',1.5);
    text(2.5, 0.63, '***', 'HorizontalAlignment', 'center', 'FontSize', 12);

    line([2,4],[0.58,0.58], 'color','k','LineWidth',1.5); 
    line([2,2],[0.58,0.56], 'color','k','LineWidth',1.5);
    line([4,4],[0.58,0.56], 'color','k','LineWidth',1.5);
    text(3, 0.59, '***', 'HorizontalAlignment', 'center', 'FontSize', 12);

    line([4,3],[0.54,0.54], 'color','k','LineWidth',1.5); 
    line([4,4],[0.54,0.52], 'color','k','LineWidth',1.5);
    line([3,3],[0.54,0.52], 'color','k','LineWidth',1.5);
    text(3.5, 0.55, '*', 'HorizontalAlignment', 'center', 'FontSize', 12);

ylim([-0.1 0.7])
title('FPN-CON Post - Trial Outcome (Main Effect)');

% 2) Band main effect
multcompare(rm_fpn_con_post,'Band')
close all;
b = boxchart(FPN_CON_Post_EC_TableLR.Band,FPN_CON_Post_EC_TableLR.TE); hold on
        b.BoxFaceColor = 'k';
        b.BoxFaceAlpha = 0.8;
        b.BoxMedianLineColor = [1 1 1];
        b.MarkerStyle = '+';
        b.MarkerColor = 'k';
        b.MarkerSize = 3;
        b.WhiskerLineStyle = '-';
xticks(1:4)
xticklabels({'Theta','Beta'})
ylabel('Connectivity (Transfer Entropy)');

    line([1,2],[0.62,0.62], 'color','k','LineWidth',1.5); 
    line([1,1],[0.62,0.60], 'color','k','LineWidth',1.5);
    line([2,2],[0.62,0.60], 'color','k','LineWidth',1.5);
    text(1.5, 0.63, '****', 'HorizontalAlignment', 'center', 'FontSize', 12);

ylim([-0.1 0.7])
title('FPN-CON Post - Band (Main Effect)');

% 3) Condition:Band effect
multcompare(rm_fpn_con_post,'condition', 'by', 'Band')
close all;
b = boxchart(FPN_CON_Post_EC_TableLR.Band,FPN_CON_Post_EC_TableLR.TE,'GroupByColor',FPN_CON_Post_EC_TableLR.Condition); hold on
        [b(1).MarkerStyle,b(2).MarkerStyle, b(3).MarkerStyle,b(4).MarkerStyle] = deal('+');
        [b(1).MarkerSize,b(2).MarkerSize,b(3).MarkerSize,b(4).MarkerSize] = deal(3);
xticks(1:2)
xticklabels({'Theta','Beta'})
ylabel('Connectivity (Transfer Entropy)');

% Theta
    % 1 and 4
    line( [0.625,1.375],[0.62,0.62], 'color','k','LineWidth',1.5); 
    line( [0.625,0.625],[0.62,0.60], 'color','k','LineWidth',1.5);
    line( [1.375,1.375],[0.62,0.60], 'color','k','LineWidth',1.5);
    text(1, 0.63, '**', 'HorizontalAlignment', 'center', 'FontSize', 12);

    % 2 and 4
    line( [0.875,1.375],[0.58,0.58], 'color','k','LineWidth',1.5); 
    line( [0.875,0.875],[0.58,0.56], 'color','k','LineWidth',1.5);
    line( [1.375,1.375],[0.58,0.56], 'color','k','LineWidth',1.5);
    text(1.125, 0.59, '**', 'HorizontalAlignment', 'center', 'FontSize', 12);
    

% Beta
    % 1 and 4
    line( [1.625,2.375],[0.42,0.42], 'color','k','LineWidth',1.5); 
    line( [1.625,1.625],[0.42,0.40], 'color','k','LineWidth',1.5);
    line( [2.375,2.375],[0.42,0.40], 'color','k','LineWidth',1.5);
    text(2, 0.43, '****', 'HorizontalAlignment', 'center', 'FontSize', 12);
    
    %1 and 3
    line([1.625,2.125] ,[0.38,0.38], 'color','k','LineWidth',1.5); 
    line([1.625,1.625],[0.38,0.36], 'color','k','LineWidth',1.5);
    line([2.125,2.125],[0.38,0.36], 'color','k','LineWidth',1.5);
    text(1.875, 0.39, '*', 'HorizontalAlignment', 'center', 'FontSize', 12);

    % 1 and 2
    line([1.625,1.875],[0.31,0.31], 'color','k','LineWidth',1.5); 
    line([1.625,1.625],[0.31,0.29], 'color','k','LineWidth',1.5);
    line([1.875,1.875],[0.31,0.29], 'color','k','LineWidth',1.5);
    text(1.75, 0.32, '*', 'HorizontalAlignment', 'center', 'FontSize', 12);   

    legend({'Success','Unsucc. Intent','Unsucc. Attempt','Rest'});

ylim([-0.1 0.7])
title('FPN-CON Post - Condition:Band');

% 4) MedFMA:Band effect
multcompare(rm_fpn_con_post,'MedFMA', 'by', 'Band')
close all;
b = boxchart(FPN_CON_Post_EC_TableLR.Band,FPN_CON_Post_EC_TableLR.TE,'GroupByColor',FPN_CON_Post_EC_TableLR.MedFMA); hold on
        [b(1).MarkerStyle,b(2).MarkerStyle] = deal('+');
        [b(1).MarkerSize,b(2).MarkerSize] = deal(3);
xticks(1:2)
xticklabels({'Theta','Beta'})
ylabel('Connectivity (Transfer Entropy)');

    % 1 and 2
    line( [0.75,1.25],[0.52,0.52], 'color','k','LineWidth',1.5); 
    line( [0.75,0.75],[0.52,0.50], 'color','k','LineWidth',1.5);
    line( [1.25,1.25],[0.52,0.50], 'color','k','LineWidth',1.5);
    text(1, 0.53, '*', 'HorizontalAlignment', 'center', 'FontSize', 12);

    legend({'Not Improved (FMA)','Improved (FMA)'});

ylim([-0.1 0.7])
title('FPN-CON Post - SubjectGroupFMA:Band (Interaction)');




