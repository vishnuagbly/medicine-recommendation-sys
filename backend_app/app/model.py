import pickle
import string
import nltk
import numpy as np
import json
import tensorflow_hub as hub
from nltk.corpus import wordnet
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer
from tensorflow.keras.preprocessing.sequence import pad_sequences
from tensorflow.keras import layers, Sequential, regularizers

NLTK_PATH = 'assets/nltk_data/'


class Model:
    def __init__(self):
        # nltk.download('wordnet')
        # nltk.download('stopwords')
        # nltk.download('averaged_perceptron_tagger')
        nltk.data.path.append(NLTK_PATH)
        with open('assets/tokenizer.pickle', 'rb') as handle:
            self.tokenizer = pickle.load(handle)
        self.model = Model._createModel()
        self.embed = hub.load('assets/universal-sentence-encoder/1')
        self.model.load_weights('assets/model.h5')
        self.lemmatizer = WordNetLemmatizer()
        self.stop_words = Model._getStopWords()
        self.conditions_map = json.load(open('assets/conditions_map.json'))

    def search(self, texts):
        if not isinstance(texts, list) or len(texts) == 0:
            return

        if not isinstance(texts[0], str):
            return

        condition_embeddings = np.array(list(self.conditions_map.values()))
        query_embedding = self.embed(texts)
        inner_product = np.inner(condition_embeddings, query_embedding)
        res = {}
        for value in texts:
            res[value] = []

        conditions = list(self.conditions_map.keys())
        for i in range(len(inner_product)):
            for j in range(len(texts)):
                res[texts[j]].append([conditions[i], inner_product[i][j]])

        for i in range(len(texts)):
            res[texts[i]] = sorted(
                res[texts[i]], key=lambda x: x[1], reverse=True)[0:20]

        return res

    @staticmethod
    def _getStopWords():
        stop_words = set(stopwords.words('english'))
        stop_words.remove('no')
        stop_words.remove('not')
        stop_words.remove('nor')
        return stop_words

    @staticmethod
    def _createModel():
        model = Sequential()
        model.add(layers.Embedding(75000, 10, input_length=100))
        model.add(layers.Bidirectional(layers.LSTM(6)))
        model.add(layers.Dropout(0.5))
        model.add(layers.Dense(16, activation='relu', kernel_initializer='he_normal',
                  kernel_regularizer=regularizers.L2(0.01)))
        model.add(layers.Dense(4, activation='relu', kernel_initializer='he_normal',
                  kernel_regularizer=regularizers.L2(0.01)))
        model.add(layers.Dense(1, activation='sigmoid',
                  kernel_initializer='glorot_normal', kernel_regularizer=regularizers.L2(0.05)))
        model.compile(optimizer='adam',
                      loss='binary_crossentropy', metrics=['accuracy'])
        return model

    def preProcessTexts(self, texts):
        def pre_process(text: str) -> str:
            text = text.replace('&#039;', "'").lower().replace('\r', ' ').replace(
                '\n', ' ').translate(str.maketrans('', '', string.punctuation))

            def get_wordnet_pos(treebank_tag):
                if treebank_tag.startswith('J'):
                    return wordnet.ADJ
                elif treebank_tag.startswith('V'):
                    return wordnet.VERB
                elif treebank_tag.startswith('N'):
                    return wordnet.NOUN
                else:
                    return wordnet.ADV

            def lemmatize(word: string) -> string:
                tag = nltk.pos_tag([word])[0][1]
                return self.lemmatizer.lemmatize(word, pos=get_wordnet_pos(tag))

            temp_text = ''
            for word in text.split():
                word = lemmatize(word)
                if (word not in self.stop_words) and (not word.isnumeric()):
                    temp_text += word + ' '
            text = temp_text

            return text

        new_texts = []
        for text in texts:
            text = pre_process(str(text))
            new_texts.append(text)

        print('length of texts: ', len(new_texts))

        def tokenize(text):
            sequences = self.tokenizer.texts_to_sequences(text)
            return pad_sequences(sequences, maxlen=100)

        return np.array(tokenize(new_texts))

    def predict(self, texts, verbose=0):
        if not isinstance(texts, list):
            texts = [texts]

        if len(texts) == 0 or type(texts[0]) != str:
            return np.array(texts)

        res = self.model.predict(self.preProcessTexts(texts), verbose=verbose)
        res = np.reshape(res, (len(texts),))
        return res
