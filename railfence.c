//
//  railfence.c
//  Theory Of Information, Lab 1
//
//  Created by Alex Azarov on 17/09/2017.
//  Copyright © 2017 Alex Azarov. All rights reserved.
//

#include <stdlib.h>
#include <string.h>
#include <ctype.h>

typedef struct specialSymbols {
    char symbol;
    int pos;
} specialSymbols;

static struct specialSymbols arr[10000];

const char *MakeRailFence(const char *plaintext, int numCols, int numRows) {
    char *str = malloc(numRows * (numCols + 1));
    char arr[numRows][numCols + 1];
    
    for (int i = 0; i < numRows; i++) {
        for (int j = 0; j < numCols; j++) {
            arr[i][j] = ' ';
        }
        arr[i][numCols] = '\n';
    }
    arr[numRows - 1][numCols] = 0;
    
    int direction = 1;
    for (int i = 0, row = 0; i < numCols; i++) {
        arr[row][i] = plaintext[i];
        if (numRows != 1)   // Here is a comment
            row += direction;
        if (row == numRows - 1 || row == 0) {
            direction *= -1;
        }
    }
    memcpy(str, arr, numRows * (numCols + 1));
    
    return str;
}

const char *Encipher(const char* railfence, int size) {
    char *ciphertext = malloc(size + 1);
    for (int i = 0, j = 0; railfence[i]; i++) {
        if (railfence[i] == ' ' || railfence[i] == '\n')
            continue;
        ciphertext[j++] = railfence[i];
    }
    
    return ciphertext;
}

const char *Decipher(const char* ciphertext, int hight) {
    int lenght = 0;
    while (ciphertext[lenght]) lenght++;
    
    char railfence[hight][lenght];
    char *plaintext = malloc(lenght + 1);
    
    for (int i = 0; i < hight; i++)
        for (int j = 0; j < lenght; j++)
            railfence[i][j] = '$';

    int direction = 1;
    for (int i = 0, row = 0; i < lenght; i++) {
        railfence[row][i] = '#';
        row += direction;
        if (row == hight - 1 || row == 0)
            direction *= -1;
    }
    
    int ciphertextIndex = 0;
    for (int i = 0; i < hight; i++)
        for (int j = 0; j < lenght; j++)
            if (railfence[i][j] == '#')
                railfence[i][j] = ciphertext[ciphertextIndex++];
    
    int plaintextIndex = 0;
    direction = 1;
    for (int i = 0, row = 0; i < lenght; i++) {
        plaintext[plaintextIndex++] = railfence[row][i];
        row += direction;
        if (row == hight - 1 || row == 0)
            direction *= -1;
    }
    plaintext[plaintextIndex] = '\0';
    return plaintext;
}

const char *SaveSpecialSymbols(const char *text) {
    int textLength = 0;
    while (text[textLength++]);
    
    char *newText = malloc((size_t) textLength);
    
    int arrIndex = 0;
    int textIndex = 0, newTextIndex = 0;
    
    while (text[textIndex]) {
        if (isalpha(text[textIndex])) {
            newText[newTextIndex++] = text[textIndex];
        } else {
            arr[arrIndex].pos = textIndex;
            arr[arrIndex++].symbol = text[textIndex];
        }
        textIndex++;
    }
    arr[arrIndex].pos = -1;
    newText[newTextIndex] = '\0';
    
    return newText;
}

const char *ReturnSpecialSymbols(const char *text) {
    int arrSize = 0;
    while (arr[arrSize].pos != -1) arrSize++;
    
    int textSize = 0;
    while (text[textSize]) textSize++;
    
    char *newText = malloc((size_t) (arrSize + textSize));
    for (int i = 0, arrPos = 0, textIndex = 0; i < arrSize + textSize; i++) {
        if (arr[arrPos].pos == i) {
            newText[i] = arr[arrPos++].symbol;
        } else {
            newText[i] = text[textIndex++];
        }
    }
    newText[arrSize + textSize] = '\0';
    
    return newText;
}

