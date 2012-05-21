file = '/Users/devo/dev/datasets/mir/devon/08 Mean Old Frisco.mp3'

[data,sr,bts,chrm,domnotes,atsl] = beatsyncfeat(file,11025);

[marginals, lls] = classifytonics(chrm,tonic_hmms);

llsmat = cell2mat(lls);

% Weighted HMM predictions
wt_preds = mat2gray(llsmat);
    
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