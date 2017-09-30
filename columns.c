//
//  columns.c
//  Theory Of Information, Lab 1
//
//  Created by Alex Azarov on 21/09/2017.
//  Copyright © 2017 Alex Azarov. All rights reserved.
//

#include <stdlib.h>
#include <string.h>
#include <printf.h>
#include <ctype.h>

static int arr[100];
static char columns[5000];

const char *ColumnEncipher(const char *plaintext, const char *keyword) {
    int keywordLen = (int) strlen(keyword);
    int plaintextLen = (int) strlen(plaintext);

    int sizeX = plaintextLen / keywordLen;
    if (plaintextLen % keywordLen)
        sizeX += 1;
    
    char matrix[sizeX][keywordLen];
    
    int flag = 0;
    for (int i = 0, k = 0; i < sizeX; i++) {
        for (int j = 0; j < keywordLen; j++) {
            if (plaintext[k] == '\0' || flag) {
                matrix[i][j] = '_';
                flag = 1;
            } else {
                matrix[i][j] = plaintext[k];
            }
            k++;
        }
    }
    
    char temp;
    int  pos;
    
    for (int i = 0; i < keywordLen; i++)
        arr[i] = -1;
    
    for (int i = 0; i < keywordLen; i++) {
        temp = '~';
        pos = 0;
        
        for (int j = 0; j < keywordLen; j++) {
            if (temp > keyword[j] && arr[j] == -1) {
                temp = keyword[j];
                pos = j;
            }
            
        }
        arr[pos] = i;
    }
    
    char *ciphertext = malloc(plaintextLen + 2);
    int index = 0;
    
    for (int i = 0; i < keywordLen; i++) {
        int j;
        for (j = 0; j < keywordLen; j++) {
            if (arr[j] == i) {
                break;
            }
        }
        for (int k = 0; k < sizeX; k++) {
            if (matrix[k][j] != '_') {
                char c = matrix[k][j];
                ciphertext[index++] = c;
            }
        }
    }
    ciphertext[plaintextLen] = '\0';
    
    index = 0;
    for (int i = 0; i < keywordLen; i++) {
        columns[index++] = keyword[i];
        columns[index++] = ' ';
    }

    columns[index - 1] = '\n';
    
    for (int i = 0; i < keywordLen; i++) {
        columns[index++] = '0' + arr[i];
        columns[index++] = ' ';
    }
    columns[index++] = '\n';
    
    for (int j = 0; j < sizeX; j++) {
        for (int i = 0; i < keywordLen; i++) {
            columns[index++] = matrix[j][i];
            columns[index++] = ' ';
        }
        columns[index++] = '\n';
    }
    
    columns[index] = '\0';

    return ciphertext;
}

const char *GetColumns() {
    return columns;
}

const char *ColumnDecipher(const char *ciphertext, const char *keyword) {
    int keywordLen = (int) strlen(keyword);
    if (keywordLen == 1)
        return ciphertext;

    int ciphertextLen = (int) strlen(ciphertext);
    int sizeX = ciphertextLen / keywordLen;
    if (ciphertextLen % keywordLen)
        sizeX += 1;
    
    char matrix[sizeX][keywordLen];
    
    char temp;
    int  pos;
    
    for (int i = 0; i < keywordLen; i++)
        arr[i] = -1;
    
    for (int i = 0; i < keywordLen; i++) {
        temp = '~';
        pos = 0;
        
        for (int j = 0; j < keywordLen; j++) {
            if (temp > keyword[j] && arr[j] == -1) {
                temp = keyword[j];
                pos = j;
            }
        }
        arr[pos] = i;
    }
    
    int ciphertextIndex = 0;
    for (int i = 0; i < sizeX; i++) {
        for (int j = 0; j < keywordLen; j++) {
            if (ciphertextIndex < ciphertextLen) {
                matrix[i][j] = ciphertext[ciphertextIndex++];
            } else {
                matrix[i][j] = '_';
            }
        }
    }
    
    int i = 0;
    int arrIndex = 0;
    ciphertextIndex = 0;
    while (i < keywordLen) {
        if (arr[arrIndex] == i) {
            for (int j = 0; j < sizeX; j++) {
                if (matrix[j][arrIndex] != '_') {
                    matrix[j][arrIndex] = ciphertext[ciphertextIndex++];
                } else {
                    matrix[j][arrIndex] = '\0';
                }
            }
            i++;
            arrIndex = 0;
        } else {
            arrIndex++;
        }
    }

//    for (int i = 0; i < sizeX; i++) {
//        for (int j = 0; j < keywordLen; j++) {
//            printf("%c ", matrix[i][j]);
//        }
//        putchar('\n');
//    }
    
    
    char *plaintext = malloc(ciphertextLen + 1);
    memcpy(plaintext, matrix, ciphertextLen);
    plaintext[ciphertextLen + 1] = '\0';
    
    return plaintext;
}
