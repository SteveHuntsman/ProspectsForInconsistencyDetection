#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#%%
import os
os.environ['OPENAI_API_KEY'] = # insert yours here

#%%
from openai import OpenAI
client = OpenAI()

#%%
import re
leadingNumber = re.compile(r"^\d*\. ")  # for removing leading strings like '2. ', etc.

#%%
import numpy as np

#%%
import pickle

#%%
claimPairs = [["The earth is flat","The earth is round"],
    ["The earth is flat","The sky is red"],
    ["The sky is blue","The sky is red"],
    ["The sky is blue","The earth is round"],
    ["The theory of evolution has been conclusively demonstrated","Evolution is a theory"],
    ["The theory of evolution has been conclusively demonstrated","Evolution is just a theory"],
    ["The theory of evolution has been conclusively demonstrated","Theories are explanatory frameworks"],
    ["The theory of evolution has been conclusively demonstrated","Theories can be disproved"],
    ["The theory of evolution has been conclusively demonstrated","The earth is round"],
    ["The theory of evolution has been conclusively demonstrated","The earth is flat"],
    ["The theory of evolution has been conclusively demonstrated","The sky is blue"],
    ["The theory of evolution has been conclusively demonstrated","The sky is red"],
    ["Purple people are evil","Purple people are good"],
    ["Purple people are different from me","People are mostly the same"],
    ["Blue people are evil","Blue people want to advance policies I dislike"],
    ["If you want peace, prepare for war","Violence is always wrong"]]

#%%
consistencyInit = 'Imagine you are a perfectly objective arbitrator with impeccable judgment and integrity. In response to a prompt of the form "evalConsistency: " followed by two claims in square brackets that are separated by a space, please do two things. First, explain the logical relationship between the two claims, assuming that the first claim is true, whether or not it actually is. I want you to ignore the truth, falsity or basis in fact of either claim. Second, use your explanation to numerically rate the relative consistency of the two claims. Do not pay attention to or comment on the truth or basis in fact of either claim independent of the other. Your rating of relative consistency should be on a scale from 0 to 10, with a value of 0 for a pair of claims that are not at all consistent and a value of 10 for a pair of claims that are totally consistent. I cannot emphasize enough that for your rating, I want you to ignore the truth or basis in fact of either claim, since anything that is not consistent with reality cannot be true. To be clear, a pair of unrelated claims should be rated a 10 and a pair of false but consistent claims should also be rated a 10. Meanwhile, a pair of claims of which one is true and the other is false, should be rated a 0. Your response must end with the numerical rating. \n\n For example, the prompt \n\n "evalConsistency: [The earth is flat] [The sky is red]" \n\n should produce a response like \n\n "The shape of the earth and color of the sky are unrelated, so the consistency rating of these claims is 10." \n\n As another example, the prompt \n\n "evalConsistency: [Purple people are evil] [Purple people are good]" \n\n should produce a response like \n\n "If either claim is true, then the other is false, so the consistency rating of these claims is 0." Your response must end with the numerical rating.' 

#%%
N = 100;
# Initializations
details3 = []
details4 = []
scores3 = np.zeros([len(claimPairs),N])
scores4 = np.zeros([len(claimPairs),N])
# Loop
for j in range(len(claimPairs)):
    str1 = claimPairs[j][0]
    str2 = claimPairs[j][1]
    details3_j = []
    details4_j = []
    consistencyPrompt = "evalConsistency: ["+str1+"] ["+str2+"]"
    # Loop over realizations
    for k in range(N):
        print(str(j+1)+"/"+str(len(claimPairs))+"; "+str(k+1)+"/"+str(N))
        #%% Interact with ChatGPT following this example:
        #        
        # completion = client.chat.completions.create(
        #     model="gpt-3.5-turbo",
        #     messages=[
        #         {"role": "system", "content": "You are a poetic assistant, skilled in explaining complex programming concepts with creative flair."},
        #         {"role": "user", "content": "Compose a poem that explains the concept of recursion in programming."}
        #   ]
        # )
        #
        # print(completion.choices[0].message)
        #
        #%%
        # Models from https://platform.openai.com/docs/models
        #%%
        completion3 = client.chat.completions.create(
            model = "gpt-3.5-turbo",
            messages = [
                {"role": "system", "content": consistencyInit},
                {"role": "user", "content": consistencyPrompt}
            ]
        )
        completion4 = client.chat.completions.create(
            model = "gpt-4",
            messages = [
                {"role": "system", "content": consistencyInit},
                {"role": "user", "content": consistencyPrompt}
            ]
        )
        # Extract response from ChatGPT
        foo3 = completion3.choices[0].message.content
        foo4 = completion4.choices[0].message.content
        # Extract the numerical rating (or NaN if none is to be found)
        try:
            bar3 = float(re.findall(r'[-+]?(?:\d*\.*\d+)',foo3)[-1])
        except Exception: 
            foo3 = ''
            bar3 = float("NaN")
        try:
            bar4 = float(re.findall(r'[-+]?(?:\d*\.*\d+)',foo4)[-1])
        except Exception: 
            foo4 = ''
            bar4 = float("NaN")
        # Append results
        scores3[j,k] = bar3
        scores4[j,k] = bar4
        details3_j.append(foo3)
        details4_j.append(foo4)
    # Append results
    details3.append(details3_j)
    details4.append(details4_j) # bug fixed from earlier version
    # Pickle/save
    with open('consistencyData20240122.pkl','wb') as f:
        pickle.dump([details3,details4,scores3,scores4],f)

#%% https://stackoverflow.com/a/47626762
import json
class NumpyEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, np.ndarray):
            return obj.tolist()
        return json.JSONEncoder.default(self, obj)

#%% Extra saves
with open('details3_20240122.json', 'w', encoding='utf-8') as f:
    json.dump(details3, f, ensure_ascii=False, indent=4)
with open('details4_20240122.json', 'w', encoding='utf-8') as f:
    json.dump(details4, f, ensure_ascii=False, indent=4)
json_dump = json.dumps({'details3': details3, 'details4': details4,
                        'scores3': scores3, 'scores4': scores4}, 
                       cls=NumpyEncoder)
with open('consistencyData20240122.json', 'w', encoding='utf-8') as f:
    json.dump(json_dump, f, ensure_ascii=False, indent=4)
