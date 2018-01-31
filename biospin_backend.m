[filename,pathname]=uigetfile({'*.jpg';'*.png'},'File Selector','Multiselect','on');

%menambah sudut ekstraksi per pixel
  offsets = [0 1; -1 1;-1 0;-1 -1;2 2];

total=length(filename);
gambar={total};
data_glcm={total};
stats={total};
data_label={total};
label=1; %ngasih nama label ke data_label per gambar sekuen
limit=10; %pemberian batas pelabelan sebuah data dari gambar ke 10 20 30 40


for i=1:total
    
    file=fullfile(pathname,filename{i});
    gambar{i}=imread(file);
    gambar{i}=imresize(gambar{i},[64 64]);
    gambar{i}=rgb2gray(gambar{i});
    
    gambar{i}=imadjust(gambar{i},stretchlim(gambar{i} ));
    gambar{i}=imsharpen(gambar{i},'Radius',1,'Amount',0.5);

%   glcm=graycomatrix(gambar{i},'Offset',offsets);
    glcm=graycomatrix(gambar{i}, 'Offset', offsets, 'Symmetric', true);
    stats{i}=graycoprops(glcm);
    
%     pengambilan data texture dan disimpan (sementara) 

iglcm=1;
    for x=1:5
      data_glcm{i,x}=stats{i}.Contrast(iglcm);
      iglcm=iglcm+1;
    end
    iglcm=1;
    for x=6:10
        data_glcm{i,x}=stats{i}.Correlation(iglcm);
        iglcm=iglcm+1;
    end
    iglcm=1;
    for x=12:16
        data_glcm{i,x}=stats{i}.Energy(iglcm);
        iglcm=iglcm+1;
    end
        iglcm=1;
    for x=18:22
        data_glcm{i,x}=stats{i}.Homogeneity(iglcm);
        iglcm=iglcm+1;
    end
        data_glcm{i,24}=mean2(gambar{i});
        data_glcm{i,25}=std2(gambar{i});
        data_glcm{i,26}=entropy(gambar{i});
%         data_glcm{i,27}= mean2(var(double(gambar{i}))); %rata-rata variance gambar
        data_glcm{i,28}=kurtosis(double(gambar{i}(:)));
        data_glcm{i,29}=skewness(double(gambar{i}(:)));
        
        %pemberian label
        if i>limit
            label=label+1;
            data_label{i}=label;
            limit=limit+10;
        else
            data_label{1,i}=label;
        end         
end
% data di konversi ke type data yg sesuai agar svm tidak bingung
data_glcm=cell2mat(data_glcm);
data_label=cell2mat(data_label);
save('data_ekstraksi.mat','data_glcm','data_label');
% contoh penggunaan svm
% SVMModel=fitcecoc(data_glcm,data_label);
% test= fitcsvm(data_glcm,data_label,'Standardize',true,'KernelFunction','RBF','KernelScale','auto');