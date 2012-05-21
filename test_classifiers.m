% load piano_feat_data
load beatles_feat_data
% load chr_maj_bnets
% load chr_fam_bnets
load chr_btls_fam_bnets

% Beatles Song/File Names
files = dir('/Users/devo/dev/datasets/mir/audio/key detection/mp3/beatles/');
fileNames = {};
for i=1:length(files)
    if ~files(i).isdir
        fname = files(i).name;
        
        splitname = regexpi(fname, '\.(mp3|wav|au|aiff?)', 'split');
        if length(splitname) > 1
            fileNames{end + 1} = splitname{1};
        end
    end
end

% Map of Note Numbers by key
keyNotes = containers.Map();
keyNotes('A major') =  [1 3 5 6 8 10 12];
keyNotes('A# major') = [2 4 6 7 9 11 1];
keyNotes('B major') =  [3 5 7 8 10 12 2];
keyNotes('C major') =  [4 6 8 9 11 1 3];
keyNotes('C# major') = [5 7 9 10 12 2 4];
keyNotes('D major') =  [6 8 10 11 1 3 5];
keyNotes('D# major') = [7 9 11 12 2 4 6];
keyNotes('E major') =  [8 10 12 1 3 5 7];
keyNotes('F major') =  [9 11 1 2 4 6 8];
keyNotes('F# major') = [10 12 2 3 5 7 9];
keyNotes('G major') =  [11 1 3 4 6 8 10];
keyNotes('G# major') = [12 2 4 5 7 9 11];

keyNotes('A minor') =  [1 3 4 6 8 9 11];
keyNotes('A# minor') = [2 4 5 7 9 10 12];
keyNotes('B minor') =  [3 5 6 8 10 11 1];
keyNotes('C minor') =  [4 6 7 9 11 12 2];
keyNotes('C# minor') = [5 7 8 10 12 1 3];
keyNotes('D minor') =  [6 8 9 11 1 2 4];
keyNotes('D# minor') = [7 9 10 12 2 3 5];
keyNotes('E minor') =  [8 10 11 1 3 4 6];
keyNotes('F minor') =  [9 11 12 2 4 5 7];
keyNotes('F# minor') = [10 12 1 3 5 6 8];
keyNotes('G minor') =  [11 1 2 4 6 7 9];
keyNotes('G# minor') = [12 2 3 5 7 8 10];

keyNotes('F dorian') =  [9 11 12 2 4 6 7];
keyNotes('D mixolydian') =  [6 8 10 11 1 3 4];
keyNotes('G mixolydian') =  [11 1 3 4 6 8 9];
keyNotes('A mixolydian') =  [1 3 5 6 8 10 11];
keyNotes('C# modal') = [5 7 9 10 12 2 4];

% chr_maj_hmms = cell(length(chr_maj_bnets),1);
% for i=1:length(chr_maj_bnets)
%     chr_maj_hmms{i} = smoother_engine(jtree_2TBN_inf_engine(chr_maj_bnets{i}));
% end

chr_fam_hmms = cell(2,1);
for i=1:2
    chr_fam_hmms{i} = smoother_engine(jtree_2TBN_inf_engine(btls_mid_bnets{i+1}));
end

notes = Notes();
correct_num = 0;
total_num = 0;
% total_songs = length(pi_chromas);
lls_correct = 0;

% Tonics by chromagram
% for i=1:length(pi_chromas)
%     [marginals, lls, engines, preds] = classify_chroma(pi_chromas{i}, chr_tonic_hmms);
%     
%     instance_correct = 0;
%     instance_total = length(preds);
%     for j=1:length(preds)
%         [mv, mi] = max(cell2mat(preds(:,j)));
%         
%         if mi == notes.noteNum(pi_tonics{i}{j})
%             correct_num = correct_num + 1;
%             instance_correct = instance_correct + 1;
%         end
%         total_num = total_num + 1;
%     end
%     
%     fprintf('%f pct correct for %s %s\n', instance_correct/instance_total, pi_tonics{i}{1}, pi_modes{i}{1});
% end

