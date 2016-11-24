

%load('ULSee_feature_triplet_44w.mat');


num_reg = size(cdata_reg.id,2);
num_vfy = size(cdata_vfy.id,2);

count_reg =1;
report = [];
while (count_reg<=num_reg)
    conv_reg = cdata_reg.conv_f{count_reg};
    reg_id = cdata_reg.id(count_reg);
    img_id_reg = cdata_reg.img_id(count_reg);
    count_vfy = 1;
    while (count_vfy<= num_vfy)
        conv_vfy = cdata_vfy.conv_f{count_vfy};
        vfy_id = cdata_vfy.id(count_vfy);
        img_id_vfy = cdata_vfy.img_id(count_vfy);
        dist = sum((conv_reg-conv_vfy).*(conv_reg- conv_vfy));
        report = [report; reg_id, img_id_reg, vfy_id, img_id_vfy, dist];
        count_vfy = count_vfy + 1;
    end;
    count_reg = count_reg + 1;
    disp(count_reg);
end;
save('triplet_v2_50w.mat','report');
        
