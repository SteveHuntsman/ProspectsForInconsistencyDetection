%% Pairs of claims
claimPairs = [["The earth is flat","The earth is round"];...
   ["The earth is flat","The sky is red"];...
   ["The sky is blue","The sky is red"];...
   ["The sky is blue","The earth is round"];...
   ["The theory of evolution has been conclusively demonstrated","Evolution is a theory"];...
   ["The theory of evolution has been conclusively demonstrated","Evolution is just a theory"];...
   ["The theory of evolution has been conclusively demonstrated","Theories are explanatory frameworks"];...
   ["The theory of evolution has been conclusively demonstrated","Theories can be disproved"];...
   ["The theory of evolution has been conclusively demonstrated","The earth is round"];...
   ["The theory of evolution has been conclusively demonstrated","The earth is flat"];...
   ["The theory of evolution has been conclusively demonstrated","The sky is blue"];...
   ["The theory of evolution has been conclusively demonstrated","The sky is red"];...
   ["Purple people are evil","Purple people are good"];...
   ["Purple people are different from me","People are mostly the same"];...
   ["Blue people are evil","Blue people want to advance policies I dislike"];...
   ["If you want peace, prepare for war","Violence is always wrong"]];

%% The following experiment cost a bit over $1.50 for ChatGPT 3.5 and $30 for ChatGPT 4
% This includes a few pennies here and there for testing w/ ChatGPT 3.5

    % #!/usr/bin/env python3
    % # -*- coding: utf-8 -*-
    % 
    % #%%
    % import os
    % os.environ['OPENAI_API_KEY'] = # insert your key here
    % 
    % #%%
    % from openai import OpenAI
    % client = OpenAI()
    % 
    % #%%
    % import re
    % leadingNumber = re.compile(r"^\d*\. ")  # for removing leading strings like '2. ', etc.
    % 
    % #%%
    % import numpy as np
    % 
    % #%%
    % import pickle
    % 
    % #%%
    % claimPairs = [["The earth is flat","The earth is round"],
    %     ["The earth is flat","The sky is red"],
    %     ["The sky is blue","The sky is red"],
    %     ["The sky is blue","The earth is round"],
    %     ["The theory of evolution has been conclusively demonstrated","Evolution is a theory"],
    %     ["The theory of evolution has been conclusively demonstrated","Evolution is just a theory"],
    %     ["The theory of evolution has been conclusively demonstrated","Theories are explanatory frameworks"],
    %     ["The theory of evolution has been conclusively demonstrated","Theories can be disproved"],
    %     ["The theory of evolution has been conclusively demonstrated","The earth is round"],
    %     ["The theory of evolution has been conclusively demonstrated","The earth is flat"],
    %     ["The theory of evolution has been conclusively demonstrated","The sky is blue"],
    %     ["The theory of evolution has been conclusively demonstrated","The sky is red"],
    %     ["Purple people are evil","Purple people are good"],
    %     ["Purple people are different from me","People are mostly the same"],
    %     ["Blue people are evil","Blue people want to advance policies I dislike"],
    %     ["If you want peace, prepare for war","Violence is always wrong"]]
    % 
    % #%%
    % consistencyInit = 'Imagine you are a perfectly objective arbitrator with impeccable judgment and integrity. In response to a prompt of the form "evalConsistency: " followed by two claims in square brackets that are separated by a space, please do two things. First, explain the logical relationship between the two claims, assuming that the first claim is true, whether or not it actually is. I want you to ignore the truth, falsity or basis in fact of either claim. Second, use your explanation to numerically rate the relative consistency of the two claims. Do not pay attention to or comment on the truth or basis in fact of either claim independent of the other. Your rating of relative consistency should be on a scale from 0 to 10, with a value of 0 for a pair of claims that are not at all consistent and a value of 10 for a pair of claims that are totally consistent. I cannot emphasize enough that for your rating, I want you to ignore the truth or basis in fact of either claim, since anything that is not consistent with reality cannot be true. To be clear, a pair of unrelated claims should be rated a 10 and a pair of false but consistent claims should also be rated a 10. Meanwhile, a pair of claims of which one is true and the other is false, should be rated a 0. Your response must end with the numerical rating. \n\n For example, the prompt \n\n "evalConsistency: [The earth is flat] [The sky is red]" \n\n should produce a response like \n\n "The shape of the earth and color of the sky are unrelated, so the consistency rating of these claims is 10." \n\n As another example, the prompt \n\n "evalConsistency: [Purple people are evil] [Purple people are good]" \n\n should produce a response like \n\n "If either claim is true, then the other is false, so the consistency rating of these claims is 0." Your response must end with the numerical rating.' 
    % 
    % #%%
    % N = 100;
    % # Initializations
    % details3 = []
    % details4 = []
    % scores3 = np.zeros([len(claimPairs),N])
    % scores4 = np.zeros([len(claimPairs),N])
    % # Loop
    % for j in range(len(claimPairs)):
    %     str1 = claimPairs[j][0]
    %     str2 = claimPairs[j][1]
    %     details3_j = []
    %     details4_j = []
    %     consistencyPrompt = "evalConsistency: ["+str1+"] ["+str2+"]"
    %     # Loop over realizations
    %     for k in range(N):
    %         print(str(j+1)+"/"+str(len(claimPairs))+"; "+str(k+1)+"/"+str(N))
    %         #%% Interact with ChatGPT following this example:
    %         #        
    %         # completion = client.chat.completions.create(
    %         #     model="gpt-3.5-turbo",
    %         #     messages=[
    %         #         {"role": "system", "content": "You are a poetic assistant, skilled in explaining complex programming concepts with creative flair."},
    %         #         {"role": "user", "content": "Compose a poem that explains the concept of recursion in programming."}
    %         #   ]
    %         # )
    %         #
    %         # print(completion.choices[0].message)
    %         #
    %         #%%
    %         # Models from https://platform.openai.com/docs/models
    %         #%%
    %         completion3 = client.chat.completions.create(
    %             model = "gpt-3.5-turbo",
    %             messages = [
    %                 {"role": "system", "content": consistencyInit},
    %                 {"role": "user", "content": consistencyPrompt}
    %             ]
    %         )
    %         completion4 = client.chat.completions.create(
    %             model = "gpt-4",
    %             messages = [
    %                 {"role": "system", "content": consistencyInit},
    %                 {"role": "user", "content": consistencyPrompt}
    %             ]
    %         )
    %         # Extract response from ChatGPT
    %         foo3 = completion3.choices[0].message.content
    %         foo4 = completion4.choices[0].message.content
    %         # Extract the numerical rating (or NaN if none is to be found)
    %         try:
    %             bar3 = float(re.findall(r'[-+]?(?:\d*\.*\d+)',foo3)[-1])
    %         except Exception: 
    %             foo3 = ''
    %             bar3 = float("NaN")
    %         try:
    %             bar4 = float(re.findall(r'[-+]?(?:\d*\.*\d+)',foo4)[-1])
    %         except Exception: 
    %             foo4 = ''
    %             bar4 = float("NaN")
    %         # Append results
    %         scores3[j,k] = bar3
    %         scores4[j,k] = bar4
    %         details3_j.append(foo3)
    %         details4_j.append(foo4)
    %     # Append results
    %     details3.append(details3_j)
    %     details4.append(details4_j) # bug fixed from earlier version
    %     # Pickle/save
    %     with open('consistencyData20240122.pkl','wb') as f:
    %         pickle.dump([details3,details4,scores3,scores4],f)
    % 
    % #%% https://stackoverflow.com/a/47626762
    % import json
    % class NumpyEncoder(json.JSONEncoder):
    %     def default(self, obj):
    %         if isinstance(obj, np.ndarray):
    %             return obj.tolist()
    %         return json.JSONEncoder.default(self, obj)
    % 
    % #%% Extra saves
    % with open('details3_20240122.json', 'w', encoding='utf-8') as f:
    %     json.dump(details3, f, ensure_ascii=False, indent=4)
    % with open('details4_20240122.json', 'w', encoding='utf-8') as f:
    %     json.dump(details4, f, ensure_ascii=False, indent=4)
    % json_dump = json.dumps({'details3': details3, 'details4': details4,
    %                         'scores3': scores3, 'scores4': scores4}, 
    %                        cls=NumpyEncoder)
    % with open('consistencyData20240122.json', 'w', encoding='utf-8') as f:
    %     json.dump(json_dump, f, ensure_ascii=False, indent=4)