% Tonics by major chromagram
% for i=1:length(pi_chromas)
%     [marginals, lls, engines, preds] = classify_chroma(pi_chromas{i}, chr_maj_hmms);
%     
%     expected = notes.noteNum(pi_tonics{i}{1});
%     lls_mult = mat2gray(cell2mat(lls));
%     [mv_lls, mi_lls] = max(lls_mult);
%     mi_lls2 = mod(mi_lls + 8, 12) + 1;
%     if mi_lls == expected || mi_lls2 == expected
%         lls_correct = lls_correct + 1;
%     end
%     
%     instance_correct = 0;
%     instance_total = length(preds);
%     for j=1:length(preds)
%         [mv, mi] = max(cell2mat(preds(:,j)) .* lls_mult);
%         
%         expected = notes.noteNum(pi_tonics{i}{j});
%         mi2 = mod(mi + 8, 12) + 1;
%         if mi == expected || mi2 == expected
%             correct_num = correct_num + 1;
%             instance_correct = instance_correct + 1;
%         end
%         total_num = total_num + 1;
%     end
%     
%     fprintf('%f pct correct for %s %s\n', instance_correct/instance_total, pi_tonics{i}{1}, pi_modes{i}{1});
% end

% Keys by chromagram
% for i=1:length(pi_chromas)
%     [marginals, lls, engines, preds] = classify_chroma(pi_chromas{i}, chr_key_hmms);
%     
%     instance_correct = 0;
%     instance_total = length(preds);
%     for j=1:length(preds)
%         [mv, mi] = max(cell2mat(preds(:,j)));
%         
%         expected = [pi_tonics{i}{j} ' ' pi_modes{i}{j}];
%         predicted = key_names{mi};
%         if strcmp(expected, predicted)
%             correct_num = correct_num + 1;
%             instance_correct = instance_correct + 1;
%         end
%         total_num = total_num + 1;
%     end
%     
%     fprintf('%f pct correct for %s %s\n', instance_correct/instance_total, pi_tonics{i}{1}, pi_modes{i}{1});
% end

% Key Prediction
% total_num = total_songs;
% correct_num2 = 0;
% for i=1:length(pi_chromas)
%     chroma = pi_chromas{i};
%     
%     [t_marginals, t_lls, t_engines, t_preds] = classify_chroma(chroma, chr_maj_hmms);
%     
%     expected_tonic = notes.noteNum(pi_tonics{i}{1});
%     expected_fam = pi_modes{i}{1};
%     
%     [mv_t, pred_maj_t] = max(cell2mat(t_lls));
%     
%     maj_chroma = circshift(chroma, [1 - pred_maj_t, 0]);
%     min_chroma = circshift(chroma, [4 - pred_maj_t, 0]);
%     
%     [maj_marginals, maj_lls, maj_engines, maj_preds] = classify_chroma(maj_chroma, chr_fam_hmms);
%     [min_marginals, min_lls, min_engines, min_preds] = classify_chroma(min_chroma, chr_fam_hmms);
%     
%     maj_diff = abs(maj_lls{1}) / abs(maj_lls{1} - maj_lls{2});
%     min_diff = abs(min_lls{2}) / abs(min_lls{1} - min_lls{2});
%     fprintf('Maj [%f %f], Min [%f %f]\n', maj_lls{1}, maj_diff, min_lls{2}, min_diff);
%     
%     pred_tonic = pred_maj_t;
%     pred_tonic2 = pred_maj_t;
%     pred_fam = 'major';
%     pred_fam2 = 'major';
%     
%     if maj_lls{1} < min_lls{2}
%         pred_tonic = pred_maj_t - 3;
%         if pred_tonic < 1; pred_tonic = pred_tonic + 12; end
%         pred_fam = 'minor';
%     end
%     
%     if maj_diff < min_diff
%         pred_tonic2 = pred_maj_t - 3;
%         if pred_tonic2 < 1; pred_tonic2 = pred_tonic2 + 12; end
%         pred_fam2 = 'minor';
%     end
%     
%     if pred_tonic == expected_tonic && strcmpi(expected_fam, pred_fam)
%         correct_num = correct_num + 1;
%     end
%     
%     if pred_tonic2 == expected_tonic && strcmpi(expected_fam, pred_fam2)
%         correct_num2 = correct_num2 + 1;
%     end
%     
%     fprintf('Expected %s %s, Predicted %s %s\n', pi_tonics{i}{1}, expected_fam, notes.noteName(pred_tonic), pred_fam);
% end

