% Epoching script (❁´◡`❁)

% Four different trial outcome epochs are extracted from the EEG based on
% corresponding markers for theta and beta bands. After that, the 12 sessions 
% are compressed into 3 by taking the average of each four and finally saving 
% it into an eeglab structure format

clear
clc

sourceDir = '...SUBJECT\EEG\Bandpassed\';
files = dir(fullfile(sourceDir, '*.set'));


    for file_num = 1:36
            
            path = fullfile(sourceDir,files(file_num).name);
            eeg = pop_loadset(path);
    
    
            % 1) INDICES OF S 2-------------------------------------------------
            k=1;
            lastS2ind = [];
            for i=1:size(eeg.event,2)-1
                if strcmp(eeg.event(i).type,'S  2')
                    lastS2ind(k) = i; k=k+1;
                end
            end
    
            % Indices of s8
            k=1;
            lastS8ind = [];
            for i=1:size(eeg.event,2)
                if strcmp(eeg.event(i).type,'S  8')
                    lastS8ind(k) = i; k=k+1;
                end
            end
            
            %----
            lastt = lastS8ind(end);
            sec_last = lastS8ind(end-2);
    
            len = lastt - sec_last;
    
            for i = 1:len
                if strcmp(eeg.event(sec_last+i).type,'S  2')
                    last = sec_last+i;
                end
            end
          
    
            % 2) START AND END OF EACH TRIAL-------------------------------------------------
            l=1; m=1;
            startsInd=[];
            endsInd=[];
            for i=1:last
                mark = eeg.event(i).type;    
                if strcmp(mark,'S  2')
                    j=i+1;  
                    startsInd(l) = i;
                    l=l+1;
                    while true
                        mark = eeg.event(j).type;
                        if strcmp(mark,'S  8')
                            endsInd(m) = j;
                            m=m+1;
                            break;                                          
                        end 
                        j=j+1;
                    end
                end
            end
            
            % 3) INDICES OF 301-------------------------------------------------
            
            interest_marker = '301';
            k=1;
            ind_301=[];
            for i=1:size(eeg.event,2)
                if strcmp(eeg.event(i).type,interest_marker)
                    ind_301(k) = i;
                    k=k+1;
                end
            end
            
            % 4) INDICES OF S  1-------------------------------------------------
            ind_s1=[];
            interest_marker = 'S  1';
            k=1;
            for i=1:size(eeg.event,2)
                if strcmp(eeg.event(i).type,interest_marker) || strcmp(eeg.event(i).type,'302')
                    ind_s1(k) = i;
                    k=k+1;
                end
            end
    
            % EPOCHING
    
            epochs_intent = [];
            epochs_attempt = [];
            epochs_301 = [];
    
            % 1) 301
            
            k=1;
            for i=1:length(ind_301)
                if strcmp(eeg.event(ind_301(i)-1).type,'S 64') || strcmp(eeg.event(ind_301(i)-1).type,'S 16')
                    epochs_301(k,:,:) = eeg.data(:,eeg.event(ind_301(i)).latency - 250:eeg.event(ind_301(i)).latency + 250);
                    k=k+1;
                end
            end
            
            % 2) INTENT
            
            k=1;
            for i=1:length(ind_s1)
                if strcmp(eeg.event(ind_s1(i)-1).type,'S 64')
                    epochs_intent(k,:,:) = eeg.data(:,eeg.event(ind_s1(i)-1).latency - 250:eeg.event(ind_s1(i)-1).latency + 250);
                    k=k+1;
                end
            end
            
            % 3) ATTEMPT
            
            k=1;
            for i=1:length(ind_s1)
                if strcmp(eeg.event(ind_s1(i)-1).type,'303')
                    disp('FOUND');
                    epochs_attempt(k,:,:) = eeg.data(:,eeg.event(ind_s1(i)-1).latency - 250:eeg.event(ind_s1(i)-1).latency + 250);
                    k=k+1;
                end
            end
    
            % 4) GETTING INTENT and ATTEMPT FROM THE WHOLE TRIAL
    
            m=size(epochs_intent,1);
            n=size(epochs_attempt,1);
    
            % To make sure that we dont get the error of 
            % 'Index in position 1 is invalid. Array indices must be positive integers or logical values.'
    
            if n==0
                n=1;
            end
    
            if m==0
                m=1;
            end
            
            for i=1:length(ind_s1)
            
                if strcmp(eeg.event(ind_s1(i)-1).type,'S  2') == 0
                    j=2;
                    while true
                        if strcmp(eeg.event(ind_s1(i)-j).type,'S  2')
                            break;
                
                        elseif strcmp(eeg.event(ind_s1(i)-j).type,'S 64') && (eeg.event(ind_s1(i)-j).latency - eeg.event(ind_s1(i)-(j+1)).latency)>250 ...
                                && (eeg.event(ind_s1(i)-(j-1)).latency - eeg.event(ind_s1(i)-j).latency)>250
                            epochs_intent(m,:,:) = eeg.data(:,eeg.event(ind_s1(i)-j).latency - 250:eeg.event(ind_s1(i)-j).latency + 250);
                            m=m+1;
                            % fprintf(' Intent: Type : %s , Dur_plus : %f and Dur_minus : %f \n',eeg.event(ind_s1(i)-j).type,(eeg.event(ind_s1(i)-j).latency - eeg.event(ind_s1(i)-(j+1)).latency)/250,(eeg.event(ind_s1(i)-(j-1)).latency - eeg.event(ind_s1(i)-j).latency)/250);
                            j=j+1;
                        elseif strcmp(eeg.event(ind_s1(i)-j).type,'303') && (eeg.event(ind_s1(i)-j).latency - eeg.event(ind_s1(i)-(j+1)).latency)>250 ...
                                && (eeg.event(ind_s1(i)-(j-1)).latency - eeg.event(ind_s1(i)-j).latency)>250
                            epochs_attempt(n,:,:) = eeg.data(:,eeg.event(ind_s1(i)-j).latency - 250:eeg.event(ind_s1(i)-j).latency + 250);
                            n=n+1;
                            % fprintf(' Attempt: Type : %s , Dur_plus : %f and Dur_minus : %f \n',eeg.event(ind_s1(i)-j).type,(eeg.event(ind_s1(i)-j).latency - eeg.event(ind_s1(i)-(j+1)).latency)/250,(eeg.event(ind_s1(i)-(j-1)).latency - eeg.event(ind_s1(i)-j).latency)/250);
                            j=j+1;
                        else
                            % fprintf('Plus: %f and minus: %f \n',(eeg.event(ind_s1(i)-j).latency - eeg.event(ind_s1(i)-(j+1)).latency)/250,(eeg.event(ind_s1(i)-(j-1)).latency - eeg.event(ind_s1(i)-j).latency)/250);
                            j=j+1;
                        end
                        
                        
                    end
                end
                % fprintf('-----------------------------------------------------------------------------------\n');
            end
            
            % 5) BASELINE
            
            k=1;
            for i=1:size(eeg.event,2)
                if strcmp(eeg.event(i).type,'S 42')
                    ind_s42(k) = i;
                    k=k+1;
                end
            end
            epochs_base = eeg.data(:,eeg.event(:,ind_s42(1)).latency-500:eeg.event(ind_s42(1)).latency);
            
            % AVERAGING ACROSS TRIALS------------------------------------------
            % 1) Success
            epoch_301{file_num,:,:} = epochs_301;
    
            % 2) Intent
            if ~isempty(epochs_intent)
                epoch_intent{file_num,:,:} = epochs_intent;
            end
    
            % 3) Attempt 
            if ~isempty(epochs_attempt)
                epoch_attempt{file_num,:,:} = epochs_attempt;
            end
    
            % 4) Base
            epoch_base(file_num,:,:) = epochs_base;
    
    end


%% Extracting sessions

% Here, taking the average of 4 sessions and making it into 1. So 12
% sessions provides avergaed 3 sessions

% lab =  [10, 11, 12, 13, 14, 3,  4,  5,  6,  7,  8,  9];
% 
% alph = [1,  4,  7,  10, 13, 16, 19, 22, 25, 28, 31, 34];
% bet =  [2,  5,  8,  11, 14, 17, 20, 23, 26, 29, 32, 35];
% thet = [3,  6,  9,  12, 15, 18, 21, 24, 27, 30, 33, 36];

to3_6A = [16,19,22,25]; 
to7_10A = [28,31,34,1];
to11_14A = [4,7,10,13]; 

to3_6B = [17,20,23,26]; 
to7_10B = [29,32,35,2]; 
to11_146B = [5,8,11,14]; 

to3_6T = [18,21,24,27]; 
to7_10T = [30,33,36,3]; 
to11_146T = [6,9,12,15];


sess3to6succAlpha = squeeze(mean(cat(1,epoch_301{16},epoch_301{19},epoch_301{22},epoch_301{25}),1));
sess7to10succAlpha = squeeze(mean(cat(1,epoch_301{28},epoch_301{31},epoch_301{34},epoch_301{1}),1));
sess11to14succAlpha = squeeze(mean(cat(1,epoch_301{4},epoch_301{7},epoch_301{10},epoch_301{13}),1));

sess3to6succBet = squeeze(mean(cat(1,epoch_301{17},epoch_301{20},epoch_301{23},epoch_301{26}),1));
sess7to10succBet = squeeze(mean(cat(1,epoch_301{29},epoch_301{32},epoch_301{35},epoch_301{2}),1));
sess11to14succBet = squeeze(mean(cat(1,epoch_301{5},epoch_301{8},epoch_301{11},epoch_301{14}),1));

sess3to6succThet = squeeze(mean(cat(1,epoch_301{18},epoch_301{21},epoch_301{24},epoch_301{27}),1));
sess7to10succThet = squeeze(mean(cat(1,epoch_301{30},epoch_301{33},epoch_301{36},epoch_301{3}),1));
sess11to14succThet = squeeze(mean(cat(1,epoch_301{6},epoch_301{9},epoch_301{12},epoch_301{15}),1));

% For Intent
% ----------------------------------------------------------------
to3_6A = [16,19,22,25]; 
to7_10A = [25,31,34,1];
to11_14A = [4,7,10,13]; 

to3_6B = [17,20,23,26]; 
to7_10B = [29,32,35,2]; 
to11_146B = [5,8,11,14]; 

to3_6T = [18,21,24,27]; 
to7_10T = [30,33,36,3]; 
to11_146T = [6,9,12,15];

%intent ------------------------------------------------------
sess3to6IntentAlpha = squeeze(mean(cat(1,epoch_intent{16},epoch_intent{19},epoch_intent{22},epoch_intent{25}),1));
sess7to10IntentAlpha = squeeze(mean(cat(1,epoch_intent{28},epoch_intent{31},epoch_intent{34},epoch_intent{1}),1));
sess11to14IntentAlpha = squeeze(mean(cat(1,epoch_intent{4},epoch_intent{7},epoch_intent{10},epoch_intent{13}),1));

sess3to6IntentBet = squeeze(mean(cat(1,epoch_intent{17},epoch_intent{20},epoch_intent{23},epoch_intent{26}),1));
sess7to10IntentBet = squeeze(mean(cat(1,epoch_intent{29},epoch_intent{32},epoch_intent{35},epoch_intent{2}),1));
sess11to14IntentBet = squeeze(mean(cat(1,epoch_intent{5},epoch_intent{8},epoch_intent{11},epoch_intent{14}),1));

sess3to6IntentThet = squeeze(mean(cat(1,epoch_intent{18},epoch_intent{21},epoch_intent{24},epoch_intent{27}),1));
sess7to10IntentThet = squeeze(mean(cat(1,epoch_intent{30},epoch_intent{33},epoch_intent{36},epoch_intent{3}),1));
sess11to14IntentThet = squeeze(mean(cat(1,epoch_intent{6},epoch_intent{9},epoch_intent{12},epoch_intent{15}),1));

% For attempt--------------------------------------------------------------


to3_6A = [16,19,22,25]; 
to7_10A = [25,31,34,1];
to11_14A = [4,7,10,13]; 

to3_6B = [17,20,23,26]; 
to7_10B = [29,32,35,2]; 
to11_146B = [5,8,11,14]; 

to3_6T = [18,21,24,27]; 
to7_10T = [30,33,36,3]; 
to11_146T = [6,9,12,15];

% attempt ------------------------------------------------------
sess3to6AttemptAlpha = squeeze(mean(cat(1,epoch_attempt{16},epoch_attempt{19},epoch_attempt{22},epoch_attempt{25}),1));
sess7to10AttemptAlpha = squeeze(mean(cat(1,epoch_attempt{28},epoch_attempt{31},epoch_attempt{34},epoch_attempt{1}),1));
sess11to14AttemptAlpha = squeeze(mean(cat(1,epoch_attempt{4},epoch_attempt{7},epoch_attempt{10},epoch_attempt{13}),1));

sess3to6AttemptBet = squeeze(mean(cat(1,epoch_attempt{17},epoch_attempt{20},epoch_attempt{23},epoch_attempt{26}),1));
sess7to10AttemptBet = squeeze(mean(cat(1,epoch_attempt{29},epoch_attempt{32},epoch_attempt{35},epoch_attempt{2}),1));
sess11to14AttemptBet = squeeze(mean(cat(1,epoch_attempt{5},epoch_attempt{8},epoch_attempt{11},epoch_attempt{14}),1));

sess3to6AttemptThet = squeeze(mean(cat(1,epoch_attempt{18},epoch_attempt{21},epoch_attempt{24},epoch_attempt{27}),1));
sess7to10AttemptThet = squeeze(mean(cat(1,epoch_attempt{30},epoch_attempt{33},epoch_attempt{36},epoch_attempt{3}),1));
sess11to14AttemptThet = squeeze(mean(cat(1,epoch_attempt{6},epoch_attempt{9},epoch_attempt{12},epoch_attempt{15}),1));
%%

% For base
to3_6A = [16,19,22,25]; 
to7_10A = [25,31,34,1];
to11_14A = [4,7,10,13]; 

to3_6B = [17,20,23,26]; 
to7_10B = [29,32,35,2]; 
to11_146B = [5,8,11,14]; 

to3_6T = [18,21,24,27]; 
to7_10T = [30,33,36,3]; 
to11_146T = [6,9,12,15]; 

% base------------------------------------------------------
sess3to6baseAlpha = squeeze(mean(epoch_base(to3_6A,:,:),1));
sess7to10baseAlpha = squeeze(mean(epoch_base(to7_10A,:,:),1));
sess11to14baseAlpha = squeeze(mean(epoch_base(to11_14A,:,:),1));

sess3to6baseBet = squeeze(mean(epoch_base(to3_6B,:,:),1));
sess7to10baseBet = squeeze(mean(epoch_base(to7_10B,:,:),1));
sess11to14baseBet = squeeze(mean(epoch_base(to11_146B,:,:),1));

sess3to6baseThet = squeeze(mean(epoch_base(to3_6T,:,:),1));
sess7to10baseThet = squeeze(mean(epoch_base(to7_10T,:,:),1));
sess11to14baseThet = squeeze(mean(epoch_base(to11_146T,:,:),1));

%% Finally EEG struct

% Here we have 24 epochs in total for each subject (2 bands x 3 sessions
% x 4 trial outcomes)

datas = {sess3to6succAlpha,sess3to6succBet,sess3to6succThet,...
        sess7to10succAlpha,sess7to10succBet,sess7to10succThet,...
        sess11to14succAlpha,sess11to14succBet,sess11to14succThet,...
        ...
        sess3to6IntentAlpha,sess3to6IntentBet,sess3to6IntentThet,...
        sess7to10IntentAlpha,sess7to10IntentBet,sess7to10IntentThet,...
        sess11to14IntentAlpha,sess11to14IntentBet,sess11to14IntentThet,...
        ...
        sess3to6AttemptAlpha,sess3to6AttemptBet,sess3to6AttemptThet,...
        sess7to10AttemptAlpha,sess7to10AttemptBet,sess7to10AttemptThet,...
        sess11to14AttemptAlpha,sess11to14AttemptBet,sess11to14AttemptThet,...
        ...
        sess3to6baseAlpha,sess3to6baseBet,sess3to6baseThet,...
        sess7to10baseAlpha,sess7to10baseBet,sess7to10baseThet,...
        sess11to14baseAlpha,sess11to14baseBet,sess11to14baseThet};

for i=1:length(datas)
    data(:,:,i) = datas{i};
end

% Saving the epoched EEGlab structure
EEG = pop_importdata('dataformat','matlab','nbchan',0,'data',double(data), ...
        'srate',250,'pnts',0,'xmin',0);
EEG.chanlocs = eeg.chanlocs;

EEG.setname = 'epoched_subject';
EEG.filepath = '...Epoched_DATA\';
EEG.filename = 'epoched_subject.set';
pop_saveset(EEG,'savemode','resave');

