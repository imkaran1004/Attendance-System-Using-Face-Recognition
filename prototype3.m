Dataset=imageDatastore('datastorage','IncludeSubfolders',true,'LabelSource','foldernames');
[Training_Dataset,Validation_Dataset]=splitEachLabel(Dataset, 0.8);
net1 = vgg19;
%analyzeNetwork (net1)
Input_Layer_Size = net1.Layers (1).InputSize;
Layer_Graph = layerGraph (net1) ;
Feature_Learner = net1.Layers(45);
Output_Classifier = net1.Layers(47);
Number_of_Classes = numel (categories (Training_Dataset.Labels));
New_Feature_Learner=fullyConnectedLayer(Number_of_Classes,'Name','Facial Feature Learner','WeightLearnRateFactor',10,'BiasLearnRateFactor',10);
New_Classifier_Layer=classificationLayer('Name','Face Classifier');
Layer_Graph=replaceLayer(Layer_Graph,Feature_Learner.Name,New_Feature_Learner);
Layer_Graph=replaceLayer(Layer_Graph,Output_Classifier.Name,New_Classifier_Layer);
%analyzeNetwork(Layer_Graph)
Pixel_Range=[-30 30];
Scale_Range=[0.9 1.1];
Image_Augmenter=imageDataAugmenter('RandXReflection',true,'RandXTranslation',Pixel_Range,'RandYTranslation',Pixel_Range,'RandXScale',Scale_Range,'RandYScale',Scale_Range);

Augmented_Training_Image=augmentedImageDatastore(Input_Layer_Size(1:2),Training_Dataset,'DataAugmentation',Image_Augmenter);
Augmented_Validation_Image=augmentedImageDatastore(Input_Layer_Size(1:2),Validation_Dataset);
Size_of_Minibatch=10;
Validation_Frequency=floor(numel(Augmented_Training_Image.Files)/Size_of_Minibatch);
Training_Options=trainingOptions('sgdm','MiniBatchSize',Size_of_Minibatch,'MaxEpochs',12,'InitialLearnRate',3e-4,'Shuffle','every-epoch','ValidationData',Augmented_Validation_Image,'ValidationFrequency',Validation_Frequency,'Verbose',false,'Plots','training-progress');
net1=trainNetwork(Augmented_Training_Image,Layer_Graph,Training_Options);