% Beatles songs predictions
% total_maj_min = 0;
% correct_num2 = 0;
% for i=1:length(chromas)
%     chroma = chromas{i};
%     
%     [t_marginals, t_lls, t_engines, t_preds] = classify_chroma(chroma, chr_maj_hmms);
%     
%     maj_min_dist = [];
%     for j=1:length(t_lls)
%         shift_chroma = circshift(chroma, [1 - j, 0]);
%     
%         [fam_marginals, fam_lls, fam_engines, fam_preds] = classify_chroma(shift_chroma, chr_fam_hmms);
%         
%         maj_min_dist = [maj_min_dist ; fam_lls{1} fam_lls{2}];
%     end
%     
%     wt_maj_min_dist = mat2gray(maj_min_dist);
%     wt_tonic_preds = mat2gray(cell2mat(t_lls));
%     tonic_maj_mult = wt_tonic_preds .* wt_maj_min_dist(:,1);
%     tonic_min_mult = circshift(wt_tonic_preds, [-3,0]) .* wt_maj_min_dist(:,2);
%     
%     [mv_maj mi_maj] = max(wt_maj_min_dist(:,1));
%     [mv_min mi_min] = max(wt_maj_min_dist(:,2));
%     [mv_t_maj mi_t_maj] = max(tonic_maj_mult);
%     [mv_t_min mi_t_min] = max(tonic_min_mult);
%     
%     if mv_maj > mv_min
%         pred_tonic1 = mi_maj;
%         pred_fam1 = 'major';
%     else
%         pred_tonic1 = mi_min;
%         pred_fam1 = 'minor';
%     end
%     
%     if mv_t_maj > mv_t_min
%         pred_tonic2 = mi_t_maj;
%         pred_fam2 = 'major';
%     else
%         pred_tonic2 = mi_t_min;
%         pred_fam2 = 'minor';
%     end
%     
%     actual_keys = java.util.HashSet;
%     for j=1:length(chroma)
%         expected_tonic = notes.noteNum(tonics{i}{j});
%         expected_fam = modes{i}{j};
%         
%         if strcmpi(expected_fam, 'major') || strcmpi(expected_fam, 'minor')
%             total_maj_min = total_maj_min + 1;
%         end
%         
%         if pred_tonic1 == expected_tonic && strcmpi(expected_fam, pred_fam1)
%             correct_num = correct_num + 1;
%         end
%         
%         if pred_tonic2 == expected_tonic && strcmpi(expected_fam, pred_fam2)
%             correct_num2 = correct_num2 + 1;
%         end
%         
%         actual_keys.add([num2str(expected_tonic) ' ' expected_fam]);
%         
%         total_num = total_num + 1;
%     end
%     
%     fprintf('Expected %s, Predicted %i %s / %i %s from\n', char(actual_keys.toString()), pred_tonic1, pred_fam1, pred_tonic2, pred_fam2);
%     disp([wt_tonic_preds wt_maj_min_dist mat2gray(tonic_maj_mult) mat2gray(tonic_min_mult)]);
% end
% fprintf('%d / %d correct out of %d total (%d maj/min)\n%f / %f pct normal\n%f / %f pct mult', correct_num, correct_num2, total_num, total_maj_min, correct_num/total_num, correct_num/total_maj_min, correct_num2/total_num, correct_num2/total_maj_min);

% Beatles MIDI
fid = fopen('HMM_Chromagram_Beatles_Classification_Results.csv', 'w');

% Header
headerStr = ['Song Title, Expected Key, Predicted Key, Pct of Song In Exp Key, ' ...
    'A major (LL), A# major (LL), B major (LL), C major (LL), C# major (LL), D major (LL), D# major (LL), E major (LL), F major (LL), F# major (LL), G major (LL), G# major (LL), ' ...
    'A minor (LL), A# minor (LL), B minor (LL), C minor (LL), C# minor (LL), D minor (LL), D# minor (LL), E minor (LL), F minor (LL), F# minor (LL), G minor (LL), G# minor (LL), ' ...
    'Note Precision (TP/Total), Dominant Note (Energy)'];
fprintf(fid, headerStr);
fprintf(headerStr);

