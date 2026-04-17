#!/usr/bin/python3

#assert Tensorflow don't reserve all gpu memory
import tensorflow as tf
gpus = tf.config.experimental.list_physical_devices('GPU')
if gpus:
  try:
    for gpu in gpus:
      tf.config.experimental.set_memory_growth(gpu, True)
  except RuntimeError as e:
    print(e)

import numpy as np
from sklearn.datasets import load_svmlight_file, dump_svmlight_file
from sklearn.metrics import classification_report,accuracy_score

def perceptron(nbhidden=1):
	entree = tf.keras.Input(shape=(3072,))
	hidden = tf.keras.layers.Dense(units=nbhidden,activation='relu')(entree)
	sortie = tf.keras.layers.Dense(units=10,activation='softmax')(hidden)

	model = tf.keras.Model(inputs=entree,outputs=sortie)
	model.compile(loss='sparse_categorical_crossentropy',optimizer='adam',metrics=['accuracy'])
	return model

def cnn():
    entree = tf.keras.Input(shape=(32,32,3))
    layer = tf.keras.layers.Conv2D(32, kernel_size=(5,5), strides=(1,1), activation='relu')(entree)
    layer = tf.keras.layers.MaxPooling2D(pool_size=(2,2), strides=(2,2))(layer)
    layer = tf.keras.layers.Conv2D(64, kernel_size=(5,5), activation='relu')(entree)
    layer = tf.keras.layers.MaxPooling2D(pool_size=(2,2))(layer)
    layer = tf.keras.layers.Conv2D(128, kernel_size=(5,5), activation='relu')(entree)
    layer = tf.keras.layers.MaxPooling2D(pool_size=(2,2), strides=(2,2))(layer)
    layer = tf.keras.layers.Dropout(0.37)(layer)
    #layer = tf.keras.layers.Conv2D(256, kernel_size=(3,3), activation='relu')(entree)
    #layer = tf.keras.layers.MaxPooling2D(pool_size=(2,2), strides=(2,2))(layer)
    layer = tf.keras.layers.Flatten()(layer)
    layer = tf.keras.layers.Dense(10000, activation='relu')(layer)
    out = tf.keras.layers.Dense(10, activation='softmax')(layer)
    model = tf.keras.Model(inputs=entree, outputs=out)
    model.compile(loss='sparse_categorical_crossentropy', optimizer='adam', metrics=['accuracy'])
    return model


def main():
    #x_train, x_test: 3*uint8 array of RGB image data with shape (num_samples, 32, 32,3).
    #y_train, y_test: uint8 array of digit labels (integers in range 0-9) with shape (num_samples,).
    (x_train, y_train), (x_test, y_test) = tf.keras.datasets.cifar10.load_data()
    print('x_train.shape=',x_train.shape)
    print('x_test.shape=',x_test.shape)
    x_train = x_train/255.0
    x_test = x_test/255.0
    #pour preceptron, on represente chaque image par un vecteur de 3072 pixel
    #x_train=x_train.reshape(50000,3072)/255
    #x_test =x_test.reshape(10000,3072)/255
    #pour CNN, on represente chaque image par un tenseur de 32*32 pixels codé sur 3 octets
    x_train = x_train.reshape(50000,32,32,3)
    x_test = x_test.reshape(10000,32,32,3)
    print('x_train.shape=',x_train.shape)
    print('x_test.shape=',x_test.shape)

    clf = cnn() #perceptron(100000)
    clf.fit(x_train,y_train,epochs=20,batch_size=51)

    predictions=clf.predict(x_test).argmax(-1) #le argmax sert à repérer le neurone actif et à donner son numéro

    print(classification_report(y_test,predictions)) #détails des erreurs
    print('accuracy_score=',accuracy_score(y_test,predictions))#score à maximiser (sans tricher)

if __name__ == "__main__":
	main()
