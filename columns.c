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
        index = i + 2;
        columns[index++] = keyword[i];
        columns[index++] = ' ';
    }
//    index = keywordLen * 2;
    columns[index - 1] = '\n';
    
    for (int i = 0; i < keywordLen; i++) {
        columns[index + i * 2] = '0' + arr[i];
        columns[index + i * 2 + 1] = ' ';
    }
    

    


    return ciphertext;
    
    
}


const char *GetColumns() {
    return columns;
}