total_maj_min = 0;
for i=1:length(chromas)
    chroma = chromas{i};
    
    maj_min_dist = [];
    for j=1:12
        shift_chroma = circshift(chroma, [1 - j, 0]);
    
        [fam_marginals, fam_lls, fam_engines, fam_preds] = classify_chroma(shift_chroma, chr_fam_hmms);
        
        maj_min_dist = [maj_min_dist ; fam_lls{1} fam_lls{2}];
    end
    
    wt_maj_min_dist = mat2gray(maj_min_dist);
    
    [mv_maj mi_maj] = max(wt_maj_min_dist(:,1));
    [mv_min mi_min] = max(wt_maj_min_dist(:,2));
    
    if mv_maj > mv_min
        pred_tonic1 = mi_maj;
        pred_fam1 = 'major';
    else
        pred_tonic1 = mi_min;
        pred_fam1 = 'minor';
    end
    pred_key = [notes.noteName(pred_tonic1) ' ' pred_fam1];
    
    key_counts = containers.Map();
    num_segs = length(chroma);
    chrsum = zeros(12,1);

    for j=1:num_segs
        expected_tonic = notes.noteNum(tonics{i}{j});
        expected_fam = modes{i}{j};
        
        chrsum = chrsum + chroma(:,j);
        
        if strcmpi(expected_fam, 'major') || strcmpi(expected_fam, 'minor')
            total_maj_min = total_maj_min + 1;
        end
        
        if pred_tonic1 == expected_tonic && strcmpi(expected_fam, pred_fam1)
            correct_num = correct_num + 1;
        end
        
        actual_key = [notes.noteName(expected_tonic) ' ' expected_fam];
        
        if ~isKey(key_counts, actual_key)
            key_counts(actual_key) = 0;
        end
        
        key_counts(actual_key) = key_counts(actual_key) + 1;
        
        total_num = total_num + 1;
    end
    
    [mv_chrsum mi_chrsum] = max(chrsum);
    dom_note = notes.noteName(mi_chrsum);
    
    prnstr  = ['\n%s, %s, %s, %f, ' ...
    '%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, ' ...
    '%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, ' ...
    '%f, %s'];

    song_keys = keys(key_counts);
    for sk=1:length(song_keys)
        song_key = song_keys{sk};
        exp_notes = keyNotes(song_key);
        pred_notes = keyNotes(pred_key);
        notes_prec = length(intersect(pred_notes,exp_notes)) / length(exp_notes);
        
        fprintf(fid, prnstr, fileNames{i}, song_key, pred_key, key_counts(song_key)/num_segs, ...
            wt_maj_min_dist(1,1), wt_maj_min_dist(2,1), wt_maj_min_dist(3,1), wt_maj_min_dist(4,1), wt_maj_min_dist(5,1), wt_maj_min_dist(6,1), ...
            wt_maj_min_dist(7,1), wt_maj_min_dist(8,1), wt_maj_min_dist(9,1), wt_maj_min_dist(10,1), wt_maj_min_dist(11,1), wt_maj_min_dist(12,1), ...
            wt_maj_min_dist(1,2), wt_maj_min_dist(2,2), wt_maj_min_dist(3,2), wt_maj_min_dist(4,2), wt_maj_min_dist(5,2), wt_maj_min_dist(6,2), ...
            wt_maj_min_dist(7,2), wt_maj_min_dist(8,2), wt_maj_min_dist(9,2), wt_maj_min_dist(10,2), wt_maj_min_dist(11,2), wt_maj_min_dist(12,2), ...
            notes_prec, dom_note);
        
        fprintf(prnstr, fileNames{i}, song_key, pred_key, key_counts(song_key)/num_segs, ...
            wt_maj_min_dist(1,1), wt_maj_min_dist(2,1), wt_maj_min_dist(3,1), wt_maj_min_dist(4,1), wt_maj_min_dist(5,1), wt_maj_min_dist(6,1), ...
            wt_maj_min_dist(7,1), wt_maj_min_dist(8,1), wt_maj_min_dist(9,1), wt_maj_min_dist(10,1), wt_maj_min_dist(11,1), wt_maj_min_dist(12,1), ...
            wt_maj_min_dist(1,2), wt_maj_min_dist(2,2), wt_maj_min_dist(3,2), wt_maj_min_dist(4,2), wt_maj_min_dist(5,2), wt_maj_min_dist(6,2), ...
            wt_maj_min_dist(7,2), wt_maj_min_dist(8,2), wt_maj_min_dist(9,2), wt_maj_min_dist(10,2), wt_maj_min_dist(11,2), wt_maj_min_dist(12,2), ...
            notes_prec, dom_note);
    end
    
    
%     fprintf('\nExpected [%s], Predicted %s from\n', char(song_keys), pred_key);
%     disp(wt_maj_min_dist);
end
fclose(fid);
fprintf('\n\n%d correct out of %d total (%d maj/min)\n%f / %f pct\n', correct_num, total_num, total_maj_min, correct_num/total_num, correct_num/total_maj_min);


