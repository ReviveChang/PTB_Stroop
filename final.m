BashSize = 2;
BlockSize = 2*BashSize;
BlockNum = 1;

PracticeNum=20;

prac={'prac1.jpg','prac2.jpg'};
intro = {'a.jpg','b.jpg','b.jpg','a.jpg'};
audioset = {'1.wav','2.wav','3.wav'};
resp={'A','L','S','K','L','A','S','K','S','K','A','L','K','A','L','S'};
random_block = randperm(3);

KbName('UnifyKeyNames'); 
escapeKey=KbName('ESCAPE');

InitializePsychSound(); %������ʼ��
win=Screen('OpenWindow',0,[],[0 0 1920 1080]);%��100��100λ�ô�һ���Ĵ��ڣ�׼�����ִ̼�
 

%��ʾ��ָ����
Ima=imread('introduction.jpg');%����ͼƬ
textureIndex=Screen('MakeTexture',win,Ima); %������ͼƬ�ķ�ʽװ��
Screen('DrawTexture',win,textureIndex);%��ͼƬ�̼��뻺����
Screen('Flip',win);
WaitSecs(2); %�̼�����10s

prac_a=1;
%��ϰ����
% for j=1:PracticeNum
%     %��ָ����
%         if mod(j,10)==1
%             Ima=imread(prac{prac_a});%����ͼƬ
%             textureIndex=Screen('MakeTexture',win,Ima); %������ͼƬ�ķ�ʽװ��
%             Screen('DrawTexture',win,textureIndex);%��ͼƬ�̼��뻺����
%             Screen('Flip',win);
%             WaitSecs(10);
%             prac_a = prac_a + 1;
%         end
%         
%         %ע�ӵ�
%         Ima=imread('cross.jpg');
%         textureIndex=Screen('MakeTexture',win,Ima); %������ͼƬ�ķ�ʽװ��
%         Screen('DrawTexture',win,textureIndex);%��ͼƬ�̼��뻺����
%         Screen('Flip',win);
%         WaitSecs(0.5); 
%         
%         %������� 100-300ms
%         Ima=imread('background.jpg');
%         textureIndex=Screen('MakeTexture',win,Ima); 
%         Screen('DrawTexture',win,textureIndex);
%         Screen('Flip',win);
%         WaitSecs(0.1+0.2*rand);
%   
%         %�̼� 500ms
%         Ima=imread([num2str(pra(j,4)),'.jpg']);
%         textureIndex=Screen('MakeTexture',win,Ima); 
%         Screen('DrawTexture',win,textureIndex);
%         Screen('Flip',win);
%         WaitSecs(0.5); 
% 
%         %������� 800-1200ms
%         Ima=imread('background.jpg');
%         textureIndex=Screen('MakeTexture',win,Ima); 
%         Screen('DrawTexture',win,textureIndex);
%         Screen('Flip',win);
%         WaitSecs(0.8+0.4*rand);
% 
% end

intro_index = 1;
%��ʽʵ��
for i=1:BlockNum %block�����
    cur_block = random_block(i);
    start_index = (cur_block-1)*BlockSize; 

   
    
    %��������
    [y,fs] = psychwavread(audioset{cur_block});
    wave = y';
    numChannels = size(wave, 1);
    pahandle = PsychPortAudio('Open',1, [], 1, fs, numChannels);
    PsychPortAudio('FillBuffer', pahandle, wave);
    PsychPortAudio('Start',pahandle,0);

    
    for k=1:BlockSize
        cur_index = start_index + k; %��������˳��
         
        %��ָ����
        if mod(k,40)==1
            Ima=imread(intro{intro_index});%����ͼƬ
            textureIndex=Screen('MakeTexture',win,Ima); %������ͼƬ�ķ�ʽװ��
            Screen('DrawTexture',win,textureIndex);%��ͼƬ�̼��뻺����
            Screen('Flip',win);
            WaitSecs(5);
            intro_index = intro_index + 1;
        end
        
        %ע�ӵ�
        Ima=imread('cross.jpg');
        textureIndex=Screen('MakeTexture',win,Ima); %������ͼƬ�ķ�ʽװ��
        Screen('DrawTexture',win,textureIndex);%��ͼƬ�̼��뻺����
        Screen('Flip',win);
        WaitSecs(0.5); 
        
        %������� 100-300ms
        Ima=imread('background.jpg');
        textureIndex=Screen('MakeTexture',win,Ima); 
        Screen('DrawTexture',win,textureIndex);
        Screen('Flip',win);
        WaitSecs(0.1+0.2*rand);
  
        %�̼� 500ms
        Ima=imread([num2str(info(cur_index,5)),'.jpg']);
        textureIndex=Screen('MakeTexture',win,Ima); 
        Screen('DrawTexture',win,textureIndex);
        Screen('Flip',win);
        t0=GetSecs; %��Ӧʱ
        timeSecs=KbWait;
        [keylsDown,t,keyCode]=KbCheck;
        WaitSecs(0.5); 

        %������� 800-1200ms
        Ima=imread('background.jpg');
        textureIndex=Screen('MakeTexture',win,Ima); 
        Screen('DrawTexture',win,textureIndex);
        Screen('Flip',win);
        WaitSecs(0.8+0.4*rand);        
         

        if keyCode(escapeKey)
            PsychPortAudio('Close');
            Screen('CloseAll')
        end

        rt(cur_index)=t-t0;
        
        rightKey = KbName(resp{info(cur_index,5)});
        res(cur_index) = any(keyCode(rightKey));
        
        
        
        
    end
    
    %��Ϣ1����
    PsychPortAudio('Stop',pahandle,0);
    Ima=imread('pause.jpg');
    textureIndex=Screen('MakeTexture',win,Ima); 
    Screen('DrawTexture',win,textureIndex);
    Screen('Flip',win);
    WaitSecs(60);  
   
end
%������
Ima=imread('end.jpg');
textureIndex=Screen('MakeTexture',win,Ima); 
Screen('DrawTexture',win,textureIndex);
Screen('Flip',win);
WaitSecs(60);

sca;

%�����ȷ�ʡ���Ӧʱ
rt1_block_all = [];
rt2_block_all = [];
res1_block_all = [];
res2_block_all = [];

for i=1:BlockNum
    start_index = (i-1)*BlockSize ;
    rt1_block = [rt(start_index+1:start_index+BashSize),rt(start_index+3*BashSize+1,start_index+4*BashSize)];
    rt2_block = rt(start_index+BashSize+1:start_index+3*BashSize);
    res1_block = [res(start_index+1:start_index+BashSize),res(start_index+3*BashSize+1,start_index+4*BashSize)];
    res2_block = res(start_index+BashSize+1:start_index+3*BashSize);
    
    rt1_block_all = [rt1_block_all,rt1_block];
    rt2_block_all = [rt2_block_all,rt2_block];
    res1_block_all = [res1_block_all,res1_block];
    res2_block_all = [res2_block_all,res2_block];
    
    output(i,1) = mean(rt1_block);
    output(i,2) = mean(rt2_block);
    output(i,3) = sum(res1_block)/size(res1_block);
    output(i,4) = sum(res2_block)/size(res2_block);
end

output(BlockNum+1,1) = mean(rt1_block_all);
output(BlockNum+1,2) = mean(rt2_block_all);
output(BlockNum+1,3) = sum(res1_block_all)/size(res1_block_all);
output(BlockNum+1,4) = sum(res2_block_all)/size(res2_block_all);
