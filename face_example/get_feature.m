function feature = get_feature(img,net,layer)
    img = img(:, :, [3, 2, 1]); % convert from RGB to BGR
    img = permute(img, [2, 1, 3]); % permute width and height
    img = (single(img) - 127.5)/128;
    res = net.forward({img});
    prob = res{1};

    feature = net.blobs(layer).get_data();
   
end