% Test set
% total_maj_min = 0;
% correct_num2 = 0;
% for i=1:length(tst_chromas)
%     chroma = tst_chromas{i};
%     
%     [t_marginals, t_lls, t_engines, t_preds] = classify_chroma(chroma, chr_maj_hmms);
%     
%     maj_min_dist = [];
%     for j=1:length(t_lls)
%         maj_chroma = circshift(chroma, [1 - j, 0]);
%         min_chroma = circshift(chroma, [4 - j, 0]);
%     
%         [maj_marginals, maj_lls, maj_engines, maj_preds] = classify_chroma(maj_chroma, chr_fam_hmms);
%         [min_marginals, min_lls, min_engines, min_preds] = classify_chroma(min_chroma, chr_fam_hmms);
%         
%         maj_min_dist = [maj_min_dist ; maj_lls{1} maj_lls{2} min_lls{1} min_lls{2}];
%     end
%     
%     maj_min_dist = [mat2gray(cell2mat(t_lls)) mat2gray(maj_min_dist)]
%     
%     % Highest Pred
%     [mv_t, pred_maj_t] = max(cell2mat(t_lls));
%     
%     maj_chroma = circshift(chroma, [1 - pred_maj_t, 0]);
%     min_chroma = circshift(chroma, [4 - pred_maj_t, 0]);
%     
%     [maj_marginals, maj_lls, maj_engines, maj_preds] = classify_chroma(maj_chroma, chr_fam_hmms);
%     [min_marginals, min_lls, min_engines, min_preds] = classify_chroma(min_chroma, chr_fam_hmms);
%     
%     % Second Highest
%     t_lls2 = cell2mat(t_lls);
%     t_lls2(pred_maj_t) = min(t_lls2);
%     [mv_t2, pred_maj_t2] = max(t_lls2);
%     
%     maj_chroma2 = circshift(chroma, [1 - pred_maj_t2, 0]);
%     min_chroma2 = circshift(chroma, [4 - pred_maj_t2, 0]);
%     
%     [maj_marginals2, maj_lls2, maj_engines2, maj_preds2] = classify_chroma(maj_chroma2, chr_fam_hmms);
%     [min_marginals2, min_lls2, min_engines2, min_preds2] = classify_chroma(min_chroma2, chr_fam_hmms);
%     
%     pred_tonic = pred_maj_t;
%     pred_tonic2 = pred_maj_t2;
%     pred_fam = 'major';
%     pred_fam2 = 'major';
%     
%     norm_tonics = mat2gray(cell2mat(t_lls));
%     tw_1 = norm_tonics(pred_maj_t);
%     tw_2 = norm_tonics(pred_maj_t2);
%     pctf_1 = 1 - 1/abs(maj_lls{1} - maj_lls{2});
%     pctf_2 = 1 - 1/abs(maj_lls2{1} - maj_lls2{2});
%     
%     if maj_lls{1} < min_lls{2}
%         pred_tonic = pred_maj_t - 3;
%         if pred_tonic < 1; pred_tonic = pred_tonic + 12; end
%         pred_fam = 'minor';
%         pctf_1 = 1 - 1/abs(min_lls{1} - min_lls{2});
%     end
%     
%     if maj_lls2{1} < min_lls2{2}
%         pred_tonic2 = pred_maj_t2 - 3;
%         if pred_tonic2 < 1; pred_tonic2 = pred_tonic2 + 12; end
%         pred_fam2 = 'minor';
%         pctf_2 = 1 - 1/abs(min_lls2{1} - min_lls2{2});
%     end
%     
%     actual_keys = java.util.HashSet;
%     for j=1:length(chroma)
%         expected_tonic = notes.noteNum(tst_tonics{i}{j});
%         expected_fam = tst_modes{i}{j};
%         
%         if strcmpi(expected_fam, 'major') || strcmpi(expected_fam, 'minor')
%             total_maj_min = total_maj_min + 1;
%         end
%         
%         if pred_tonic == expected_tonic && strcmpi(expected_fam, pred_fam)
%             correct_num = correct_num + 1;
%         end
%         
%         if pred_tonic2 == expected_tonic && strcmpi(expected_fam, pred_fam2)
%             correct_num2 = correct_num2 + 1;
%         end
%         
%         actual_keys.add([num2str(expected_tonic) ' ' expected_fam]);
%         
%         total_num = total_num + 1;
%     end
%     
%     fprintf('Expected %s, Predicted %i %s / %i %s\n', char(actual_keys.toString()), pred_tonic, pred_fam, pred_tonic2, pred_fam2);
%     fprintf('%d %d %d %d\n', tw_1, pctf_1, tw_2, pctf_2);
% end

% fprintf('%d correct out of %d / %d (%f / %f)\n', correct_num, total_num, total_maj_min, correct_num/total_num, correct_num/total_maj_min);