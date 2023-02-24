
%I=imread("aryanmtest.jpeg");
cam=webcam("Integrated Webcam");

I=snapshot(cam);
G=imresize(I,[224,224]);
[Label,Prob]=classify(net,G);
figure;
imshow(G);
title({char(Label),num2str(max(Prob),2)});
M = readtable('attandence.csv','ReadVariableNames',false);
disp(M);
Names=["aryan mehta" "axit thummar" "darshan dobariya" "dhruv prajapati" "dhruvin varsani" "jay nakum" "karan gondaliya" "kashyap chudasama" "kuldip bhadarka" "kunjan gokani" "mohil kachhadiya" "sahil borad" "tirth chavda" "vivek godhasara" "yash ginoya" "yash gohel" "aryan chavda" "jayneel zala" "sagar patel" "aakash arya" "aditya pachchigar" "aditya singh" "aryan choksi" "aryan pandi" "avi tayal" "jinang vohera" "kanav avasthi"];
result=find(Names==string(Label));
M.Var2(result)=M.Var2(result)+1;
disp(M.Var2);
writetable(M,'attandence.csv','WriteMode','overwrite');