%% [Some Python and ChatGPT API stuff happens in consistency20240119.py...]
% I just copypasted the scores into Word and reformatted them as below

%% ChatGPT 3.5
scores3 = [[ 0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.  10.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0. ];...
 [10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10. ];...
 [ 0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0. ];...
 [10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10. ];...
 [10.  10.  10.  10.  10.  10.   0.  10.   9.5 10.  10.   9.5 10.  10....
  10.  10.  10.  10.   9.  10.  10.  10.  10.  10.  10.   0.  10.   7.5...
  10.  10.  10.  10.   9.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.   5.  10.  10.   9.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.   0.  10.  10.   9.5  0.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.   0.  10.  10.  10.  10.  10.  10....
  10.  10.  10.   0.   9.5 10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10. ];...
 [ 0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.  10.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   8.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   2.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   5.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   2.   0....
   0.   0. ];...
 [10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
   8.  10.  10.  10.  10.   8.  10.  10.  10.  10.   8.  10.  10.  10....
  10.  10.  10.   nan 10.  10.   8.   7.  10.  10.  10.  10.  10.  10....
  10.   8.  10.  10.  10.  10.  10.  10.  10.  10.   8.  10.  10.   8....
  10.   8.   9.5 10.  10.  10.  10.  10.  10.  10.   7.   8.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.   8.5  3.5 10....
  10.   8.  10.  10.  10.  10.  10.  10.  10.  10.  10.   8.   7.  10....
  10.  10. ];...
 [ 0.   9.  10.  10.  10.  10.  10.  10.  10.  10.   0.   3.  10.  10....
  10.   0.  10.  10.   5.   0.  10.  10.  10.  10.  10.   0.  10.  10....
  10.  10.   0.  10.  10.   8.   0.  10.  10.   8.  10.   0.  10.  10....
   7.5 10.   0.   0.  10.  10.   3.5  0.   0.  10.  10.  10.  10.  10....
  10.   0.  10.  10.  10.  10.   0.   0.   9.  10.   0.  10.   0.  10....
   0.  10.  10.   0.  10.  10.   0.  10.  10.  10.  10.  10.  10.   9....
  10.  10.  10.  10.  10.  10.  10.  10.   0.  10.  10.   0.   0.   0....
   0.   0. ];...
 [10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10. ];...
 [10.   0.   0.   0.   0.  10.  10.  10.  10.   0.  10.   0.  10.  10....
  10.  10.   0.   0.   0.   0.   0.  10.   0.  10.   0.   0.   0.   0....
   0.   0.   0.  10.   0.  10.  10.  10.  10.   0.   0.   0.  10.   0....
  10.   0.  10.  10.   0.  10.  10.  10.  10.   0.   0.  10.   0.  10....
  10.  10.   0.   0.   0.   0.  10.   0.  10.   0.  10.   0.   0.   0....
   0.  10.   0.  10.   0.  10.  10.   0.   0.  10.  10.   0.  10.  10....
   0.   0.  10.  10.  10.  10.  10.  10.   0.   0.   0.  10.  10.  10....
   0.   0. ];...
 [10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10. ];...
 [10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10. ];...
 [ 0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0. ];...
 [ 0.   0.   0.  10.   0.  10.  10.   0.   9.   0.   0.   0.   0.   0....
   0.  10.   0.   0.  10.   0.   8.  10.   0.   0.  10.   0.   0.   0....
   0.   0.  10.   0.   0.  10.   0.  10.   0.   0.  10.   8.   0.   0....
   7.5  8.5 10.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   7.5 10.   0.  10.   0.  10.   0.   8.   0.  10.   0.   0.   0.   8.5...
   0.   0.   0.   0.   0.   0.   8.   0.   0.  10.   0.   0.   0.   7....
   0.   0.   3.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.  10....
   0.   0. ];...
 [10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.   5.  10....
  10.  10.   8.  10.   5.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.   5.  10.  10.  10.  10.  10.   5.   6....
  10.  10.  10.   8.  10.  10.  10.  10.  10.  10.   5.  10.  10.  10....
  10.  10.  10.  10.  10.  10.   5.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.   6.  10.  10.  10.  10.  10.  10.   8.  10....
  10.  10. ];...
 [ 0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0. ]];

