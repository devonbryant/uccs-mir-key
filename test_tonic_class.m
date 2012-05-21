% clear
% [norm_tonic_hmms, norm_tonic_bnets] = traintonichmms(tr_tonics, tr_chromas, tr_atslopes);
% load trained_norm_tonic_hmms

class_counts = cell(12,1);
class_counts(:) = {[0 0]};

total_classes = length(tst_chromas);
preds_correct = 0; chrsum_correct = 0; comb_correct = 0; 
chr_atsl_correct = 0; comb_as_correct = 0;

for i=1:total_classes
    tonic = tst_tonics{i};
    chrm = tst_chromas{i};
    atsl = tst_atslopes{i};
    
    fprintf('--------------------------------------------------------\n');
    fprintf('Testing %d (%s)\n',tonic,tst_modes{i});
    
    % Normalized Chrm Classification
    [marginals, lls] = classifytonics(chrm,norm_tonic_hmms);
    % Non-normalized Chrm Classification
%     [marginals, lls] = classifytonics(chrm,nonnorm_tonic_hmms,0);
    
    llsmat = cell2mat(lls);
    
    % Weighted HMM predictions
    wt_preds = mat2gray(llsmat);
%     wt_preds = llsmat;
    
    % Weighted Chromagram Sum
    wt_chrsum = zeros(12,1);
    wt_chr_atslsum = zeros(12,1);
    for j=1:length(chrm)
        wt_chrsum = wt_chrsum + chrm(:,j);
        wt_chr_atslsum = wt_chr_atslsum + (chrm(:,j) * atsl(j));
    end
    wt_chrsum = mat2gray(wt_chrsum);
    wt_chr_atslsum = mat2gray(wt_chr_atslsum);
    
    wt_cmb = mat2gray(wt_preds .* wt_chrsum);
    wt_cmb_as = mat2gray(wt_preds .* wt_chr_atslsum);
    
    % Predicted Tonics
    [mv_lls, mi_lls] = max(wt_preds);
    [mv_chr, mi_chr] = max(wt_chrsum);
    [mv_cmb, mi_cmb] = max(wt_cmb);
    [mv_chr_atsl, mi_chr_atsl] = max(wt_chr_atslsum);
    [mv_cmb_as, mi_cmb_as] = max(wt_cmb_as);
    
    idxs = (1:12)';
    pick_pcts = [idxs wt_preds wt_chrsum wt_cmb wt_chr_atslsum wt_cmb_as]
    top_picks = [mi_lls mi_chr mi_cmb mi_chr_atsl mi_cmb_as]
    
%     fprintf('Predicted %d, %d, %d\n',mi_lls,mi_chr,mi_cmb);
    if mi_lls == tonic; preds_correct = preds_correct + 1; end
    if mi_chr == tonic; chrsum_correct = chrsum_correct + 1; end
    if mi_cmb == tonic; comb_correct = comb_correct + 1; end
    if mi_chr_atsl == tonic; chr_atsl_correct = chr_atsl_correct + 1; end
    if mi_cmb_as == tonic; comb_as_correct = comb_as_correct + 1; end
    
    if mi_lls == tonic
        class_counts{tonic}(1,1) = class_counts{tonic}(1,1) + 1;
%         fprintf('Correct!\n');
    else
        if tonic < mi_lls; diff = mi_lls - tonic;
        else diff = (mi_lls + 12) - tonic; end
%         fprintf('Diff %d\n',diff);
        class_counts{tonic}(1,2) = class_counts{tonic}(1,2) + 1;
    end
    
    % Voting (top 2 from each)
    
end

correct_nums = [preds_correct chrsum_correct comb_correct chr_atsl_correct comb_as_correct]
