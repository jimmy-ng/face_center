

%load('triplet_v4_5_36w.mat');

num_reg = size(cdata_reg.id,2);
num_vfy = size(cdata_vfy.id,2);
file_name= 'center_model'; 
threshold = 0.26;
max_v = 2.8225;
min_v = 0.017;
mkdir('FP');
mkdir('TN');
count_reg =1;
report = [];
while (count_reg<=num_reg)
    fc_reg = cdata_reg.fc_f{count_reg};
    reg_id = cdata_reg.id(count_reg);
    img_id_reg = cdata_reg.img_id(count_reg);
    image_path_reg = cdata_reg.image_path{count_reg};
    count_vfy = 1;
    while (count_vfy<= num_vfy)
        fc_vfy = cdata_vfy.fc_f{count_vfy};
        vfy_id = cdata_vfy.id(count_vfy);
        img_id_vfy = cdata_vfy.img_id(count_vfy);
        image_path_vfy = cdata_vfy.image_path{count_vfy};
        dist = sum((fc_reg-fc_vfy).*(fc_reg- fc_vfy));
        dist = (dist-min_v)./(max_v-min_v);
        if(dist < threshold && reg_id ~= vfy_id)
          img_reg = imread(image_path_reg);
          img_vfy = imread(image_path_vfy);
          img_to_write = [img_reg;img_vfy];
          imwrite(img_to_write, ['FP/',num2str(count_reg),'_',num2str(count_vfy),'.jpg']);
        end;
        if(dist > threshold && reg_id == vfy_id)
          img_reg = imread(image_path_reg);
          img_vfy = imread(image_path_vfy);
          img_to_write = [img_reg;img_vfy];
          imwrite(img_to_write, ['TN/',num2str(count_reg),'_',num2str(count_vfy),'.jpg']);
        end;
        report = [report; reg_id, img_id_reg, vfy_id, img_id_vfy, dist];
        count_vfy = count_vfy + 1;
    end;
    count_reg = count_reg + 1;
    disp(count_reg);
end;
save([file_name,'_fc.mat'],'report');

%count_reg =1;
%report = [];
%while (count_reg<=num_reg)
 %   conv_reg = cdata_reg.conv_f{count_reg};
  %  reg_id = cdata_reg.id(count_reg);
   % img_id_reg = cdata_reg.img_id(count_reg);
%    count_vfy = 1;
  %  while (count_vfy<= num_vfy)
  %      conv_vfy = cdata_vfy.conv_f{count_vfy};
  %      vfy_id = cdata_vfy.id(count_vfy);
  %      img_id_vfy = cdata_vfy.img_id(count_vfy);
  %      dist = sum((conv_reg-conv_vfy).*(conv_reg- conv_vfy));
 %       report = [report; reg_id, img_id_reg, vfy_id, img_id_vfy, dist];
  %      count_vfy = count_vfy + 1;
  %  end;
  %  count_reg = count_reg + 1;
  %  disp(count_reg);
%end;
%save([file_name,'_conv.cmat'],'report');