%% ChatGPT 4
scores4 = [[ 0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0. ];...
 [10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10. ];...
 [ 0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0. ];...
 [10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10. ];...
 [10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.   9.5 10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10. ];...
 [10.   2.   8.  10.  10.  10.  10.   3.5 10.   7.   0.  10.   4.   5....
   6.   5.   7.  10.  10.   8.   8.   7.   2.  10.  10.   6.   7.   8....
  10.  10.  10.   0.   7.   5.   4.  10.   5.   7.  10.   7.  10.   3....
   5.   0.  10.   0.  10.   0.  10.   8.   5.   6.  10.  10.   5.   5....
  10.  10.   3.   3.  10.   8.   7.5  8.5  8.   0.  10.  10.   8.   6....
   6.   7.   5.  10.  10.  10.   5.   5.  10.   7.   5.  10.   7.   5....
  10.   5.  10.   6.5  4.   8.   6.  10.   4.   5.  10.   7.5  0.   7....
   6.   5. ];...
 [10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10. ];...
 [10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.   8.  10.  10.  10.   8.   7.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
   4.  10.  10.  10.  10.  10.  10.  10.  10.   9.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.   0.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10. ];...
 [10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10. ];...
 [10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10. ];...
 [10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10. ];...
 [10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10.  10....
  10.  10. ];...
 [ 0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0. ];...
 [10.   8.   5.   4.   5.   5.   7.   5.   8.   8.  10.   7.   5.   7....
   3.   8.   5.   7.   5.   5.   8.  10.   8.   5.   5.  10.   5.   8....
   5.   8.  10.  10.  10.  10.  10.   9.   7.  10.  10.   7.  10.   5....
   6.   7.   4.   6.   9.   7.   6.  10.   8.   5.   5.   6.  10.  10....
   7.  10.  10.  10.  10.   7.   7.  10.   4.  10.   0.   7.   7.  10....
   5.   6.   7.   8.  10.   7.   0.  10.  10.   5.   8.   5.  10.   7....
   5.   7.   0.   7.   7.   9.   8.   7.   3.   7.   6.  10.   8.   8....
   7.  10. ];...
 [ 8.   8.   8.  10.   7.   8.   7.   7.   8.   7.   8.  10.   7.   8....
   7.  10.   9.   8.   8.   7.   8.   8.   7.  10.   9.  10.   7.   6....
   6.   7.   7.   7.   9.   8.5  5.   7.   8.   7.   8.5 10.   8.  10....
   7.5  7.  10.  10.   7.   7.   8.   7.   8.   7.   7.   6.   8.  10....
   7.   5.  10.  10.   5.   7.   8.  10.  10.   7.   9.   5.   7.   7....
   8.  10.  10.   7.   7.  10.   7.   5.   7.   9.   7.  10.  10.  10....
   7.   5.   5.  10.   8.   7.  10.   9.   7.   7.   7.   7.   7.   6....
   7.  10. ];...
 [ 0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0.   0....
   0.   0. ]];

