%  Copyright (c) 2015, Omkar M. Park:q
%  All rights reserved.

%config.paths.net_path = 'data/vgg_face.mat';
%config.paths.face_model_path = 'data/face_model.mat';

%faceDet = lib.face_detector.dpmCascadeDetector(config.paths.face_model_path);
%convNet = lib.face_feats.convNet(config.paths.net_path);
clear all;     
clc;

addpath('/ghome/zwual/caffe_face/matlab/');

%model = './extract_features.prototxt';3
%weights = './ULSeeModel.caffemodel';
model = './face_deploy.prototxt';
weights = './face_model.caffemodel';
caffe.set_mode_gpu();
gpu_id = 0;
caffe.set_device(gpu_id);
net = caffe.Net(model, weights, 'test'); % create net and load weights

averageImg = [129.1863,104.7624,93.5940] ;

%img = imread('ak.jpg');
%det = faceDet.detect(img);
%crop = crop(img,det(1:4,1));
%imwrite(crop,'crop.png');
%[score,class] = max(convNet.simpleNN(crop));

path = '/ghome/zwual/face_test/aligned'
Dir = dir(path);
count_reg = 0;
report = [];
cdata=cell(1,length(Dir)-2);
count_id=1;
count_dir =3;
total_num_reg =1;
total_num_vfy =1;
cdata_reg=struct('id',[],'img_id',[],'image_path',cell(1,1),'conv_f',cell(1,1),'fc_f',cell(1,1));

cdata_vfy=struct('id',[],'img_id',[],'image_path',cell(1,1),'conv_f',cell(1,1),'fc_f',cell(1,1));
while(count_dir <= length(Dir))
    path_reg = [path,'/',Dir(count_dir).name,'/reg/'];
    path_vfy = [path,'/',Dir(count_dir).name,'/vfy/'];
    dir_reg = dir(path_reg);
    dir_vfy = dir(path_vfy);
    reg_num = length(dir_reg) -2 ;
    vfy_num = length(dir_vfy) -2 ;

    sub_count_reg = 3;
    while(sub_count_reg<= length(dir_reg))
        image_path = [path_reg,dir_reg(sub_count_reg).name];
        img = imread(image_path);
       % conv_f=get_feature(img,net,'pool5');
%	conv_f = reshape(conv_f,[1,320]);
 %  	conv_f = conv_f/norm(conv_f); 
        fc_f = get_feature(img,net,'fc5');

        fc_mirror = get_feature(flipdim(img,2),net,'fc5');
        fc_f = [fc_f;fc_mirror];
	fc_f = fc_f/norm(fc_f); 
        cdata_reg.id(total_num_reg) = count_id;
        cdata_reg.img_id(total_num_reg) = sub_count_reg-2;
        cdata_reg.image_path{total_num_reg} = image_path;
       % cdata_reg.conv_f{total_num_reg} = conv_f;
        cdata_reg.fc_f{total_num_reg} = fc_f;;
        sub_count_reg = sub_count_reg + 1;
	total_num_reg = total_num_reg+1;
        disp(image_path);
    end;
    sub_count_vfy = 3;
    while(sub_count_vfy<= length(dir_vfy))
        image_path = [path_vfy,dir_vfy(sub_count_vfy).name];
        img = imread(image_path);
        %conv_f=get_feature(img,net,'pool5');
	%conv_f = reshape(conv_f,[1,320]);
   	%conv_f = conv_f/norm(conv_f); 
       fc_f = get_feature(img,net,'fc5');
        fc_mirror = get_feature(flipdim(img,2),net,'fc5');
        fc_f = [fc_f;fc_mirror];
	fc_f = fc_f/norm(fc_f); 
        cdata_vfy.id(total_num_vfy) = count_id;
        cdata_vfy.img_id(total_num_vfy) = sub_count_vfy-2;
        cdata_vfy.image_path{total_num_vfy} = image_path;
     %   cdata_vfy.conv_f{total_num_vfy} = conv_f;
        cdata_vfy.fc_f{total_num_vfy} = fc_f;
        sub_count_vfy = sub_count_vfy + 1;
	total_num_vfy = total_num_vfy +1;
        disp(image_path)
    end;
    disp(path_reg);
    count_dir = count_dir +1;
    count_id= count_id + 1;
    
end
%save('triplet_v4_5_36w.mat','cdata_reg','cdata_vfy');
caffe.reset_all();

get_evaluation;