%% Get counts
counts3 = nan(size(claimPairs,1),11);
counts4 = nan(size(claimPairs,1),11);
for j = 1:size(claimPairs,1)
    counts3(j,:) = histcounts(scores3(j,:),(0:11)-.5);
    counts4(j,:) = histcounts(scores4(j,:),(0:11)-.5);
end

%% Reorder things for clarity in plots because I was silly
idx = [1:4,13:16,5:12];
claimPairs = claimPairs(idx,:);
counts3 = counts3(idx,:);
counts4 = counts4(idx,:);

%% Plot counts
h = figure;
set(h,'Position',[h.Position(1:3),525]);   % 1.5x height
ha = tight_subplot(8,2,[.01,.01],.075,.075);
for j = 1:numel(ha)
    axes(ha(j)); %#ok<LAXES>
    %% Bars
    b = bar([counts3(j,:);counts4(j,:)]');
    b(1).FaceColor = 'r';%[1,1,1]*2/3;
    b(1).EdgeColor = "none";
    b(2).FaceColor = 'b';%[1,1,1]*0;
    b(2).EdgeColor = "none";
    %%
    ylim([0,110]);
    %% Labels
    if j > 14
        xticklabels(string(0:10));
        xlabel('consistency rating');
    else
        xticklabels([]);
    end
    yticks([0,100]);
    if mod(j,2)
        ylabel('bin count');
    else
        yticklabels([]);
    end
    %% Text
    str = [];
    splitThreshold = 32;
    for k = 1:2
        foo = regexp(claimPairs(j,k),'\s');
        ind = foo(find(foo>splitThreshold,1,'first'));
        if numel(ind)
            tmp = char(claimPairs(j,k));
            foo = [string(tmp(1:(ind-1))),string(tmp((ind+1):end))];
        else
            foo = claimPairs(j,k);
        end
        if k == 1
            pre = "1:";
        else
            pre = "2:";
        end
        str = [str,join([pre,foo(1)]),foo(2:end)]; %#ok<AGROW>
    end
    text(5+1,105,str,'HorizontalAlignment','center',...
        'VerticalAlignment','top');
    %% Legend
    if j == 1
        legend(["ChatGPT 3.5","ChatGPT 4"],...
            "Location","southeast","Orientation","horizontal");
    end
end

%% Save
fileDir = '/Users/sha0639/Documents/BD';
fileName = ['chatGPT',num2str(yyyymmdd(datetime))];
print([fileDir,filesep,fileName],'-dpng');
print([fileDir,filesep,fileName],'-dpdf');

